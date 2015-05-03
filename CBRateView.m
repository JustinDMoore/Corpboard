//
//  CBRateView.m
//  CorpBoard
//
//  Created by Isaias Favela on 11/20/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBRateView.h"

int numOfStars = 0;
int y = 0;
bool onStar = NO;
UIImageView *currentStar;

@implementation CBRateView {
    
    IBOutlet UIImageView *star1;
    IBOutlet UIImageView *star2;
    IBOutlet UIImageView *star3;
    IBOutlet UIImageView *star4;
    IBOutlet UIImageView *star5;
    
    __weak IBOutlet UIView *viewStars;

    __weak IBOutlet UIButton *btnSubmit;
    
    __weak IBOutlet UIButton *btnCancel;
    
    __weak IBOutlet UILabel *lblRating;


}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        self.clipsToBounds = YES;
        
        for (UIView *view in self.subviews) {
            view.alpha = 0;
            view.hidden = YES;
        }
    }
    return self;
}

-(void)tapStar:(UITapGestureRecognizer *)recog {
    
    btnSubmit.enabled = YES;
    lblRating.alpha = 1;
    UIImageView *imgView = (UIImageView*)recog.view;
    if (imgView == star1) { numOfStars = 1; lblRating.text = @"Poor"; }
    if (imgView == star2) { numOfStars = 2; lblRating.text = @"Fair"; }
    if (imgView == star3) { numOfStars = 3; lblRating.text = @"Good"; }
    if (imgView == star4) { numOfStars = 4; lblRating.text = @"Very Good"; }
    if (imgView == star5) { numOfStars = 5; lblRating.text = @"Excellent"; }
    
    star5.image = [UIImage imageNamed:@"star_unselected"];
    star4.image = [UIImage imageNamed:@"star_unselected"];
    star3.image = [UIImage imageNamed:@"star_unselected"];
    star2.image = [UIImage imageNamed:@"star_unselected"];
    star1.image = [UIImage imageNamed:@"star_unselected"];
    
    y = numOfStars;
    [self animateStar];
    
}

-(void)animateStar {

    UIImageView *theStar;
    
    if (y == 1) theStar = star1;
    if (y == 2) theStar = star2;
    if (y == 3) theStar = star3;
    if (y == 4) theStar = star4;
    if (y == 5) theStar = star5;
    
    //star expand
    [UIView animateWithDuration:.06
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         
                         theStar.frame = CGRectMake(theStar.frame.origin.x - 10, theStar.frame.origin.y - 10, theStar.frame.size.width + 20, theStar.frame.size.height + 20);
                         theStar.image = [UIImage imageNamed:@"star_selected"];
                         theStar.tag = 1;
                     } completion:^(BOOL finished){

                         y--;
                         if (y > 0) [self animateStar];
                         
                         //star contract
                         [UIView animateWithDuration:.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^(void) {
                                              
                                              theStar.frame = CGRectMake(theStar.frame.origin.x + 15, theStar.frame.origin.y + 15, theStar.frame.size.width - 30, theStar.frame.size.height - 30);
                                          } completion:^(BOOL finished){
                                              
                                              
                                              //star resize
                                              [UIView animateWithDuration:.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                                                               animations:^(void) {
                                                                   
                                                                   theStar.frame = CGRectMake(theStar.frame.origin.x - 5, theStar.frame.origin.y - 5, theStar.frame.size.width + 10, theStar.frame.size.height + 10);
                                                               } completion:^(BOOL finished){
                                                                   
                                                                   
                                                               }];
                                              
                                          }];
                     }];
    
}

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

- (IBAction)btnCancelled_clicked:(id)sender {
    [delegate rateCancelled];
    //[self closeView: YES];
}

- (IBAction)btnSubmit_clicked:(id)sender {
    [delegate rateSubmitted: numOfStars];
    [self closeView: NO];
}

-(void)initUI {
    
    self.userInteractionEnabled = YES;
    
    star1.image = [UIImage imageNamed:@"star_unselected"];
    star2.image = [UIImage imageNamed:@"star_unselected"];
    star3.image = [UIImage imageNamed:@"star_unselected"];
    star4.image = [UIImage imageNamed:@"star_unselected"];
    star5.image = [UIImage imageNamed:@"star_unselected"];
    
    star1.userInteractionEnabled = YES;
    star2.userInteractionEnabled = YES;
    star3.userInteractionEnabled = YES;
    star4.userInteractionEnabled = YES;
    star5.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStar:)];
    [star1 addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStar:)];
    [star2 addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStar:)];
    [star3 addGestureRecognizer:tap3];
    
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStar:)];
    [star4 addGestureRecognizer:tap4];
    
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStar:)];
    [star5 addGestureRecognizer:tap5];
    
    lblRating.text = @"     ";
    
    [UIView animateWithDuration:.25
                          delay:0
                        options:0
                     animations:^{
                         for (UIView *view in self.subviews) {
                             view.hidden = NO;
                             view.alpha = 1;
                         }
                     } completion:^(BOOL finished) {
                         
                     }];
}

-(void)showInParent {
    
    [self initUI];
}

-(void)closeView:(BOOL)cancelled {
    [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:8 options:0 animations:^{
        
        self.transform = CGAffineTransformScale(self.transform, 1.1, 1.1);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:8
                            options:0
                         animations:^{
                             self.transform = CGAffineTransformScale(self.transform, 0.1f, 0.1f);
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [self removeFromSuperview];
                             if (cancelled) [delegate rateCancelled];
                         }];
    }];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
