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
    self.dateFormat = [[NSDateFormatter alloc] init];
    self.dateFormat.dateStyle = NSDateFormatterNoStyle;
    self.dateFormat.timeStyle = NSDateFormatterShortStyle;
    

    return self;
}


-(void)sendLocation:(CLLocationCoordinate2D)location;
{
    
    // check for valid location, don't report 0.0/0.0
    if (location.latitude == 0 && location.longitude == 0) {
        [self waitForLocation];
        return;
        
    }
    
    // create session with Lifeguard URL and session defaults
    NSDate *now = [[NSDate alloc] init];
    NSString *vendorId = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    
//    NSString *urlWithParams = [NSString stringWithFormat:@"http://eocexternal.cdc.gov/Lifeguard/lgService.aspx?p=%@&t=%.0f&lat=%f&lng=%f",
//                               vendorId, floor([now timeIntervalSince1970]),
//                               location.latitude, location.longitude];
    NSString *urlWithParams = [NSString stringWithFormat:@"https://desolate-river-2879.herokuapp.com/location?p=%@&t=%.0f&lat=%f&long=%f",
                                   vendorId, floor([now timeIntervalSince1970]),
                                   location.latitude, location.longitude];
    //NSString *urlWithParams = [NSString stringWithFormat:@"http://127.0.0.1:5000/location?p=%@&t=%.0f&lat=%f&long=%f",
    //                           vendorId, floor([now timeIntervalSince1970]),
    //                           location.latitude, location.longitude];
    NSLog(@"Sending HTTP GET %@", urlWithParams);
    
    
    NSURL *url = [NSURL URLWithString:urlWithParams];
    NSURLSession *session = [NSURLSession sharedSession];
    
    // NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    // NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // set request to be a GET
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        // handle basic connectivity issues here
        if (error) {
            NSLog(@"dataTaskWithRequest error: %@", error);
            self.statusString = error.userInfo[@"NSLocalizedDescription"];
            
        }
        
        // handle HTTP errors here
        else if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            

            
            if (statusCode != 200) {
                NSLog(@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode);
                self.statusString = [NSString stringWithFormat:@"HTTP error code %ld occurred.", (long)statusCode];
            } else {
                [self updateSuccess];
            }
        }
        
        else {
            [self updateSuccess];

        // otherwise, everything is probably fine and you should interpret the `data` contents
        NSLog(@"data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            
        }
        
        return;

        
    }];
    
    [task resume];
}

-(void)updateSuccess
{
    NSDate *now = [[NSDate alloc] init];
    NSString *dateString = [self.dateFormat stringFromDate:now];
    NSString *status = [NSString stringWithFormat:@"Location successfully updated at %@.", dateString];
    
    NSLog(@"LifeguardService success: %@", status);

    self.statusString = status;

    
}

-(void)waitForLocation
{
    NSString *status = [NSString stringWithFormat:@"Waiting for valid location..."];
    
    NSLog(@"LifeguardService update: %@", status);
    
    self.statusString = status;

    
}



@end


