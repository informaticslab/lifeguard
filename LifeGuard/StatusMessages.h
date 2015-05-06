//
//  StatusStrings.h
//  Lifeguard
//
//  Created by jtq6 on 5/6/15.
//  Copyright (c) 2015 CDC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusMessages : NSObject

// status message types
#define NETWORK_REACHABILITY 0
#define GPS_TIMESTAMP 1
#define LOCATION_SENT_TIMESTAMP 2

@property(nonatomic, strong) NSMutableArray *messages;
@property NSUInteger currMessageIndex;
@property(nonatomic, strong) NSString *networkReachability;
@property(nonatomic, strong) NSString *gpsTimestamp;
@property(nonatomic, strong) NSString *locationSentTimestamp;

-(void)setMessage:(NSString *)message forType:(int)type;

@end
