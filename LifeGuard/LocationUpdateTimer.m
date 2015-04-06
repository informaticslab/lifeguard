//
//  LocationUpdateTimer.m
//  Lifeguard
//
//  Created by jtq6 on 4/3/15.
//  Copyright (c) 2015 CDC. All rights reserved.
//

#import "AppDelegate.h"
#import "LocationUpdateTimer.h"

// #define SECONDS_BETWEEN_UPDATES 60*15
#define SECONDS_BETWEEN_UPDATES 5

@implementation LocationUpdateTimer

-(id)init {
    
    self = [super init];
    
    // use when using this object's location manager
    // otherwise use AppDelegate's
    // [self initLocationManager];
    
    [self startTimer];
    return self;
    
}

-(void)initLocationManager
{
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    //self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    //self.locationManager.activityType = CLActivityTypeOtherNavigation;
    
    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    
}


- (void)startTimer {
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:SECONDS_BETWEEN_UPDATES
                                                  target:self
                                                selector:@selector(timerFired:)
                                                userInfo:nil
                                                 repeats:YES];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    NSLog(@"locationManager didUpdateLocations: %@",locations);
    
    for (int i=0; i<locations.count; i++){
        
        CLLocation *newLocation = [locations objectAtIndex:i];
        CLLocationCoordinate2D theLocation = newLocation.coordinate;
        CLLocationAccuracy theAccuracy = newLocation.horizontalAccuracy;
        
        self.currLocation = theLocation;
        self.currLocationAccuracy = theAccuracy;
    }
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Error while getting core location : %@",[error localizedFailureReason]);
    if ([error code] == kCLErrorDenied) {
        // denied
    }
    [manager stopUpdatingLocation];
}



- (void)stopTimer {
    
    //
    if ([timer isValid]) {
        [timer invalidate];
    }
    timer = nil;
}

- (void)timerFired:(NSTimer *)timer {
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    
    NSDate *now = [[NSDate alloc] init];

    // line for logging when using this AppDelegate location manager
    NSLog(@"LocationUpdateTimer fired at %@, lat/long = %f,%f", now, delegate.currLocation.latitude, delegate.currLocation.longitude );

    // line for logging when using this object's location manager
    // NSLog(@"LocationUpdateTimer fired at %@, latitude = %f, longitude = %f", now, self.currLocation.latitude, self.currLocation.longitude );
    
    [self postLocation];

}

-(void)postLocation
{
    // create session with Lifeguard URL and session defaults
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    NSDate *now = [[NSDate alloc] init];
    NSString *vendorId = [[UIDevice currentDevice] identifierForVendor].UUIDString;

    NSString *urlWithParams = [NSString stringWithFormat:@"http://127.0.0.1:5000/location?p=%@&t=%f&lat=%f&long=%f",
                        vendorId, floor([now timeIntervalSince1970]),
                        delegate.currLocation.latitude, delegate.currLocation.longitude];
    NSURL *url = [NSURL URLWithString:urlWithParams];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // set request to be a GET
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
    
    //
    NSDictionary *dictionary = @{@"key1": @"value1"};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary
                                                   options:kNilOptions error:&error];
    
    if (!error) {
        // 4
        NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                                   fromData:data completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                                                                       // Handle response here
                                                                   }];
        
        // 5
        [uploadTask resume];
    }
    
    
}

@end