//
//  StreamAnalytics.m
//  StreamAnalytics
//
//  Created by Alexander van der Werff on 22/08/15.
//  Copyright (c) 2015 Stream. All rights reserved.
//

#import "StreamAnalytics.h"
#import "StreamClient.h"

@interface StreamAnalytics()

@property (nonatomic, strong) StreamClient *streamClient;

@end

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
        
//        NSAssert(streamAnalitycsSettings!=nil, @"STREAM ANALYTICS requires A StreamAnalytics dict entry in your app config plist file");
        
        if (streamAnalitycsSettings && (NSString *)[streamAnalitycsSettings objectForKey:@"APIKey"]) {
            self.APIKey = [streamAnalitycsSettings objectForKey:@"APIKey"];
        }

        if (streamAnalitycsSettings && (NSString *)[streamAnalitycsSettings objectForKey:@"JWTToken"]) {
            self.JWTToken = [streamAnalitycsSettings objectForKey:@"JWTToken"];
        }
        
    }
    return self;
}


-(NSString *)userId {
    return _userId == nil ? self.APIKey : _userId;
}

- (void)send:(StreamEvent <StreamEvent>*)event {
    
    NSString *endPoint = [NSString stringWithFormat:@"%@/?api_key=%@", [[event class] endPoint], [StreamAnalytics sharedInstance].APIKey];
    
    [self.streamClient doRequestForEndPoint:[endPoint stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withData:[event build] completionHandler:nil];
}

- (void)send:(StreamEvent <StreamEvent>*)event completionHandler:(StreamRequestResult)result {
    
    NSString *endPoint = [NSString stringWithFormat:@"%@/?api_key=%@", [[event class] endPoint], [StreamAnalytics sharedInstance].APIKey];
    
    [self.streamClient doRequestForEndPoint:[endPoint stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withData:[event build] completionHandler:result];
}

@end
