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
- (IBAction)btnAction_tapped:(id)sender;
- (IBAction)btnClose_tapped:(id)sender;

@end

@implementation CBWebViewController

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
        self.myProgressView.progress += 0.01;
        if (self.myProgressView.progress >= 0.90) {
            self.myProgressView.progress = 0.90;
        }
    }
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    self.myProgressView.progress = 0;
    self.theBool = false;
    //0.01667 is roughly 1/60, so it will update at 60 FPS
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:0.02667 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    self.theBool = true;
}

- (IBAction)btnAction_tapped:(id)sender {

    NSString *other1 = @"Copy link";
    NSString *other2 = @"Open in Safari";
    NSString *cancelTitle = @"Cancel";
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:nil
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:other1, other2, nil];
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
}

- (IBAction)btnClose_tapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark - UIActionSheet Delegates
#pragma mark -

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0: // copy link
            [UIPasteboard generalPasteboard].string = self.webURL;
            break;
        case 1: // open in safari
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.webURL]];
            break;
        default:
            break;
    }
}

@end
