//
//  IMImgurUploader.h
//  Impressionism
//
//  Created by Brad on 5/10/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface IMImgurUploaderOperation : AFURLConnectionOperation

+(IMImgurUploaderOperation *)operationWithImage:(UIImage *)image
                                        success:(void(^)(NSString *location))completionHandler
                                        failure:(void(^)())failure;

@property NSInteger totalBytesWritten;
@property NSInteger totalBytesExpectedToWrite;

@end
