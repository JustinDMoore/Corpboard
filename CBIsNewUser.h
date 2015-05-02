//
//  CBIsNewUser.h
//  CorpBoard
//
//  Created by Isaias Favela on 11/22/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewUserProtocol <NSObject>
@required
-(void)isNewUser:(BOOL)newUser;
@end

@interface CBIsNewUser : UIView {
    id delegate;
}

@property (nonatomic, strong) UIViewController *parent;
-(void)setDelegate:(id)newDelegate;

@end
