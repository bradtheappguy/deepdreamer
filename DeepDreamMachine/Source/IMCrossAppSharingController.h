//
//  IMInstagramSharingController.h
//  Impressionism
//
//  Created by Brad on 4/28/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "IMPainting.h"


typedef NS_ENUM(NSInteger, CrossAppSharingType) {
  CrossAppSharingTypeInstagram,
  CrossAppSharingTypeTumblr
};


@interface IMCrossAppSharingController : NSObject <SKStoreProductViewControllerDelegate> {
  UIViewController *_vc;
  CrossAppSharingType _serviceType;
}


@property (nonatomic, copy) void (^completionHandler)(BOOL canceled);


+ (BOOL) isAppInstalledForServiceType:(CrossAppSharingType)type;

- (id) initWithServiceType:(CrossAppSharingType)type;

- (void) promptUserToInstallAppUsingViewController:(UIViewController *)vc completion:(void(^)(BOOL canceled))completionHandler;
- (UIDocumentInteractionController *)interactionControllerWithPainting:(IMPainting *)painting;

@end
