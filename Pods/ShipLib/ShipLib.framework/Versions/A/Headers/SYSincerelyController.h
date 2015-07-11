//
//  SYSincerelyController.h
//  Sincerely
//
//  Created by Sincerely on 7/5/11.
//  Copyright 2013 Sincerely, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYConstants.h"

extern NSString *const SYSincerelyErrorDomain;

@protocol SYSincerelyControllerDelegate;

@interface SYSincerelyController : UINavigationController {
    
}

@property (nonatomic, weak) id <SYSincerelyControllerDelegate> sincerelyDelegate;

/*
 * If you would like to skip the crop screen, set this value to YES.
 * The photo submitted will be center cropped to a resolution of 1200 x 1800.
 */

@property (nonatomic, assign) BOOL shouldSkipCrop;

/*
 * If you would like to skip the personalize screen (message + profile photo) set this value to YES.
 */

@property (nonatomic, assign) BOOL shouldSkipPersonalize;

/*
 * Setting this value will pre-populate the message field.
 */

@property (nonatomic, copy) NSString *message;

/*
 * Setting this value will pre-populate the selected profile photo.
 */

@property (nonatomic, strong) UIImage *profilePhoto;

/*
 * Setting this value will pre-select the recipients in the array.
 * Each value in the array must be the following:
 *
 * @type NSDictionary
 *      name - NSString (required)
 *      street1 - NSString (required)
 *      street2 - NSString
 *      city - NSString (required)
 *      state - NSString
 *      zipcode - NSString
 *      country - NSString (required)
 *
 * You must include the 4 required fields: name, street1, city, country in order for your recipient to appear in the list.
 *
 * Alternatively, for US based addresses, you can submit just name, city, and zipcode and we will fill out the remaining fields for you.
 */

@property (nonatomic, strong) NSArray *recipients;

/*
 * Use this method to create a SYSincerelyController that you can use to display modally.
 * 
 * @param images - An NSArray object that must only contain UIImage objects. If any other objects are present in the array, this initializer will return nil.
 * @param productType - A product type as defined in SYConstants.h
 * @param applicationKey - Your application key designated for this app from http://dev.sincerely.com
 * @param delegate - The object to receive delegate callbacks.
 *
 * Special notes: It is possible for this method to return nil. If it does so, sincerelyControllerDidFailInitiationWithError: will be called.
 * Because it can return nil, you must check for a non-nil value before calling [self presentModalViewController:animated:]
 * 
 * Product Type requirements:
 * SYProductTypePostcard - The images array must contain one and only one UIImage object. Any other will cause nil to be returned.
 */

- (id)initWithImages:(NSArray *)images product:(SYProductType)productType applicationKey:(NSString *)appKey delegate:(id <SYSincerelyControllerDelegate>)delegate;

@end

@protocol SYSincerelyControllerDelegate <NSObject>

@required
- (void)sincerelyControllerDidFinish:(SYSincerelyController *)controller;
- (void)sincerelyControllerDidCancel:(SYSincerelyController *)controller;
- (void)sincerelyControllerDidFailInitiationWithError:(NSError *)error;

@end
