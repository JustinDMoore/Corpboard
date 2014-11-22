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

-(void)setDelegate:(id)newDelegate;

@end
