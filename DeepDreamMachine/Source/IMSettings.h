//
//  IMSettings.h
//  Impressionism
//
//  Created by Brad on 4/24/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IMImageFormat) {
  IMImageFormatJPEG,
  IMImageFormatPNG
};

typedef NS_ENUM(NSInteger, IMImageSize) {
  IMImageSizeSmall,
  IMImageSizeMedium,
  IMImageSizeLarge,
  IMImageSizeOriginal
};

extern NSString *const IMSettingsImageSizeSettingDidChangeNotification;


@interface IMSettings : NSObject

+(IMImageSize) imageSize;
+(IMImageFormat) imageFormat;

+(void) setImageSize:(IMImageSize)size;
+(void) setImageFormat:(IMImageFormat)format;

+(CGFloat) maximumResolutionForCurrentImageSize;

+(BOOL) pinchToZoomEnabled;

+(void) setCanvasBackgroundAlpha:(CGFloat)alpha;
+(CGFloat) canvasBackgroundAlpha;

+(void) setCanvasSelectedIndex:(NSUInteger)index;
+(NSUInteger) canvasSelectedIndex;

+(void) setBrushSelectedIndex:(NSUInteger)index;
+(NSUInteger) brushSelectedIndex;

+(void) setSequenceSelectedIndex:(NSUInteger)index;
+(NSUInteger) sequeunceSelectedIndex;
@end
