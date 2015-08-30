//
//  StreamEngagement.h
//  StreamAnalytics
//
//  Created by Alexander van der Werff on 22/08/15.
//  Copyright (c) 2015 Stream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StreamEvent.h"

@interface StreamEngagement : StreamEvent


/**
 Activity Id, required
 */
@property(nonatomic, strong) NSString *activityId;

/**
    Label field, required
 */
@property(nonatomic, strong) NSString *label;

/**
    Score field, optional
 */
@property(nonatomic, strong) NSNumber *score;


/*
    Class method for creating an engagement event
    last 2 params can be set nil and so are optional
 */
+ (instancetype)createEngagementEventWithActivityId:(NSString *)activityId
                                             feedId:(NSString *)feedId
                                              label:(NSString *)label
                                              score:(NSNumber *)score
                                          extraData:(NSDictionary *)extraData;


@end
