//
//  CBScreenName.h
//  CorpBoard
//
//  Created by Justin Moore on 11/21/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol nicknameProtocol <NSObject>
@required
-(void)nicknameChosen;
@end

@interface CBScreenName : UIView <UITextFieldDelegate> {
    id delegate;
}

-(void)setDelegate:(id)newDelegate;
-(void)showInParent:(CGRect)parent withTitle:(NSString *)title;

@end
