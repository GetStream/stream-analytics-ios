//
//  StreamEngagement.m
//  StreamAnalytics
//
//  Created by Alexander van der Werff on 22/08/15.
//  Copyright (c) 2015 Stream. All rights reserved.
//

#import "StreamAnalytics.h"
#import "StreamEngagement.h"
#import "StreamEvent.h"

static NSString *const StreamEngagementEndpoint = @"engagement";

@interface StreamEngagement() <StreamEvent>

@end

@implementation StreamEngagement

+ (instancetype)createEngagementEventWithActivityId:(NSString *)activityId
                                     feedId:(NSString *)feedId
                                      label:(NSString *)label
                                      score:(NSNumber *)score
                                  extraData:(NSDictionary *)extraData {
    
    StreamEngagement *engagement = [StreamEngagement new];

    NSAssert(activityId!=nil, @"An activity id is required for tracking engagement events");
    engagement.activityId = activityId;
    
    NSAssert(feedId!=nil, @"An feed id is required for tracking engagement events");
    engagement.feedId = feedId;
    
    NSAssert(label!=nil, @"A label is required for tracking engagement events");
    engagement.label = label;
    
    engagement.score = score;
    engagement.extraData = extraData;

    return engagement;
}


#pragma mark - StreamEvent

+ (NSString *)endPoint {
    return StreamEngagementEndpoint;
}

- (NSDictionary *)build {
    NSMutableDictionary *dict = @{
                                  @"activity_id":self.activityId,
                                  @"feed_id":self.feedId,
                                  @"label":self.label,
                                  @"user_id":[[StreamAnalytics sharedInstance] userId]
                                  }.mutableCopy;
    if(self.score != nil) {
        dict[@"score"] = self.score;
    }
    if(self.extraData != nil) {
        dict[@"extra_data"] = self.extraData;
    }
    return dict;
}

@end
