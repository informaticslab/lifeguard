//
//  AboutUsViewController.m
//  Lifeguard
//
//  Created by jtq6 on 4/13/15.
//  Copyright (c) 2015 CDC. All rights reserved.
//

#import "AboutUsViewController.h"
#import "AppManager.h"

@implementation AboutUsViewController

AppManager *appMgr;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL *url=[[NSBundle mainBundle] bundleURL];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"about-us"
                                                     ofType:@"html"];
    
    NSString *html = [NSString stringWithContentsOfFile:path
                                               encoding:NSUTF8StringEncoding
                                                  error:NULL];
    self.webView.delegate = self;
    [self.webView loadHTMLString:html baseURL:url];
    appMgr = [AppManager singletonAppManager];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSString *ver = [appMgr getAppVersion];
    NSString *js_func_call = [NSString stringWithFormat:@"insertVersion(\"%@\")", ver];
    [self.webView stringByEvaluatingJavaScriptFromString:js_func_call];
    

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
