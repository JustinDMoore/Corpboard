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

@protocol editDescriptionProtocol <NSObject>

@required
-(void)savedDescription;
-(void)cancelledDescription;
@end

@interface CBEditDescription : UIView {
    id delegate;
}

@property (nonatomic, strong) IBOutlet CBTextViewPlaceHolder *txtDescription;

- (IBAction)btn_Cancel:(id)sender;
- (IBAction)btnSave:(id)sender;

-(void)setDelegate:(id)newDelegate;
-(void)showInParent:(CGRect)parent;
@end
