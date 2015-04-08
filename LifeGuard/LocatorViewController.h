//
//  LocatorViewController.h
//  Lifeguard
//
//  Created by jtq6 on 4/3/15.
//  Copyright (c) 2015 CDC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationUpdateTimer.h"
#import <MessageUI/MessageUI.h>


@interface LocatorViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) LocationUpdateTimer *locUpdateTimer;

- (IBAction)btnShowDeviceIdTouchUp:(id)sender;
- (IBAction)btnEmailDeviceIdTouchUp:(id)sender;
- (IBAction)btnCallEocTouchUp:(id)sender;
- (IBAction)btnSendLocationNowTouchUp:(id)sender;
- (IBAction)btnAboutUsTouchUp:(id)sender;
- (IBAction)btnPrivacyInfoTouchUp:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *feedbackMsg;

@end
