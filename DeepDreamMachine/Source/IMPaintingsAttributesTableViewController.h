//
//  IMPaintingsAttributesTableViewController.h
//  Impressionism
//
//  Created by Brad on 5/29/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMAttributeTableViewCell.h"

@protocol IMPaintingsAttributesTableViewControllerDelegate <NSObject>

-(void)paintingAttribute:(NSString *)attributeName didChangeToValue:(NSNumber *)value;

-(void)currentBrushEdited:(NSString *)json;

@end

@interface IMPaintingsAttributesTableViewController : UITableViewController <IMAttributeTableViewCellDelegate>

@property (nonatomic) NSString *fileName;
@property (nonatomic) id delegate;

@property BOOL hasBeenModified;

- (id) initWithJSON:(NSString *)attributes;

@end

