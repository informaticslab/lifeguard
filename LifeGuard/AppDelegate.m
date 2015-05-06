//
//  AppDelegate.m
//  LifeGuard
//
//  Created by jtq6 on 4/2/15.
//  Copyright (c) 2015 CDC. All rights reserved.
//

#import "AppDelegate.h"
#import "LifeguardService.h"
#import "AppManager.h"

@implementation AppDelegate

AppManager *appMgr;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    appMgr = [AppManager singletonAppManager];
    
    // Override point for customization after application launch.
    DebugLog(@"didFinishLaunchingWithOptions");
    
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


- (void)applicationWillResignActive:(UIApplication *)application {
    
    
    [appMgr.cdcLocator appInactive];

}





@end
