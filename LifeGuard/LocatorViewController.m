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
    
}

- (IBAction)btnCallEocTouchUp:(id)sender {
    
}

- (IBAction)btnSendLocationNowTouchUp:(id)sender {
    
}

- (IBAction)btnAboutUsTouchUp:(id)sender {

    NSString *aboutUs = [NSString stringWithFormat:@"Lifeguard for iOS %@", [self versionBuild]];

    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"About Us"
                                          message:aboutUs
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
