//
//  DeepDreamAPIClient.m
//  DeepDreamMachine
//
//  Created by Bradley R Anderson on 7/11/15.
//  Copyright (c) 2015 Jet. All rights reserved.
//
#import "DeepDreamAPIClient.h"
#import <AFNetworking/AFNetworking.h>

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

- (void)MOCKRESPONSE:(void (^)(UIImage *image))completion {
  UIImage *imageToReturn = [UIImage imageNamed:@"output2"];
  completion(imageToReturn);
}

- (void)requestDeepDreamImageUsingImage:(UIImage *)image
                              withStyle:(int)style
                      completionHandler:(void (^)(UIImage *image))completion {
  [self performSelector:@selector(MOCKRESPONSE:)
             withObject:completion
             afterDelay:2];
  image = [UIImage imageNamed:@"in1.jpg"];

  // 1
  NSURL *url =
      [NSURL URLWithString:@"http://" @"ec2-52-8-221-11.us-west-1.compute."
             @"amazonaws.com:8888/postImage"];
  NSURLSessionConfiguration *config =
      [NSURLSessionConfiguration defaultSessionConfiguration];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:config];

  // 2
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
  request.HTTPMethod = @"POST";

  // 3d
  NSData *data = UIImageJPEGRepresentation(image, 0.8);

  if (data) {
    // 4
    NSURLSessionUploadTask *uploadTask =
        [session uploadTaskWithRequest:request
                              fromData:data
                     completionHandler:^(NSData *data, NSURLResponse *response,
                                         NSError *error) {
                       NSLog(@"done");
                     }];

    // 5
    [uploadTask resume];
  }
}

@end
