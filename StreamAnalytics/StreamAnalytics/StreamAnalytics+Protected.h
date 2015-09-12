//
//  StreamAnalytics+Protected.h
//  StreamAnalytics
//
//  Created by Alexander van der Werff on 01/09/15.
//  Copyright (c) 2015 Stream. All rights reserved.
//

@class StreamClient;
@interface StreamAnalytics()

@property(nonatomic, strong) StreamClient *streamClient;

@property(nonatomic, assign) BOOL loggingEnabled;

/**
 API Key obtained from Stream, can be set in app information property list
 */
@property(nonatomic, strong, readwrite) NSString *APIKey;


/**
 API secret obtained from Stream, can be set in app information property list
 */
@property(nonatomic, strong, readwrite) NSString *JWTToken;

- (void)logMessage:(NSString *)message;

@end
