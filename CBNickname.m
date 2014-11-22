//
//  CBNickname.m
//  CorpBoard
//
//  Created by Justin Moore on 11/21/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBNickName.h"

@implementation CBNickname {
    
    IBOutlet UILabel *lblTitle;
    IBOutlet UITextField *txtNickname;
    
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        self.clipsToBounds = YES;
        txtNickname.delegate = self;
    }
    return self;
}

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

- (IBAction)btnDone_clicked:(id)sender {
    //check for unique nickname in delegate
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField.text length]) {
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}

@end
