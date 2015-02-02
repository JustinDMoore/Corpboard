//
//  CBNewChatView.h
//  CorpBoard
//
//  Created by Justin Moore on 2/1/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBTextViewPlaceHolder.h"

@protocol NewChatProtocol <NSObject>
@required
-(void)newChatWithTopic:(NSString *)topic withMessage:(NSString *)message;
-(void)newChatCancelled;
@end

@interface CBNewChatView : UIView <UITextViewDelegate> {
    id delegate;
}

@property (nonatomic, strong) IBOutlet CBTextViewPlaceHolder *txtTopic;
@property (nonatomic, strong) IBOutlet CBTextViewPlaceHolder *txtMessage;
@property (nonatomic, strong) IBOutlet UIButton *btnStartChat;
@property (nonatomic, strong) IBOutlet UIButton *btnCancel;



- (IBAction)btnStartChat_tapped:(id)sender;
- (IBAction)btnCancel_tapped:(id)sender;

-(void)setDelegate:(id)newDelegate;
-(void)showInParent:(CGRect)parent;
-(void)closeView:(BOOL)cancelled;

@end
