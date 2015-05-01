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

    UIAlertView * alert;

    // Override point for customization after application launch.
    NSLog(@"didFinishLaunchingWithOptions");
    
    [self initLocationManager];
    
    _lifeguardService = [[LifeguardService alloc] init];
    
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
    
    _deferringUpdates = NO;
    _isBackgroundMode = NO;
    
    if ([CLLocationManager locationServicesEnabled] == NO) {
        NSLog(@"Location Service are not enabled.");
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
            NSLog(@"Core Location Authorization Status set to kCLAuthorizationStatusNotDetermined.");
            [_locationManager requestAlwaysAuthorization];
        }
        
        // if authorized setting is While Using the App, let user know app works better when setting is Always
        else if (status == kCLAuthorizationStatusDenied) {
            NSLog(@"CDC Lifeguard Is Denied Location Access.");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"CDC Lifeguard Denied Location Access"
                                                           message:@"CDC Lifeguard has been denied access to your location. In order to report your location go to Settings > Privacy > Location Services, select CDC Lifeguard and then select Always. See Help for more information."
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
        else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
            NSLog(@"CDC Lifeguard Does Not Always Have Location Access.");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"CDC Lifeguard Does Not Always Have Location Access"
                                                           message:@"CDC Lifeguard does not have access to your location when the app is running in the background. In order to report your location when the app is in the background go to Settings > Privacy > Location Services, select CDC Lifeguard and then select Always. See Help for more information."
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
        
        // if authorized status is Always or While Using the App
        if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
            
            NSLog(@"Core Location Authorization Status set to kCLAuthorizationStatusAuthorizedAlways or kCLAuthorizationStatusAuthorizedWhenInUse.");
            // This is the most important property to set for the manager. It ultimately determines how the manager will
            // attempt to acquire location and thus, the amount of power that will be consumed.
            _locationManager.desiredAccuracy = 45;
            _locationManager.distanceFilter = 100;
            
            // Once configured, the location manager must be "started".
            [_locationManager startUpdatingLocation];
            
        }
    }
}

-(void)applicationWillEnterForeground:(UIApplication *)application
{
    _isBackgroundMode = NO;
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    _isBackgroundMode = YES;
    
    [_locationManager stopUpdatingLocation];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    [_locationManager setDistanceFilter:kCLDistanceFilterNone];
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    _locationManager.activityType = CLActivityTypeOther;
    [_locationManager startUpdatingLocation];
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //  store location data
    CLLocation *newLocation = [locations lastObject];
    self.userLocation = newLocation;
    
    NSLog(@"CDC Lifeguard didUpdateLocations was called.");

    
    // tell the location manager to deferred location updates if in background
    if (_isBackgroundMode && !_deferringUpdates)
    {
        NSLog(@"CDC Lifeguard calling allowDeferredLocationUpdatesUntilTraveled.");
        [_lifeguardService sendLocation:newLocation.coordinate];

        _deferringUpdates = YES;
        [self.locationManager allowDeferredLocationUpdatesUntilTraveled:CLLocationDistanceMax timeout:20];
    }
}

- (void) locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error {
    
    _deferringUpdates = NO;
    if (error != NULL)
        NSLog(@"CDC Lifeguard didFinishDeferredUpdatesWithError was called with NSError: %@",[error localizedDescription] );
    else
        NSLog(@"CDC Lifeguard didFinishDeferredUpdatesWithError was called without an error.");

}

-(BOOL)isLocationManagerAuthorized
{
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse )
        return YES;
    else
        return NO;
    
}

-(BOOL)isDeferringLocationUpdates
{
    if (_isBackgroundMode && _deferringUpdates)
        return YES;
    
    return NO;
    
}


@end
