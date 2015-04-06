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
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    //self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    //self.locationManager.activityType = CLActivityTypeOtherNavigation;
    
    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    [self startTimer];
    return self;
    
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
    
    NSDate *now = [[NSDate alloc] init];
    NSLog(@"LocationUpdateTimer fired at %@, latitude = %f, longitude = %f", now, self.currLocation.latitude, self.currLocation.longitude );

}

@end