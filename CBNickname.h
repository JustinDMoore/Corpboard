//
//  CBNickname.h
//  CorpBoard
//
//  Created by Justin Moore on 11/21/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NicknameProtocol <NSObject>
@required
-(void)nicknameChosen;
@end

@interface CBNickname : UIView <UITextFieldDelegate> {
    id delegate;
}

-(void)setDelegate:(id)newDelegate;


@end
