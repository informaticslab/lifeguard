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

@implementation CdcLocator


-(id)init {
    
    // Create the manager object
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    if ([CLLocationManager locationServicesEnabled] == NO) {
        DebugLog(@"Location Service are not enabled.");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Location Services Disabled"
                                                       message:@"Location Services must be enabled for CDC Lifeguard to report your location. Please go to Settings > Privacy > Location Services and turn on Location Services."
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
        [alert show];
        
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
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"CDC Lifeguard Denied Location Access"
                                                           message:@"CDC Lifeguard has been denied access to your location. In order to report your location go to Settings > Privacy > Location Services, select CDC Lifeguard and then select Always. See Help for more information."
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
        else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
            DebugLog(@"CDC Lifeguard Does Not Always Have Location Access.");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"CDC Lifeguard Does Not Always Have Location Access"
                                                           message:@"CDC Lifeguard does not have access to your location when the app is running in the background. In order to report your location when the app is in the background go to Settings > Privacy > Location Services, select CDC Lifeguard and then select Always. See Help for more information."
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
        
        // if authorized status is Always or While Using the App
        if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
            
            DebugLog(@"Core Location Authorization Status set to kCLAuthorizationStatusAuthorizedAlways or kCLAuthorizationStatusAuthorizedWhenInUse.");
            // This is the most important property to set for the manager. It ultimately determines how the manager will
            // attempt to acquire location and thus, the amount of power that will be consumed.
            _locationManager.desiredAccuracy = 45;
            _locationManager.distanceFilter = 100;
            
            // Once configured, the location manager must be "started".
            [_locationManager startUpdatingLocation];
            
        }
    }

    return self;
    
}

-(void)appInactive
{
    
    [_locationManager stopUpdatingLocation];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [_locationManager setDistanceFilter:kCLDistanceFilterNone];
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    [_locationManager startUpdatingLocation];
    _isBackgroundMode = YES;
    
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //  store location data
    CLLocation *newLocation = [locations lastObject];
    self.userLocation = newLocation;
    self.locationTimestamp = newLocation.timestamp;
    
    // tell the location manager to deferred location updates if in background
    if (([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground))
    {
        [self.locationManager allowDeferredLocationUpdatesUntilTraveled:CLLocationDistanceMax timeout:15*60];
    }
}

- (void) locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error
{
    
    DebugLog(@"CDC Lifeguard didFinishDeferredUpdatesWithError was called with NSError: %@",[error localizedDescription] );
    
}

-(void)startBackgroundLocationUpdates
{
    [_locationManager stopUpdatingLocation];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [_locationManager setDistanceFilter:kCLDistanceFilterNone];
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    [_locationManager startMonitoringSignificantLocationChanges];
    _isBackgroundMode = YES;
    
}

-(void)startForegroundLocationUpdates
{
    [_locationManager stopMonitoringSignificantLocationChanges];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [_locationManager setDistanceFilter:kCLDistanceFilterNone];
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    [_locationManager startUpdatingLocation];
    _isBackgroundMode = YES;

    
}

@end