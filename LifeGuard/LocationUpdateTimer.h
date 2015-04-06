//
//  LocationUpdateTimer.h
//  Lifeguard
//
//  Created by jtq6 on 4/3/15.
//  Copyright (c) 2015 CDC. All rights reserved.
//

#ifndef Lifeguard_LocationUpdateTimer_h
#define Lifeguard_LocationUpdateTimer_h

#import <Foundation/Foundation.h>
#import "CdcLocator.h"

@interface LocationUpdateTimer  : NSObject <CLLocationManagerDelegate>
{
    NSTimer *timer;
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D currLocation;
@property (nonatomic) CLLocationAccuracy currLocationAccuracy;

- (void)timerFired:(NSTimer *)timer;
- (void)startTimer;
- (void)stopTimer;

@end


#endif
