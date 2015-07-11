//
//  IMSharingViewController.h
//  Impressionism
//
//  Created by Brad on 4/23/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMImageCropViewController.h"

@protocol IMImageCropViewControllerDelegate;

@class IMSharingViewController;

@protocol IMSharingViewControllerDelegate <NSObject>

- (void)emailButtonPressed:(id)sender;
- (void)openInButtonPressed:(id)sender;
- (void)saveToPhotosButtonPressed:(id)sender;
- (void)copyButtonPressed:(id)sender;

- (void)postCardButtonPressed:(id)sender;
- (void)instagramButtonPressed:(id)sender;
- (void)tumblrButtonPressed:(id)sender;
- (void)twitterButtonPressed:(id)sender;
- (void)facebookButtonPressed:(id)sender;
- (void) sharingViewControllerDidRequestRenderedImage:(IMSharingViewController *)sharingViewController;

@end

@interface IMSharingViewController : UIViewController <IMImageCropViewControllerDelegate>

@property (nonatomic, weak) id <IMSharingViewControllerDelegate> delegate;
@property (nonatomic) IBOutlet UIButton *closeButton;

@end

