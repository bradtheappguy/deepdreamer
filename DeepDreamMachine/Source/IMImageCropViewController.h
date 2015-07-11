//
//  IMImageCropViewController.h
//  Impressionism
//
//  Created by Brad on 4/29/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMImageCropViewController;

@protocol IMImageCropViewControllerDelegate <NSObject>

-(void) cropViewController:(IMImageCropViewController *)controller didCropImage:(UIImage *)image;

@end

@interface IMImageCropViewController : UIViewController

@property (nonatomic, weak) id <IMImageCropViewControllerDelegate> delegate;

@property (nonatomic) UIImage *cropImage;
@end
