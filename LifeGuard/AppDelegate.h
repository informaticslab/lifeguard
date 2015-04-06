//
//  AppDelegate.h
//  LifeGuard
//
//  Created by jtq6 on 4/2/15.
//  Copyright (c) 2015 CDC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CdcLocator.h"
#import "LocationUpdateTimer.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CdcLocator *locator;

@property (nonatomic) CLLocationCoordinate2D lastLocation;
@property (nonatomic) CLLocationAccuracy lastLocationAccuracy;

@property (nonatomic) CLLocationCoordinate2D currLocation;
@property (nonatomic) CLLocationAccuracy currLocationAccuracy;

@end

