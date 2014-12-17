//
//  CBEditName.h
//  CorpBoard
//
//  Created by Justin Moore on 12/16/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

@protocol editNameProtocol <NSObject>
@required
-(void)savedName;
-(void)cancelledSaveName;
@end

@interface CBEditName : UIView {
    id delegate;
}

@property (nonatomic, weak) PFUser *userProfile;
@property (nonatomic, weak) IBOutlet UILabel *lblusername;
@property (nonatomic, weak) IBOutlet UITextField *txtNickname;
@property (nonatomic, weak) IBOutlet UITextField *txtLocation;

- (IBAction)btnCancel:(id)sender;
- (IBAction)btnSave:(id)sender;
-(void)setDelegate:(id)newDelegate;
-(void)showInParent:(CGRect)parent;
-(void)closeView:(BOOL)cancelled;

@end
