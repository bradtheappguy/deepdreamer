//
//  IMBrush.h
//  ZenPainter
//
//  Created by Brad on 7/19/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMBrush : NSObject

+ (NSUInteger) numberOfBrushes;
+ (IMBrush *) brushWithIndex:(NSUInteger)index;
+ (IMBrush *)currentBrush;

- (NSString *) name;
- (NSUInteger) thickness;
- (CGFloat) opacity;

- (NSString *) json;

- (void) setOpacity:(CGFloat)value;
- (void) setSize:(CGFloat)value;
- (UIImage *) brushImage;
- (void) makeCurrent;
- (void) save;
-(NSString *) fileName;
-(void) setJSON:(NSString *)json;
@end
