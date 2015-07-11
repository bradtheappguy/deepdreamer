//
//  UIAlertView+blocks.m
//  Impressionism
//
//  Created by Brad on 5/31/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import "UIAlertView+blocks.h"

@implementation UIAlertView (blocks)

static void (^comletionblock)();

+(void)showOKCancelAlertWithMessage:(NSString *)message OKBlock:(void (^)())completion {
  comletionblock = completion;
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ALERT", nil)
                                                  message:message
                                                 delegate:self
                                        cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
                                        otherButtonTitles:NSLocalizedString(@"OK",nil), nil];
  [alert show];
}

+ (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    comletionblock();
  }
}

@end
