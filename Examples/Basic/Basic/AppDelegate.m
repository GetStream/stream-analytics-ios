//
//  AppDelegate.m
//  Basic
//
//  Created by Alexander van der Werff on 26/09/15.
//  Copyright © 2015 Stream. All rights reserved.
//

#import "AppDelegate.h"

#import "Stream.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //enable debug logging
    [StreamAnalytics enableLogging:YES];
    
    return YES;
}

@end
