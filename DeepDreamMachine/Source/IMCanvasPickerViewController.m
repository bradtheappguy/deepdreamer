//
//  IMCanvasPickerViewController.m
//  Impressionism
//
//  Created by josh michaels on 7/11/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import "IMCanvasPickerViewController.h"
#import "IMRootViewController.h"
#import "IMBrush.h"
#import "IMSettings.h"

@interface IMCanvasPickerViewController (/* private */) {
  NSUInteger _selectdIndex;
}
@property (nonatomic) IBOutlet UIButton *closeButton;
@property (nonatomic) IBOutlet UIButton *leftButton;
@property (nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UILabel *canvasNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISlider *opacitySlider;
@end


@implementation IMCanvasPickerViewController

-(void) awakeFromNib {
  [super awakeFromNib];
  _selectdIndex = 0;
  //self.selectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"IMMainScrollViewSelectedIndex"];
  [self update];
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.closeButton.hidden = YES;
        self.closeButton.enabled = NO;
    }
  _selectdIndex = [IMSettings canvasSelectedIndex];
  self.opacitySlider.value = [IMSettings canvasBackgroundAlpha];
  [self update];
}


- (IBAction)opacityValueDidChange:(UISlider *)sender {
  [self.delegate canvasBackgroundOpacityDidChange:sender.value];
  [IMSettings setCanvasBackgroundAlpha:sender.value];
}

- (IBAction)closeButtonPressed:(id)sender {
    IMRootViewController *rootViewController = (IMRootViewController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [rootViewController dismissViewControllerAnimated:YES completion:nil];
    [rootViewController dismissPopoverAndModalViewControllers];
}

-(void) update {
  if (_selectdIndex == 0) {
    self.leftButton.enabled = NO;
    self.rightButton.enabled = YES;
    self.canvasNameLabel.text = @"Original Photo";
    self.opacitySlider.value = [IMSettings canvasBackgroundAlpha];
    self.opacitySlider.enabled = YES;
    [IMSettings setCanvasBackgroundAlpha:[IMSettings canvasBackgroundAlpha]];
  }
  if (_selectdIndex == 1) {
    self.leftButton.enabled = YES;
    self.rightButton.enabled = NO;
    self.canvasNameLabel.text = @"Black";
    self.opacitySlider.value = 0;
    self.opacitySlider.enabled = NO;
    [IMSettings setCanvasBackgroundAlpha:0];
  }
  [IMSettings setCanvasSelectedIndex:_selectdIndex];
}

#pragma mark Buttons
-(IBAction)leftBrushButtonPressed:(id)sender {
  _selectdIndex--;
  [self update];
}

-(IBAction)rightBrushButtonPressed:(id)sender {
  _selectdIndex++;
  [self update];
}

- (IBAction)resetButtonPressed:(id)sender {
  [self.delegate resetCanvasButtonPressed:sender];
}
@end
