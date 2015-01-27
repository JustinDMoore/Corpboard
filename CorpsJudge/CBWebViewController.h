//
//  CBWebController.h
//  CorpBoard
//
//  Created by Justin Moore on 10/31/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBWebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSString *webURL;
@property (nonatomic, strong) NSString *websiteTitle;
@property (nonatomic, strong) NSString *websiteSubTitle;

@property (nonatomic) BOOL theBool;
//IBOutlet means you can place the progressView in Interface Builder and connect it to your code
@property (weak, nonatomic) IBOutlet UIProgressView *myProgressView;
@property (nonatomic, strong) NSTimer *myTimer;


@end
