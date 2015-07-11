//
//  UIImage+Scaling.h
//  Impressionism
//
//  Created by Brad on 5/3/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scaling)

-(UIImage*)imageByScalingToSize:(CGSize)targetSize;

- (UIImage *) scaleToSize: (CGSize)size;

- (UIImage *) scaleProportionalToMaxDimension: (CGFloat)dimension;

@end
