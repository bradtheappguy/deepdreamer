//
//  IMZoomingScrollView.m
//  Impressionism
//
//  Created by Brad on 4/29/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import "IMZoomingScrollView.h"
#import "IMSettings.h"

@implementation IMZoomingScrollView

- (void) awakeFromNib {
  [super awakeFromNib];
 /* UITapGestureRecognizer *doubleTapGestureRecognizier = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
  doubleTapGestureRecognizier.numberOfTapsRequired = 2;
  [self addGestureRecognizer:doubleTapGestureRecognizier];
*/
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zoomToOne) name:@"ZOOM_CANVAS" object:nil];

}

-(void) doubleTap:(UIGestureRecognizer *)gr {
  if ([IMSettings pinchToZoomEnabled]) {
    if (self.zoomScale < self.maximumZoomScale) {
      [self setZoomScale:self.maximumZoomScale animated:YES];
    }
    else {
      [self setZoomScale:self.minimumZoomScale animated:YES];
    }
  }
}

-(void) zoomToFit {
  [self setZoomScale:self.maximumZoomScale animated:YES];
}


-(void) setupScaling {
  CGFloat xScale = self.bounds.size.width/_view.bounds.size.width;
  CGFloat yScale = self.bounds.size.height/_view.bounds.size.height;

  CGFloat scale =(xScale < yScale)?xScale:yScale;

  self.minimumZoomScale = scale;
  self.maximumZoomScale = 2.0;
}

-(void) zoomToOne {
  [self centerContent];
  CGFloat xScale = self.bounds.size.width/_view.bounds.size.width;
  CGFloat yScale = self.bounds.size.height/_view.bounds.size.height;
  CGFloat scale =(xScale > yScale)?xScale:yScale;

  [UIView beginAnimations:@"" context:nil];
  [UIView setAnimationDelay:1.0f];
  [UIView setAnimationDuration:1.0];
  [self setZoomScale:scale animated:NO];
  self.alpha = 1;
  [UIView commitAnimations];
}

-(void) zoomIn {

  CGFloat xScale = self.bounds.size.width/_view.bounds.size.width;
  CGFloat yScale = self.bounds.size.height/_view.bounds.size.height;

  CGFloat scale =(xScale > yScale)?xScale:yScale;

  scale = scale;

  self.minimumZoomScale = 0.01;
  self.maximumZoomScale = scale;
  self.zoomScale = 0.01;
  self.alpha = 0;

  [self zoomToOne];
}

-(void) setViewToCenterAndZoom:(UIView *)view {

  _view = view;
  //_view.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
  self.delegate = self;
  [self addSubview:view];
  //[self setupScaling];
  [self zoomIn];

}

#pragma mark -
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return _view;
}
- (void)centerContent {
  CGFloat top = 0, left = 0;
  if (self.contentSize.width < self.bounds.size.width) {
    left = (self.bounds.size.width-self.contentSize.width) * 0.5f;
  }
  if (self.contentSize.height < self.bounds.size.height) {
    top = (self.bounds.size.height-self.contentSize.height) * 0.5f;
  }
  self.contentInset = UIEdgeInsetsMake(top, left, top, left);
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView {
  // [self centerContent];


  /*// center the image as it becomes smaller than the size of the screen
  CGSize boundsSize = scrollView.bounds.size;
  CGRect frameToCenter = _view.frame;

  // center horizontally
  if (frameToCenter.size.width < boundsSize.width)
    {
    frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    } else {
      frameToCenter.origin.x = 0;
    }

  // center vertically
  if (frameToCenter.size.height < boundsSize.height)
    {
    frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    } else {
      frameToCenter.origin.y = 0;
    }

  _view.frame = frameToCenter;*/
  
}

-(void) rotate {
  [self setupScaling];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
  NSLog(@"%f",scale);
}

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];
  [self centerContent];
}

-(void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
