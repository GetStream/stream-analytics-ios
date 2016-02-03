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
 API_KEY 8r9brv6v4xj5
 JWT_TOKEN eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY3Rpb24iOiJ3cml0ZSIsInVzZXJfaWQiOiIqIiwicmVzb3VyY2UiOiJhbmFseXRpY3MifQ.rKwIdyV10DQyoFgC-KmAXBUljoFU7wbeqQV6uqNvSDg
 */

@interface StreamAnalyticsTests : XCTestCase

@end

@implementation StreamAnalyticsTests

- (void)setUp {
    [super setUp];
    [StreamAnalytics enableLogging:YES];
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

- (void)testseUserIdAndAlias {
    StreamAnalytics *shared = [StreamAnalytics sharedInstance];
    [shared setUserId:@"486892" andAlias:@"Julian"];
    
    XCTAssertEqual([shared userData][@"id"], @"486892", @"User id not equal to set user id");
    XCTAssertEqual([shared userData][@"alias"], @"Julian", @"User id not equal to set user id");
}

- (void)testTrackEngagementEventWithUserId {
    StreamEngagement *event = [StreamEngagement createEngagementEvent:@"label" withContent:@{@"foreign_id": @"fid"}.mutableCopy];
    StreamAnalytics *shared = [StreamAnalytics sharedInstance];
    [shared setUserId:@"userX"];
    
    XCTAssertEqual([shared userData][@"id"], @"userX", @"User id not equal to set user id");
    
    [shared send:event];
}

- (void)testExample1 {
    StreamImpression *event = [StreamImpression createImpressionEventWithContentList:@[@"song:34349698", @"song:34349699", @"song:34349697"]];
    [[StreamAnalytics sharedInstance] setUserId:@"userX"];
    event.feedId = @"flat:tommaso";
    event.location = @"ios-app";
    [[StreamAnalytics sharedInstance] send:event];
}

- (void)testExample2 {
    [[StreamAnalytics sharedInstance] setUserId:@"userX"];
    NSMutableDictionary *content = [NSMutableDictionary new];
    content[@"foreign_id"] = @"post:42";
    content[@"label"] = @"Tom shared She wolf from Shakira";
    content[@"actor"] = @{@"id": @"user:2353540", @"label": @"Tom"};
    content[@"object"] = @{@"id": @"song:34349698", @"label": @"She wolf"};
    content[@"verb"] = @"share";
    StreamEngagement *event = [StreamEngagement createEngagementEvent:@"click" withContent: content];
    event.feedId = @"timeline:tom";
    [[StreamAnalytics sharedInstance] send:event];
}

- (void)testExample3 {
    [[StreamAnalytics sharedInstance] setUserId:@"userX"];
    NSMutableDictionary *content = [NSMutableDictionary new];
    content[@"foreign_id"] = @"post:42";
    content[@"label"] = @"Tom shared She wolf from Shakira";
    content[@"actor"] = @{@"id": @"user:2353540", @"label": @"Tom"};
    content[@"object"] = @{@"id": @"song:34349698", @"label": @"She wolf"};
    content[@"verb"] = @"share";
    StreamEngagement *event = [StreamImpression createImpressionEventWithContentList:@[content]];
    event.feedId = @"timeline:tom";
    [[StreamAnalytics sharedInstance] send:event];
}

- (void)testTrackEngagementEventWithUserIdAndFeatures {
    StreamEngagement *event = [StreamEngagement createEngagementEvent:@"label" withContent: @{@"foreign_id": @"fid"}.mutableCopy];
    event.features = @[@{@"group":@"topic", @"value":@"programming"}.mutableCopy].mutableCopy;
    StreamAnalytics *shared = [StreamAnalytics sharedInstance];
    [shared setUserId:@"userX"];
    
    XCTAssertEqual([shared userData][@"id"], @"userX", @"User id not equal to set user id");
    XCTestExpectation *expectation = [self expectationWithDescription:@"Track async engagement event"];

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

- (void)testTrackEngagementEventCallback {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Track async engagement event"];
    
    StreamEngagement *event = [StreamEngagement createEngagementEvent:@"label" withContent:@{@"foreign_id": @"fid"}.mutableCopy];
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

- (void)testTrackImpressionEventCallback {

    XCTestExpectation *expectation = [self expectationWithDescription:@"Track async impression event"];
    
    StreamImpression *event = [StreamImpression createImpressionEventWithContentList:@[@"id1", @"id2", @"id3"]];
    [[StreamAnalytics sharedInstance] setUserId:@"userX"];
    [[StreamAnalytics sharedInstance] send:event completionHandler:^(NSInteger statusCode, id JSON, NSError *error) {
       
        NSLog(@"response with status code: %ld", (long)statusCode);
        
        XCTAssertTrue(error==nil, @"%@", error.localizedDescription);
        
        XCTAssertEqual(statusCode, 201, @"event not created on server");
        
        //finish async test
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

- (void)testTrackImpressionContentObjectsEventCallback {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Track async impression event"];
    
    StreamImpression *event = [StreamImpression createImpressionEventWithContentList:@[@{@"foreign_id": @"fid"}.mutableCopy]];
    [[StreamAnalytics sharedInstance] setUserId:@"userX"];
    [[StreamAnalytics sharedInstance] send:event completionHandler:^(NSInteger statusCode, id JSON, NSError *error) {
        
        NSLog(@"response with status code: %ld", (long)statusCode);
        
        XCTAssertTrue(error==nil, @"%@", error.localizedDescription);
        
        XCTAssertEqual(statusCode, 201, @"event not created on server");
        
        //finish async test
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

- (void)testTrackImpressionWithLocationEventCallback {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Track async impression event"];
    
    StreamImpression *event = [StreamImpression createImpressionEventWithContentList:@[@"id1", @"id2", @"id3"]];
    event.location = @"frontpage";
    event.position = @"top";

    [[StreamAnalytics sharedInstance] setUserId:@"userX"];
    [[StreamAnalytics sharedInstance] send:event completionHandler:^(NSInteger statusCode, id JSON, NSError *error) {
        
        NSLog(@"response with status code: %ld", (long)statusCode);
        
        XCTAssertTrue(error==nil, @"%@", error.localizedDescription);
        
        XCTAssertEqual(statusCode, 201, @"event not created on server");
        
        //finish async test
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

- (void)testEventCallbackError {
    
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
