//
//  AppManager.h
//  pedigree
//
//  Created by jtq6 on 3/21/13.
//  Copyright (c) 2013 CDC Informatics R&D Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Debug.h"
#import "Reachability.h"
#import "CdcLocator.h"

@interface AppManager : NSObject 

@property (nonatomic, strong) NSString *appName;

@property (strong, nonatomic) Reachability *hostReachability;
@property BOOL isPowerConservationModeOn;
@property (nonatomic, strong) CdcLocator *cdcLocator;

+ (id)singletonAppManager;
-(BOOL)isDebugInfoEnabled;


-(NSString *)getDeviceModel;
-(NSString *)getDeviceSystemVersion;
-(NSString *)getDeviceSystemName;
-(NSString *)getAppVersion;

@end
