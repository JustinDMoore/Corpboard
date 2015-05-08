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
-(void)sendProblem:(NSString *)report withImages:(NSMutableArray *)arrayOfImages;
-(void)backFromProblemWhat;
@end

@interface CBProblemWhat : UIView <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
     id delegate;
}

@property (nonatomic, strong) UIScrollView *scrollProblemWhat;
@property (nonatomic, strong) IBOutlet CBTextViewPlaceHolder *txtReport;
@property (nonatomic, strong) NSString *where;
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;
@property (nonatomic, strong) UIButton *imgView1;
@property (nonatomic, strong) UIButton *imgView2;
@property (nonatomic, strong) UIButton *imgView3;
@property (nonatomic, strong) UIButton *btnDelete1;
@property (nonatomic, strong) UIButton *btnDelete2;
@property (nonatomic, strong) UIButton *btnDelete3;
@property (nonatomic, strong) NSMutableArray *arrayOfScreenshots;
@property (nonatomic, strong) IBOutlet UIButton *btnBack;
@property (nonatomic, strong) IBOutlet UIButton *btnSend;
@property (nonatomic) BOOL isAProblem;
@property (nonatomic, strong) UIViewController *parent;
@property (nonatomic, strong) IBOutlet UILabel *lblPlaceholder;

-(void)showInParent;
-(void)setDelegate:(id)newDelegate;

@end
