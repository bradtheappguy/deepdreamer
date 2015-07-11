//
//  IMBrushPickerViewController.h
//  Impressionism
//
//  Created by josh michaels on 7/11/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMBrush.h"
#import "IMSequence.h"

@class IMBrushPickerViewController;


@protocol IMBrushPickerViewControllerDelegate <NSObject>

-(void) brushPicker:(IMBrushPickerViewController *)picker didSelectBrush:(IMBrush *)brush;
-(void) brushPicker:(IMBrushPickerViewController *)picker didSelectSequence:(IMSequence *)sequence;
-(void) brushPickerDidCancel:(IMBrushPickerViewController *)picker;

-(void) presentBrushEditor;
-(void) presentSequenceEditor;

@end

@interface IMBrushPickerViewController : UIViewController

@property (nonatomic, assign) id <IMBrushPickerViewControllerDelegate> delegate;

@end
