//
//  IMAttributeTableViewCell.m
//  Impressionism
//
//  Created by Brad on 5/29/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import "IMAttributeTableViewCell.h"

@implementation IMAttributeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) setAttributeValue:(NSNumber *)attributeValue {
  _attributeValue = attributeValue;
  self.slider.value = [_attributeValue floatValue];
  self.theSwitch.on = [_attributeValue boolValue];
  [self.valueLabel setText:[_attributeValue stringValue]];
}


-(void)setAttributeName:(NSString *)attributeName {
  _attributeName = attributeName;
  [self.textLabel setText:attributeName];
}

-(void)setMinimumValue:(CGFloat)minimumValue {
  _maximumValue = minimumValue;
  _slider.minimumValue = minimumValue;
}

-(void)setMaximumValue:(CGFloat)maximumValue {
  _maximumValue = maximumValue;
  _slider.maximumValue = maximumValue;
}

-(IBAction)sliderValueChanged:(UISlider *)sender {

}

-(IBAction)sliderTouchUpInside:(UISlider *)sender {
  CGFloat value = sender.value;
  self.attributeValue = [NSNumber numberWithFloat:value];
  [self.delegate tableViewCell:self valueDidChange:self.attributeValue];
}


-(IBAction)switchValueChanged:(UISwitch *)sender {
  BOOL value = sender.isOn;
  self.attributeValue = [NSNumber numberWithBool:value];
  [self.delegate tableViewCell:self valueDidChange:self.attributeValue];
}

@end
