//
//  DeepDreamAPIClient.m
//  DeepDreamMachine
//
//  Created by Bradley R Anderson on 7/11/15.
//  Copyright (c) 2015 Jet. All rights reserved.
//
#import "DeepDreamAPIClient.h"
//#import <AFNetworking/AFNetworking.h>
#import "UIImage+Resize.h"

@implementation DeepDreamAPIClient

+ (instancetype)sharedClient {
  static DeepDreamAPIClient *sharedClient = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedClient = [[self alloc] init];
  });
  return sharedClient;
}

- (instancetype)init {
  if (self = [super init]) {
  }
  return self;
}

- (void)dealloc {
  // Should never be called, but just here for clarity really.
}

- (void)requestDeepDreamImageUsingImage:(UIImage *)image
                              withStyle:(int)style
                      completionHandler:(void (^)(UIImage *image))completion {
  // 1
  NSURL *url = [NSURL
      URLWithString:
          [NSString stringWithFormat:
                        @"http://deepdream.theappguy.guru/dream?effect=%d",
                        style]];
  
  image = [image resizedImage:CGSizeMake(320, 320) interpolationQuality:kCGInterpolationHigh];
  NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
  
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  [request setHTTPMethod:@"POST"];
  NSString *boundary = @"YOUR_BOUNDARY_STRING";
  NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
  [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
  
  NSMutableData *body = [NSMutableData data];

  [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", @"file"] dataUsingEncoding:NSUTF8StringEncoding]];
  [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  [body appendData:imageData];
  [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];


  [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

// setting the body of the post to the reqeust
[request setHTTPBody:body];

  //set up the network session
  NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
  sessionConfiguration.timeoutIntervalForRequest = 240.0;
  NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
  NSURLSessionDataTask *uploadTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error){
      NSLog(@"error: @%@",error);
    }else{
      UIImage *responseImge  = [UIImage imageWithData:data];
      if (responseImge) {
        completion(responseImge);
      }
    }
    // Process the response
  }];
  [uploadTask resume];

  

}

@end
