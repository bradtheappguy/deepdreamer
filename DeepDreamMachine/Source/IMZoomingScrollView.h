//
//  IMZoomingScrollView.h
//  Impressionism
//
//  Created by Brad on 4/29/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMZoomingScrollView : UIScrollView <UIScrollViewDelegate>{
  UIView *_view;
}


-(void) setViewToCenterAndZoom:(UIView *)view;
-(void) rotate;
- (void)scrollViewDidZoom:(UIScrollView *)scrollView;

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;
-(void) zoomToOne;

@end
