//
//  StreamAnalytics.h
//  StreamAnalytics
//
//  Created by Alexander van der Werff on 22/08/15.
//  Copyright (c) 2015 Stream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StreamEvent.h"


typedef void (^ StreamRequestResult)(NSInteger, id, NSError*);


@interface StreamAnalytics : NSObject

/** 
    API Key obtained from Stream, can be set in app information property list
 */
@property(nonatomic, strong, readonly) NSString *APIKey;


/**
    API secret obtained from Stream, can be set in app information property list
 */
@property(nonatomic, strong, readonly) NSString *JWTToken;


/**
    Every resource created by the client is always related to an user id, set this
    propery before start tracking
 */
@property(nonatomic, strong) NSString *userId;


/**
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
    class instance method send, sends the actual data to the server
 */

- (void)send:(StreamEvent *)event;

- (void)send:(StreamEvent *)event completionHandler:(StreamRequestResult) result;

@end
