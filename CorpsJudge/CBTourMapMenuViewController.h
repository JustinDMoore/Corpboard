//
//  CBTourMapMenuViewController.h
//  CorpBoard
//
//  Created by Justin Moore on 3/16/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "SlideNavigationContorllerAnimator.h"
#import "SlideNavigationContorllerAnimatorFade.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"
#import "SlideNavigationContorllerAnimatorSlideAndFade.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@protocol mapMenuProtocol <NSObject>
@required
-(void)toggleSatellite:(BOOL)on;
-(void)filterShowByCorps:(PFObject *)corps;
@end


@interface CBTourMapMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {

}

@property (weak, nonatomic) IBOutlet UITableView *tableMenu;
@property (nonatomic, assign) id delegate;
@property (nonatomic) BOOL satellite;
-(void)refreshMenu;

@end
