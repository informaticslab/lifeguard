//
//  LocatorViewController.h
//  Lifeguard
//
//  Created by jtq6 on 4/3/15.
//  Copyright (c) 2015 CDC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationUpdateTimer.h"

@interface LocatorViewController : UIViewController

@property (strong, nonatomic) LocationUpdateTimer *locUpdateTimer;

- (IBAction)btnShowDeviceIdTouchUp:(id)sender;
- (IBAction)btnEmailDeviceIdTouchUp:(id)sender;
- (IBAction)btnCallEocTouchUp:(id)sender;
- (IBAction)btnSendLocationNowTouchUp:(id)sender;
- (IBAction)btnAboutUsTouchUp:(id)sender;

@end
