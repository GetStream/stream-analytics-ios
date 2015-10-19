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
 Foreign Ids, required
 */
@property(nonatomic, strong) NSArray *foreignIds;

/*
 Class method for creating an impression event
 */
+ (instancetype)createImpressionEventWithForeignIds:(NSArray *)foreignIds;

@end
