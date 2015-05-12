//
//  LocationShare.h
//  LifeGuard
//
//  Created by jtq6 on 4/2/15.
//  Copyright (c) 2015 CDC. All rights reserved.
//

#ifndef LifeGuard_LocationShare_h
#define LifeGuard_LocationShare_h

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LifeguardService.h"

@interface CdcLocator : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property BOOL inBackgroundMode;
@property BOOL areDeferringUpdates;
@property NSUInteger updateLocationCount;
@property CLLocation *userLocation;
@property LifeguardService *lifeguardService;
@property (nonatomic, weak) NSDate *locationTimestamp;

-(void)enterForegroundMode;
-(void)enterBackgroundMode;
-(void)enterDeferredUpdateBackgroundMode;


@end

#endif
