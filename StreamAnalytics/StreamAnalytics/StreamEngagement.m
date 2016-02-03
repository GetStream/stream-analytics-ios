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

+ (instancetype)createEngagementEvent:(NSString *)label withContent:(NSDictionary*) content {
    StreamEngagement *engagement = [StreamEngagement new];
    NSAssert(label!=nil, @"A label is required for tracking engagement events");
    engagement.label = label;
    engagement.content = content;
    return engagement;
}


#pragma mark - StreamEvent

+ (NSString *)endPoint {
    return StreamEngagementEndpoint;
}

- (NSDictionary *)build {
    NSMutableDictionary *dict = @{
                                  @"label":self.label,
                                  @"content": self.content,
                                  @"user_data":[[StreamAnalytics sharedInstance] userData].mutableCopy
                                  }.mutableCopy;
    [dict addEntriesFromDictionary: [super createBaseEventPayload]];
    if(self.boost != nil) {
        dict[@"boost"] = self.boost;
    }
    return dict;
}

@end
