//
//  IMUndimmedPopoverBackgroundView.m
//  DeepDreamMachine
//
//  Created by Daniel DeCovnick on 7/12/15.
//  Copyright (c) 2015 Jet. All rights reserved.
//

#import "IMUndimmedPopoverBackgroundView.h"

@implementation IMUndimmedPopoverBackgroundView
@synthesize arrowDirection;
@synthesize arrowOffset;
+ (UIEdgeInsets)contentViewInsets {
    return UIEdgeInsetsZero;
}
+ (CGFloat)arrowBase {
    return 0.0f;
}
+ (CGFloat)arrowHeight {
    return 0.0f;
}
+ (BOOL)wantsDefaultContentAppearance {
    return NO;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.opaque = NO;
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
}
@end
