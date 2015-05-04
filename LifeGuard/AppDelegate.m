//
//  AppDelegate.m
//  LifeGuard
//
//  Created by jtq6 on 4/2/15.
//  Copyright (c) 2015 CDC. All rights reserved.
//

#import "AppDelegate.h"
#import "LifeguardService.h"


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    NSLog(@"didFinishLaunchingWithOptions");
    
    [self initLocationManager];
    UIAlertView * alert;
    

    // Background App Refresh in Settings->General must be enabled for location updates to work in the background
    if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"CDC Lifeguard is most effective when the Background App Refresh is enabled. To turn it on, go to Settings > General > Background App Refresh."
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    } else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"CDC Lifeguard is limited because the Background App Refresh is disabled."
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
    return YES;
    
}


//
//
-(void) initLocationManager
{
    // Create the manager object
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    if ([CLLocationManager locationServicesEnabled] == NO) {
        NSLog(@"Location Service are not enabled.");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Location Services Disabled"
                                              message:@"Location Services must be enabled for CDC Lifeguard to report your location. Please go to Settings > Privacy and turn on Location Services."
                                             delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil, nil];
            [alert show];
   
    }
    
    
    // get authorization status
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if ( status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"Core Location Authorization Status set to kCLAuthorizationStatusNotDetermined.");
        [_locationManager requestAlwaysAuthorization];
    } else if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse ) {
        
        NSLog(@"Core Location Authorization Status set to kCLAuthorizationStatusAuthorizedAlways or kCLAuthorizationStatusAuthorizedWhenInUse.");
        // This is the most important property to set for the manager. It ultimately determines how the manager will
        // attempt to acquire location and thus, the amount of power that will be consumed.
        _locationManager.desiredAccuracy = 45;
        _locationManager.distanceFilter = 100;
        
        // Once configured, the location manager must be "started".
        [_locationManager startUpdatingLocation];
        
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    _isBackgroundMode = YES;
    
    [_locationManager stopUpdatingLocation];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [_locationManager setDistanceFilter:kCLDistanceFilterNone];
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    [_locationManager startUpdatingLocation];
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

- (void) locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error {
    
        NSLog(@"CDC Lifeguard didFinishDeferredUpdatesWithError was called with NSError: %@",[error localizedDescription] );
}




@end
