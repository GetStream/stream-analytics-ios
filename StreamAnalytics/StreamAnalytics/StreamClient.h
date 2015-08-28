//
//  StreamClient.h
//  StreamAnalytics
//
//  Created by Alexander van der Werff on 25/08/15.
//  Copyright (c) 2015 Stream. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "StreamAnalytics.h"

@interface StreamClient : NSObject

+ (instancetype)sharedInstance;

- (void) doRequestForEndPoint: (NSString *)endPoint withData:(NSDictionary *)data completionHandler:(StreamRequestResult)completionHandler;

@end
