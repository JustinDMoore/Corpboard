//
//  CBNewMenuViewController.h
//  CorpBoard
//
//  Created by Justin Moore on 7/2/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBNewMenuViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    

}

@property (nonatomic, retain) NSMutableArray *arrayOfHeadshots;
@property (nonatomic, retain) UIImageView *pageOneDoc;
@property (nonatomic, retain) UIImageView *pageTwoDoc;
@property (nonatomic, retain) UIImageView *pageThreeDoc;



- (void)loadPageWithId:(int)index onPage:(int)page;

@end
