//
//  DeepDreamAPIClient.m
//  DeepDreamMachine
//
//  Created by Bradley R Anderson on 7/11/15.
//  Copyright (c) 2015 Jet. All rights reserved.
//

#import "DeepDreamAPIClient.h"

@implementation DeepDreamAPIClient

+ (id)sharedClient {
  static DeepDreamAPIClient *sharedClient = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedClient = [[self alloc] init];
  });
  return sharedClient;
}

- (id)init {
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
}

@end
