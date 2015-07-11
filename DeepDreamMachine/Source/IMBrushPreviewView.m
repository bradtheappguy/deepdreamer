//
//  IMBrushPreviewView.m
//  ZenPainter
//
//  Created by Brad on 8/6/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import "IMBrushPreviewView.h"

@implementation IMBrushPreviewView

-(void) awakeFromNib {
  [self loadScriptAtPath:@"ejecta-main.js"];
}

@end
