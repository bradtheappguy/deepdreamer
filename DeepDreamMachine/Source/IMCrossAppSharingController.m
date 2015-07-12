//
//  IMInstagramSharingController.m
//  Impressionism
//
//  Created by Brad on 4/28/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import "IMCrossAppSharingController.h"
#import "IMPainting.h"

@implementation IMCrossAppSharingController

+ (BOOL) isAppInstalledForServiceType:(CrossAppSharingType)type {
  NSURL *url = nil;
  if (type == CrossAppSharingTypeInstagram) {
    url = [NSURL URLWithString:@"instagram://"];
  }
  if (type == CrossAppSharingTypeTumblr) {
    url = [NSURL URLWithString:@"tumblr://"];
  }

  return [[UIApplication sharedApplication] canOpenURL:url];
}

- (id) initWithServiceType:(CrossAppSharingType)type {
  if (self = [super init]) {
    _serviceType = type;
  }
  return self;
}

- (void) promptUserToInstallAppUsingViewController:(UIViewController *)vc completion:(void(^)(BOOL canceled))completionHandler {
  _vc = vc;
  self.completionHandler = completionHandler;
  NSString * title = nil;
  if (_serviceType == CrossAppSharingTypeInstagram) {
    title = NSLocalizedString(@"INSTAGRAM", nil);
  }
  if (_serviceType == CrossAppSharingTypeTumblr) {
    title = NSLocalizedString(@"TUMBLR", nil);
  }
  NSString *message = [NSString stringWithFormat:NSLocalizedString(@"{APP}_IS_NOT_INSTALLED", nil),title];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ALERT", nil) message:message delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
  [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    if (( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )) {
      [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }

    SKStoreProductViewController *vc =[[SKStoreProductViewController alloc] init];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [vc.view addSubview:spinner];
    spinner.center = CGPointMake(vc.view.bounds.size.width/2, vc.view.bounds.size.width/2);
    vc.delegate = self;
    [spinner startAnimating];

    NSString *itemId = @"";

    if (_serviceType == CrossAppSharingTypeInstagram) {
      itemId = @"389801252";
    }
    if (_serviceType == CrossAppSharingTypeTumblr) {
      itemId = @"305343404";
    }

    [vc loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:itemId} completionBlock:^(BOOL success, NSError *error){
      spinner.hidden = YES;
      if (success == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ALERT", nil) message:NSLocalizedString(@"APP_STORE_FAILED_TO_LOAD", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
      }
      else if (success == YES) {
        NSString *appName = @"";
        if (_serviceType == CrossAppSharingTypeInstagram) {
          appName = NSLocalizedString(@"INSTAGRAM", nil);
        }
        if (_serviceType == CrossAppSharingTypeTumblr) {
          appName = NSLocalizedString(@"TUMBLR", nil);
        }
        NSString *string = [NSString stringWithFormat:NSLocalizedString(@"AFTER_DOWNLOADING_YOU_NEED_TO_LOGIN_TO_{APP}", nil),appName];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NOTICE", nil) message:string delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
      }
    }];
    [_vc presentViewController:vc animated:YES completion:nil];

  }
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
  [viewController dismissViewControllerAnimated:YES completion:nil];
  self.completionHandler(NO);
  // [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}


-(UIDocumentInteractionController *)interactionControllerWithIMAGE:(UIImage *)image croppedImage:(UIImage *)croppedImage {
  if (_serviceType == CrossAppSharingTypeInstagram) {
    NSString *jpgPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/impressionist.igo"];
    [UIImageJPEGRepresentation(croppedImage, 1.0) writeToFile:jpgPath atomically:YES];
    NSURL *igImageHookFile = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"file://%@",jpgPath]];
    if (!igImageHookFile) {
      return nil;
    }
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: igImageHookFile];
    interactionController.UTI = @"com.instagram.exclusivegram";
    interactionController.annotation = [NSDictionary dictionaryWithObject:NSLocalizedString(@"INSTAGRAM_SHARING_TEXT", nil) forKey:@"InstagramCaption"];
    return interactionController;
  }
  if (_serviceType == CrossAppSharingTypeTumblr) {
    NSString *jpgPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/impressionist.tumblrphoto"];
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:jpgPath atomically:YES];
    NSURL *jpegFile = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"file://%@",jpgPath]];
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: jpegFile];
    interactionController.UTI = @"com.tumblr.photo";
    NSString *text = [NSString stringWithFormat:NSLocalizedString(@"TUMBLR_SHARING_TEXT_{URL}", nil),@""];
    interactionController.annotation = @{@"TumblrCaption": text, @"TumblrTags": @[@"Impressionist"]};
    return interactionController;
  }
  return nil;
}


@end
