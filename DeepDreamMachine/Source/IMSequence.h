//
//  IMSequence.h
//  ZenPainter
//
//  Created by Brad on 7/21/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMSequence : NSObject

+ (NSUInteger) numberOfSequences;
+ (IMSequence *) sequenceWithIndex:(NSUInteger)index;
+ (IMSequence *)currentSequence;

- (NSString *) name;
- (NSString *) json;
- (UIImage *) brushImage;
- (void) makeCurrent;

-(NSMutableArray *)steps;

-(void)save;
@end
