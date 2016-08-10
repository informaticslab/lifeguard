//
//  LocatorViewController.m
//  Lifeguard
//
//  Created by jtq6 on 4/3/15.
//  Copyright (c) 2015 CDC. All rights reserved.
//

#import "LocatorViewController.h"
#import "AppManager.h"
#import "Reachability.h"
#import "WPSAlertController.h"

@interface LocatorViewController ()

@property (strong, nonatomic) NSTimer *uiUpdateTimer;

@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;

@end

@implementation LocatorViewController

AppManager *appMgr;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.locUpdateTimer = [[LocationUpdateTimer alloc] init];

    self.feedbackMsg.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.7];
    self.feedbackMsg.text = @"";
    
    UIColor *btnBackground = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.6];
    self.btnPrivacyInfo.backgroundColor = btnBackground;
    self.btnShowDeviceId.backgroundColor = btnBackground;
    self.btnEmailDeviceId.backgroundColor = btnBackground;
    self.btnCallEoc.backgroundColor = btnBackground;
    self.btnSendLocationNow.backgroundColor = btnBackground;
    self.btnAboutUs.backgroundColor = btnBackground;
    self.btnHelp.backgroundColor = btnBackground;

    self.uiUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:3
                                                 target:self
                                               selector:@selector(uiUpdateTimerFired:)
                                               userInfo:nil
                                                repeats:YES];
    [self sendLocation];
    
    
    // Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    NSString *remoteHostName = @"eocexternal.cdc.gov";
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    [self updateInterfaceWithReachability:self.hostReachability];
    
}

/*
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{

    Reachability *currReach = [note object];
    NSParameterAssert([currReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:currReach];

}


- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    if (reachability == self.hostReachability)
    {
        [self configureReachabilityStatusMessage:STATUS_MESSAGE_HOST_REACHABILITY reachability:reachability];
        BOOL connectionRequired = [reachability connectionRequired];
        
        NSString *baseLabelText = @"";
        
        if (connectionRequired)
        {
            baseLabelText = NSLocalizedString(@"Cellular data network is available.\nInternet traffic will be routed through it after a connection is established.", @"Reachability text if a connection is required");
        }
        else
        {
            baseLabelText = NSLocalizedString(@"Cellular data network is active.\nInternet traffic will be routed through it.", @"Reachability text if a connection is not required");
        }
        //self.summaryLabel.text = baseLabelText;
    }
    
    if (reachability == self.internetReachability)
    {
        [self configureReachabilityStatusMessage:STATUS_MESSAGE_INTERNET_REACHABILITY reachability:reachability];
    }
    
    if (reachability == self.wifiReachability)
    {
        [self configureReachabilityStatusMessage:STATUS_MESSAGE_WIFI_REACHABILITY reachability:reachability];
    }

    
}

- (void)configureReachabilityStatusMessage:(int)type reachability:(Reachability *)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    BOOL connectionRequired = [reachability connectionRequired];
    NSString* statusString = @"";
    
    switch (netStatus)
    {
        case NotReachable:        {
            statusString = NSLocalizedString(@"Lifeguard Server Not Reachable", @"");
            connectionRequired = NO;
            break;
        }
            
        case ReachableViaWWAN:        {
            statusString = NSLocalizedString(@"Lifeguard Server Reachable via WWAN", @"");
            break;
        }
        case ReachableViaWiFi:        {
            statusString = NSLocalizedString(@"Lifeguard Server Reachable via WiFi", @"");
            break;
        }
    }
    
    if (connectionRequired)
    {
        NSString *connectionRequiredFormatString = NSLocalizedString(@"%@, Connection Required", @"Concatenation of status string with connection requirement");
        statusString= [NSString stringWithFormat:connectionRequiredFormatString, statusString];
    }
    [appMgr.statusMsgs setMessage:statusString forType:type] ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnShowDeviceIdTouchUp:(id)sender {

    self.feedbackMsg.text = @"";

    
    NSString *vendorId = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Device ID"
                                          message:vendorId
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [alertController dismissViewControllerAnimated:YES completion:nil];
                               }];
    
    [alertController addAction:okAction];

    [self presentViewController:alertController animated:YES completion:nil];

}


- (IBAction)btnEmailDeviceIdTouchUp:(id)sender {
    self.feedbackMsg.text = @"";

    // can the device can send email?
    if ([MFMailComposeViewController canSendMail] == YES)
    {
        [self displayMailComposerSheet];
    } else {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Device Can't Send Email"
                                              message:@"This device can not send email or an email account has not been configured."
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [alertController dismissViewControllerAnimated:YES completion:nil];
                                   }];
        
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        

    }

    
}

- (void)displayMailComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"Lifeguard iOS Device ID"];
    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@"deodeployequip@cdc.gov"];
    
    [picker setToRecipients:toRecipients];
    NSString *bodyPreamble = @"Listed below is the device ID that will be used by the Lifeguard for iOS app for the originator of this email:";
    NSString *vendorId = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    
    // Fill out the email body text
    NSString *emailBody = [NSString stringWithFormat:@"%@ \n\n %@", bodyPreamble, vendorId];
    [picker setMessageBody:emailBody isHTML:NO];
    
    [self presentViewController:picker animated:YES completion:NULL];

    
}


-(void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    self.feedbackMsg.hidden = NO;
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            self.feedbackMsg.text = @"Result: Mail sending canceled";
            break;
        case MFMailComposeResultSaved:
            self.feedbackMsg.text = @"Result: Mail saved";
            break;
        case MFMailComposeResultSent:
            self.feedbackMsg.text = @"Result: Mail sent";
            break;
        case MFMailComposeResultFailed:
            self.feedbackMsg.text = @"Result: Mail sending failed";
            break;
        default:
            self.feedbackMsg.text = @"Result: Mail not sent";
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)btnCallEocTouchUp:(id)sender {
    self.feedbackMsg.text = @"";

    
    NSString *phoneNumber = @"+14045537870";
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phoneNumber]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        [WPSAlertController presentOkayAlertWithTitle:@"Device Can't Complete Call" message:@"This device's call facility is not available."];

    }
    
}

-(void)updateAppAuthorizationStatus
{
    NSString *status = @"";
    
    // set status string based on app location sharing authorization
    if ([appMgr.cdcLocator isAppAuthorizedWithoutAlerts] == NO)
        status = @"Lifeguard is not authorized to share location.";
    
    [appMgr.statusMsgs setMessage:status forType:STATUS_MESSAGE_LOCATION_SHARE_AUTHORIZATION];
    
}

- (void)uiUpdateTimerFired:(NSTimer *)timer {

    // self.feedbackMsg.text = self.locUpdateTimer.lifeguardService.statusString;
    [self updateAppAuthorizationStatus];
    self.feedbackMsg.text = [appMgr.statusMsgs getNextMessage];
    //DebugLog(@"UI Update Timer Fired");

    
}

-(void)sendLocation
{
    self.feedbackMsg.text = @"Sending location....";
    [self.locUpdateTimer sendLocation];

}

- (IBAction)btnSendLocationNowTouchUp:(id)sender {

    if ([appMgr.cdcLocator isAppAuthorizedWithAlerts]) {
        [self sendLocation];
    }
    
}

- (IBAction)btnAboutUsTouchUp:(id)sender {
    

}

- (IBAction)btnPrivacyInfoTouchUp:(id)sender {
}

- (NSString *) appVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}

- (NSString *) build
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
}

- (NSString *) versionBuild
{
    NSString * version = [self appVersion];
    NSString * build = [self build];
    
    NSString * versionBuild = [NSString stringWithFormat: @"%@", version];
    
    if (![version isEqualToString: build]) {
        versionBuild = [NSString stringWithFormat: @"Version %@ Build (%@)", versionBuild, build];
    }
    
    return versionBuild;
}


@end
