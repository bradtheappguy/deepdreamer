//
//  DeepDreamAPIClient.m
//  DeepDreamMachine
//
//  Created by Bradley R Anderson on 7/11/15.
//  Copyright (c) 2015 Jet. All rights reserved.
//
#import "DeepDreamAPIClient.h"
//#import <AFNetworking/AFNetworking.h>

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
                        @"http://deepdream.theappguy.guru:8888/dream?effect=%d",
                        style]];
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
                       UIImage *imageToReturn =
                           [[UIImage alloc] initWithData:data];
                       completion(imageToReturn);
                     }];

    // 5
    [uploadTask resume];
  }
}

@end
