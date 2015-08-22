//
//  StreamAnalytics.m
//  StreamAnalytics
//
//  Created by Alexander van der Werff on 22/08/15.
//  Copyright (c) 2015 Stream. All rights reserved.
//

#import "StreamAnalytics.h"

@implementation StreamAnalytics


#pragma mark - class methods

+ (id)sharedInstance {
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
        NSBundle *appBundle = [NSBundle bundleForClass:[self class]];
        NSDictionary *streamAnalitycsSettings = [appBundle objectForInfoDictionaryKey:@"StreamAnalytics"];
        
        NSAssert(streamAnalitycsSettings!=nil, @"STREAM ANALYTICS requires A StreamAnalytics dict entry in your app config plist file");
        
        
        
    }
    return self;
}

@end
