//
//  LifeguardService.h
//  Lifeguard
//
//  Created by jtq6 on 4/8/15.
//  Copyright (c) 2015 CDC. All rights reserved.
//

#ifndef Lifeguard_LifeguardService_h
#define Lifeguard_LifeguardService_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LifeguardService : NSObject

@property(nonatomic, strong) NSString *statusString;
@property(nonatomic, strong) NSDateFormatter *dateFormat;
-(void)sendLocation:(CLLocation *)location;

@end
#endif
