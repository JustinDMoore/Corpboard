//
//  CBNicknameView.h
//  CorpBoard
//
//  Created by Isaias Favela on 11/22/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NicknameProtocol <NSObject>
@required
-(void)nicknameChosen;
@end

@interface CBNicknameView : UIView <UITextFieldDelegate> {
    id delegate;
}
@property (nonatomic,strong) IBOutlet UITextField *txtNickname;
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) UIView *viewToScroll;

-(void)setDelegate:(id)newDelegate;

@end
