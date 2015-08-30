//
//  StreamImpression.h
//  StreamAnalytics
//
//  Created by Alexander van der Werff on 23/08/15.
//  Copyright (c) 2015 Stream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StreamEvent.h"

@interface StreamImpression : StreamEvent

/**
 Activity Ids, required
 */
@property(nonatomic, strong) NSArray *activityIds;

/*
 Class method for creating an impression event
 last 2 params can be set nil and so are optional
 */
+ (instancetype)createImpressionEventWithActivityIds:(NSArray *)activityIds
                                              feedId:(NSString *)feedId
                                           extraData:(NSDictionary *)extraData;

@end
