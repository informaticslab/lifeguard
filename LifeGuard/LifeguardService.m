//
//  LifeguardService.m
//  Lifeguard
//
//  Created by jtq6 on 4/8/15.
//  Copyright (c) 2015 CDC. All rights reserved.
//

#include "LifeguardService.h"

@implementation LifeguardService

-(id)init {
    
    self = [super init];
    return self;
}


-(void)sendLocation:(CLLocationCoordinate2D)location;

{
    // create session with Lifeguard URL and session defaults
    
    NSDate *now = [[NSDate alloc] init];
    NSString *vendorId = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    
    //    NSString *urlWithParams = [NSString stringWithFormat:@"https://desolate-river-2879.herokuapp.com/location?p=%@&t=%f&lat=%f&long=%f",
    //                               vendorId, floor([now timeIntervalSince1970]),
    //                               _userLocation.coordinate.latitude, _userLocation.coordinate.longitude];
    NSString *urlWithParams = [NSString stringWithFormat:@"http://127.0.0.1:5000/location?p=%@&t=%f&lat=%f&long=%f",
                               vendorId, floor([now timeIntervalSince1970]),
                               location.latitude, location.longitude];
    NSLog(@"Sending HTTP POST %@", urlWithParams);
    
    
    NSURL *url = [NSURL URLWithString:urlWithParams];
    NSURLSession *session = [NSURLSession sharedSession];
    
    // NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    // NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // set request to be a POST
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        // handle basic connectivity issues here
        if (error) {
            NSLog(@"dataTaskWithRequest error: %@", error);
            return;
        }
        
        // handle HTTP errors here
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            
            if (statusCode != 200) {
                NSLog(@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode);
                return;
            }
        }
        
        // otherwise, everything is probably fine and you should interpret the `data` contents
        NSLog(@"data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
    }];
    
    [task resume];
}

@end


