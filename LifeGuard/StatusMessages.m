//
//  StatusStrings.m
//  Lifeguard
//
//  Created by jtq6 on 5/6/15.
//  Copyright (c) 2015 CDC. All rights reserved.
//

#import "StatusMessages.h"
#import "Debug.h"

@implementation StatusMessages


- (instancetype)init
{
    self = [super init];
    if (self) {
        _messages = [[NSMutableArray alloc] init];
        _currMessageIndex = 0;
    }
    return self;
}

-(void)addMessage:(NSString *)newMessage
{
    [_messages addObject:newMessage];
    
}


-(NSString *)getNextMessage
{
    NSString *next = @"";
    
    // get next message
    do {
        if (_currMessageIndex > [_messages count])
            _currMessageIndex++;
        else
            _currMessageIndex = 0;
    } while ([next isEqualToString:@""]);
    
    return [_messages objectAtIndex:_currMessageIndex];
    
}

-(void)setMessage:(NSString *)message forType:(int)type
{

    switch (type) {
        case NETWORK_REACHABILITY:
            _networkReachability = message;
            break;
        case GPS_TIMESTAMP:
            _gpsTimestamp = message;
            break;
        case LOCATION_SENT_TIMESTAMP:
            _locationSentTimestamp = message;
            break;
        default:
            DebugLog(@"undefined message type");
            break;
    }
    
}



@end
