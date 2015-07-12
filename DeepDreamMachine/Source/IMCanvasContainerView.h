//
//  IMCanvasContainerView.h
//  Impressionism
//
//  Created by Brad on 4/27/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "IMNativeCanvasView.h"
#import "IMZoomingScrollView.h"
#import "IMPaintingsAttributesTableViewController.h"

@interface IMCanvasContainerView : IMZoomingScrollView  {
  MBProgressHUD *progessHUD;
}

@property (nonatomic)  IMNativeCanvasView *canvasView;


- (void) createNewCanvasWithImage:(UIImage *)image presets:(NSString *)presets;
- (void) createNewCanvasWithImageURL:(NSURL *)url presets:(NSString *)presets;
- (void) setBrushJSON:(NSString *)attributes;
- (void) setSequence:(NSString *)sequence;
- (IMPainting *) renderedPainting;
- (void) createNewCanvasWithExistingImageUsingPresets:(NSString *)presets;
- (void) showProgressHUDWithString:(NSString *)string;
- (void) hideProgressView;
- (void) resetCanvas;
- (void) pause;
- (void) resume;

-(void) capturePaintingWithCompletionHandeler:(void (^)(UIImage *painting))completion;


-(void) setBackgroundImageAlpha:(CGFloat)alpha;

- (UIImage *) currentBackgroundImage;
- (void) setBackgroundImage:(UIImage *)image;

@end
