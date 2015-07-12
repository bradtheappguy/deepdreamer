//
//  IMNativeCanvasView.h
//  Impressionism
//
//  Created by Brad on 4/26/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import "EJJavaScriptView.h"
#import "IMPainting.h"

typedef void(^MyCustomBlock)(IMPainting *painting);

@interface IMNativeCanvasView : EJJavaScriptView <UIScrollViewDelegate> {
  UIImage *_image;
  IMPainting *_renderedPainting;

  UIImageView *backgroundImageView;
}

@property (nonatomic) UIImage *originalImage;
@property (nonatomic, copy) MyCustomBlock customBlock;



- (void) setImage:(UIImage *)image withpresets:(NSString *)json;
- (IMPainting *) renderedPainting;
- (void)upload;

- (void)setPresets:(id)presents;
- (void)setSequence:(NSString *)presents;

- (void) resetCanvas;

-(UIImage *) currentBackgroundImage;
- (void) setBackgroundImage:(UIImage *)image;


- (id)initWithImage:(UIImage *)image presets:(NSString *)presets;

- (id)initWithImageURL:(NSURL *)url presets:(NSString *)presets;
- (void) capturePaintingWithCompletionHandeler:(void (^)(IMPainting *painting))completion;

- (void) updateAttribute:(NSString *)attributeName toNewValue:(NSNumber *)value;

-(void) setBackgroundImageAlpha:(CGFloat)alpha;

@end
