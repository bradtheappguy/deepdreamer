//
//  IMBrushPickerViewController.m
//  Impressionism
//
//  Created by josh michaels on 7/11/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import "IMBrushPickerViewController.h"
#import "IMRootViewController.h"
#import "IMBrush.h"
#import "IMSettings.h"

@interface IMBrushPickerViewController (/* private */) {
  NSUInteger _selectdIndex;
  IMBrush *_selectedBrush;

  IMSequence *_selectedSequence;
  NSUInteger _selectedSequenceIndex;
}

@property (nonatomic) IBOutlet UIButton *closeButton;
@property (nonatomic) IBOutlet UIButton *leftButton;
@property (nonatomic) IBOutlet UIButton *rightButton;
@property (nonatomic) IBOutlet UIButton *palleteButton;

@property (nonatomic) IBOutlet UILabel *brushNameLabel;

@property (nonatomic) IBOutlet UISlider *sizeSilder;
@property (nonatomic) IBOutlet UISlider *opacitySlider;

@property (nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *debugEditButton;
@end


@implementation IMBrushPickerViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

#if DEBUG
  self.debugEditButton.hidden = NO;
#else
  self.debugEditButton.hidden = YES;
#endif

  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    self.closeButton.hidden = YES;
    self.closeButton.enabled = NO;
  }

  self.sizeSilder.maximumValue = 100;
  self.sizeSilder.minimumValue = 0;

  self.opacitySlider.maximumValue = 1;
  self.opacitySlider.minimumValue = 0;

  _selectdIndex = [IMSettings brushSelectedIndex];

  _selectedSequenceIndex = [IMSettings sequeunceSelectedIndex];
  [self update];
}


-(void) update {
  [IMSettings setBrushSelectedIndex:_selectdIndex];
  [IMSettings setSequenceSelectedIndex:_selectedSequenceIndex];

  self.leftButton.enabled = YES;
  self.rightButton.enabled = YES;

  if (self.segmentedControl.selectedSegmentIndex == 0) {
    [_selectedBrush save];
    _selectedBrush = [IMBrush brushWithIndex:_selectdIndex];
    [_selectedBrush makeCurrent];
    [self.delegate brushPicker:self didSelectBrush:_selectedBrush];
    
    self.sizeSilder.enabled = YES;
    self.opacitySlider.enabled = YES;
    self.brushNameLabel.text = _selectedBrush.name;
    [self.sizeSilder setValue:_selectedBrush.thickness animated:YES];
    [self.opacitySlider setValue:_selectedBrush.opacity animated:YES];
    if (_selectdIndex <= 0) {
      self.leftButton.enabled = NO;
    }
    if (_selectdIndex >= [IMBrush numberOfBrushes] - 1) {
      self.rightButton.enabled = NO;
    }
    self.imageView.image = _selectedBrush.brushImage;
  }
  else {
    _selectedSequence = [IMSequence sequenceWithIndex:_selectedSequenceIndex];
    [_selectedSequence makeCurrent];
    self.sizeSilder.enabled = NO;
    self.opacitySlider.enabled = NO;
    self.brushNameLabel.text = _selectedSequence.name;
    [self.sizeSilder setValue:50 animated:YES];
    [self.opacitySlider setValue:0.5 animated:YES];
    if (_selectedSequenceIndex <= 0) {
      self.leftButton.enabled = NO;
    }
    if (_selectedSequenceIndex >= [IMSequence numberOfSequences] - 1) {
      self.rightButton.enabled = NO;
    }
    self.imageView.image = _selectedSequence.brushImage;
  }


}

#pragma mark -
#pragma mark IBActions
- (IBAction)closeButtonPressed:(id)sender {
  [_selectedBrush save];
  [self.delegate brushPickerDidCancel:self];
}

-(IBAction)leftBrushButtonPressed:(id)sender {
  if (self.segmentedControl.selectedSegmentIndex == 0) {
    _selectdIndex--;
  }
  else {
    _selectedSequenceIndex--;
  }
  [self update];
}

-(IBAction)rightBrushButtonPressed:(id)sender {
  if (self.segmentedControl.selectedSegmentIndex == 0) {
    _selectdIndex++;
  }
  else {
    _selectedSequenceIndex++;
  }
  [self update];
}

-(IBAction)sizeSliderDidChange:(UISlider *)sender {
  [_selectedBrush setSize:sender.value];
}

-(IBAction)opacitySliderDidChange:(UISlider *)sender {
  [_selectedBrush setOpacity:sender.value];
}

-(IBAction)palleteButtonPressed:(UIButton *)sender {

}

-(IBAction)actionButtonPressed:(UIButton  *)sender {
    [self.delegate brushPicker:self didSelectSequence:_selectedSequence];
}

-(IBAction)segmentedControlValueDidChange:(UISegmentedControl *)sender {
  [self update];
}

- (IBAction)debugEditButtonPressed:(id)sender {
  [_selectedBrush save];
  if (self.segmentedControl.selectedSegmentIndex == 0) {
    [self.delegate presentBrushEditor];
  }
  else {
    [self.delegate presentSequenceEditor];
  }
}
@end

