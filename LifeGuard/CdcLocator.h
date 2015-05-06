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


@interface CdcLocator : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property BOOL isBackgroundMode;
@property BOOL deferringUpdates;
@property CLLocation *userLocation;
@property (nonatomic, weak) NSDate *locationTimestamp;

-(void)appInactive;


@end

#endif
