//
//  StreamAnalytics.h
//  StreamAnalytics
//
//  Created by Alexander van der Werff on 22/08/15.
//  Copyright (c) 2015 Stream. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ StreamResult)(id, NSError*);

@interface StreamAnalytics : NSObject

/** 
    API Key obtained from Stream, can be set in app information property list
 */
@property(nonatomic, strong) NSString *APIKey;


/**
    API secret obtained from Stream, can be set in app information property list
 */
@property(nonatomic, strong) NSString *JWTToken;


/**
    Every resource created by the client is always related to an user id, set this
    propery before start stracking
 */
@property(nonatomic, strong) NSString *userId;


/**
    class method for accesing StreamAnalytics singleton instance
 */
+ (id)sharedInstance;


/**
    class instance method send, sends the actual data to the server
 */

- (void)send:(NSDictionary *)parameters;

- (void)send2:(NSDictionary *)parameters withBlock:(StreamResult) result;

@end
