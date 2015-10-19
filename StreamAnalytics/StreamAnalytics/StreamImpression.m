//
//  StreamImpression.m
//  StreamAnalytics
//
//  Created by Alexander van der Werff on 23/08/15.
//  Copyright (c) 2015 Stream. All rights reserved.
//

#import "StreamAnalytics.h"
#import "StreamImpression.h"
#import "StreamEvent.h"

static NSString *const StreamImpressionEndpoint = @"impression";

@interface StreamImpression() <StreamEvent>

@end

@implementation StreamImpression

+ (instancetype)createImpressionEventWithForeignIds:(NSArray *)foreignIds {
    
    StreamImpression *impression = [StreamImpression new];
    NSAssert(foreignIds!=nil, @"A list of foreign_ids is required for tracking impression events");
    impression.foreignIds = foreignIds;
    return impression;
    
}

#pragma mark - StreamEvent

+ (NSString *)endPoint {
    return StreamImpressionEndpoint;
}

- (NSDictionary *)build {
    NSMutableDictionary *dict = @{
                                  @"foreign_ids":self.foreignIds,
                                  @"user_id":[[StreamAnalytics sharedInstance] userId]
                                  }.mutableCopy;
    [dict addEntriesFromDictionary: [super createBaseEventPayload]];
    return dict;
}

@end
