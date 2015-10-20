//
//  DetailViewController.m
//  Basic
//
//  Created by Alexander van der Werff on 05/10/15.
//  Copyright © 2015 Stream. All rights reserved.
//

#import "DetailViewController.h"
#import "Stream.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    //create engagement event
    StreamEngagement *event = [StreamEngagement createEngagementEvent:@"open" withForeignId: @"page_main"];
    StreamAnalytics *shared = [StreamAnalytics sharedInstance];
    
    //set user id
    [shared setUserId:@"userX"];
    
    //send it
    [shared send:event completionHandler:^(NSInteger statusCode, id JSON, NSError *error) {
        
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        
        NSLog(@"response with status code: %ld", (long)statusCode);
        
    }];
    
}

@end
