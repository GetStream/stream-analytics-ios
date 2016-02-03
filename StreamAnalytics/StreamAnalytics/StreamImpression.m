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

+ (instancetype)createImpressionEventWithContentList:(NSArray *)contentList {
    
    StreamImpression *impression = [StreamImpression new];
    NSAssert(contentList!=nil, @"A list of dictionaries is required for tracking impression events");
    impression.contentList = contentList;
    return impression;
    
}

#pragma mark - StreamEvent

+ (NSString *)endPoint {
    return StreamImpressionEndpoint;
}

- (NSDictionary *)build {
    NSMutableDictionary *dict = @{
                                  @"content_list":self.contentList,
                                  @"user_data":[[StreamAnalytics sharedInstance] userData].mutableCopy
                                  }.mutableCopy;
    [dict addEntriesFromDictionary: [super createBaseEventPayload]];
    return dict;
}

@end
