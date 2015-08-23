//
//  StreamEngagement.m
//  StreamAnalytics
//
//  Created by Alexander van der Werff on 22/08/15.
//  Copyright (c) 2015 Stream. All rights reserved.
//

#import "StreamEngagement.h"

@implementation StreamEngagement

+ (void)createEngagementEventWithActivityId:(NSNumber *)activityId feedId:(NSString *)feedId label:(NSString *)label score:(NSNumber *)score extraData:(NSDictionary *)extraData {
    
}

#pragma mark - StreamEvent

- (NSDictionary *)build {
    return @{};
}

- (BOOL)validate {
    return YES;
}

@end
