//
//  CBProblemWhat.h
//  CorpBoard
//
//  Created by Justin Moore on 5/5/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBTextViewPlaceHolder.h"

@protocol problemWhatProtocol <NSObject>
@required
-(void)sendProblem:(NSString *)report withImages:(NSMutableArray *)arrayOfImages whereAt:(NSString *)whereat;
-(void)backFromProblemWhat;
@end

@interface CBProblemWhat : UIView <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
     id delegate;
}

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *textViewHeightConstraint;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollProblemWhat;
@property (nonatomic, strong) IBOutlet CBTextViewPlaceHolder *txtReportHolder;
@property (nonatomic, strong) NSString *where;
@property (nonatomic, strong) IBOutlet UIView *view1;
@property (nonatomic, strong) IBOutlet UIView *view2;
@property (nonatomic, strong) IBOutlet UIView *view3;
@property (nonatomic, strong) IBOutlet UIButton *imgView1;
@property (nonatomic, strong) IBOutlet UIButton *imgView2;
@property (nonatomic, strong) IBOutlet UIButton *imgView3;
@property (nonatomic, strong) IBOutlet UIButton *btnDelete1;
@property (nonatomic, strong) IBOutlet UIButton *btnDelete2;
@property (nonatomic, strong) IBOutlet UIButton *btnDelete3;
@property (nonatomic, strong) NSMutableArray *arrayOfScreenshots;
@property (nonatomic, strong) IBOutlet UIButton *btnBack;
@property (nonatomic, strong) IBOutlet UIButton *btnSend;
@property (nonatomic, strong) UIViewController *parent;
@property (nonatomic, strong) IBOutlet UILabel *lblPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *viewScreenshots;
@property (nonatomic) BOOL isProblem;
@property (nonatomic, strong) IBOutlet UILabel *lblHeader;
-(void)showMenu;
-(void)showInParent;
-(void)setDelegate:(id)newDelegate;

@end
