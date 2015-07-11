//
//  UIImage+FixRotation.h
//  Impressionism
//
//  Created by Brad on 5/17/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FixRotation)

- (UIImage *)fixRotation:(UIImage *)image;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

@end
