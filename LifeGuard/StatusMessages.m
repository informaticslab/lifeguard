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
        for (int i= 0; i < STATUS_MESSAGE_SIZE; i++) {
            _messages[i] = @"";
        }
        _currMessageIndex = 0;
    }
    return self;
}

-(void)addMessage:(NSString *)newMessage
{
    [_messages addObject:newMessage];
    
}

// used by the view controller to get the next message
-(NSString *)getNextMessage
{
    NSString *next = @"";
    NSUInteger initialIndex = _currMessageIndex;
    
    if ([_messages count] == 0) {
        return next;
    }
    
    // get next message which is not empty string, check for return to initial index
    do {
        if (_currMessageIndex < [_messages count] -1)
            _currMessageIndex++;
        else
            _currMessageIndex = 0;
        next = _messages[_currMessageIndex];
    } while ([next isEqualToString:@""] && _currMessageIndex != initialIndex);
    
    
    return [_messages objectAtIndex:_currMessageIndex];
    
    
}

// only one message allowed per type
-(void)setMessage:(NSString *)message forType:(int)type
{
    
    switch (type) {
        case STATUS_MESSAGE_GPS_TIMESTAMP:
            _gpsTimestamp = message;
            [_messages replaceObjectAtIndex:STATUS_MESSAGE_GPS_TIMESTAMP withObject:message];
            break;
        case STATUS_MESSAGE_LOCATION_SENT_TIMESTAMP:
            _locationSentTimestamp = message;
            [_messages replaceObjectAtIndex:STATUS_MESSAGE_LOCATION_SENT_TIMESTAMP withObject:message];
            break;
        case STATUS_MESSAGE_HOST_REACHABILITY:
            _locationSentTimestamp = message;
            [_messages replaceObjectAtIndex:STATUS_MESSAGE_HOST_REACHABILITY withObject:message];
            break;
        case STATUS_MESSAGE_LOCATION_SHARE_AUTHORIZATION:
            _locationShareAuthorization = message;
            [_messages replaceObjectAtIndex:STATUS_MESSAGE_LOCATION_SHARE_AUTHORIZATION withObject:message];
            break;
        case STATUS_MESSAGE_REGISTRATION_USER_NAME:
            _registrationUserName = message;
            [_messages replaceObjectAtIndex:STATUS_MESSAGE_REGISTRATION_USER_NAME withObject:message];
            break;
        case STATUS_MESSAGE_REGISTRATION_VENDOR_ID:
            _registrationVendorId = message;
            [_messages replaceObjectAtIndex:STATUS_MESSAGE_REGISTRATION_VENDOR_ID withObject:message];
            break;
//        case STATUS_MESSAGE_INTERNET_REACHABILITY:
//            _locationSentTimestamp = message;
//            [_messages replaceObjectAtIndex:STATUS_MESSAGE_INTERNET_REACHABILITY withObject:message];
//            break;
//        case STATUS_MESSAGE_WIFI_REACHABILITY:
//            _locationSentTimestamp = message;
//            [_messages replaceObjectAtIndex:STATUS_MESSAGE_WIFI_REACHABILITY withObject:message];
//            break;
        default:
            DebugLog(@"undefined message type");
            break;
    }
    
}



@end
