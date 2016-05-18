//
//  LocationServicesPermission.h
//  CorpBoard
//
//  Created by Justin Moore on 5/17/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol delegateLocationServices <NSObject>
-(void)locationAllowed;
@end

@interface LocationServicesPermission : UIView {
    id delegate;
}

@property (weak, nonatomic) IBOutlet UIView *viewDialog;
@property (weak, nonatomic) IBOutlet UIButton *btnImage;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;

-(void)showInParent:(UINavigationController *)parentNav;
-(void)setDelegate:(id)newDelegate;

@end
