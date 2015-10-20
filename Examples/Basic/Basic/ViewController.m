//
//  ViewController.m
//  Basic
//
//  Created by Alexander van der Werff on 26/09/15.
//  Copyright © 2015 Stream. All rights reserved.
//

#import "ViewController.h"
#import "Stream.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //track an impression
    StreamImpression *event = [StreamImpression createImpressionEventWithForeignIds:@[@"id1", @"id2", @"id3"]];

    //set user id
    [[StreamAnalytics sharedInstance] setUserId:@"userX"];
    
    //send with completion handler
    [[StreamAnalytics sharedInstance] send:event completionHandler:^(NSInteger statusCode, id JSON, NSError *error) {
        
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        
        NSLog(@"response with status code: %ld", (long)statusCode);
        
    }];
    
}

@end
