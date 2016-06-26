//
//  CBPredictionSubmitted.h
//  CorpBoard
//
//  Created by Justin Moore on 5/21/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol predictionThankYouProtocol <NSObject>
@required
-(void)predictionThankYou;
@end

@interface CBPredictionSubmitted : UIView {
    id delegate;
}

@property (weak, nonatomic) IBOutlet UIView *viewDialog;
@property (weak, nonatomic) IBOutlet UIImageView *btnImage;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;

-(void)setDelegate:(id)newDelegate;
-(void)showInParent:(UINavigationController *)parentNav;

@end
