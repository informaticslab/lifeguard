//
//  LocationUpdateTimer.m
//  Lifeguard
//
//  Created by jtq6 on 4/3/15.
//  Copyright (c) 2015 CDC. All rights reserved.
//

#import "AppDelegate.h"
#import "AppManager.h"
#import "LocationUpdateTimer.h"


#define SECONDS_BETWEEN_UPDATES 1*60
#define VALID_LOCATION_SECONDS 1

@implementation LocationUpdateTimer

AppManager *appMgr;

-(id)init {
    
    self = [super init];
    appMgr = [AppManager singletonAppManager];
    
    self.haveFirstLocation = NO;
    // use when using this object's location manager
    self.lifeguardService = [[LifeguardService alloc] init];
    [self startFirstLocationTimer];
    return self;
    
}

-(CLLocationCoordinate2D)getCurrentLocationCoordinates
{
    
    return appMgr.cdcLocator.userLocation.coordinate;
    
    
}

-(CLLocation *)getCurrentLocation
{
    
    return appMgr.cdcLocator.userLocation;
    
    
}


-(void)sendLocation
{
    [self.lifeguardService sendLocation:[self getCurrentLocation]];
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
    
    
    CLLocation *location = [self getCurrentLocation];
    CLLocationDegrees lat = location.coordinate.latitude;
    CLLocationDegrees lng = location.coordinate.longitude;
    
    // do nothing if we do not have first valid location
    if (self.haveFirstLocation == NO && lat == 0 && lng == 0)
        return;
    
    // if we just found first valid location
    if (self.haveFirstLocation == NO && (lat != 0 || lng != 0)) {
        
        // have valid location, stop fast first location timer
        // use slower update location timer
        self.haveFirstLocation = YES;
        [self stopTimer];
        [self startLocationUpdateTimer];
    }
    
    NSDate *now = [[NSDate alloc] init];
    
    // line for logging when using this AppDelegate location manager
    DebugLog(@"fired at %@, lat/long = %f,%f", now, lat, lng);
    
     
    [self.lifeguardService sendLocation:location];
    
}

@end