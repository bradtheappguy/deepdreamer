//
//  IMBrushImagePickerViewController.h
//  Impressionism
//
//  Created by Brad on 7/1/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMPaintingsAttributesTableViewController.h"

@interface IMBrushImagePickerViewController : UIViewController {
  IBOutlet UICollectionView *collectionView;


}
@property NSDictionary *attributes;
@property id <IMPaintingsAttributesTableViewControllerDelegate> delegate;
@end
