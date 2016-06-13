//
//  CBEditDescription.h
//  CorpBoard
//
//  Created by Justin Moore on 12/16/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBTextViewPlaceHolder.h"
#import "Parse/Parse.h"

@protocol delegateEditDescription <NSObject>
@required
-(void)decriptionUpdated;
@end

@interface CBEditDescription : UIView {
    id delegate;
}

@property (nonatomic, strong) IBOutlet CBTextViewPlaceHolder *txtDescription;
@property (weak, nonatomic) IBOutlet UIView *viewDialog;
@property (weak, nonatomic) IBOutlet UIButton *btnImage;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;

- (IBAction)btnClose:(id)sender;
- (IBAction)btnSave:(id)sender;

-(void)setDelegate:(id)newDelegate;
-(void)showInParent:(UINavigationController *)parentNav;
@end
