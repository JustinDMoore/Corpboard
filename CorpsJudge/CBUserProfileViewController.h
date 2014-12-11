//
//  CBUserProfileViewController.h
//  CorpBoard
//
//  Created by Isaias Favela on 12/10/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface CBUserProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
}

@property (weak, nonatomic) PFUser *userProfile;
@property (weak, nonatomic) IBOutlet PFImageView *imgUser;
@property (weak, nonatomic) IBOutlet UILabel *lblUserNickname;
@property (weak, nonatomic) IBOutlet UILabel *lblUserLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblViews;

@property (weak, nonatomic) IBOutlet UIButton *btnMessageUser_clicked;
@property (weak, nonatomic) IBOutlet UIButton *btnReportUser_clicked;
@property (weak, nonatomic) IBOutlet UIView *viewControls;


-(void)setUser:(PFUser*)user;
@end
