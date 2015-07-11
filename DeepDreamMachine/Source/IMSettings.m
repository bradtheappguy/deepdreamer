//
//  IMSettings.m
//  Impressionism
//
//  Created by Brad on 4/24/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import "IMSettings.h"

@implementation IMSettings

static NSString *kIMSettingsImageSizeKey = @"IMSettingsImageSizeKey";
static NSString *kIMSettingsImageFormatKey = @"IMSettingsImageFormatKey";

static NSString *kIMSettingsCanvasBackgroundAlpha = @"IMSettingsCanvasBackgroundAlpha";

static CGFloat kMaximumResoultionLarge = 2048;
static CGFloat kMaximumResoultionMedium = 1024;
static CGFloat kMaximumResoultionSmall = 512;

NSString *const IMSettingsImageSizeSettingDidChangeNotification = @"IMSettingsImageSizeSettingDidChangeNotification";

+(IMImageSize) imageSize {
  return [[NSUserDefaults standardUserDefaults] integerForKey:kIMSettingsImageSizeKey];
}

+(IMImageFormat) imageFormat {
  return [[NSUserDefaults standardUserDefaults] integerForKey:kIMSettingsImageFormatKey];
}

+(void) setImageSize:(IMImageSize)size {
  [[NSUserDefaults standardUserDefaults] setInteger:size forKey:kIMSettingsImageSizeKey];
  [[NSUserDefaults standardUserDefaults] synchronize];
  [[NSNotificationCenter defaultCenter] postNotificationName:IMSettingsImageSizeSettingDidChangeNotification object:self userInfo:nil];
}

+(void) setImageFormat:(IMImageFormat)format {
  [[NSUserDefaults standardUserDefaults] setInteger:format forKey:kIMSettingsImageFormatKey];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+(CGFloat) maximumResolutionForCurrentImageSize {
  CGFloat maxResolution;
  switch ([IMSettings imageSize]) {
    case IMImageSizeSmall:
      maxResolution = kMaximumResoultionSmall;
      break;
    case IMImageSizeMedium:
      maxResolution = kMaximumResoultionMedium;
      break;
    case IMImageSizeLarge:
      maxResolution = kMaximumResoultionLarge;
      break;
    case IMImageSizeOriginal:
      maxResolution = kMaximumResoultionLarge;  //Original is not yet supported
      break;
  }
  return maxResolution;
}

+(BOOL) pinchToZoomEnabled {
  return YES;
}

+(void) setCanvasBackgroundAlpha:(CGFloat)alpha {
  [[NSUserDefaults standardUserDefaults] setFloat:alpha forKey:kIMSettingsCanvasBackgroundAlpha];
}

+(CGFloat) canvasBackgroundAlpha {
  return [[NSUserDefaults standardUserDefaults] floatForKey:kIMSettingsCanvasBackgroundAlpha];
}

+(void) setCanvasSelectedIndex:(NSUInteger)index {
  [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"selected_canvas"];
}

+(NSUInteger) canvasSelectedIndex {
  return [[NSUserDefaults standardUserDefaults] integerForKey:@"selected_canvas"];
}

+(void) setBrushSelectedIndex:(NSUInteger)index {
  [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"selected_brush"];
}

+(NSUInteger) brushSelectedIndex {
  return [[NSUserDefaults standardUserDefaults] integerForKey:@"selected_brush"];
}

+(void) setSequenceSelectedIndex:(NSUInteger)index {
  [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"selected_sequeunce"];
}

+(NSUInteger) sequeunceSelectedIndex {
  return [[NSUserDefaults standardUserDefaults] integerForKey:@"selected_sequeunce"];
}
@end
