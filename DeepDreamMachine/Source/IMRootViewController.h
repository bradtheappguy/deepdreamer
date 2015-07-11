//
//  IMRootViewController.h
//  Impressionism
//
//  Created by Brad on 4/23/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMSharingViewController.h"

@interface IMRootViewController : UIViewController <UIScrollViewDelegate, UIViewControllerTransitioningDelegate>

- (void) dismissPopoverAndModalViewControllers;
- (void) sharingViewControllerDidRequestRenderedImage:(IMSharingViewController *)sharingViewController;

- (void) openGalleryWithPostID:(NSURL *)postID;
- (void) editPresetDoneButtonPressed:(id)sender;

-(IBAction)resetCanvasButtonPressed:(UIButton *)sender;

- (void) canvasBackgroundOpacityDidChange:(CGFloat)alpha;
@end