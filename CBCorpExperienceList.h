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

@interface CBCorpExperienceList : UIView {
    id delegate;
}

@property (nonatomic, weak) IBOutlet UITableView *tableExperience;

- (IBAction)btnClose:(id)sender;
-(void)setDelegate:(id)newDelegate;
-(void)showInParent:(CGRect)parent;
-(void)closeView:(BOOL)cancelled;
@end
