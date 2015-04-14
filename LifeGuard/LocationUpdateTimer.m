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

#define SECONDS_BETWEEN_UPDATES 10
#define VALID_LOCATION_SECONDS 2

@implementation LocationUpdateTimer

-(id)init {
    
    self = [super init];
    self.haveFirstLocation = NO;
    // use when using this object's location manager
    self.lifeguardService = [[LifeguardService alloc] init];
    [self startFirstLocationTimer];
    return self;
    
}

-(CLLocationCoordinate2D)getCurrentLocationCoordinates
{
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.userLocation.coordinate;

}

-(void)sendLocation
{
    [self.lifeguardService sendLocation:[self getCurrentLocationCoordinates]];
}


- (void)startFirstLocationTimer {
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:VALID_LOCATION_SECONDS
                                                  target:self
                                                selector:@selector(timerFired:)
                                                userInfo:nil
                                                 repeats:YES];
    }
}

- (void)startLocationUpdateTimer {
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:SECONDS_BETWEEN_UPDATES
                                                      target:self
                                                    selector:@selector(timerFired:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}


- (void)stopTimer {
    
    //
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
    self.timer = nil;
}

- (void)timerFired:(NSTimer *)timer {
    
    
    CLLocationCoordinate2D currCoordinates = [self getCurrentLocationCoordinates];

    if (self.haveFirstLocation == NO) {
        
        // check for valid location
        if (currCoordinates.latitude != 0 || currCoordinates.longitude != 0) {
            
            // have valid location, stop fast first location timer
            // use slower update location timer
            self.haveFirstLocation = YES;
            [self stopTimer];
            [self startLocationUpdateTimer];
            return;
            
        }
    }
        
    NSDate *now = [[NSDate alloc] init];

    // line for logging when using this AppDelegate location manager
    NSLog(@"LocationUpdateTimer fired at %@, lat/long = %f,%f", now, currCoordinates.latitude, currCoordinates.longitude);

    // line for logging when using this object's location manager
    // NSLog(@"LocationUpdateTimer fired at %@, latitude = %f, longitude = %f", now, self.currLocation.latitude, self.currLocation.longitude );
    
    [self.lifeguardService sendLocation:currCoordinates];

}


@end