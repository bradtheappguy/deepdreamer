//
//  IMBrush.m
//  ZenPainter
//
//  Created by Brad on 7/19/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import "IMBrush.h"

static NSString *kOpacityKey = @"opacity";
static NSString *kThicknessKey = @"thickness";
static NSString *kNameKey = @"name";
static NSString *kBrushImageKey = @"brushImage";

@interface IMBrush (/* private */) {
  NSString *_json;
  NSDictionary *_dictionary;
  UIImage *_image;
  NSString *_fileName;
  NSUInteger _index;
}

@end


@implementation IMBrush

+(NSUInteger) numberOfBrushes {
  return 10;
}

+(IMBrush *) brushWithIndex:(NSUInteger)index {
  return [[IMBrush alloc] initWithIndex:index];
}


static IMBrush *currentBrush = nil;

+(IMBrush *)currentBrush {
  if (!currentBrush) {
    currentBrush = [[IMBrush alloc] initWithIndex:0];
  }
  return currentBrush;
}

+(void)setCurrentBrush:(IMBrush *)brush {
  currentBrush = brush;
}


-(id) initWithIndex:(NSUInteger)index {
  if (self = [super init]) {
    _index = index;
    _fileName = [NSString stringWithFormat:@"%d.json",index+1];
    NSError *err = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:_fileName];
    //path = [path stringByAppendingPathExtension:@"json"];


    if (NO == [[NSFileManager defaultManager] fileExistsAtPath:path]) {
      path = [[NSBundle mainBundle] pathForResource:[_fileName stringByDeletingPathExtension] ofType:@"json"];
    }

    _json = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];

    _dictionary = [[NSJSONSerialization JSONObjectWithData:[_json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&err] mutableCopy];

    //NSString *imageName =  _dictionary[kBrushImageKey];
    NSString *imageName = [NSString stringWithFormat:@"brush%d.png",index+1];
    _image = [UIImage imageNamed:imageName];

  }
  return self;

}

-(void) setJSON:(NSString *)json {
      NSError *err = nil;
  _json = json;
  _dictionary = [[NSJSONSerialization JSONObjectWithData:[_json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&err] mutableCopy];
}

-(NSString *) fileName {
  return [NSString stringWithFormat:@"%d.json",_index+1];
}

-(NSString *) name {
  return _dictionary[kNameKey];
}

-(UIImage *) brushImage {
  return _image;
}

- (NSUInteger) thickness {
  return [_dictionary[kThicknessKey] integerValue];
}

- (CGFloat) opacity {
  return [_dictionary[kOpacityKey] floatValue];
}

-(NSString *) json {
  NSError *error;
  NSData *data = [NSJSONSerialization dataWithJSONObject:_dictionary options:0 error:&error];
  return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

-(void) setOpacity:(CGFloat)value {
  [_dictionary setValue:[NSNumber numberWithFloat:value] forKey:kOpacityKey];
}

-(void) setSize:(CGFloat)value {
  [_dictionary setValue:[NSNumber numberWithFloat:value] forKey:kThicknessKey];
}

- (void)makeCurrent {
  currentBrush = self;
}

-(void) save {
  NSString *toJSON = [self json];
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *path = [documentsDirectory stringByAppendingPathComponent:_fileName];
  NSError *error;
  [toJSON writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
}

@end
