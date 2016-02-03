//
//  StreamAnalytics.h
//  StreamAnalytics
//
//  Created by Alexander van der Werff on 22/08/15.
//  Copyright (c) 2015 Stream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StreamEvent.h"


/**
 *
 */
typedef void (^ StreamRequestResult)(NSInteger, id, NSError*);


@interface StreamAnalytics : NSObject

/** 
 *  API Key obtained from Stream, can be set in app information property list
 *  
 *  @warning API key is required for tracking
 */
@property(nonatomic, strong, readonly) NSString *APIKey;


/**
 *  API secret obtained from Stream, can be set in app information property list
 *  
 *  @warning JWT token is required for tracking
 */
@property(nonatomic, strong, readonly) NSString *JWTToken;


/**
    Every resource created by the client is always related to an user, set this
    propery before start tracking
 */
@property(nonatomic, strong) NSDictionary *userData;


/**
 *  Property to enable debug info for debug builds, release builds will ignore this setting
 */



/**
    class method for accesing StreamAnalytics singleton instance
 */
+ (instancetype)sharedInstance;


/**
    class method for enabling logging in debug mode
 */
+ (void)enableLogging:(BOOL)enable;


/**
 instance method to set userId
 */
- (void)setUserId:(NSString *) userId;

/**
 instance method to set userId and its label
 */
- (void)setUserId:(NSString *) userId andAlias:(NSString *) alias;

/**
    class instance method send, sends the actual data to the server
 */
- (void)send:(StreamEvent *)event;

/**
 *  class instance method, sends the actual data to the server with a completion handler called when done
 *
 *  @param StreamEvent the stream event to track
 *  @param StreamRequestResult completion block called with status, id and or error
 */
- (void)send:(StreamEvent *)event completionHandler:(StreamRequestResult) result;

@end
