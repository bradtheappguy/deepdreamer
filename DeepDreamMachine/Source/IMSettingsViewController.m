//
//  IMSettingsViewController.m
//  Impressionism
//
//  Created by Brad on 4/24/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import "IMSettingsViewController.h"
#import "IMSettings.h"
#import "UIAlertView+blocks.h"
#import "IMRootViewController.h"

@interface IMSettingsViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *imageFormatSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *imageSizeSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *bottomTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *topTextLabel;
@end

@implementation IMSettingsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = NSLocalizedString(@"Image Settings", @"Settings");
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"Save") style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed:)];
  [self.imageFormatSegmentedControl setSelectedSegmentIndex:[IMSettings imageFormat]];
  [self.imageSizeSegmentedControl setSelectedSegmentIndex:[IMSettings imageSize]];
  [self updateTextLabels];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.closeButton.hidden = YES;
        self.closeButton.enabled = NO;
    }
 }

- (void)updateTextLabels {

  CGFloat maxResolution = [IMSettings maximumResolutionForCurrentImageSize];
  self.bottomTextLabel.text =
  [NSString stringWithFormat:
   NSLocalizedString(@"IMAGE WILL BE SAVED WITH A MAXIMUM SiZE OF %dx%d PIXELS.", nil),(int)maxResolution,(int)maxResolution];

  NSString *format = @"";
  if ([IMSettings imageFormat] == IMImageFormatJPEG) {
    format = @"JPEGs";
  }
  else {
    format = @"PNGs";
  }
  self.topTextLabel.text = format;
  NSLocalizedString(@"EXPORTED IMAGES WILL BE SAVED AS %@", format);
}

#pragma mark -
#pragma mark Button Handeling

-(void) saveButtonPressed:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)closeButtonPressed:(id)sender {
    IMRootViewController *rootViewController = (IMRootViewController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [rootViewController dismissViewControllerAnimated:YES completion:nil];
    [rootViewController dismissPopoverAndModalViewControllers];
}

- (IBAction)formatSegmentedControlValueDidChange:(UISegmentedControl *)sender {
  [IMSettings setImageFormat:sender.selectedSegmentIndex];
  [self updateTextLabels];
}

- (IBAction)sizeSegmentedControlValueDidChange:(UISegmentedControl *)sender {
  [IMSettings setImageSize:sender.selectedSegmentIndex];
  [self updateTextLabels];
}


- (IBAction)resetAllCustomSettingsButtonPressed:(id)sender {
  [UIAlertView showOKCancelAlertWithMessage:NSLocalizedString(@"RESET_ALL_CUSTOM_PRESETS", nil) OKBlock:^(void){
    for (int index = 1; index < 20; index++) {
      NSString *fileName = [NSString stringWithFormat:@"%d.json",index];
      NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
      NSString *documentsDirectory = [paths objectAtIndex:0];
      NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
      [[NSFileManager defaultManager] removeItemAtPath:path error:0];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ALERT", nil) message:NSLocalizedString(@"ALL_CUSOM_PRESETS_HAVE_BEEN_DELETED", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    alert.tag = 1;
    [alert show];
  }];
}
@end
