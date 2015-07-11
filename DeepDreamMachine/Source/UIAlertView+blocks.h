//
//  UIAlertView+blocks.h
//  Impressionism
//
//  Created by Brad on 5/31/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (blocks)
+(void)showOKCancelAlertWithMessage:(NSString *)message OKBlock:(void (^)())completion;
@end
