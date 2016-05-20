//
//  LocationServicesPermission.h
//  CorpBoard
//
//  Created by Justin Moore on 5/17/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationServicesPermission : UIView <CLLocationManagerDelegate> {
    id delegate;
}

@property (weak, nonatomic) IBOutlet UIView *viewDialog;
@property (weak, nonatomic) IBOutlet UIButton *btnImage;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIView *viewLoading;
@property (weak, nonatomic) IBOutlet UIButton *btnNotNow;

-(void)showInParent:(UINavigationController *)parentNav;
-(void)setDelegate:(id)newDelegate;
-(void)dismissView;

@end
