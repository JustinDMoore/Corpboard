//
//  CBTerms.h
//  CorpBoard
//
//  Created by Justin Moore on 3/22/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TermsProtocol <NSObject>
@required
-(void)viewDidClose;
@end

@interface CBTerms : UIView {
    id delegate;
}
@property (nonatomic, strong) IBOutlet UIWebView *web;
-(void)setDelegate:(id)newDelegate;
-(void)showInParent:(CGRect)parent withHTMLString:(NSString *)str;
@end
