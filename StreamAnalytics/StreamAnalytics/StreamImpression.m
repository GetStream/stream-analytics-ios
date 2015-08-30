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

+ (instancetype)createImpressionEventWithActivityIds:(NSArray *)activityIds feedId:(NSString *)feedId extraData:(NSDictionary *)extraData {
    
    StreamImpression *impression = [StreamImpression new];
    
    NSAssert(activityIds!=nil, @"An activity id is required for tracking engagement events");
    impression.activityIds = activityIds;
    
    NSAssert(feedId!=nil, @"An feed id is required for tracking engagement events");
    impression.feedId = feedId;

    impression.extraData = extraData;
    
    return impression;
    
}

#pragma mark - StreamEvent

+ (NSString *)endPoint {
    return StreamImpressionEndpoint;
}

- (NSDictionary *)build {
    NSMutableDictionary *dict = @{
                                  @"activity_ids":self.activityIds,
                                  @"feed_id":self.feedId,
                                  @"user_id":[[StreamAnalytics sharedInstance] userId]
                                  }.mutableCopy;

    if(self.extraData != nil) {
        dict[@"extra_data"] = self.extraData;
    }
    return dict;
}

@end
