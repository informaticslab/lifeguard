//
//  AboutUsViewController.h
//  Lifeguard
//
//  Created by jtq6 on 4/13/15.
//  Copyright (c) 2015 CDC. All rights reserved.
//

#ifndef Lifeguard_AboutUsViewController_h
#define Lifeguard_AboutUsViewController_h

#import <UIKit/UIKit.h>

@interface AboutUsViewController : UIViewController <UIWebViewDelegate>
- (IBAction)btnDoneTouchUp:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end


#endif
