//
//  DeepDreamAPIClient.h
//  DeepDreamMachine
//
//  Created by Bradley R Anderson on 7/11/15.
//  Copyright (c) 2015 Jet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DeepDreamAPIClient : NSObject

+ (instancetype)sharedClient;

/*
  style is an int between 0 and 10 for now
*/
- (void)requestDeepDreamImageUsingImage:(UIImage *)image
                              withStyle:(int)style
                      completionHandler:(void (^)(UIImage *image))completion;

@end
