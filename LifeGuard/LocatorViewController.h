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

@property (weak, nonatomic) IBOutlet UIButton *btnPrivacyInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnShowDeviceId;
@property (weak, nonatomic) IBOutlet UIButton *btnEmailDeviceId;
@property (weak, nonatomic) IBOutlet UIButton *btnCallEoc;
@property (weak, nonatomic) IBOutlet UIButton *btnSendLocationNow;
@property (weak, nonatomic) IBOutlet UIButton *btnAboutUs;
@property (weak, nonatomic) IBOutlet UIButton *btnHelp;

@property (weak, nonatomic) IBOutlet UILabel *feedbackMsg;


@end
