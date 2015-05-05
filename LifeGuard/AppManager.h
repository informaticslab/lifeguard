//
//  AppManager.h
//  pedigree
//
//  Created by jtq6 on 3/21/13.
//  Copyright (c) 2013 CDC Informatics R&D Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Debug.h"
#include "Reachability.h"

@interface AppManager : NSObject 

@property (nonatomic, strong) NSString *appName;

@property (strong, nonatomic) Reachability *hostReachability;
@property BOOL isPowerConservationModeOn;

+ (id)singletonAppManager;
-(BOOL)isDebugInfoEnabled;


-(NSString *)getDeviceModel;
-(NSString *)getDeviceSystemVersion;
-(NSString *)getDeviceSystemName;
-(NSString *)getAppVersion;

@end
