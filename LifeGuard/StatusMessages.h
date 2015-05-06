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
#define STATUS_MESSAGE_NETWORK_REACHABILITY 0
#define STATUS_MESSAGE_GPS_TIMESTAMP 1
#define STATUS_MESSAGE_LOCATION_SENT_TIMESTAMP 2
#define STATUS_MESSAGE_SIZE 3

@property(nonatomic, strong) NSMutableArray *messages;
@property NSUInteger currMessageIndex;
@property(nonatomic, strong) NSString *networkReachability;
@property(nonatomic, strong) NSString *gpsTimestamp;
@property(nonatomic, strong) NSString *locationSentTimestamp;

-(void)setMessage:(NSString *)message forType:(int)type;
-(NSString *)getNextMessage;

@end
