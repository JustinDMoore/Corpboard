//
//  LocationServicesDisabled.h
//  CorpBoard
//
//  Created by Justin Moore on 5/19/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationServicesDisabled : UIView

@property (weak, nonatomic) IBOutlet UIView *viewDialog;
@property (weak, nonatomic) IBOutlet UIButton *btnImage;
@property (weak, nonatomic) IBOutlet UIButton *btnOK;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;

-(void)showInParent:(UINavigationController *)parentNav;

@end
