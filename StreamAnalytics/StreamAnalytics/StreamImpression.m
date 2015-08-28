//
//  StreamImpression.m
//  StreamAnalytics
//
//  Created by Alexander van der Werff on 23/08/15.
//  Copyright (c) 2015 Stream. All rights reserved.
//

#import "StreamImpression.h"
#import "StreamEvent.h"

static NSString *const StreamImpressionEndpoint = @"impression";

@interface StreamImpression() <StreamEvent>

@end

@implementation StreamImpression


#pragma mark - StreamEvent

+ (NSString *)endPoint {
    return StreamImpressionEndpoint;
}

- (NSDictionary *)build {
    return @{};
}

@end
