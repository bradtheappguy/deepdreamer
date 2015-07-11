//
//  IMViewController.m
//  welcome
//
//  Created by Brad on 7/30/14.
//  Copyright (c) 2014 Brad. All rights reserved.
//

#import "IMWelcomeViewController.h"

@interface IMWelcomeViewController () {
  CGPoint logoStartingCenter;
  CGPoint scrollViewStartingCenter;
}
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIButton *makeNewButton;
@property (weak, nonatomic) IBOutlet UIButton *ideasButton;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) IBOutlet UIView *page1ContentView;
@property (strong, nonatomic) IBOutlet UIView *page2ContentView;
@property (strong, nonatomic) IBOutlet UIView *page3WrapperView;
@property (strong, nonatomic) IBOutlet UIView *page3ContentView;

@property (weak, nonatomic) IBOutlet UITextView *page1TextView;
@property (strong, nonatomic) IBOutlet UIView *page2TextView;

@property (weak, nonatomic) IBOutlet UIScrollView *page3VerticalScrollView;
@end

static NSUInteger kScrollViewNumberOfPages = 3;
static CGFloat kLogoShiftDistance = 100;

@implementation IMWelcomeViewController

-(void)setupScrollView {
  [self.scrollView addSubview:self.page1ContentView];
  [self.scrollView addSubview:self.page2ContentView];
  [self.scrollView addSubview:self.page3WrapperView];
  self.page2ContentView.center = CGPointMake(self.page2ContentView.center.x + (self.scrollView.bounds.size.width * 1), self.page2ContentView.center.y);
  self.page3WrapperView.center = CGPointMake(self.page3WrapperView.center.x + (self.scrollView.bounds.size.width * 2), self.page3WrapperView.center.y);
  self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * kScrollViewNumberOfPages, self.scrollView.bounds.size.height);

  [self.page3VerticalScrollView addSubview:self.page3ContentView];
  self.page3VerticalScrollView.contentSize = self.page3ContentView.bounds.size;
}

-(void)setScrollViewHidden:(BOOL)hidden animated:(BOOL)animated {
  [UIView animateWithDuration:0.33
                        delay:0
       usingSpringWithDamping:1
        initialSpringVelocity:1
                      options:0
                   animations:^(void) {
                     if (hidden) {
                       self.scrollView.alpha = 0;
                       self.pageControl.alpha = 0;
                       self.infoButton.alpha = 1;
                       self.makeNewButton.alpha = 1;
                       self.ideasButton.alpha = 1;
                       self.titleLabel.alpha = 1;
                       self.logoImageView.center = logoStartingCenter;
                       self.scrollView.center = CGPointMake(scrollViewStartingCenter.x, scrollViewStartingCenter.y + 200);
                     }
                     else {
                       self.scrollView.alpha = 1;
                       self.pageControl.alpha = 1;
                       self.infoButton.alpha = 0;
                       self.makeNewButton.alpha = 0;
                       self.ideasButton.alpha = 0;
                       self.titleLabel.alpha = 0;
                       self.logoImageView.center = CGPointMake(self.logoImageView.center.x, self.logoImageView.center.y - kLogoShiftDistance);
                       self.scrollView.center = scrollViewStartingCenter;
                     }
                   }
                   completion:nil];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  logoStartingCenter = self.logoImageView.center;
  scrollViewStartingCenter = self.scrollView.center;
  [self setupScrollView];
  [self setScrollViewHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Main Buttons
- (IBAction)closeButtonPressed:(id)sender {
  [self setScrollViewHidden:YES animated:YES];
}

- (IBAction)infoButtonPressed:(id)sender {
  [self setScrollViewHidden:NO animated:YES];
}

- (IBAction)newButtonPressed:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)ideasButtonPressed:(id)sender {
}

#pragma mark -
#pragma mark Social Buttons
- (IBAction)pageControlValueChanged:(id)sender {
}
- (IBAction)instagramButtonPressed:(id)sender {
}
- (IBAction)facebookButtonPressed:(id)sender {
}
- (IBAction)twitterButtonPressed:(id)sender {
}
- (IBAction)reviewButtonPressed:(id)sender {
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (scrollView == self.scrollView) {
    CGFloat width = scrollView.bounds.size.width;
    CGFloat trigger = 0.5;

    CGFloat logoAlpha = MAX(0,scrollView.contentOffset.x - width);
    logoAlpha = (width * trigger) - MIN(logoAlpha,(width * trigger));
    logoAlpha = logoAlpha / (width * trigger);

    self.logoImageView.alpha = logoAlpha;
}
}

@end
