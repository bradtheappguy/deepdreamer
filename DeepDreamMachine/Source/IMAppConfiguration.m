//
//  IMAppConfiguration.m
//  Impressionism
//
//  Created by Brad on 4/12/14.
//  Copyright (c) 2014. All rights reserved.
//

#import "IMAppConfiguration.h"

@implementation IMAppConfiguration

+(NSString *)stringForKey:(NSString *)key {
  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
  NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
  NSString *ret = [dict objectForKey:key];
  return ret;
}

+(NSString *) apiBaseURL {
  return [self stringForKey:@"api_base_url"];
}

+(NSString *) sincerelyAppKey {
  return [self stringForKey:@"sincerely_app_key"];
}

+(NSString *) imgurClientId {
  return [self stringForKey:@"imgur_client_id"];
}

+(NSString *) imgurClientSecret {
  return [self stringForKey:@"imgur_client_secret"];
}


@end
