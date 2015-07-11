//
//  IMAttributeTableViewCell.h
//  Impressionism
//
//  Created by Brad on 5/29/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IMAttributeTableViewCell;

@protocol IMAttributeTableViewCellDelegate <NSObject>

-(void) tableViewCell:(IMAttributeTableViewCell *)cell valueDidChange:(NSNumber *)value;


@end

@interface IMAttributeTableViewCell : UITableViewCell

@property (nonatomic) IBOutlet UISlider *slider;
@property (nonatomic) IBOutlet UISwitch *theSwitch;
@property (nonatomic) IBOutlet UILabel *valueLabel;

@property (nonatomic, weak) id delegate;

@property (nonatomic) NSNumber *attributeValue;

@property (nonatomic) NSString *attributeName;

@property (nonatomic) CGFloat minimumValue;
@property (nonatomic) CGFloat maximumValue;



@end
