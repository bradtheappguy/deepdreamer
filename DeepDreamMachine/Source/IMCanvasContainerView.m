//
//  IMCanvasContainerView.m
//  Impressionism
//
//  Created by Brad on 4/27/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import "IMCanvasContainerView.h"
#import "IMSettings.h"

@implementation IMCanvasContainerView

//-------------------

-(void)awakeFromNib {
  [super awakeFromNib];
  [self setBackgroundColor:[UIColor blackColor]];
}

- (void) createNewCanvasWithImage:(UIImage *)image presets:(NSString *)presets {


  [self.canvasView removeFromSuperview];
  self.canvasView = [[IMNativeCanvasView alloc] initWithImage:image presets:presets];
  [self setViewToCenterAndZoom:self.canvasView];
  progessHUD = [[MBProgressHUD alloc] initWithFrame:self.canvasView.bounds];
  [[self superview] addSubview:progessHUD];
  [self showProgressHUDWithString:NSLocalizedString(@"Loading...", nil) ];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideProgressView) name:@"HIDE_PROGESS_LABEL" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgressView:) name:@"UPDATE_PROGESS_LABEL" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sequenceDidFinish) name:@"SEQUENCE_DID_FINISH" object:nil];
}

- (void) createNewCanvasWithImageURL:(NSURL *)url presets:(NSString *)presets {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideProgressView) name:@"HIDE_PROGESS_LABEL" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgressView:) name:@"UPDATE_PROGESS_LABEL" object:nil];
  [self.canvasView removeFromSuperview];
  // UIImage *image = [UIImage imageWithContentsOfFile:url.path];
  self.canvasView = [[IMNativeCanvasView alloc] initWithImageURL:url presets:presets];
  self.canvasView.backgroundColor = [UIColor blackColor];
  

  [self setViewToCenterAndZoom:self.canvasView];
  progessHUD = [[MBProgressHUD alloc] initWithFrame:self.canvasView.bounds];
  [[self superview] addSubview:progessHUD];
  [self showProgressHUDWithString:NSLocalizedString(@"Dreaming Deeply...", nil) ];

}

- (void) createNewCanvasWithExistingImageUsingPresets:(NSString *)presets {
  UIImage *image = self.canvasView.originalImage;
  [self createNewCanvasWithImage:image presets:presets];
}

- (void) setBrushJSON:(NSString *)attributes {
  [self.canvasView setPresets:attributes];
}

- (void) setSequence:(NSString *)sequence {
  [self.canvasView setSequence:sequence];
}

- (void) sequenceDidFinish {
  [[[UIAlertView alloc] initWithTitle:@"TODO" message:@"TODO" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (IMPainting *) renderedPainting {
  NSLog(@"Depricate");
  return [self.canvasView renderedPainting];
}

-(void) capturePaintingWithCompletionHandeler:(void (^)(UIImage *painting))completion {
  [self.canvasView capturePaintingWithCompletionHandeler:completion];
}

- (void) layoutSubviews {
  [super layoutSubviews];
  progessHUD.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

-(void) showProgressHUDWithString:(NSString *)string {
  //[progessHUD setLabelText:string];
  //[progessHUD show:YES];
}

- (void) hideProgressView {
  //[progessHUD hide:YES];
}

- (void) updateProgressView:(NSNotification *)notification {
  [progessHUD show:NO];
  [progessHUD setLabelText:notification.object];
}

- (UIImage *) currentBackgroundImage {
  return self.canvasView.currentBackgroundImage;
}

- (void) setBackgroundImage:(UIImage *)image {
  [self.canvasView setBackgroundImage:image];
}

- (void) resetCanvas {
  [self zoomToOne];
  [self.canvasView resetCanvas];
}

- (void) pause {
  [self.canvasView pause];
}

- (void) resume {
  [self.canvasView resume];
}


-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  UIView *v = [super hitTest:point withEvent:event];
  return v;
}


-(void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIView *) viewForZoomingInScrollView:(UIScrollView *) scrollView
{
  return [super viewForZoomingInScrollView:scrollView];
}


#pragma mark -
#pragma mark IMAttributeTableViewCellDelegate
-(void)paintingAttribute:(NSString *)attributeName didChangeToValue:(NSNumber *)value {
  [self.canvasView updateAttribute:attributeName toNewValue:value];
}

-(void) setBackgroundImageAlpha:(CGFloat)alpha {
  [self.canvasView setBackgroundImageAlpha:alpha];
}

- (void) currentBrushEdited:(NSString *)json {
  [self setBrushJSON:json];
}
@end
