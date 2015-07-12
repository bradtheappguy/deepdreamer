//
//  IMSharingViewController.m
//  Impressionism
//
//  Created by Brad on 4/23/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import "IMSharingViewController.h"
#import "IMRootViewController.h"
#import "IMSettingsViewController.h"
#import "IMImageCropViewController.h"

@interface IMSharingViewController () <IMImageCropViewControllerDelegate>

@end

@implementation IMSharingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.preferredContentSize = CGSizeMake(509, 408);
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void) viewDidLoad {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.closeButton.hidden = YES;
        self.closeButton.enabled = NO;
    }
    self.view.superview.backgroundColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

/*
- (void) viewWillLayoutSubviews {
    NSLog(@"Entered VWLS");
}
- (void) viewDidLayoutSubviews {

}
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Buttons
- (IBAction)closeButtonPressed:(id)sender {
    IMRootViewController *rootViewController = (IMRootViewController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [rootViewController dismissViewControllerAnimated:YES completion:nil];
    [rootViewController dismissPopoverAndModalViewControllers];
}

-(IBAction)emailButtonPressed:(id)sender {
    [self.delegate emailButtonPressed:nil];
}

- (IBAction)openInButtonPressed:(id)sender {
    [self.delegate openInButtonPressed:sender];
}

- (IBAction)saveToPhotosButtonPressed:(id)sender {
    [self.delegate saveToPhotosButtonPressed:sender];
}

- (IBAction)copyButtonPressed:(id)sender {
    [self.delegate copyButtonPressed:sender];
}

- (IBAction)postCardButtonPressed:(id)sender {
    [self.delegate postCardButtonPressed:sender];
}
- (IBAction)instagramButtonPressed:(id)sender {
    [self.delegate sharingViewControllerDidRequestRenderedImage:self];
}
- (IBAction)tumblrButtonPressed:(id)sender {
    [self.delegate tumblrButtonPressed:sender];
}
- (IBAction)twitterButtonPressed:(id)sender {
    [self.delegate twitterButtonPressed:sender];
}
- (IBAction)facebookButtonPressed:(id)sender {
    [self.delegate facebookButtonPressed:sender];
}

-(void) cropViewController:(IMImageCropViewController *)controller didCropImage:(UIImage *)image {
  [self.delegate instagramButtonPressed:image];
}

@end
