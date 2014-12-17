//
//  CBChooseCorp.h
//  CorpBoard
//
//  Created by Justin Moore on 12/13/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBTextField.h"
#import "Parse/Parse.h"

@protocol corpExperienceProtocol <NSObject>

@required
-(void)savedCorpExperience;
-(void)closedCorpExperience;
@end

@interface CBChooseCorp : UIView <UITextFieldDelegate> {
    id delegate;
}

@property (nonatomic, strong) PFObject *selectedCorp;
@property (nonatomic, strong) PFObject *selectedYear;
@property (nonatomic, strong) NSString *selectedPosition;

@property (nonatomic, strong) IBOutlet UIButton *btnCorps;
@property (nonatomic, strong) NSArray *arrayOfPositions;
@property (nonatomic, strong) NSMutableArray *arrayOfYears;
@property (nonatomic, strong) IBOutlet CBTextField *txtCorpsName;
@property (nonatomic, strong) IBOutlet CBTextField *txtYear;
@property (nonatomic, strong) IBOutlet CBTextField *txtPosition;
@property (nonatomic, strong) UIPickerView *corpPicker;

-(void)setDelegate:(id)newDelegate;
-(void)showInParent:(CGRect)parent;
@end
