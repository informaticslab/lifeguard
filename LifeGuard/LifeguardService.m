//
//  LifeguardService.m
//  Lifeguard
//
//  Created by jtq6 on 4/8/15.
//  Copyright (c) 2015 CDC. All rights reserved.
//

#include "LifeguardService.h"
#include "AppManager.h"

@implementation LifeguardService

AppManager *appMgr;


-(id)init {
    
    self = [super init];
    self.dateFormat = [[NSDateFormatter alloc] init];
    self.dateFormat.dateStyle = NSDateFormatterShortStyle;
    self.dateFormat.timeStyle = NSDateFormatterShortStyle;

    return self;
}


-(NSString *)getServerUrl
{
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"useTestServer"])
        return @"https://desolate-river-2879.herokuapp.com";
    else
        return @"https://eocexternal.cdc.gov/Lifeguard";
    
}


-(NSString *)getLocationServiceUrl
{
    
    NSString *serverUrl = [self getServerUrl];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"useTestServer"])
        return [NSString stringWithFormat:@"%@/location", serverUrl];
        
    else
        return [NSString stringWithFormat:@"%@/lgService.aspx", serverUrl];
    
}


-(NSString *)getRegistrationServiceUrl
{
    
    NSString *serverUrl = [self getServerUrl];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"useTestServer"])
        return [NSString stringWithFormat:@"%@/register", serverUrl];
    
    else
        return [NSString stringWithFormat:@"%@/lgregister.aspx", serverUrl];
    
}


-(NSString *)getStringTimestampFromLocation:(CLLocation *)location
{

    NSString *timestamp = [self.dateFormat stringFromDate:location.timestamp];
    NSString *status = [NSString stringWithFormat:@"Location from GPS at %@", timestamp];
    [appMgr.statusMsgs setMessage:status forType:STATUS_MESSAGE_GPS_TIMESTAMP];
    
    return timestamp;
    
}


-(NSString *)getLocationServiceUrlParams:(CLLocation *)location
{

    CLLocationDegrees latitude = location.coordinate.latitude;
    CLLocationDegrees longitude = location.coordinate.longitude;
    
    // create session with Lifeguard URL and session defaults
    NSDate *now = [[NSDate alloc] init];
    NSString *vendorId = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    NSString *urlWithParams = [NSString stringWithFormat:@"%@?p=%@&t=%.0f&lat=%f&long=%f",
                         [self getLocationServiceUrl], vendorId, floor([now timeIntervalSince1970]),
                         latitude, longitude];
    
    return urlWithParams;
    
}


-(NSString *)getRegistrationServiceUrlParams:(NSString *)uid location:(CLLocation *)location
{
    
    CLLocationDegrees latitude = location.coordinate.latitude;
    CLLocationDegrees longitude = location.coordinate.longitude;
    
    // create session with Lifeguard URL and session defaults
    NSDate *now = [[NSDate alloc] init];
    NSString *vendorId = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    NSString *urlWithParams = [NSString stringWithFormat:@"%@?uid=%@&p=%@&t=%.0f&lat=%f&long=%f",
                               [self getRegistrationServiceUrl], uid, vendorId, floor([now timeIntervalSince1970]),
                               latitude, longitude];
    
    return urlWithParams;
    
}


-(BOOL)locationIsValid:(CLLocation *)location
{
    CLLocationDegrees latitude = location.coordinate.latitude;
    CLLocationDegrees longitude = location.coordinate.longitude;
    
    // check for valid location, don't report 0.0/0.0
    if (latitude == 0 && longitude == 0) {
        [self showWaitForLocationStatus];
        return NO;
        
    }

    return YES;
    
}

-(void)sendUrl:(NSString *)urlWithParams
{
    NSURL *url = [NSURL URLWithString:urlWithParams];
    NSURLSession *session = [NSURLSession sharedSession];
    
    DebugLog(@"Sending HTTP GET %@", urlWithParams);

    
    // set request to be a GET
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        // handle basic connectivity issues here
        if (error) {
            DebugLog(@"dataTaskWithRequest error: %@", error);
            self.statusString = error.userInfo[@"NSLocalizedDescription"];
            
        }
        
        // handle HTTP errors here
        else if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            
            if (statusCode != 200) {
                DebugLog(@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode);
                self.statusString = [NSString stringWithFormat:@"HTTP error code %ld occurred.", (long)statusCode];
            } else {
                [self updateSuccess];
            }
        }
        
        else {
            [self updateSuccess];
            
            // otherwise, everything is probably fine and you should interpret the `data` contents
            DebugLog(@"data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            
        }
        
        return;
        
    }];
    
    [task resume];
    
}


-(void)sendLocation:(CLLocation *)location
{
    // if location is not valid do not send
    if ([self locationIsValid:location] == NO)
        return;
    
    NSString *urlWithParams = [self getLocationServiceUrlParams:location];
    [self sendUrl:urlWithParams];
    
}


-(void)sendRegistration:(NSString *)uid location:(CLLocation *)location
{
    
    NSString *urlWithParams = [self getRegistrationServiceUrlParams:uid location:location];
    [self sendUrl:urlWithParams];
    
}


-(void)updateSuccess
{
    
    NSDate *now = [[NSDate alloc] init];
    NSString *dateString = [self.dateFormat stringFromDate:now];
    NSString *status = [NSString stringWithFormat:@"Location sent at %@", dateString];
    
    [appMgr.statusMsgs setMessage:status forType:STATUS_MESSAGE_LOCATION_SENT_TIMESTAMP];
    DebugLog(@"update success: %@", status);

    self.statusString = status;

}


-(void)showWaitForLocationStatus
{
    NSString *status = [NSString stringWithFormat:@"Waiting for valid location..."];
    
    DebugLog(@"done waiting for location: %@", status);
    self.statusString = status;
    [appMgr.statusMsgs setMessage:status forType:STATUS_MESSAGE_LOCATION_SENT_TIMESTAMP];
}


@end


