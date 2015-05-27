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

@property (nonatomic, strong) UIVisualEffectView *viewBlur;
@property (nonatomic, strong) IBOutlet UIButton *btnMakePrediction;
@property (nonatomic, strong) UINavigationController *parentNav;

-(void)show;
-(void)setDelegate:(id)newDelegate;

@end