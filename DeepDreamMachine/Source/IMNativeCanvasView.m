//
//  IMNativeCanvasView.m
//  Impressionism
//
//  Created by Brad on 4/26/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import "IMNativeCanvasView.h"
#import "IMPaintingAttributes.h"
#import "UIImage+Scaling.h"
#import "UIImage+Resize.h"
#import "IMSettings.h"
#import "UIImage+FixRotation.h"
#import <ImageIO/ImageIO.h>
#import "IMAppDelegate.h"

@implementation IMNativeCanvasView

- (id)initWithImage:(UIImage *)image presets:(NSString *)presets {
  self = [super initWithFrame:CGRectMake(0, 0, 0, 0) appFolder:@"/"];
  if (self) {
    [self clearCaches];
    //[self loadScriptAtPath:@"ejecta-main.js"];
    self.originalImage = nil;

    backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    backgroundImageView.backgroundColor = [UIColor redColor];
    backgroundImageView.alpha = 1;//[IMSettings canvasBackgroundAlpha];
    self.backgroundColor = [UIColor blueColor];
    self.backgroundColor = [UIColor redColor];
    backgroundImageView.alpha = 1.0;
    [self addSubview:backgroundImageView];
    [self sendSubviewToBack:backgroundImageView];

    [self setImage:image withpresets:presets];

    self.userInteractionEnabled = YES;
  }
  return self;
}

- (id)initWithImageURL:(NSURL *)url presets:(NSString *)presets {
  return [self initWithImage:[UIImage imageWithContentsOfFile:url.path]
                     presets:presets];
}

- (void)setImage:(UIImage *)image withpresets:(NSString *)json {
  NSLog(@"original points: %f %f", image.size.width, image.size.height);
  NSLog(@"original pixels: %f %f", image.size.width * image.scale,
        image.size.height * image.scale);

  _image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit
                                       bounds:CGSizeMake(1024, 1024)
                         interpolationQuality:kCGInterpolationHigh];

  if (!self.originalImage) {
    self.originalImage = _image;
  }

  self.frame = CGRectMake(0, 0, _image.size.width, _image.size.height);
  //[backgroundImageView setContentMode:UIViewContentModeScaleAspectFit];
  backgroundImageView.contentScaleFactor = 1.0;

  [backgroundImageView setImage:_image];
  backgroundImageView.alpha = 1;//[IMSettings canvasBackgroundAlpha];

 
#pragma mark THIS IS WHERE WE NEED TO CODE
      [[NSNotificationCenter defaultCenter] postNotificationName:@"HIDE_PROGESS_LABEL" object:nil userInfo:nil];
  
  NSLog(@"resied points:  %f %f", _image.size.width, _image.size.height);
  NSLog(@"resied pixels:  %f %f", _image.size.width * image.scale,
        _image.size.height * image.scale);



  [(IMAppDelegate *)[[UIApplication sharedApplication] delegate]
      setImage:_image];

  
}

- (void)capturePaintingWithCompletionHandeler:
    (void (^)(IMPainting *painting))completion {
  self.customBlock = completion;
  //[self evaluateScript:@"AppContext.pause();"];
  [self evaluateScript:@"AppContext.exportRenderedImage('image/png', 2);"];
}

- (IMPainting *)renderedPainting {
  NSLog(@"Depricate");
  return nil;
}

- (void)upload {
}

- (void)setPresets:(NSString *)presents {
  NSLog(@"setting presets %@", presents);
  NSString *s =
      [presents stringByReplacingOccurrencesOfString:@"\n" withString:@""];
  //    NSLog(@"OUTPUTTIN... %@", s);
  NSString *cmd = [NSString stringWithFormat:@"AppContext.setPresets('%@')", s];
  [self evaluateScript:cmd];
}

- (void)setSequence:(NSString *)presents {
  NSLog(@"setting sequence");
  NSString *s =
      [presents stringByReplacingOccurrencesOfString:@"\n" withString:@""];
  //    NSLog(@"OUTPUTTIN... %@", s);
  NSString *brushes = [IMPaintingAttributes allBrushDefinitions];
  s = [s stringByReplacingOccurrencesOfString:@"\n" withString:@""];
  s = [s stringByReplacingOccurrencesOfString:@" " withString:@""];
  brushes = [brushes stringByReplacingOccurrencesOfString:@"\n" withString:@""];
  brushes = [brushes stringByReplacingOccurrencesOfString:@" " withString:@""];
  NSString *cmd = [NSString
      stringWithFormat:@"AppContext.setSequence('%@','%@')", s, brushes];
  [self evaluateScript:cmd];
}

- (void)imageCapturedFromWebGL:(NSNotification *)notification {
  UIImage *image = [[notification userInfo] objectForKey:@"image"];
  NSString *options = [[notification userInfo] objectForKey:@"options"];
  NSString *noisemap = [[notification userInfo] objectForKey:@"noisemap"];

  _renderedPainting =
      [[IMPainting alloc] initWithOriginalImage:self.originalImage
                                  renderedImage:image
                                        options:options
                                       noisemap:noisemap];
  if (self.customBlock) {
    self.customBlock(_renderedPainting);
  }
}

- (void)resetCanvas {
  [self evaluateScript:@"AppContext.clearCanvas()"];
}

- (void)updateAttribute:(NSString *)attributeName toNewValue:(NSNumber *)value {
  return;

  if ([value isKindOfClass:[NSString class]]) {
    NSString *cmd =
        [NSString stringWithFormat:@"AppContext.options.%@.set(\"%@\");",
                                   attributeName, value];
    NSLog(@"evaluating: %@", cmd);
    [self evaluateScript:cmd];
  } else if (strcmp(value.objCType, @encode(BOOL)) == 0) {
    NSString *cmd = [NSString
        stringWithFormat:@"AppContext.options.%@.set(%@);", attributeName,
                         value.boolValue ? @"true" : @"false"];
    NSLog(@"evaluating: %@", cmd);
    [self evaluateScript:cmd];
  } else {
    NSString *cmd =
        [NSString stringWithFormat:@"AppContext.options.%@.set(%f);",
                                   attributeName, value.floatValue];
    NSLog(@"evaluating: %@", cmd);
    [self evaluateScript:cmd];
  }
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];
  // self.frame = CGRectMake(0, 0, _image.size.width/2, _image.size.height/2);
  [backgroundImageView setFrame:self.bounds];
}

- (void)setBackgroundImageAlpha:(CGFloat)alpha {
  backgroundImageView.alpha = alpha;
}

@end
