//
//  LocationShare.m
//  LifeGuard
//
//  Created by jtq6 on 4/2/15.
//  Copyright (c) 2015 CDC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Debug.h"
#import "CdcLocator.h"
#import "AppManager.h"
#import "WPSAlertController.h"


@implementation CdcLocator

#define DESIRED_ACCURAC

-(id)init {
    
    // Create the manager object
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    // if authorized status is Always or While Using the App
    if ([self isAppAuthorizedWithAlerts]) {
        
        DebugLog(@"Core Location Authorization Status set to kCLAuthorizationStatusAuthorizedAlways or kCLAuthorizationStatusAuthorizedWhenInUse.");
        [self setDefaultCLProperties];
        
        // Once configured, the location manager must be "started".
        [_locationManager startUpdatingLocation];
        
        [self enterForegroundMode];
    }
    
    
    return self;
    
}

-(void)setDefaultCLProperties
{
    
    // This is the most important property to set for the manager. It ultimately determines how the manager will
    // attempt to acquire location and thus, the amount of power that will be consumed.

    _locationManager.desiredAccuracy = 100;
    _locationManager.distanceFilter = 100;
    _locationManager.activityType = CLActivityTypeOther;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    if ([_locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)]) {
        [_locationManager setAllowsBackgroundLocationUpdates:YES];
        
    }
    

}


-(BOOL)isAppAuthorizedWithAlerts
{
    BOOL appAuthorized = NO;
    
    if ([CLLocationManager locationServicesEnabled] == NO) {
        DebugLog(@"Location Service are not enabled.");
        
        
        [WPSAlertController presentOkayAlertWithTitle:@"Location Services Disabled" message:@"Location Services must be enabled for CDC Lifeguard to report your location. Please go to Settings > Privacy > Location Services and turn on Location Services."];

        
    } else {
        
        
        // get authorization status
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        
        // request authorization if has not been set as is the case after app installation
        if ( status == kCLAuthorizationStatusNotDetermined) {
            DebugLog(@"Core Location Authorization Status set to kCLAuthorizationStatusNotDetermined.");
            [_locationManager requestAlwaysAuthorization];
        }
        
        // if authorized setting is While Using the App, let user know app works better when setting is Always
        else if (status == kCLAuthorizationStatusDenied) {
            DebugLog(@"CDC Lifeguard Is Denied Location Access.");
            
            [WPSAlertController presentOkayAlertWithTitle:@"CDC Lifeguard Denied Location Access" message:@"CDC Lifeguard has been denied access to your location. In order to report your location go to Settings > Privacy > Location Services, select CDC Lifeguard and then select Always. See Help for more information."];

            
        }
        
        else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
            DebugLog(@"CDC Lifeguard Does Not Always Have Location Access.");
            
            [WPSAlertController presentOkayAlertWithTitle:@"CDC Lifeguard Does Not Always Have Location Access" message:@"CDC Lifeguard does not have access to your location when the app is running in the background. In order to report your location when the app is in the background go to Settings > Privacy > Location Services, select CDC Lifeguard and then select Always. See Help for more information."];

        }
        
        
        // if authorized status is Always or While Using the App
        if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse)
            appAuthorized = YES;
        
    }
    
    return appAuthorized;
}

-(BOOL)isAppAuthorizedWithoutAlerts
{
    BOOL appAutorized = NO;
    
    if ([CLLocationManager locationServicesEnabled] == NO) {
        DebugLog(@"Location Service are not enabled.");
        
    } else {
        
        // get authorization status
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        
        // request authorization if has not been set as is the case after app installation
        if ( status == kCLAuthorizationStatusNotDetermined) {
            DebugLog(@"Core Location Authorization Status set to kCLAuthorizationStatusNotDetermined.");
        }
        
        // if authorized setting is While Using the App, let user know app works better when setting is Always
        else if (status == kCLAuthorizationStatusDenied) {
            DebugLog(@"CDC Lifeguard Is Denied Location Access.");
            
        }
        
        else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
            DebugLog(@"CDC Lifeguard Does Not Always Have Location Access.");
            
        }
        
        // if authorized status is Always or While Using the App
        if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse)
            appAutorized = YES;
        
    }
    
    return appAutorized;
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //  store location data
    CLLocation *newLocation = [locations lastObject];
    self.userLocation = newLocation;
    
    // tell the location manager to deferred location updates if in background
    if (([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground))
    {
        [self.locationManager allowDeferredLocationUpdatesUntilTraveled:CLLocationDistanceMax timeout:15*60];
    }
    
}


- (void) locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error
{
    if (error) {
        DebugLog(@"finished deferred updates with error %@",[error localizedDescription] );
    } else {
        DebugLog(@"finished deferred updates without an error.");
        [self.lifeguardService sendLocation:_userLocation];
    }
}


-(void)enterForegroundMode
{
    //[_locationManager stopMonitoringSignificantLocationChanges];
    DebugLog(@"entering foreground mode..");
    [_locationManager stopUpdatingLocation];
    
    // only report to location manager if the user has traveled 50 meters
    [self setDefaultCLProperties];

    _inBackgroundMode = NO;
    [_locationManager startUpdatingLocation];
    
}

-(void)enterBackgroundMode
{
    _inBackgroundMode = YES;
    
    [_locationManager stopUpdatingLocation];
    [self setDefaultCLProperties];
    [_locationManager startUpdatingLocation];
}

-(void)enterDeferredUpdateBackgroundMode
{
    // Need to stop regular updates first
    _inBackgroundMode = YES;
    DebugLog(@"entering deferred background mode..");
    [_locationManager stopUpdatingLocation];
    // only report to location manager if the user has traveled 1000 meters
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [_locationManager setDistanceFilter:kCLDistanceFilterNone];
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    
    // Only monitor significant changes
    //[_locationManager startMonitoringSignificantLocationChanges];
    
    [_locationManager startUpdatingLocation];
    
}


//-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    //  store location data
//    CLLocation *newLocation = [locations lastObject];
//    self.userLocation = newLocation;
//    self.locationTimestamp = newLocation.timestamp;
//
//    DebugLog(@"didUpdateLocations called.");
//    _updateLocationCount++;
//
//    // tell the location manager to deferred location updates if in background
//    if ((_inBackgroundMode == YES)  && (_areDeferringUpdates == NO) && (_updateLocationCount >= 10) )
//    {
//        DebugLog(@"in background and not deferring, so start deferred updates");
//        _areDeferringUpdates = YES;
//        _updateLocationCount = 0;
//        [self.locationManager allowDeferredLocationUpdatesUntilTraveled:CLLocationDistanceMax timeout:60];
//
//    }
//}



@end