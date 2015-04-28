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

//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
//
//    NSLog(@"locationManager didUpdateLocations: %@",locations);
//
//    for(int i=0;i<locations.count;i++){
//
//        CLLocation *newLocation = [locations objectAtIndex:i];
//        CLLocationCoordinate2D theLocation = newLocation.coordinate;
//        CLLocationAccuracy theAccuracy = newLocation.horizontalAccuracy;
//
//        self.currLocation = theLocation;
//        self.currLocationAccuracy = theAccuracy;
//    }
//
//    [self addLocationToPList:self.locator.afterResume];
//}
//
//
//- (void)applicationDidEnterBackground:(UIApplication *)application
//{
//    NSLog(@"applicationDidEnterBackground");
//    [self.locator.locationManager stopMonitoringSignificantLocationChanges];
//
//    if(IS_OS_8_OR_LATER) {
//        [self.locator.locationManager requestAlwaysAuthorization];
//    }
//    [self.locator.locationManager startMonitoringSignificantLocationChanges];
//
//    [self addApplicationStatusToPList:@"applicationDidEnterBackground"];
//}
//
//
//
//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//    NSLog(@"applicationDidBecomeActive");
//
//    [self addApplicationStatusToPList:@"applicationDidBecomeActive"];
//
//    // Remove the "afterResume" Flag after the app is active again.
//    self.locator.afterResume = NO;
//
//    if(self.locator.locationManager)
//        [self.locator.locationManager stopMonitoringSignificantLocationChanges];
//
//    self.locator.locationManager = [[CLLocationManager alloc]init];
//    self.locator.locationManager.delegate = self;
//    self.locator.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
//    self.locator.locationManager.activityType = CLActivityTypeOtherNavigation;
//
//    if(IS_OS_8_OR_LATER) {
//        [self.locator.locationManager requestAlwaysAuthorization];
//    }
//    [self.locator.locationManager startMonitoringSignificantLocationChanges];
//}
//
//
//-(void)applicationWillTerminate:(UIApplication *)application{
//    NSLog(@"applicationWillTerminate");
//    [self addApplicationStatusToPList:@"applicationWillTerminate"];
//}
//
//
/////////////////////////////////////////////////////////////////
//// Below are 3 functions that add location and Application status to PList
//// The purpose is to collect location information locally
//
//-(void)addResumeLocationToPList{
//
//    NSLog(@"addResumeLocationToPList");
//    UIApplication* application = [UIApplication sharedApplication];
//
//    NSString * appState;
//    if([application applicationState]==UIApplicationStateActive)
//        appState = @"UIApplicationStateActive";
//    if([application applicationState]==UIApplicationStateBackground)
//        appState = @"UIApplicationStateBackground";
//    if([application applicationState]==UIApplicationStateInactive)
//        appState = @"UIApplicationStateInactive";
//
//    self.locator.locationDictInPlist = [[NSMutableDictionary alloc]init];
//    [self.locator.locationDictInPlist setObject:@"UIApplicationLaunchOptionsLocationKey" forKey:@"Resume"];
//    [self.locator.locationDictInPlist setObject:appState forKey:@"AppState"];
//    [self.locator.locationDictInPlist setObject:[NSDate date] forKey:@"Time"];
//
//    NSString *plistName = [NSString stringWithFormat:@"LocationArray.plist"];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docDir = [paths objectAtIndex:0];
//    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", docDir, plistName];
//
//    NSMutableDictionary *savedProfile = [[NSMutableDictionary alloc] initWithContentsOfFile:fullPath];
//
//    if (!savedProfile){
//        savedProfile = [[NSMutableDictionary alloc] init];
//        self.locator.locationArrayInPlist = [[NSMutableArray alloc]init];
//    }
//    else{
//        self.locator.locationArrayInPlist = [savedProfile objectForKey:@"LocationArray"];
//    }
//
//    if(self.locator.locationDictInPlist)
//    {
//        [self.locator.locationArrayInPlist addObject:self.locator.locationDictInPlist];
//        [savedProfile setObject:self.locator.locationArrayInPlist forKey:@"LocationArray"];
//    }
//
//    if (![savedProfile writeToFile:fullPath atomically:FALSE] ) {
//        NSLog(@"Couldn't save LocationArray.plist" );
//    }
//}
//
//
//
//-(void)addLocationToPList:(BOOL)fromResume{
//    NSLog(@"addLocationToPList");
//
//    UIApplication* application = [UIApplication sharedApplication];
//
//    NSString * appState;
//    if([application applicationState]==UIApplicationStateActive)
//        appState = @"UIApplicationStateActive";
//    if([application applicationState]==UIApplicationStateBackground)
//        appState = @"UIApplicationStateBackground";
//    if([application applicationState]==UIApplicationStateInactive)
//        appState = @"UIApplicationStateInactive";
//
//    self.locator.locationDictInPlist = [[NSMutableDictionary alloc]init];
//    [self.locator.locationDictInPlist setObject:[NSNumber numberWithDouble:self.currLocation.latitude]  forKey:@"Latitude"];
//    [self.locator.locationDictInPlist setObject:[NSNumber numberWithDouble:self.currLocation.longitude] forKey:@"Longitude"];
//    [self.locator.locationDictInPlist setObject:[NSNumber numberWithDouble:self.currLocationAccuracy] forKey:@"Accuracy"];
//
//    [self.locator.locationDictInPlist setObject:appState forKey:@"AppState"];
//
//    if(fromResume)
//        [self.locator.locationDictInPlist setObject:@"YES" forKey:@"AddFromResume"];
//    else
//        [self.locator.locationDictInPlist setObject:@"NO" forKey:@"AddFromResume"];
//
//    [self.locator.locationDictInPlist setObject:[NSDate date] forKey:@"Time"];
//
//    NSString *plistName = [NSString stringWithFormat:@"LocationArray.plist"];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docDir = [paths objectAtIndex:0];
//    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", docDir, plistName];
//
//    NSMutableDictionary *savedProfile = [[NSMutableDictionary alloc] initWithContentsOfFile:fullPath];
//
//    if (!savedProfile){
//        savedProfile = [[NSMutableDictionary alloc] init];
//        self.locator.locationArrayInPlist = [[NSMutableArray alloc]init];
//    }
//    else{
//        self.locator.locationArrayInPlist = [savedProfile objectForKey:@"LocationArray"];
//    }
//
//    NSLog(@"Dict: %@",self.locator.locationDictInPlist);
//
//    if(self.locator.locationDictInPlist)
//    {
//        [self.locator.locationArrayInPlist addObject:self.locator.locationDictInPlist];
//        [savedProfile setObject:self.locator.locationArrayInPlist forKey:@"LocationArray"];
//    }
//
//    if (![savedProfile writeToFile:fullPath atomically:FALSE] ) {
//        NSLog(@"Couldn't save LocationArray.plist" );
//    }
//}
//
//
//
//-(void)addApplicationStatusToPList:(NSString*)applicationStatus{
//
//    NSLog(@"addApplicationStatusToPList");
//    UIApplication* application = [UIApplication sharedApplication];
//
//    NSString * appState;
//    if([application applicationState]==UIApplicationStateActive)
//        appState = @"UIApplicationStateActive";
//    if([application applicationState]==UIApplicationStateBackground)
//        appState = @"UIApplicationStateBackground";
//    if([application applicationState]==UIApplicationStateInactive)
//        appState = @"UIApplicationStateInactive";
//
//    self.locator.locationDictInPlist = [[NSMutableDictionary alloc]init];
//    [self.locator.locationDictInPlist setObject:applicationStatus forKey:@"applicationStatus"];
//    [self.locator.locationDictInPlist setObject:appState forKey:@"AppState"];
//    [self.locator.locationDictInPlist setObject:[NSDate date] forKey:@"Time"];
//
//    NSString *plistName = [NSString stringWithFormat:@"LocationArray.plist"];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docDir = [paths objectAtIndex:0];
//    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", docDir, plistName];
//
//    NSMutableDictionary *savedProfile = [[NSMutableDictionary alloc] initWithContentsOfFile:fullPath];
//
//    if (!savedProfile){
//        savedProfile = [[NSMutableDictionary alloc] init];
//        self.locator.locationArrayInPlist = [[NSMutableArray alloc]init];
//    }
//    else{
//        self.locator.locationArrayInPlist = [savedProfile objectForKey:@"LocationArray"];
//    }
//
//    if(self.locator.locationDictInPlist)
//    {
//        [self.locator.locationArrayInPlist addObject:self.locator.locationDictInPlist];
//        [savedProfile setObject:self.locator.locationArrayInPlist forKey:@"LocationArray"];
//    }
//
//    if (![savedProfile writeToFile:fullPath atomically:FALSE] ) {
//        NSLog(@"Couldn't save LocationArray.plist" );
//    }
//}





//
// methods below are used for background location tracking scheme 2
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
        [self.locationManager allowDeferredLocationUpdatesUntilTraveled:CLLocationDistanceMax timeout:60];
    }
}

- (void) locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error {
    
        NSLog(@"CDC Lifeguard didFinishDeferredUpdatesWithError was called with NSError: %@",[error localizedDescription] );
}




@end
