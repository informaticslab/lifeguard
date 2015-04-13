//
//  HelpViewController.m
//  Lifeguard
//
//  Created by jtq6 on 4/13/15.
//  Copyright (c) 2015 CDC. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL *url=[[NSBundle mainBundle] bundleURL];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"help"
                                                     ofType:@"html"];
    
    NSString *html = [NSString stringWithContentsOfFile:path
                                               encoding:NSUTF8StringEncoding
                                                  error:NULL];
    
    [self.webView loadHTMLString:html baseURL:url];
    
    
    
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

- (IBAction)btnDoneTouchUp:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
