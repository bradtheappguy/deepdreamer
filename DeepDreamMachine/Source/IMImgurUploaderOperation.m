//
//  IMImgurUploader.m
//  Impressionism
//
//  Created by Brad on 5/10/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import "IMImgurUploaderOperation.h"
#import "IMAppConfiguration.h"

@implementation IMImgurUploaderOperation

+(IMImgurUploaderOperation *)operationWithImage:(UIImage *)image
                                     success:(void(^)(NSString *location))completionHandler
                                     failure:(void(^)())failure {


  AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.imgur.com/"]];
  NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST"
                                                                   path:@"3/image"
                                                             parameters:nil
                                              constructingBodyWithBlock:^(id<AFMultipartFormData> data) {
                                                [data appendPartWithFileData:UIImageJPEGRepresentation(image, 1)
                                                                        name:@"image"
                                                                    fileName:@"original.jpeg"
                                                                    mimeType:@"image/jpeg"
                                                 ];
                                              }];
  NSString *auth = [NSString stringWithFormat:@"Client-ID %@",[IMAppConfiguration imgurClientId]];
  [request setValue:auth forHTTPHeaderField:@"Authorization"];

  IMImgurUploaderOperation *connectionOperation = [[self alloc] initWithRequest:request];
  __weak IMImgurUploaderOperation *weakConnectionOperation = connectionOperation;
  
  [connectionOperation setCompletionBlock:^(void) {
    NSString *location = nil;
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)[weakConnectionOperation response];
    NSString *responseString = [weakConnectionOperation responseString];
    responseString = responseString;
    if ([response statusCode] == 200) {
      id responseDictionary = [NSJSONSerialization JSONObjectWithData:[weakConnectionOperation responseData] options:nil error:nil];
      location = [[responseDictionary objectForKey:@"data"] objectForKey:@"link"];
    }
    if (location) {
      completionHandler(location);
    }
    else {
      failure();
    }
  }];

  /*[connectionOperation start];*/
  return connectionOperation;
}

- (void)connection:(NSURLConnection __unused *)connection
   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
  self.totalBytesWritten = totalBytesWritten;
  self.totalBytesExpectedToWrite = totalBytesExpectedToWrite;
  [super connection:connection didSendBodyData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
}

@end
