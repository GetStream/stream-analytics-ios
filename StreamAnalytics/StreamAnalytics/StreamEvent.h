//
//  StreamEventBuilder.h
//  StreamAnalytics
//
//  Created by Alexander van der Werff on 22/08/15.
//  Copyright (c) 2015 Stream. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    Engagement = 0,
    Impression
} StreamEventType;

/** 
    StreamEvent protocol 
 */

@protocol StreamEvent <NSObject>

- (NSDictionary *) build;

+ (NSString *) endPoint;

@end


@interface StreamEvent: NSObject


/**
 User id, required
 */
@property(nonatomic, strong) NSDictionary *userData;

/**
 Features, optional
 */
@property(nonatomic, strong) NSArray *features;

/**
 Feed id, optional
 */
@property(nonatomic, strong) NSString *feedId;

/**
 Location field, optional
 */
@property(nonatomic, strong) NSString *location;

/**
 Position field, optional
 */
@property(nonatomic, strong) NSString *position;


/*
 Instance method for creating the base event data payload
 */
- (NSMutableDictionary*)createBaseEventPayload;


@end