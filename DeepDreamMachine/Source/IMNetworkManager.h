//
//  IMNetworkManager.h
//  Impressionism
//
//  Created by Brad on 4/24/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMPainting.h"

@interface IMNetworkManager : NSObject

-(void)uploadPainting:(IMPainting *)painting withCompletion:(void (^)())completionBlock withFailure:(void (^)())failureBlock;

@property (weak) UIProgressView *progressView;
@property (weak) UILabel *progressLabel;

@end
