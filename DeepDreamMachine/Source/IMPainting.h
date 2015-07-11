//
//  IMPainting.h
//  Impressionism
//
//  Created by Brad on 4/11/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMPaintingAttributes.h"

@interface IMPainting : NSObject

@property (nonatomic) NSString *postURL;
@property (nonatomic) NSString *originalURL;

@property (nonatomic) UIImage *originalImage;
@property (nonatomic) UIImage *capturedImage;
@property (nonatomic) UIImage *croppedImage;
@property (nonatomic) IMPaintingAttributes *attributes;

@property (nonatomic) NSString *noisemap;


-(BOOL) isUploaded;

-(id) initWithOriginalImage:(UIImage *)original renderedImage:(UIImage *)rendered options:(NSString *)json noisemap:(NSString *)noisemap;

@end
