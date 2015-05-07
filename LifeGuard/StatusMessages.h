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
#define STATUS_MESSAGE_HOST_REACHABILITY 0
#define STATUS_MESSAGE_INTERNET_REACHABILITY 1
#define STATUS_MESSAGE_WIFI_REACHABILITY 2
#define STATUS_MESSAGE_GPS_TIMESTAMP 3
#define STATUS_MESSAGE_LOCATION_SENT_TIMESTAMP 4
#define STATUS_MESSAGE_SIZE 5

@property(nonatomic, strong) NSMutableArray *messages;
@property NSUInteger currMessageIndex;
@property(nonatomic, strong) NSString *networkReachability;
@property(nonatomic, strong) NSString *gpsTimestamp;
@property(nonatomic, strong) NSString *locationSentTimestamp;

-(void)setMessage:(NSString *)message forType:(int)type;
-(NSString *)getNextMessage;

@end
