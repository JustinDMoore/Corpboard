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
#import "CBLocationServices.h"
#import "CBLocationServicesDisabled.h"
#import "CBVersion.h"

@interface CBNewMenuViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, dataProtocol, CBMakeFinalsPredictionDelegate, CBLocationProtocol, versionProtocol> {

}

@property (nonatomic, strong) CBVersion *viewVersion;
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;
@property (nonatomic, strong) UIBarButtonItem *btnAdminBarButton;
@property (nonatomic, strong) UIButton *btnAdminButton;
@property (weak, nonatomic) IBOutlet UILabel *lblCopyright;
@property (weak, nonatomic) IBOutlet UIButton *btnDCI;

-(void)loadPageWithId:(int)index onPage:(int)page;

@end
