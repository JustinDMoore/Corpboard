//
//  CBCorpExperienceList.h
//  CorpBoard
//
//  Created by Justin Moore on 12/17/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol corpExperienceListProtocol <NSObject>
@required
-(void)corpExperienceUpdated;
@end

@interface CBCorpExperienceList : UIView <UITableViewDelegate, UITableViewDataSource> {
    id delegate;
}

@property (nonatomic, weak) IBOutlet UITableView *tableExperience;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIView *viewDialog;
@property (weak, nonatomic) IBOutlet UIButton *btnIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (nonatomic, strong) NSMutableArray *arrayOfExperience; // of PUserExperience

- (IBAction)btnClose:(id)sender;
-(void)setDelegate:(id)newDelegate;
-(void)showInParent:(UINavigationController *)parentNav;
-(void)closeView:(BOOL)cancelled;
@end
