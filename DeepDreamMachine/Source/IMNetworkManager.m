//
//  IMNetworkManager.m
//  Impressionism
//
//  Created by Brad on 4/24/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//


/*
  UPloading to the backend is a 2 step process.
  
  First an image is uploaded to Amazon S3. 
  Then once the image is uploaded to S3, we pass the S3 URL to our backend, along with 
  other metadata.
 
  AFNetworking gives us accurate tracking of the upload progress for step one, but for step 2 we only git notified on completion.
  To caluculate the overall progress, we assume that step one takes X percent of the time.
 
  OverallProgress = (StepOnePercent * X ) + ( isStep2Done * 1-X )
 
*/
#import "IMNetworkManager.h"
#import <AFAmazonS3Client/AFAmazonS3Client.h>
#import <AFNetworking/AFNetworking.h>
#import "IMAppConfiguration.h"
#import "IMImgurUploaderOperation.h"

@implementation IMNetworkManager


-(void) postImageLocationToBackend:(NSString *)location withPainting:(IMPainting *)painting withCompletion:(void (^)())completionBlock withFailure:(void (^)())failureBlock {
  NSLog(@"posting to backend");
  NSString *attributes = [[painting.attributes rawJSON] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  CGFloat width = painting.originalImage.size.width;
  CGFloat height = painting.originalImage.size.height;

  NSString *url = [NSString stringWithFormat:@"%@/posts.json?post[original_url]=%@&post[media_url]=%@&post[width]=%d&post[height]=%d&post[effect_params]=%@",[IMAppConfiguration apiBaseURL],painting.originalURL,painting.postURL,(int)width,(int)height,attributes];

  NSURL *URL = [NSURL URLWithString:url];

  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL ];
  [request setHTTPMethod:@"POST"];

  AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                    NSString *postURL = JSON[@"url"];
                                                    NSLog(@"Painting Posted: %@",postURL);
                                                    [painting setPostURL:postURL];
                                                    [self.progressView setProgress:1.0 animated:YES];
                                                    [self performSelector:@selector(hideProgressView) withObject:nil afterDelay:0.25];
                                                    completionBlock();
                                                  }
                                                  failure:^(NSURLRequest *r, NSHTTPURLResponse *res, NSError *e, id JSON) {
                                                    NSLog(@"Error posting to backend: %@",JSON);
                                                    failureBlock();
                                                  }];
  [operation start];
}


-(void)uploadPainting:(IMPainting *)painting withCompletion:(void (^)())completionBlock withFailure:(void (^)())failureBlock {
  self.progressView.alpha = 1;
  self.progressView.progress = 0;
  self.progressLabel.alpha = 1;
  self.progressLabel.text = NSLocalizedString(@"Uploading", nil);

  NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
  [operationQueue setMaxConcurrentOperationCount:2];

  NSOperation *finishOperation = nil;


  static dispatch_once_t failureBlockDispatchOncePredicate;
  failureBlockDispatchOncePredicate = 0;



  IMImgurUploaderOperation *uploadOriginal = [IMImgurUploaderOperation operationWithImage:painting.originalImage
                                                                                  success:^(NSString *location) {
                                                                                    painting.originalURL = location;
                                                                                    NSLog(@"Original posted to Location %@",location);
                                                                                    if (painting.originalURL && painting.postURL) {
                                                                                      [finishOperation start];
                                                                                    }
                                                                                  }
                                                                                  failure:^() {
                                                                                    [operationQueue cancelAllOperations];
                                                                                    dispatch_once(&failureBlockDispatchOncePredicate, ^(void){
                                                                                      dispatch_sync(dispatch_get_main_queue(), failureBlock);
                                                                                    });
                                                                                  }];

  IMImgurUploaderOperation *uploadRendered = [IMImgurUploaderOperation operationWithImage:painting.capturedImage
                                                                     success:^(NSString *location) {
                                                                       painting.postURL = location;
                                                                       NSLog(@"REndered posted to Location %@",location);
                                                                       if (painting.originalURL && painting.postURL) {
                                                                         [finishOperation start];
                                                                       }
                                                                     }
                                                                     failure:^() {
                                                                       [operationQueue cancelAllOperations];
                                                                       dispatch_once(&failureBlockDispatchOncePredicate, ^(void){
                                                                         dispatch_sync(dispatch_get_main_queue(), failureBlock);
                                                                       });
                                                                     }];

  finishOperation = [NSBlockOperation blockOperationWithBlock:^{
    [self postImageLocationToBackend:nil withPainting:painting withCompletion:completionBlock withFailure:failureBlock];
  }];

  void * block = (__bridge void *)^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
    CGFloat uploadPercent = (float)(uploadOriginal.totalBytesWritten + uploadRendered.totalBytesWritten) / (float)(uploadOriginal.totalBytesExpectedToWrite + uploadRendered.totalBytesExpectedToWrite);
    [self.progressView setProgress:uploadPercent];
  };

  [uploadOriginal setUploadProgressBlock:(__bridge void (^)(NSUInteger, long long, long long))(block)];
  [finishOperation addDependency:uploadOriginal];
  [finishOperation addDependency:uploadRendered];

  [operationQueue addOperations:@[uploadOriginal, uploadRendered, finishOperation] waitUntilFinished:NO];
}

-(void)hideProgressView {
  self.progressView.alpha = 0;
  self.progressView.progress = 0;
  self.progressLabel.alpha = 0;
}

@end