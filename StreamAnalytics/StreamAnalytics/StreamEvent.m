//
//  StreamEvent.m
//  StreamAnalytics
//
//  Created by Alexander van der Werff on 27/08/15.
//  Copyright (c) 2015 Stream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StreamEvent.h"

@implementation StreamEvent


- (NSMutableDictionary*)createBaseEventPayload {
    NSMutableDictionary *dict = @{}.mutableCopy;
    if (self.feedId != nil) {
        dict[@"feed_id"] = self.feedId;
    }
    if (self.location != nil) {
        dict[@"location"] = self.location;
    }
    if (self.position != nil) {
        dict[@"position"] = self.position;
    }
    if (self.features != nil) {
        dict[@"features"] = self.features;
    }
    if(self.feedId != nil) {
        dict[@"feed_id"] = self.feedId;
    }
    return dict;
};

@end