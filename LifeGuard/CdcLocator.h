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

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface CdcLocator : NSObject 

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) NSMutableDictionary *locationDictInPlist;
@property (nonatomic) NSMutableArray *locationArrayInPlist;
@property (nonatomic) BOOL afterResume;

+(id)singleton;

@end

#endif
