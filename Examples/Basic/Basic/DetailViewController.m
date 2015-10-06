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
    StreamEngagement *event = [StreamEngagement createEngagementEventWithActivityId:self.someId feedId:@"feedId" label:@"label" score:[NSNumber numberWithInt:10] extraData:@{@"extra":@"extra"}];
    StreamAnalytics *shared = [StreamAnalytics sharedInstance];
    
    //set user id
    [shared setUserId:@"userX"];
    
    //send it
    [shared send:event];
    
}

@end
