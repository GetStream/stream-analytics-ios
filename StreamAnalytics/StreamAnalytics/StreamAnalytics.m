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

static BOOL loggingEnabled = NO;
static NSString *const LogPrompt = @"<STREAM ANALYTICS>";



@implementation StreamAnalytics


#pragma mark - class methods

+ (instancetype)sharedInstance {
    static StreamAnalytics *streamAnalytics = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        streamAnalytics = [[self alloc] initWith:loggingEnabled];
    });
    return streamAnalytics;
}

+ (void)enableLogging:(BOOL)enable {
    loggingEnabled = enable;
    #ifdef DEBUG
    [[StreamAnalytics sharedInstance] logMessage:[NSString stringWithFormat:@"Logging on: %d", loggingEnabled]];
    #endif
}

#pragma mark - instance methods

- (instancetype)init {
    return [self initWith:NO];
}

- (instancetype)initWith:(BOOL)loggingEnabled {
    self = [super init];
    if(self) {
        
        self.streamClient = [StreamClient sharedInstance];
        
        loggingEnabled = loggingEnabled;
        
        NSBundle *appBundle = [NSBundle mainBundle];
        NSDictionary *streamAnalitycsSettings = [appBundle objectForInfoDictionaryKey:@"StreamAnalytics"];
        
        if (!streamAnalitycsSettings) {
            #ifdef DEBUG
            [self logMessage:@"Stream Analytics requires an API key and JWT token."];
            #endif
        }
        
        if (streamAnalitycsSettings && [(NSString *)[streamAnalitycsSettings objectForKey:@"APIKey"] length] != 0 ) {
            self.APIKey = [streamAnalitycsSettings objectForKey:@"APIKey"];
        }
        else {
            #ifdef DEBUG
            [self logMessage:@"API key missing."];
            #endif
        }
        
        if (streamAnalitycsSettings && [(NSString *)[streamAnalitycsSettings objectForKey:@"JWTToken"] length] != 0) {
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


- (void)setUserId:(NSString *) userId andAlias:(NSString *) alias{
    [StreamAnalytics sharedInstance].userData = @{@"id": userId, @"alias": alias};
}


- (void)setUserId:(NSString *) userId {
    [StreamAnalytics sharedInstance].userData = @{@"id": userId};
}


#pragma - property accessors

- (void)send:(StreamEvent <StreamEvent>*)event {
    
    NSString *endPoint = [NSString stringWithFormat:@"%@/?api_key=%@", [[event class] endPoint], [StreamAnalytics sharedInstance].APIKey];
    
    #ifdef DEBUG
    [self logMessage:[NSString stringWithFormat:@"Send event: %@", endPoint]];
    #endif

    if ([self.userData objectForKey:@"key"] != nil) {
        [self.streamClient doRequestForEndPoint:[endPoint stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withData:[event build] completionHandler:nil];
    } else {
        [self logMessage:[NSString stringWithFormat:@"You must set the user in order to track events"]];
    }

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
    if(loggingEnabled) {
        StreamLogDebug([NSString stringWithFormat:@"%@\n%@", LogPrompt, message]);
    }
}

@end
