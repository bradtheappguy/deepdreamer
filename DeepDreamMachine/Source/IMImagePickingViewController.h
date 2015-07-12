//
//  IMImagePickingViewController.h
//  Impressionism
//
//  Created by Brad on 4/23/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IMImagePickingViewController;

@protocol IMActionViewControllerDelegate <NSObject>

-(void)imagePickerDidCancel:(IMImagePickingViewController *)picker;

@optional

-(void)picker:(IMImagePickingViewController *)picker didFinishPickingImage:(UIImage *)image;
-(void)picker:(IMImagePickingViewController *)picker didFinishPickingImageWithURL:(NSURL *)url;

@end

@interface IMImagePickingViewController : UIViewController <UIWebViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

-(id) initWithDelegate:(id <IMActionViewControllerDelegate>)delegate;

@property (nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIScrollView *topScrollView;
@property (weak) id <IMActionViewControllerDelegate> delegate;

@property (nonatomic) NSUInteger indexOfPresetImage;
 
@end
