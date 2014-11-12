//
//  CBWebViewController.m
//  CorpBoard
//
//  Created by Justin Moore on 10/31/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBWebViewController.h"
@interface CBWebViewController()
@property (weak, nonatomic) IBOutlet UILabel *lblWebsiteTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblWebsiteSubTitle;

@end

@implementation CBWebViewController
- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadWebsite];
    // Do any additional setup after loading the view.
}

-(void)loadWebsite {
    
    self.lblWebsiteTitle.text = self.websiteTitle;
    self.lblWebsiteSubTitle.text = self.websiteSubTitle;
    NSURL *url = [NSURL URLWithString:self.webURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    self.webView.hidden = NO;
}

-(void)functionCalledWhenUIWebViewFinishesLoading {
    self.theBool = true;
}

-(void)timerCallback {
    if (self.theBool) {
        if (self.myProgressView.progress >= 1) {
            self.myProgressView.hidden = true;
            [self.myTimer invalidate];
        }
        else {
            self.myProgressView.progress += 0.1;
        }
    }
    else {
        self.myProgressView.progress += 0.05;
        if (self.myProgressView.progress >= 0.90) {
            self.myProgressView.progress = 0.90;
        }
    }
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    self.myProgressView.progress = 0;
    self.theBool = false;
    //0.01667 is roughly 1/60, so it will update at 60 FPS
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:0.01667 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    self.theBool = true;
}

@end
