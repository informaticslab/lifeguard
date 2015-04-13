//
//  LocatorViewController.m
//  Lifeguard
//
//  Created by jtq6 on 4/3/15.
//  Copyright (c) 2015 CDC. All rights reserved.
//

#import "LocatorViewController.h"
@interface LocatorViewController ()

@end

@implementation LocatorViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.locUpdateTimer = [[LocationUpdateTimer alloc] init];
    self.feedbackMsg.text = @"";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

    
    if ([MFMailComposeViewController canSendMail])
        // The device can send email.
    {
        [self displayMailComposerSheet];
    }

    
}

- (void)displayMailComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"Lifeguard iOS Device ID"];
    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@"gsledbetter@gmail.com"];
    
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

    
    NSString *phoneNUmber = @"+17706825071";
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phoneNUmber]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }
    
}

- (IBAction)btnSendLocationNowTouchUp:(id)sender {
    
    [self.locUpdateTimer sendLocation];
    
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
