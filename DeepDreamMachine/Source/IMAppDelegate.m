//
//  IMAppDelegate.m
//  Impressionism
//
//  Created by Brad on 4/10/14.
//  Copyright (c) 2014. All rights reserved.
//

#import "IMAppDelegate.h"
#import "IMRootViewController.h"
#import "IMWelcomeViewController.h"
#import "DeepDreamAPIClient.h"

@implementation IMAppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.rootViewController =
      [[IMRootViewController alloc] initWithNibName:@"IMRootViewController"
                                             bundle:[NSBundle mainBundle]];

  IMWelcomeViewController *welcome =
      [[IMWelcomeViewController alloc] initWithNibName:nil bundle:nil];
  [self.window makeKeyAndVisible];

  //[self.window.rootViewController presentViewController:welcome animated:NO
  //completion:nil];

  UILabel *fpsLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 150, 50)];
  fpsLabel.tag = 690;
  fpsLabel.font = [UIFont systemFontOfSize:20];
  fpsLabel.textColor = [UIColor whiteColor];

  fpsLabel.text = @"0 FPS";
  //[self.window.rootViewController.view addSubview:fpsLabel];

  NSLog(@"Did finish launching.");

  [[DeepDreamAPIClient sharedClient]
      requestDeepDreamImageUsingImage:nil
                            withStyle:1
                    completionHandler:^(UIImage *image) {
                      NSLog(@"%@", image);
                    }];

  return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
  NSLog(@"Launching App from %@, using URL: %@ and annotation: %@",
        sourceApplication, [url absoluteString], annotation);
  [(IMRootViewController *)self.window.rootViewController
      openGalleryWithPostID:url];
  return YES;
}

@end
