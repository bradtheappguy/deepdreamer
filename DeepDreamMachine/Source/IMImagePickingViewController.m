//
//  IMImagePickingViewController.m
//  Impressionism
//
//  Created by Brad on 4/23/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import "IMImagePickingViewController.h"
#import "IMRootViewController.h"

@interface IMImagePickingViewController () {
  UIImageView *backgroundImage;
}

@property(nonatomic, weak) IBOutlet UIButton *pasteButton;
@property(weak, nonatomic) IBOutlet UIButton *example1Button;
@property(weak, nonatomic) IBOutlet UIButton *example2Button;
@property(weak, nonatomic) IBOutlet UIButton *example3Button;

@property(weak, nonatomic) IBOutlet UIView *viewToMask;

- (void)updatePasteboardButton;

@end

@interface IMImagePickingViewControllerView : UIView
@end

@implementation IMImagePickingViewControllerView

- (void)awakeFromNib {
  [super awakeFromNib];
}
@end

@implementation IMImagePickingViewController

- (id)initWithDelegate:(id<IMActionViewControllerDelegate>)delegate {
  if (self = [super init]) {
    self.delegate = delegate;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    self.closeButton.hidden = YES;
    self.closeButton.enabled = NO;
  }

  [self updatePasteboardButton];
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(updatePasteboardButton)
             name:UIPasteboardChangedNotification
           object:nil];
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(updatePasteboardButton)
             name:UIApplicationDidBecomeActiveNotification
           object:nil];
  [self.example1Button.imageView
      setContentMode:UIViewContentModeScaleAspectFit];
  [self.example2Button.imageView
      setContentMode:UIViewContentModeScaleAspectFit];
  [self.example3Button.imageView
      setContentMode:UIViewContentModeScaleAspectFit];
  self.preferredContentSize = CGSizeMake(1020 / 2, 780 / 2);
  self.view.backgroundColor = [UIColor clearColor];
  backgroundImage = [UIImageView new];
  backgroundImage.image = [UIImage imageNamed:@"camera-popup"];
  backgroundImage.frame = self.view.bounds;
  [self.viewToMask addSubview:backgroundImage];
  //[self.view sendSubviewToBack:backgroundImage];

  self.viewToMask.backgroundColor = [UIColor blackColor];
  
  UIImage *_maskingImage = [UIImage imageNamed:@"camera-popup-mask@2x"];

  CALayer *_maskingLayer = [CALayer layer];
  _maskingLayer.frame = CGRectMake(0, 0, 1020 / 2, 780 / 2);
  [_maskingLayer setContents:(id)[_maskingImage CGImage]];
  [self.viewToMask.layer setMask:_maskingLayer];
}

- (void)viewDidAppear:(BOOL)animated {
  //[super viewWillAppear:animated];
  CGRect f = self.topScrollView.frame;
  f.size.height = self.view.bounds.size.height - f.origin.y - 5;
  self.topScrollView.frame = f;
  self.topScrollView.showsVerticalScrollIndicator = 1;
  self.topScrollView.contentSize = CGSizeMake(1020 / 2, 780 / 2);
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark Buttons
- (IBAction)cameraButtonPressed:(id)sender {
  UIImagePickerControllerSourceType sourceType =
      UIImagePickerControllerSourceTypeCamera;
  if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
    UIImagePickerController *imagePickerController =
        [[UIImagePickerController alloc] init];
    imagePickerController.allowsEditing = NO;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.delegate = self;
    [self addChildViewController:imagePickerController];
    [[self view] addSubview:[imagePickerController view]];
  }
}

- (IBAction)libraryButtonPressed:(id)sender {
  UIImagePickerController *vc = [[UIImagePickerController alloc] init];
  vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  vc.delegate = self;
  vc.view.frame = self.view.bounds;
  [self addChildViewController:vc];
  [[self view] addSubview:[vc view]];
}

- (IBAction)pasteButtonPressed:(id)sender {
  UIImage *image = [[UIPasteboard generalPasteboard] image];
  if (image) {
    IMRootViewController *rootViewController = (IMRootViewController *)[[[
        [UIApplication sharedApplication] delegate] window] rootViewController];
    [rootViewController dismissViewControllerAnimated:YES completion:nil];
    [self.delegate picker:self didFinishPickingImage:image];
  }
}

- (IBAction)exampleButtonPressed:(UIButton *)sender {
  NSURL *url = [[NSBundle mainBundle]
      URLForResource:[NSString stringWithFormat:@"sample%d", sender.tag]
       withExtension:@"jpg"];
  [self.delegate picker:self didFinishPickingImageWithURL:url];
  IMRootViewController *rootViewController = (IMRootViewController *)[
      [[[UIApplication sharedApplication] delegate] window] rootViewController];
  [rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closeButtonPressed:(id)sender {
  IMRootViewController *rootViewController = (IMRootViewController *)[
      [[[UIApplication sharedApplication] delegate] window] rootViewController];
  [rootViewController dismissViewControllerAnimated:YES completion:nil];
  [rootViewController dismissPopoverAndModalViewControllers];
}

#pragma mark -
#pragma mark UIImagePickerController

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
  UIImage *image = info[@"UIImagePickerControllerEditedImage"];
  if (!image) {
    image = info[@"UIImagePickerControllerOriginalImage"];
  }
  [self.delegate picker:self didFinishPickingImage:image];
  [[picker view] removeFromSuperview];
  [picker removeFromParentViewController];
  IMRootViewController *rootViewController = (IMRootViewController *)[
      [[[UIApplication sharedApplication] delegate] window] rootViewController];
  [rootViewController dismissViewControllerAnimated:YES completion:nil];
  [rootViewController dismissPopoverAndModalViewControllers];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [self.delegate imagePickerDidCancel:self];
  [[picker view] removeFromSuperview];
  [picker removeFromParentViewController];
}

#pragma mark -
#pragma mark KVO

- (void)updatePasteboardButton {
  self.pasteButton.enabled = ([[UIPasteboard generalPasteboard] image] != nil);
}

@end
