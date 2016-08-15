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
#import "WPSAlertController.h"

@implementation AppDelegate

AppManager *appMgr;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    appMgr = [AppManager singletonAppManager];
    
    // Override point for customization after application launch.
    DebugLog(@"didFinishLaunchingWithOptions");
    
    // Background App Refresh in Settings->General must be enabled for location updates to work in the background
    if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied){
        
        [WPSAlertController presentOkayAlertWithTitle:@"Warning" message:@"CDC Lifeguard is most effective when the Background App Refresh is enabled. To turn it on, go to Settings > General > Background App Refresh."];
        
    } else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted){
        
        [WPSAlertController presentOkayAlertWithTitle:@"Warning" message:@"CDC Lifeguard is limited because the Background App Refresh is disabled."];

    }
    
    return YES;
    
}


-(void)applicationWillEnterForeground:(UIApplication *)application {
    
//    [appMgr.cdcLocator enterForegroundMode];
    DebugLog(@"application entering foreground..");
    
}

-(void)applicationWillResignActive:(UIApplication *)application {
    
    [appMgr.cdcLocator enterBackgroundMode];
    DebugLog(@"application entering background..");
//    [appMgr.cdcLocator enterDeferredUpdateBackgroundMode];
    
}

@end
