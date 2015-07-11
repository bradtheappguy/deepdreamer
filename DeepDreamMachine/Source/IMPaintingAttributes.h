//
//  IMPaintingAttributes.h
//  Impressionism
//
//  Created by Brad on 4/19/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface IMPaintingAttributes : NSObject


@property (nonatomic) NSString * rawJSON;


-(id) initWithJSONString:(NSString *)json;
+(BOOL) hasAttributeFileAtIndexBeenModifified:(NSUInteger)index;
+(NSString *) filenameWithIndex:(NSUInteger)index;
+(NSUInteger) numberOfAttributes;
+(NSString *) JSONStringFromAttributeFileWithIndex:(NSInteger)index;
+(NSArray *) filenames;
+(NSString *) JSONStringFromAttributeFileWithName:(NSString *)fileName;
+(NSString *) allBrushDefinitions;

@end
