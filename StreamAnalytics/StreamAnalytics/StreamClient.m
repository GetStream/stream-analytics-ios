//
//  StreamClient.m
//  StreamAnalytics
//
//  Created by Alexander van der Werff on 25/08/15.
//  Copyright (c) 2015 Stream. All rights reserved.
//

#import "StreamAnalytics.h"
#import "StreamAnalytics+Protected.h"
#import "StreamClient.h"


#define MAX_CONNECTIONS 10

/* Stream base URI */
static NSString *const StreamBaseURI = @"https://analytics.getstream.io/analytics";

/* Sream API version */
static NSString *const StreamAPIVersion = @"v1.0";



@interface StreamClient()


@end


@implementation StreamClient

+ (instancetype)sharedInstance {
    static StreamClient *streamClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        streamClient = [[self alloc] init];
    });
    return streamClient;
}

-(void)dealloc {
//    [session invalidateAndCancel];
}

+ (NSURL *) baseURL {
    static NSURL *baseURL = nil;
    if(!baseURL)
        baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", StreamBaseURI, StreamAPIVersion]];
    return baseURL;
}


- (NSURLSession *) streamSession {
    
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        [configuration setHTTPMaximumConnectionsPerHost:MAX_CONNECTIONS];
        configuration.URLCache = nil;
        configuration.allowsCellularAccess = YES;
        configuration.timeoutIntervalForRequest = 30;
        configuration.timeoutIntervalForResource = 60;

        [configuration setHTTPAdditionalHeaders:@{
                                                  @"Authorization" : [StreamAnalytics sharedInstance].JWTToken,
                                                  @"STREAM-AUTH-TYPE" : @"jwt",
                                                  @"Content-Type"  : @"application/json"
                                                  }];
        
        session = [NSURLSession sessionWithConfiguration:configuration];        
        
    });
    return session;
}

- (void)doRequestForEndPoint:(NSString *)endPoint withData:(NSDictionary *)data completionHandler:(StreamRequestResult)completionHandler {

    NSURL *url = [NSURL URLWithString:endPoint relativeToURL:[[self class] baseURL]];
    
    NSError *err = nil;
    NSData *serializedData = [NSJSONSerialization dataWithJSONObject:data
                                                   options:kNilOptions error:&err];
    
    
    if (err) {
        #ifdef DEBUG
        [[StreamAnalytics sharedInstance] logMessage:[NSString stringWithFormat:@"%@", [err localizedDescription]]];
        #endif
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    request.HTTPMethod = @"POST";
    request.HTTPBody = serializedData;
    
    NSURLSessionDataTask *dataTask = [[self streamSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        //accepted statusCodes...
        NSInteger statusCode = [(NSHTTPURLResponse *) response statusCode];
        
        if (!error)
        {
            NSError *dataError;
            id jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&dataError];
            
            if ([NSJSONSerialization isValidJSONObject:jsonData]
                && dataError == nil
                && (statusCode==200 || statusCode==201)) {

                #ifdef DEBUG
                [[StreamAnalytics sharedInstance] logMessage:[NSString stringWithFormat:@"%@", [NSJSONSerialization JSONObjectWithData:data options:0 error:nil]]];
                #endif

                if(completionHandler) {
                    completionHandler(statusCode, jsonData, nil);
                }
                
            }
            else {
                NSError *err = [NSError errorWithDomain:@"io.getstream.analytics" code:statusCode userInfo:@{
                                                                                              NSLocalizedDescriptionKey:@"Event not created!"
                                                                                              }];
                if(completionHandler) {
                    completionHandler(statusCode, @{}, err);
                }
            }
        }
        else
        {

            NSError *dataError;
            id jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&dataError];
            
            if ([NSJSONSerialization isValidJSONObject:jsonData] && dataError != nil) {
                
                if(completionHandler) {
                    completionHandler(statusCode, jsonData, error);
                }
        
            }
            else {
                completionHandler(statusCode, @{@"error":err.localizedDescription}, error);
            }

        }
        
    }];

    [dataTask resume];
}

@end
