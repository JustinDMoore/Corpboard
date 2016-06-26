//
//  CBMakeFinalsPrediction.h
//  CorpBoard
//
//  Created by Isaias Favela on 5/14/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CBMakeFinalsPredictionDelegate <NSObject>
@required
-(void)makePrediction;
@end

@interface CBMakeFinalsPrediction : UIView {
    id delegate;
}

@property (weak, nonatomic) IBOutlet UIView *viewDialog;
@property (weak, nonatomic) IBOutlet UIButton *btnImage;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;

-(void)showInParent:(UINavigationController *)parentNav;

@end
