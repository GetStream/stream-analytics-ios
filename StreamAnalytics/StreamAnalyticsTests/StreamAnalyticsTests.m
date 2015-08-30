//
//  StreamAnalyticsTests.m
//  StreamAnalytics
//
//  Created by Alexander van der Werff on 22/08/15.
//  Copyright (c) 2015 Stream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "Stream.h"

/*
 API_KEY nfq26m3qgfyp
 JWT_TOKEN eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY3Rpb24iOiJ3cml0ZSIsImZlZWRfaWQiOiIqIiwicmVzb3VyY2UiOiJhbmFseXRpY3MifQ.pFU9mTsGtBuhdU-_NjKmd6dLRwvAcNskeMZ97BRRMnE
 */

@interface StreamAnalyticsTests : XCTestCase

@end

@implementation StreamAnalyticsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testStreamAnalyticsSingletonExists {
    XCTAssertNotNil( [StreamAnalytics sharedInstance], @"StreamAnalytics singleton class exists");
}

- (void)testStreamAnalyticsAPIKeyFromInfoPlist {
    NSDictionary *settings = [[NSBundle bundleForClass:[self class]] objectForInfoDictionaryKey:@"StreamAnalytics"];
    XCTAssertEqual((NSString *)[settings objectForKey:@"APIKey"],[[StreamAnalytics sharedInstance] APIKey], @"API Key is not equal to enry in app info property list");
}

- (void)testStreamAnalyticsApiSecretFromInfoPlist {
    NSDictionary *settings = [[NSBundle bundleForClass:[self class]] objectForInfoDictionaryKey:@"StreamAnalytics"];
    XCTAssertEqual((NSString *)[settings objectForKey:@"JWTToken"],[[StreamAnalytics sharedInstance] JWTToken], @"JWT Token not equal to entry in app info property list");
}

- (void)testTrackEngagementEvent {
    
    StreamEngagement *event = [StreamEngagement createEngagementEventWithActivityId:@"activityId" feedId:@"feedId" label:@"label" score:[NSNumber numberWithInt:10] extraData:@{@"extra":@"extra"}];
    StreamAnalytics *shared = [StreamAnalytics sharedInstance];
    [shared setUserId:@"userX"];
    [shared send:event];

}

- (void)testTrackEngagementEventCallback {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Track async event"];
    
    StreamEngagement *event = [StreamEngagement createEngagementEventWithActivityId:@"activityId" feedId:@"feedId" label:@"label" score:[NSNumber numberWithInt:10] extraData:@{@"extra":@"extra"}];
    StreamAnalytics *shared = [StreamAnalytics sharedInstance];
    [shared setUserId:@"userX"];
    [shared send:event completionHandler:^(NSInteger statusCode, id JSON, NSError *error) {
        
        NSLog(@"response with status code: %ld", (long)statusCode);
        
        XCTAssertTrue(error==nil, @"%@", error.localizedDescription);

        XCTAssertEqual(statusCode, 201, @"event not created on server");
        
        XCTAssertTrue(![NSThread isMainThread], @"Callback is on the main thread!");
        
        //finish async test
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}



- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
