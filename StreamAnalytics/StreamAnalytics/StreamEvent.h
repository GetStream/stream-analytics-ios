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
} StreamEventBuilderType;

/** 
    StreamEvent protocol 
 */

@protocol StreamEvent <NSObject>

- (NSDictionary *) build;

- (BOOL) validate;

@end
