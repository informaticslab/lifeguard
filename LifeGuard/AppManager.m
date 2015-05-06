//
//  AppManager.m
//  pedigree
//
//  Created by jtq6 on 3/21/13.
//  Copyright (c) 2013 CDC Informatics R&D Lab. All rights reserved.
//

#import "AppManager.h"
#import "AppDelegate.h"
static AppManager *sharedAppManager = nil;

@implementation AppManager


#pragma mark Singleton Methods
+ (id)singletonAppManager {
	@synchronized(self) {
		if(sharedAppManager == nil)
			sharedAppManager = [[self alloc] init];
	}
    
	return sharedAppManager;

}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if(sharedAppManager == nil)  {
			sharedAppManager = [super allocWithZone:zone];
			return sharedAppManager;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}


- (id)init {
    
	if ((self = [super init]))
    {
		self.appName = @"Lifeguard";
        
        DebugLog(@"%@ %@ is loading....", self.appName, [self getAppVersion]);
        DebugLog(@"Device System Name = %@", [self getDeviceSystemName]);
        DebugLog(@"Device System Version = %@", [self getDeviceSystemVersion]);
        DebugLog(@"Device Model = %@", [self getDeviceModel]);
        
        [self processAppSettings];
        self.cdcLocator = [[CdcLocator alloc] init];
        
    }
	return self;

}
-(NSString *)getDeviceModel
{
    UIDevice *device = [UIDevice currentDevice];
    return [device model];
}

-(NSString *)getDeviceSystemVersion
{
    UIDevice *device = [UIDevice currentDevice];
    return [device systemVersion];
}

-(NSString *)getDeviceSystemName
{
    UIDevice *device = [UIDevice currentDevice];
    return [device systemName];
}



-(NSString *)getAppVersion
{
    
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *currVersion = [NSString stringWithFormat:@"%@.%@",
                             [appInfo objectForKey:@"CFBundleShortVersionString"],
                             [appInfo objectForKey:@"CFBundleVersion"]];

    return currVersion;
    
}

-(BOOL)isDebugInfoEnabled
{
    // Get user preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL enabled = [defaults boolForKey:@"enableDebugInfo"];
    return enabled;
    
}

-(void)processAppSettings
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"EnablePowerConservation"] == YES)
        _isPowerConservationModeOn = YES;
    else
        _isPowerConservationModeOn = NO;
    
        
}







@end
