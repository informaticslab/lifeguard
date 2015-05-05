//
//  AppManager.h
//  pedigree
//
//  Created by jtq6 on 3/21/13.
//  Copyright (c) 2013 CDC Informatics R&D Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Debug.h"
#import "IssuesManager.h"
#import "JsonParser.h"
#import "SplitViewManager.h"
#include "Reachability.h"
#include "SiteCatalystController.h"

@interface AppManager : NSObject 

@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) UIFont *tableFont;
@property (nonatomic, strong) UIFont *textFont;
@property BOOL agreedWithEula;

// Core Data properties
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) IssuesManager *issuesMgr;
@property (strong, nonatomic) JsonParser *jsonParser;
@property (strong, nonatomic) SplitViewManager *splitVM;
@property (weak, nonatomic) UISplitViewController *splitVC;
@property (strong, nonatomic) Reachability *hostReachability;
@property (strong, nonatomic) SiteCatalystController *usageTracker;

+ (id)singletonAppManager;
-(BOOL)isDebugInfoEnabled;
-(BOOL)isDeviceIpad;
- (void)saveContext;

-(NSString *)getDeviceModel;
-(NSString *)getDeviceSystemVersion;
-(NSString *)getDeviceSystemName;
-(NSString *)getAppVersion;

@end
