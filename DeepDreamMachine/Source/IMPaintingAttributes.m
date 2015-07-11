//
//  IMPaintingAttributes.h
//  Impressionism
//
//  Created by Brad on 4/19/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import "IMPaintingAttributes.h"

@implementation IMPaintingAttributes

static NSDictionary *attributesInfomation;


static NSUInteger kNumberOfBrushFiles = 10;

+(NSUInteger) numberOfAttributes {
  if (!attributesInfomation) {
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"attributes" ofType:@"json"]];

    id JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if ([JSON isKindOfClass:[NSDictionary class]]) {
      attributesInfomation = JSON[@"attributes"];
    }
  }
  return [attributesInfomation count];
}

+(NSArray *) filenames {
  NSMutableArray *aray = [NSMutableArray new];
  for (int c=0; c<kNumberOfBrushFiles; c++) {
    [aray addObject:[NSString stringWithFormat:@"%d.json",c+1]];
  }
  return aray;
}

+(NSString *) filenameWithIndex:(NSUInteger)index {
  return [NSString stringWithFormat:@"%d.json",index+1];
}

+(BOOL) hasAttributeFileAtIndexBeenModifified:(NSUInteger)index {
  NSString *fileName = [NSString stringWithFormat:@"%d",index+1];

  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *path = [documentsDirectory stringByAppendingPathComponent:[fileName stringByAppendingString:@".json"]];


  return ([[NSFileManager defaultManager] fileExistsAtPath:path]);
}

+(NSString *) JSONStringFromAttributeFileWithIndex:(NSInteger)index {


  NSString *fileName = [NSString stringWithFormat:@"%d.json",index+1];


  return [self JSONStringFromAttributeFileWithName:fileName];
}

+(NSString *) allBrushDefinitions {
  NSMutableString *string = [NSMutableString new];
  [string appendString:@"{"];
  NSString *json;
  for (int c =0; (json = [self JSONStringFromAttributeFileWithIndex:c]) > 0; c++) {
    if (string.length > 2) {
      [string appendString:@","];
    }
    NSString *name = [self filenameWithIndex:c];
    [string appendString:[NSString stringWithFormat:@"\"%@\":%@",name,json]];
  }
  [string appendString:@"}"];
  return string;
}

+(NSString *) JSONStringFromAttributeFileWithName:(NSString *)fileName {
   NSError *err = nil;
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
  //path = [path stringByAppendingPathExtension:@"json"];


  if (NO == [[NSFileManager defaultManager] fileExistsAtPath:path]) {
    path = [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension] ofType:@"json"];
  }


  NSString *json = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
  return json;
}



-(id) initWithJSONString:(NSString *)json {
  if (self = [super init]) {
    NSError *error = nil;
    if (json) {
      //id object = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];

      self.rawJSON = json;
    }
    else {
      error = [NSError errorWithDomain:@"com." code:1 userInfo:nil];
    }


    if (NO == [self isValid]) {
      NSLog(@"Error: Painting Attributes Not Valid");
    }
    if (error) {
      NSLog(@"ERROR: %@",[error localizedDescription]);
    }
  }
  return self;
}



BOOL validateFloat(char *name, CGFloat value, CGFloat minimum, CGFloat maximum) {
  if (value < minimum || value > maximum) {
    NSLog(@"%s %f is out of range (%f - %f)",name, value, minimum, maximum);
    return NO;
  }
  return YES;
}

BOOL validateInteger(char *name, NSUInteger value, NSUInteger minimum, NSUInteger maximum) {
  if (value < minimum || value > maximum) {
    NSLog(@"%s %d is out of range (%d - %d)",name, value, minimum, maximum);
    return NO;
  }
  return YES;
}



-(BOOL) isValid {
  return YES;
  
}
@end
