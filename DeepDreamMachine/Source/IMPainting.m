//
//  IMPainting.m
//  Impressionism
//
//  Created by Brad on 4/11/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import "IMPainting.h"

@implementation IMPainting

-(id) initWithOriginalImage:(UIImage *)original renderedImage:(UIImage *)rendered options:(NSString *)json noisemap:(NSString *)noisemap {
  if (self = [super init]) {
    NSError *error = nil;
    id data = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    self.attributes = [[IMPaintingAttributes alloc] initWithJSONString:data[@"attributes"]];

    self.noisemap = noisemap;

    self.originalImage = original;
    self.capturedImage = rendered;
  }
  return self;
}

-(BOOL) isUploaded {
  if (self.postURL) {
    return YES;
  }
  else {
    return NO;
  }
}

@end
