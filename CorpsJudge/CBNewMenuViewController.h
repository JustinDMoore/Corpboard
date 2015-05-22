//
//  CBNewMenuViewController.h
//  CorpBoard
//
//  Created by Justin Moore on 7/2/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBSingle.h"
#import "CBMakeFinalsPrediction.h"

@interface CBNewMenuViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, dataProtocol, CBMakeFinalsPredictionDelegate> {

}

-(void)loadPageWithId:(int)index onPage:(int)page;

@end
