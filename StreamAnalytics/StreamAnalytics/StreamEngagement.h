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
@property(nonatomic, strong) NSDictionary *content;

/**
    Label field, required
 */
@property(nonatomic, strong) NSString *label;

/**
    Score field, optional
 */
@property(nonatomic, strong) NSNumber *boost;


/*
    Class method for creating an engagement event
 */
+ (instancetype)createEngagementEvent:(NSString *)label withContent:(NSDictionary*) content;


@end
