//
//  IMSequence.m
//  ZenPainter
//
//  Created by Brad on 7/21/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import "IMSequence.h"

@interface IMSequence () {
  NSString *_fileName;
  NSDictionary *_dict;
  UIImage *_image;
  NSMutableArray *_steps;
}

@end

@implementation IMSequence

static IMSequence *_currentSequence = nil;

+ (IMSequence *)currentSequence {
  return _currentSequence;
}

+ (NSUInteger) numberOfSequences {
  return 2;
}

+ (instancetype) sequenceWithIndex:(NSUInteger)index {
  return [[IMSequence alloc] initWithIndex:index];
}

-(id) initWithIndex:(NSUInteger)index {
  if (self = [super init]) {
    if (index == 0) {
      _fileName = @"a.json";
      _image = [UIImage imageNamed:@"sequence1"];
    }
    if (index == 1) {
      _fileName = @"b.json";
      _image = [UIImage imageNamed:@"sequence2"];
    }

    NSError *err = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:_fileName];


    if (NO == [[NSFileManager defaultManager] fileExistsAtPath:path]) {
      path = [[NSBundle mainBundle] pathForResource:[_fileName stringByDeletingPathExtension] ofType:@"json"];
    }


    NSString *json = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    _dict = [dict mutableCopy];
  }
  return self;
}

- (NSString *) name {
  return _fileName;
}

- (NSString *)json {
  NSError *error;
  NSData *data = [NSJSONSerialization dataWithJSONObject:_dict options:0 error:&error];
  return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (UIImage *) brushImage {
  return _image;
}

- (void)makeCurrent {
  _currentSequence = self;
}

-(NSMutableArray *)steps {
  if (!_steps) {
    _steps = [_dict[@"steps"] mutableCopy];
  }
  return _steps;
}


-(void)save {
  NSError *err;
  NSMutableDictionary *object = [_dict mutableCopy];
  [object setValue:_steps forKey:@"steps"];

  NSString *json = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&err] encoding:NSUTF8StringEncoding];
  NSLog(@"%@",json);

  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *path = [documentsDirectory stringByAppendingPathComponent:_fileName];

  [json writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err];

}
@end
