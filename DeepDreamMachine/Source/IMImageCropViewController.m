//
//  IMImageCropViewController.m
//  Impressionism
//
//  Created by Brad on 4/29/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import "IMImageCropViewController.h"
#import "IMZoomingScrollView.h"
#import "UIImage+FixRotation.h"

@interface IMImageCropViewController () {
  NSArray *_colors;
  UIImageView *_imageView;
}

@property (weak, nonatomic) IBOutlet IMZoomingScrollView *scrollView;


@end

@implementation IMImageCropViewController


- (void)viewDidLoad {
  [super viewDidLoad];
  self.automaticallyAdjustsScrollViewInsets = NO;
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"CROP", nil) style:UIBarButtonSystemItemAction target:self action:@selector(doneButtonPressed:)];

  _colors = @[
                      [UIColor brownColor],
                      [UIColor blackColor],
                      [UIColor whiteColor],
                      [UIColor grayColor],
                      [UIColor lightGrayColor],
                      [UIColor darkGrayColor]
                      ];
  for (int c=0; c<[_colors count]; c++) {
    UIButton *button = (UIButton *)[self.view viewWithTag:c+1];
    button.backgroundColor = [_colors objectAtIndex:c];
  }

  CAShapeLayer *_border = [CAShapeLayer layer];
  _border.strokeColor = [UIColor colorWithRed:67/255.0f green:37/255.0f blue:83/255.0f alpha:1].CGColor;
  _border.fillColor = nil;
  _border.lineDashPattern = @[@4, @2];

   _border.path = [UIBezierPath bezierPathWithRect:self.scrollView.bounds].CGPath;
   _border.frame = self.scrollView.frame;
  [self.view.layer addSublayer:_border];
  self.view.backgroundColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  _imageView = [[UIImageView alloc] init];
  _imageView.image = self.cropImage;
  [_imageView sizeToFit];
  [self.scrollView setViewToCenterAndZoom:_imageView];
  _imageView.center = CGPointMake(self.scrollView.frame.size.width/2, self.scrollView.frame.size.height/2);
  _imageView.backgroundColor = [UIColor blackColor];
}


- (void) doneButtonPressed:(id)sender {
CGRect visibleRect = [self.scrollView convertRect:self.scrollView.bounds toView:_imageView];

  visibleRect.origin.x = MAX(0, visibleRect.origin.x);
  visibleRect.origin.y = MAX(0, visibleRect.origin.y);
  visibleRect.size.width = MIN(_imageView.image.size.width, visibleRect.size.width);
  visibleRect.size.height = MIN(_imageView.image.size.height, visibleRect.size.height);

  UIImage *image;
  CGImageRef imageRef = CGImageCreateWithImageInRect([_imageView.image CGImage], visibleRect);
  if ((int)visibleRect.size.width != (int)visibleRect.size.height)  {
    CGFloat length = MAX(visibleRect.size.width, visibleRect.size.height);

    UIGraphicsBeginImageContext(CGSizeMake(length, length));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [self.scrollView.backgroundColor CGColor]);
    CGContextFillRect(ctx, CGRectMake(0, 0, length, length));

    CGFloat maxEdge = MAX(visibleRect.size.width, visibleRect.size.height);

    CGRect drawingRect;
    drawingRect.origin.x = (maxEdge - visibleRect.size.width)/2;
    drawingRect.origin.y = (maxEdge - visibleRect.size.height)/2;
    drawingRect.size = visibleRect.size;

    CGContextDrawImage(ctx, drawingRect, imageRef);
    image = UIGraphicsGetImageFromCurrentImageContext();
    image = [image imageRotatedByDegrees:180.0f];
    UIGraphicsEndImageContext();
  }
  else {
    image = [UIImage imageWithCGImage:imageRef];
  }
  CGImageRelease(imageRef);

  [self.delegate cropViewController:self didCropImage:image];
}

- (IBAction)colorButtonPressed:(UIButton *)sender {
  [self.scrollView setBackgroundColor:sender.backgroundColor];
}
@end
