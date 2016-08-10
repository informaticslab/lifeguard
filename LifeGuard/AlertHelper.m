//
//  AlertHelper.m
//  Lifeguard
//
//  Created by Greg Ledbetter on 8/10/16.
//  Copyright © 2016 CDC. All rights reserved.
//

#import "AlertHelper.h"


@implementation AlertHelper : NSObject 

+(void)show:(UIAlertController *)alertController {
    
    UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    topWindow.rootViewController = [UIViewController new];
    topWindow.windowLevel = UIWindowLevelAlert + 1;
    
    
}

@end

