//
//  StreamAnalytics.m
//  StreamAnalytics
//
//  Created by Alexander van der Werff on 22/08/15.
//  Copyright (c) 2015 Stream. All rights reserved.
//

#include <asl.h>
#import "StreamAnalytics.h"
#import "StreamAnalytics+Protected.h"
#import "StreamClient.h"

static void AddStderrOnce() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        asl_add_log_file(NULL, STDERR_FILENO);
    });
}

/**
    Loging method not ending up in device logs
 */
void StreamLogDebug (NSString *format, ...) {
    AddStderrOnce();
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format
                                               arguments:args];
    asl_log(NULL, NULL, (ASL_LEVEL_DEBUG), "%s", [message UTF8String]);
    va_end(args);
}


static NSString *const LogPrompt = @"<STREAM ANALYTICS>";



@implementation StreamAnalytics


#pragma mark - class methods

+ (instancetype)sharedInstance {
    static StreamAnalytics *streamAnalytics = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        streamAnalytics = [[self alloc] init];
    });
    return streamAnalytics;
}


#pragma mark - instance methods

- (instancetype)init {
    self = [super init];
    if(self) {
        
        self.streamClient = [StreamClient sharedInstance];
        
        NSBundle *appBundle = [NSBundle bundleForClass:[self class]];
        NSDictionary *streamAnalitycsSettings = [appBundle objectForInfoDictionaryKey:@"StreamAnalytics"];
        
        if (streamAnalitycsSettings && (NSString *)[streamAnalitycsSettings objectForKey:@"APIKey"]) {
            self.APIKey = [streamAnalitycsSettings objectForKey:@"APIKey"];
        }
        else {
            #ifdef DEBUG
            [self logMessage:@"API key missing."];
            #endif
        }

        if (streamAnalitycsSettings && (NSString *)[streamAnalitycsSettings objectForKey:@"JWTToken"]) {
            self.JWTToken = [streamAnalitycsSettings objectForKey:@"JWTToken"];
        }
        else {
            #ifdef DEBUG
            [self logMessage:@"JWTToken key missing."];
            #endif
        }
        
    }
    return self;
}


#pragma - property accessors

-(void)setLoggingEnabled:(BOOL)loggingEnabled {
    _loggingEnabled = loggingEnabled;
    #ifdef DEBUG
    [self logMessage:[NSString stringWithFormat:@"api key: %@\nJWTToken: %@", self.APIKey, self.JWTToken]];
    #endif
}

-(NSString *)userId {
    return _userId == nil ? self.APIKey : _userId;
}

- (void)send:(StreamEvent <StreamEvent>*)event {
    
    NSString *endPoint = [NSString stringWithFormat:@"%@/?api_key=%@", [[event class] endPoint], [StreamAnalytics sharedInstance].APIKey];
    
    #ifdef DEBUG
    [self logMessage:[NSString stringWithFormat:@"Send event: %@", endPoint]];
    #endif
    
    [self.streamClient doRequestForEndPoint:[endPoint stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withData:[event build] completionHandler:nil];
}

- (void)send:(StreamEvent <StreamEvent>*)event completionHandler:(StreamRequestResult)result {
    
    NSString *endPoint = [NSString stringWithFormat:@"%@/?api_key=%@", [[event class] endPoint], [StreamAnalytics sharedInstance].APIKey];
    
    #ifdef DEBUG
    [self logMessage:[NSString stringWithFormat:@"Send event: %@", endPoint]];
    #endif
    
    [self.streamClient doRequestForEndPoint:[endPoint stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withData:[event build] completionHandler:result];
}

#pragma mark - Private

-(void)logMessage:(NSString *)message {
    if(self.loggingEnabled) {
        StreamLogDebug([NSString stringWithFormat:@"%@\n%@", LogPrompt, message]);
    }
}

@end
