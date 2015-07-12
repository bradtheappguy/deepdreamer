//
//  IMRootViewController.h
//  Impressionism
//
//  Created by Brad on 4/23/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import "IMRootViewController.h"

#import <MessageUI/MessageUI.h>
#import <Reachability/Reachability.h>
#import <ShipLib/ShipLib.h>
#import <Social/Social.h>
#import "IMSequenceEditorTableViewController.h"
#import "EJJavaScriptView.h"
#import "IMAboutViewController.h"
#import "IMAppConfiguration.h"
#import "IMCanvasContainerView.h"
#import "IMCrossAppSharingController.h"
#import "IMImageCropViewController.h"
#import "IMImagePickingViewController.h"
#import "IMNetworkManager.h"
#import "IMSettings.h"
#import "IMSharingViewController.h"
#import "IMWebViewController.h"
#import "IMSettingsViewController.h"
#import "IMPaintingsAttributesTableViewController.h"
#import "UIAlertView+blocks.h"
#import "IMBrushPickerViewController.h"
#import "IMCanvasPickerViewController.h"
#import "ScaleAnimation.h"
#import "IMBrush.h"
#import "DeepDreamAPIClient.h"

@interface IMRootViewController ()<
    MFMailComposeViewControllerDelegate, IMSharingViewControllerDelegate,
    UIDocumentInteractionControllerDelegate, SYSincerelyControllerDelegate,
    UIPopoverControllerDelegate, IMBrushPickerViewControllerDelegate,
    IMActionViewControllerDelegate> {
  IMNetworkManager *_networkManager;
  UIButton *presentedpopoverButton;
  UIDocumentInteractionController *interactionController;
  ScaleAnimation *_scaleAnimationController;
}

@property(weak, nonatomic) IBOutlet IMCanvasContainerView *canvasContainerView;
@property(nonatomic) UIPopoverController *popover;
@property(weak, nonatomic) IBOutlet UILabel *progressLabel;
@property(weak, nonatomic) IBOutlet UIProgressView *progressView;
@property(weak, nonatomic) IBOutlet UIButton *brushButton;
@property(weak, nonatomic) IBOutlet UIButton *heartButton;
@property(weak, nonatomic) IBOutlet UIButton *canvasButton;
@property(weak, nonatomic) IBOutlet UIButton *imagePickingButton;
@property(weak, nonatomic) IBOutlet UIScrollView *effectPickingScrollView;

@property(weak, nonatomic) IBOutlet UIImageView *animImage;

@property(nonatomic) IMCrossAppSharingController *crossAppSharingController;
@end

@implementation IMRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage
    // imageNamed:@"bg_texture"]];
    _networkManager = [[IMNetworkManager alloc] init];
    _networkManager.progressView = self.progressView;
    _networkManager.progressLabel = self.progressLabel;
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(imageSettingsDidChange:)
               name:IMSettingsImageSizeSettingDidChangeNotification
             object:nil];
    Reachability *reach =
        [Reachability reachabilityWithHostname:@"www.google.com"];
    reach.reachableBlock = ^(Reachability *reach) {
      NSLog(@"REACHABLE!");
    };

    reach.unreachableBlock = ^(Reachability *reach) {
      NSLog(@"UNREACHABLE!");
    };
    [reach startNotifier];

  }
  
  return self;
}

- (void)openGalleryWithPostID:(NSURL *)url {
  IMWebViewController *webViewController =
      [[IMWebViewController alloc] initWithNibName:@"IMWebViewController"
                                            bundle:nil];
  webViewController.url = url;
  UINavigationController *navigationController = [[UINavigationController alloc]
      initWithRootViewController:webViewController];
  [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)setInitialLoadingState:(BOOL)enabled {
  if (enabled) {
    self.progressLabel.alpha = 0;
    self.progressView.alpha = 0;
    [self.heartButton setEnabled:NO];
    [self.imagePickingButton setEnabled:NO];
  } else {
    self.progressLabel.alpha = 0;
    self.progressView.alpha = 0;
    [self.heartButton setEnabled:YES];
    [self.imagePickingButton setEnabled:YES];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setInitialLoadingState:NO];
  self.heartButton.enabled = NO;
  _scaleAnimationController = [[ScaleAnimation alloc] init];
  
  [self.animImage setAnimationDuration:3.0];
  [self.animImage setAnimationImages:@[
                                       [UIImage imageNamed:@"default-portrait_ipad0"],
                                       [UIImage imageNamed:@"default-portrait_ipad1"],
                                       [UIImage imageNamed:@"default-portrait_ipad2"],
                                       [UIImage imageNamed:@"default-portrait_ipad3"]
                                       ]];
  [self.animImage startAnimating];
  
  [self.canvasContainerView.canvasView removeFromSuperview];
  self.canvasContainerView.alpha = 0.0;
  
}

- (void)viewDidDisappear:(BOOL)animated {
  NSLog(@"WTF?");
}

- (BOOL)shouldAutorotate {
  // Rotate on iPad but not iPhone
  return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (void)didRotateFromInterfaceOrientation:
    (UIInterfaceOrientation)fromInterfaceOrientation {
  [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
  if (self.popover.isPopoverVisible) {
    [self.popover presentPopoverFromRect:presentedpopoverButton.frame
                                  inView:self.view
                permittedArrowDirections:UIPopoverArrowDirectionDown
                                animated:YES];
  }
}

- (BOOL)prefersStatusBarHidden {
  return YES;
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  [self.canvasContainerView rotate];
  [self snapDraggingPopoverToCorner];
  [self.view layoutSubviews];
  [self.view bringSubviewToFront:self.effectPickingScrollView];

  self.effectPickingScrollView.contentSize =
      CGSizeMake(self.effectPickingScrollView.superview.bounds.size.width * 2,
                 self.effectPickingScrollView.superview.bounds.size.height);
}

- (void)popoverControllerDidDismissPopover:
    (UIPopoverController *)popoverController {
  [self.canvasContainerView resume];
  [self.imagePickingButton setEnabled:YES];
}

#pragma mark -
#pragma mark Button Handling

- (IBAction)cameraButtonPressed:(UIButton *)sender {
  [self.canvasContainerView pause];
  IMImagePickingViewController *vc =
      [[IMImagePickingViewController alloc] initWithDelegate:self];
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    self.popover =
        [[UIPopoverController alloc] initWithContentViewController:vc];
    self.popover.backgroundColor = [UIColor clearColor];
    self.popover.delegate = self;
    presentedpopoverButton = sender;
    [self.popover presentPopoverFromRect:sender.frame
                                  inView:self.view
                permittedArrowDirections:UIPopoverArrowDirectionDown
                                animated:YES];
  } else {
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
  }
}

- (IBAction)brushButtonPressed:(UIButton *)sender {
  // self.scrollView.hidden = !self.scrollView.hidden;

  [self.canvasContainerView pause];
  // sender.enabled = NO;
  IMBrushPickerViewController *vc = [[IMBrushPickerViewController alloc]
      initWithNibName:@"IMBrushPickerViewController"
               bundle:[NSBundle mainBundle]];
  vc.delegate = self;
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    self.popover =
        [[UIPopoverController alloc] initWithContentViewController:vc];
    self.popover.backgroundColor = vc.view.backgroundColor;
        self.popover.backgroundColor = [UIColor clearColor];;
    self.popover.delegate = self;
    presentedpopoverButton = sender;
    [self.popover presentPopoverFromRect:sender.frame
                                  inView:self.view
                permittedArrowDirections:UIPopoverArrowDirectionDown
                                animated:YES];
  } else {
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
  }
}

- (IBAction)canvasButtonPressed:(UIButton *)sender {
  [self.canvasContainerView pause];
  IMCanvasPickerViewController *vc = [[IMCanvasPickerViewController alloc]
      initWithNibName:@"IMCanvasPickerViewController"
               bundle:[NSBundle mainBundle]];
  vc.delegate = self;
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    self.popover =
        [[UIPopoverController alloc] initWithContentViewController:vc];
    self.popover.backgroundColor = vc.view.backgroundColor;
        self.popover.backgroundColor = [UIColor clearColor];
    self.popover.delegate = self;
    presentedpopoverButton = sender;
    [self.popover presentPopoverFromRect:sender.frame
                                  inView:self.view
                permittedArrowDirections:UIPopoverArrowDirectionDown
                                animated:YES];
  } else {
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
  }
}

- (IBAction)shareButtonPressed:(UIButton *)sender {
  [self.canvasContainerView pause];
  IMSharingViewController *vc = [[IMSharingViewController alloc] init];
  vc.delegate = self;

  // UINavigationController *nav = [[UINavigationController alloc]
  // initWithRootViewController:vc];
  // nav.navigationBar.backgroundColor = [UIColor clearColor];
  // nav.navigationBar.shadowImage = [UIImage new];
  //[nav.navigationBar setTranslucent:YES];
  //[nav.navigationBar setBackgroundImage:[UIImage new]
  // forBarMetrics:UIBarMetricsDefault];

  // nav.preferredContentSize = CGSizeMake(320, 480);

  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    vc.preferredContentSize = CGSizeMake(433, 347);
    self.popover =
        [[UIPopoverController alloc] initWithContentViewController:vc];
    self.popover.delegate = self;
    self.popover.backgroundColor = vc.view.backgroundColor;
        //self.popover.backgroundColor = [UIColor clearColor];
    presentedpopoverButton = sender;
    [self.popover presentPopoverFromRect:sender.frame
                                  inView:self.view
                permittedArrowDirections:UIPopoverArrowDirectionUp
                                animated:YES];
  } else {
    [vc.view setBounds:self.view.bounds];
    NSLog(@"VC Bounds: w: %f, h: %f", vc.view.bounds.size.width,
          vc.view.bounds.size.height);
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
  }
}

- (IBAction)resetCanvasButtonPressed:(UIButton *)sender {
  [UIAlertView showOKCancelAlertWithMessage:NSLocalizedString(
                                                @"DO_YOU_WANT_TO_RESET", nil)
                                    OKBlock:^(void) {
                                      [self.canvasContainerView resetCanvas];
                                    }];
}

- (IBAction)settingsButtonPressed:(UIButton *)sender {
  [self.canvasContainerView pause];
  IMSettingsViewController *settingsViewController =
      [[IMSettingsViewController alloc]
          initWithNibName:@"IMSettingsViewController"
                   bundle:nil];

  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    settingsViewController.preferredContentSize = CGSizeMake(320, 480);
    self.popover = [[UIPopoverController alloc]
        initWithContentViewController:settingsViewController];
    self.popover.delegate = self;
    self.popover.backgroundColor = settingsViewController.view.backgroundColor;
        self.popover.backgroundColor = [UIColor clearColor];
    presentedpopoverButton = sender;
    [self.popover presentPopoverFromRect:sender.frame
                                  inView:self.view
                permittedArrowDirections:UIPopoverArrowDirectionDown
                                animated:YES];
  } else {
    settingsViewController.preferredContentSize = CGSizeMake(320, 568);
    // settingsViewController.transitioningDelegate = self;
    settingsViewController.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:settingsViewController
                       animated:YES
                     completion:nil];
  }
}

static UIView *draggingPopover;
static UINavigationController *nav2;

- (void)editPresetDoneButtonPressed:(id)sender {
  if (draggingPopover) {
    [draggingPopover removeFromSuperview];
    draggingPopover = nil;
    nav2 = nil;
  } else {
    [self.presentedViewController dismissViewControllerAnimated:YES
                                                     completion:nil];
  }
}

- (void)snapDraggingPopoverToCorner {
  CGPoint upperLeft = CGPointMake(draggingPopover.bounds.size.width / 2,
                                  draggingPopover.bounds.size.height / 2);
  CGPoint upperRight =
      CGPointMake([draggingPopover superview].bounds.size.width -
                      draggingPopover.bounds.size.width / 2,
                  draggingPopover.bounds.size.height / 2);
  CGFloat distancetoupperLeft = ((draggingPopover.center.x - upperLeft.x) *
                                 (draggingPopover.center.x - upperLeft.x)) +
                                ((draggingPopover.center.y - upperLeft.y) *
                                 (draggingPopover.center.y - upperLeft.y));
  CGFloat distancetoupperRight = ((draggingPopover.center.x - upperRight.x) *
                                  (draggingPopover.center.x - upperRight.x)) +
                                 ((draggingPopover.center.y - upperRight.y) *
                                  (draggingPopover.center.y - upperRight.y));
  CGPoint dest = upperLeft;
  if (distancetoupperRight < distancetoupperLeft) {
    dest = upperRight;
  }

  [UIView animateWithDuration:0.3
                   animations:^(void) {
                     draggingPopover.center = dest;
                   }];
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer {
  if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
    // Calculate new center of the view based on the gesture recognizer's
    // translation.
    CGPoint newCenter = draggingPopover.center;
    newCenter.x += [gestureRecognizer translationInView:self.view].x;
    newCenter.y += [gestureRecognizer translationInView:self.view].y;

    // Set the new center of the view.
    draggingPopover.center = newCenter;

    // Reset the translation of the recognizer.
    [gestureRecognizer setTranslation:CGPointZero inView:self.view];
  }
  if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
    [self snapDraggingPopoverToCorner];
  }
}

#pragma mark -

- (void)presentBrushEditor {
  if (draggingPopover) {
    [draggingPopover removeFromSuperview];
    draggingPopover = nil;
    nav2 = nil;
  }
  NSString *json = [[IMBrush currentBrush] json];
  IMPaintingsAttributesTableViewController *vc =
      [[IMPaintingsAttributesTableViewController alloc] initWithJSON:json];
  vc.delegate = self.canvasContainerView;
  vc.fileName = [[IMBrush currentBrush] fileName];

  nav2 = [[UINavigationController alloc] initWithRootViewController:vc];
  nav2.preferredContentSize = CGSizeMake(320, 480);
  vc.preferredContentSize = CGSizeMake(320, 480);
  vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                           target:self
                           action:@selector(editPresetDoneButtonPressed:)];
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    UIGestureRecognizer *panGestureRecoginizer =
        [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handlePan:)];
    [nav2.navigationBar addGestureRecognizer:panGestureRecoginizer];

    draggingPopover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    draggingPopover.layer.cornerRadius = 10.0f;
    draggingPopover.layer.masksToBounds = YES;
    draggingPopover.backgroundColor = [UIColor whiteColor];
    nav2.view.frame = CGRectMake(0, 0, 320, 480);
    [draggingPopover addSubview:nav2.view];
    [self.view addSubview:draggingPopover];
  } else {
    [self.presentedViewController presentViewController:nav2
                                               animated:YES_PLEASE
                                             completion:nil];
  }
}

- (void)presentSequenceEditor {
  if (draggingPopover) {
    [draggingPopover removeFromSuperview];
    draggingPopover = nil;
    nav2 = nil;
  }

  IMSequence *sequence = [IMSequence currentSequence];

  IMSequenceEditorTableViewController *seq =
      [[IMSequenceEditorTableViewController alloc] initWithSequence:sequence];

  nav2 = [[UINavigationController alloc] initWithRootViewController:seq];

  nav2.preferredContentSize = CGSizeMake(320, 480);

  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    UIGestureRecognizer *panGestureRecoginizer =
        [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handlePan:)];
    [nav2.navigationBar addGestureRecognizer:panGestureRecoginizer];

    draggingPopover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    draggingPopover.layer.cornerRadius = 10.0f;
    draggingPopover.layer.masksToBounds = YES;
    draggingPopover.backgroundColor = [UIColor whiteColor];
    nav2.view.frame = CGRectMake(0, 0, 320, 480);
    [draggingPopover addSubview:nav2.view];
    [self.view addSubview:draggingPopover];
  } else {
    [self.presentedViewController presentViewController:nav2
                                               animated:YES_PLEASE
                                             completion:nil];
  }
}

- (void)brushPicker:(IMBrushPickerViewController *)picker
     didSelectBrush:(IMBrush *)brush {
  NSString *json = [brush json];
  [self.canvasContainerView setBrushJSON:json];
  [self dismissPopoverAndModalViewControllers];
}

- (void)brushPicker:(IMBrushPickerViewController *)picker didSelectSequence:(NSUInteger)sequence {
  UIImage *image = [self.canvasContainerView currentBackgroundImage];
  [[DeepDreamAPIClient sharedClient] requestDeepDreamImageUsingImage:image withStyle:sequence completionHandler:^(UIImage *image) {
    dispatch_async(dispatch_get_main_queue(), ^(void){
      [self.canvasContainerView setBackgroundImage:image];
    });
  }];
}

- (void)brushPickerDidCancel:(IMBrushPickerViewController *)picker {
  [self dismissPopoverAndModalViewControllers];
}

- (void)aboutButtonPressed:(id)sender {
  UIViewController *viewController = [[IMAboutViewController alloc] init];
  UINavigationController *nav = [[UINavigationController alloc]
      initWithRootViewController:viewController];
  nav.modalPresentationStyle = UIModalPresentationFormSheet;
  [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark -
#pragma mark UI
- (void)dismissPopoverAndModalViewControllers {
  if (self.presentedViewController) {
    [self dismissViewControllerAnimated:YES completion:nil];
  }
  [self.canvasContainerView resume];
  [self.popover dismissPopoverAnimated:YES];
}

- (void)picker:(IMImagePickingViewController *)picker
    didFinishPickingImage:(UIImage *)image {
  NSString *json = [[IMBrush currentBrush] json];
  [self.canvasContainerView createNewCanvasWithImage:image presets:json];
  [self dismissPopoverAndModalViewControllers];
  [self.heartButton setEnabled:YES];
  [self.imagePickingButton setEnabled:YES];
  if (draggingPopover) {
    [self.view bringSubviewToFront:draggingPopover];
  }
}

- (void)picker:(IMImagePickingViewController *)picker
    didFinishPickingImageWithURL:(NSURL *)url {
  NSString *json = [[IMBrush currentBrush] json];
  [self.canvasContainerView createNewCanvasWithImageURL:url presets:json];
  [self dismissPopoverAndModalViewControllers];
  [self.heartButton setEnabled:YES];
  [self.imagePickingButton setEnabled:YES];
  if (draggingPopover) {
    [self.view bringSubviewToFront:draggingPopover];
  }
}

- (void)imagePickerDidCancel:(IMImagePickingViewController *)picker {
  [self dismissPopoverAndModalViewControllers];
  [self.imagePickingButton setEnabled:YES];
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
    __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_3_0) {
  [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark CApturing and Uploading
- (void)capturePaintingAndBlockAndPerformWithoutUpload:
    (void (^)(IMPainting *painting))action {
  [self dismissPopoverAndModalViewControllers];
  [UIView animateWithDuration:0.33f
                   animations:^(void) {
                     [self.heartButton setAlpha:0];
                   }];
  [self.canvasContainerView
      capturePaintingWithCompletionHandeler:^(IMPainting *painting) {
        action(painting);
        [UIView animateWithDuration:0.33f
                         animations:^(void) {
                           [self.heartButton setAlpha:1.0f];
                         }];
      }];
}

- (void)capturePaintingAndBlockAndPerform:
    (void (^)(IMPainting *painting))action {
#if DONT_UPLOAD_BEFORE_SHARING
  [self capturePaintingAndBlockAndPerformWithoutUpload:action];
#else
  [self capturePaintingAndBlockAndPerformWithoutUpload:^(IMPainting *painting) {
    [self.canvasContainerView
        showProgressHUDWithString:NSLocalizedString(@"UPLOADING", nil)];
    [_networkManager uploadPainting:painting
        withCompletion:^(void) {
          [self.canvasContainerView hideProgressView];
          [UIView animateWithDuration:0.33f
                           animations:^(void) {
                             [self.heartButton setAlpha:1];
                           }];
          action(painting);
        }
        withFailure:^(void) {
          UIAlertView *alert = [[UIAlertView alloc]
                  initWithTitle:NSLocalizedString(@"ERROR", nil)
                        message:NSLocalizedString(@"UPLOAD_FAILED", nil)
                       delegate:nil
              cancelButtonTitle:NSLocalizedString(@"OK", nil)
              otherButtonTitles:nil];
          [alert show];
          [self.canvasContainerView hideProgressView];
          [UIView animateWithDuration:0.33f
                           animations:^(void) {
                             [self.heartButton setAlpha:1];
                           }];
          [UIView animateWithDuration:0.33f
                           animations:^(void) {
                             [self.progressLabel setAlpha:0];
                           }];
          [UIView animateWithDuration:0.33f
                           animations:^(void) {
                             [self.progressView setAlpha:0];
                           }];
        }];
  }];
#endif
}

#pragma mark Sharing Delegate
- (void)emailButtonPressed:(id)sender {
  [self capturePaintingAndBlockAndPerform:^(IMPainting *painting) {
    UIImage *image = [painting capturedImage];

    MFMailComposeViewController *vc =
        [[MFMailComposeViewController alloc] init];
    if ([[vc class] canSendMail]) {
      [vc setSubject:NSLocalizedString(@"EMAIL_SHARING_SUBJECT", nil)];
      NSString *link =
          [NSString stringWithFormat:@"<a href=\"%@\">%@</a>", painting.postURL,
                                     painting.postURL];
      NSString *body = [NSString
          stringWithFormat:NSLocalizedString(@"EMAIL_SHARING_HTML_{LINK}", nil),
                           link];
      [vc setMessageBody:body isHTML:YES];

      vc.mailComposeDelegate = self;
      NSData *jpegData = UIImageJPEGRepresentation(image, 1);

      NSString *fileName = @"impressionist";
      fileName = [fileName stringByAppendingPathExtension:@"jpeg"];
      [vc addAttachmentData:jpegData mimeType:@"image/jpeg" fileName:fileName];

      [self dismissPopoverAndModalViewControllers];
      [self presentViewController:vc animated:YES completion:nil];
    } else {
      UIAlertView *alert = [[UIAlertView alloc]
              initWithTitle:NSLocalizedString(@"ERROR", nil)
                    message:NSLocalizedString(
                                @"THIS_DEVICE_NOT_CONFIGURED_FOR_EMAIL", nil)
                   delegate:nil
          cancelButtonTitle:NSLocalizedString(@"OK", nil)
          otherButtonTitles:nil];
      [alert show];
    }
  }];
}

- (void)openInButtonPressed:(id)sender {
  [self capturePaintingAndBlockAndPerformWithoutUpload:^(IMPainting *painting) {

    NSString *text = NSLocalizedString(@"APP_SHARING_TEXT", nil);
    // NSURL *url = [NSURL URLWithString:painting.postURL];
    UIImage *image = painting.capturedImage;
    if (YES) {
      UIActivityViewController *controller = [[UIActivityViewController alloc]
          initWithActivityItems:@[ text, image ]
          applicationActivities:nil];

      controller.excludedActivityTypes = @[
        UIActivityTypePrint,
        UIActivityTypeCopyToPasteboard,
        UIActivityTypeAddToReadingList,
        UIActivityTypePostToVimeo,
        UIActivityTypePostToTencentWeibo,
        UIActivityTypeAirDrop
      ];
      controller.completionHandler =
          ^void(NSString *activityType, BOOL completed) {
            [UIView animateWithDuration:0.33f
                             animations:^(void) {
                               [self.heartButton setAlpha:1];
                             }];
          };
      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.popover = [[UIPopoverController alloc]
            initWithContentViewController:controller];
            self.popover.backgroundColor = [UIColor clearColor];
        [self.popover presentPopoverFromRect:self.heartButton.frame
                                      inView:self.view
                    permittedArrowDirections:UIPopoverArrowDirectionDown
                                    animated:YES];
      } else {
        [self presentViewController:controller animated:YES completion:nil];
      }
    }
  }];
}

- (void)saveToPhotosButtonPressed:(id)sender {
  [self.canvasContainerView
      showProgressHUDWithString:NSLocalizedString(@"Saving...", nil)];
  [self capturePaintingAndBlockAndPerformWithoutUpload:^(IMPainting *painting) {
    UIImageWriteToSavedPhotosAlbum(painting.capturedImage, self,
                                   @selector(thisImage:
                                       hasBeenSavedInPhotoAlbumWithError:
                                                        usingContextInfo:),
                                   NULL);
  }];
}

- (void)copyButtonPressed:(id)sender {
  [self.canvasContainerView
      showProgressHUDWithString:NSLocalizedString(@"Copying...", nil)];
  [self capturePaintingAndBlockAndPerformWithoutUpload:^(IMPainting *painting) {
    if (painting.postURL) {
      [[UIPasteboard generalPasteboard] setString:painting.postURL];
    }
    if (painting.capturedImage) {
      [[UIPasteboard generalPasteboard] setImage:painting.capturedImage];
    }
    [self performSelector:@selector(copyDidFinish)
               withObject:nil
               afterDelay:1.0];
  }];
}

- (void)postCardButtonPressed:(id)sender {
  [self capturePaintingAndBlockAndPerformWithoutUpload:^(IMPainting *painting) {
    UIImage *i = [painting capturedImage];
    SYSincerelyController *controller = [[SYSincerelyController alloc]
        initWithImages:@[ i ]
               product:SYProductTypePostcard
        applicationKey:[IMAppConfiguration sincerelyAppKey]
              delegate:self];
    [self presentViewController:controller animated:YES completion:NULL];
  }];
}

- (void)facebookButtonPressed:(id)sender {
  [self capturePaintingAndBlockAndPerform:^(IMPainting *painting) {
    SLComposeViewController *composeViewController = [SLComposeViewController
        composeViewControllerForServiceType:SLServiceTypeFacebook];
    [composeViewController
        setInitialText:NSLocalizedString(@"FACEBOOK_SHARING_TEXT", nil)];
#if !DONT_UPLOAD_BEFORE_SHARING
    NSURL *url = [NSURL URLWithString:painting.postURL];
    [composeViewController addURL:url];
#endif
    [composeViewController addImage:[painting capturedImage]];

    [self presentViewController:composeViewController
                       animated:YES
                     completion:nil];
  }];
}

- (void)instagramButtonPressed:(UIImage *)sender {
  self.crossAppSharingController = [[IMCrossAppSharingController alloc]
      initWithServiceType:CrossAppSharingTypeInstagram];
  if (NO == [IMCrossAppSharingController
                isAppInstalledForServiceType:CrossAppSharingTypeInstagram]) {
    [self.crossAppSharingController promptUserToInstallAppUsingViewController:
                                        self completion:^(BOOL canceled) {
      [self dismissPopoverAndModalViewControllers];
    }];
  } else {
    [self capturePaintingAndBlockAndPerform:^(IMPainting *painting) {
      painting.croppedImage = sender;
      interactionController = [self.crossAppSharingController
          interactionControllerWithPainting:painting];
      interactionController.delegate = self;
      [interactionController presentOpenInMenuFromRect:self.heartButton.frame
                                                inView:self.view
                                              animated:YES];
    }];
  }
}

- (void)tumblrButtonPressed:(id)sender {
  self.crossAppSharingController = [[IMCrossAppSharingController alloc]
      initWithServiceType:CrossAppSharingTypeTumblr];

  if (NO == [IMCrossAppSharingController
                isAppInstalledForServiceType:CrossAppSharingTypeTumblr]) {
    [self.crossAppSharingController promptUserToInstallAppUsingViewController:
                                        self completion:^(BOOL canceled) {
      [self dismissPopoverAndModalViewControllers];
    }];
  } else {
    [self capturePaintingAndBlockAndPerform:^(IMPainting *painting) {
      interactionController = [self.crossAppSharingController
          interactionControllerWithPainting:painting];
      interactionController.delegate = self;
      [interactionController presentOpenInMenuFromRect:self.heartButton.frame
                                                inView:self.view
                                              animated:YES];
    }];
  }
}

- (void)twitterButtonPressed:(id)sender {
  [self capturePaintingAndBlockAndPerform:^(IMPainting *painting) {
    SLComposeViewController *composeViewController = [SLComposeViewController
        composeViewControllerForServiceType:SLServiceTypeTwitter];
    [composeViewController
        setInitialText:NSLocalizedString(@"TWITTER_SHARING_TEXT", nil)];
#if !DONT_UPLOAD_BEFORE_SHARING
    NSURL *url = [NSURL URLWithString:painting.postURL];
    [composeViewController addURL:url];
#endif
    [composeViewController addImage:[painting capturedImage]];
    [self presentViewController:composeViewController
                       animated:YES
                     completion:nil];
  }];
}

#pragma mark -
#pragma mark Sharing Callbacks
- (void)thisImage:(UIImage *)image
    hasBeenSavedInPhotoAlbumWithError:(NSError *)error
                     usingContextInfo:(void *)ctxInfo {
  [UIView animateWithDuration:0.33f
                   animations:^(void) {
                     [self.heartButton setAlpha:1];
                   }];
  [self.canvasContainerView hideProgressView];

  if (error) {
    UIAlertView *alert = [[UIAlertView alloc]
            initWithTitle:NSLocalizedString(@"Error", nil)
                  message:NSLocalizedString(@"Error saving to photo library",
                                            nil)
                 delegate:nil
        cancelButtonTitle:NSLocalizedString(@"Ok", nil)
        otherButtonTitles:nil];
    [alert show];
  } else {
  }
}

- (void)copyDidFinish {
  [UIView animateWithDuration:0.33f
                   animations:^(void) {
                     [self.heartButton setAlpha:1];
                   }];
  [self.canvasContainerView hideProgressView];
}

- (void)sharingViewControllerDidRequestRenderedImage:
    (IMSharingViewController *)sharingViewController {
  IMImageCropViewController *cropViewController =
      [[IMImageCropViewController alloc]
          initWithNibName:@"IMImageCropViewController"
                   bundle:[NSBundle mainBundle]];
  cropViewController.delegate = sharingViewController;

  [self.canvasContainerView
      capturePaintingWithCompletionHandeler:^(IMPainting *painting) {
        cropViewController.cropImage = [painting capturedImage];
        [sharingViewController.navigationController
            pushViewController:cropViewController
                      animated:YES_PLEASE];
      }];
}

#pragma mark -
#pragma mark SYSincerelyControllerDelegate
- (void)sincerelyControllerDidFinish:(SYSincerelyController *)controller {
  [UIView animateWithDuration:0.33f
                   animations:^(void) {
                     [self.heartButton setAlpha:1];
                   }];
  [self dismissPopoverAndModalViewControllers];
  [self dismissViewControllerAnimated:YES completion:NULL];
  [self.canvasContainerView resume];
}

- (void)sincerelyControllerDidCancel:(SYSincerelyController *)controller {
  [UIView animateWithDuration:0.33f
                   animations:^(void) {
                     [self.heartButton setAlpha:1];
                   }];
  [self dismissPopoverAndModalViewControllers];
  [self dismissViewControllerAnimated:YES completion:NULL];
  [self.canvasContainerView resume];
}

- (void)sincerelyControllerDidFailInitiationWithError:(NSError *)error {
  [UIView animateWithDuration:0.33f
                   animations:^(void) {
                     [self.heartButton setAlpha:1];
                   }];
  [self dismissPopoverAndModalViewControllers];
  [self dismissViewControllerAnimated:YES completion:NULL];
  [self.canvasContainerView resume];
  NSLog(@"Error: %@", error);
}

#pragma mark -
#pragma mark Notifications
- (void)imageSettingsDidChange:(NSNotification *)notification {
  [self.canvasContainerView createNewCanvasWithExistingImageUsingPresets:
                                [[IMBrush currentBrush] json]];
}

#pragma mark - Transitioning Delegate (Modal) - Custom View Controller Animations
- (id<UIViewControllerAnimatedTransitioning>)
animationControllerForPresentedController:(UIViewController *)presented
                     presentingController:(UIViewController *)presenting
                         sourceController:(UIViewController *)source {
  _scaleAnimationController.type = AnimationTypePresent;
  return _scaleAnimationController;
}

- (id<UIViewControllerAnimatedTransitioning>)
animationControllerForDismissedController:(UIViewController *)dismissed {
  _scaleAnimationController.type = AnimationTypeDismiss;
  return _scaleAnimationController;
}

- (void)canvasBackgroundOpacityDidChange:(CGFloat)alpha {
  [self.canvasContainerView setBackgroundImageAlpha:alpha];
}

@end
