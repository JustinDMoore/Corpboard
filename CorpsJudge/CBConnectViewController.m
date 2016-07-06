//
//  CBConnectViewController.m
//  CorpBoard
//
//  Created by Justin Moore on 5/7/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBConnectViewController.h"
#import "PulsingHaloLayer.h"
#import "NSDate+Utilities.h"
#import "KVNProgress.h"
#import "Configuration.h"
#import "Corpsboard-swift.h"

@interface CBConnectViewController ()

@end

UIRefreshControl *refreshControl;
PFQuery *queryUsers;
PUser *userToOpen;

@implementation CBConnectViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(loadUsers)
             forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
    
    self.title = @"Near Me";
    [self loadUsers];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:NO animated:NO];
    UIButton *backBtn = [UISingleton.sharedInstance getBackButton];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
}

-(void)goback {
    
    [queryUsers cancel];
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress dismiss];
    });
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadUsers {

    [refreshControl endRefreshing];
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress setConfiguration:[Configuration standardProgressConfig]];
        [KVNProgress show];
    });
    
    PFUser *user = [PFUser currentUser];
    PFGeoPoint *userGeoPoint = user[@"geo"];
    
    if (userGeoPoint) {
        
        queryUsers = [PFUser query];
        [queryUsers whereKey:@"objectId" notEqualTo:[PFUser currentUser].objectId];
        //[queryUsers whereKey:@"geo" nearGeoPoint:userGeoPoint];
        [queryUsers whereKey:@"geo" nearGeoPoint:userGeoPoint withinMiles:3000];
        queryUsers.limit = 150;
        [queryUsers findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                [self.arrayOfUsers removeAllObjects];
                [self.arrayOfUsers addObjectsFromArray:objects];
                [self.collectionView reloadData];
                [refreshControl endRefreshing];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [KVNProgress dismiss];
                });
            } else {
                // Log details of the failure
                [refreshControl endRefreshing];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [KVNProgress dismiss];
                });
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    } else {
        //location is nil, update it first, wait for callback, then retry
        Server.sharedInstance.delegateLocation = self;
        [Server.sharedInstance updateUserLocation];
    }
}

-(void)userLocationUpdated {
    [self loadUsers];
}

-(void)userLocationError {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Location Services"
                                  message:@"Corpsboard could not find your location."
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             [self goback];
                             
                         }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.arrayOfUsers count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    PFUser *user = self.arrayOfUsers[indexPath.row];
    PFImageView *imgUser = (PFImageView *)[cell viewWithTag:100];
    PFFile *imgFile = user[@"picture"];
    if (imgFile) {
        [imgUser setFile:imgFile];
        [imgUser loadInBackground];
    } else {
        [imgUser setImage:[UIImage imageNamed:@"defaultProfilePicture"]];
    }
    //imgUser.layer.cornerRadius = imgUser.frame.size.width/2;
    //imgUser.layer.masksToBounds = YES;
    
    UIView *viewCell = (UIView *)[cell viewWithTag:500];
    
    viewCell.frame = CGRectMake(viewCell.frame.origin.x, viewCell.frame.origin.y, 100, 100);
    
    viewCell.layer.cornerRadius = viewCell.frame.size.height / 2;
    
    //CGFloat(roundf(CGFloat(viewCell.frame.size.width/2.0)));
    //viewCell.layer.masksToBounds = YES;
    viewCell.layer.borderColor = UIColor.whiteColor.CGColor;
    viewCell.layer.borderWidth = 3;
    
    UILabel *lblDistance = (UILabel *)[cell viewWithTag:200];
    
    PFGeoPoint *userLoc = user[@"geo"];
    PFUser *cUser = [PFUser currentUser];
    double distance = [userLoc distanceInMilesTo:cUser[@"geo"]];
    
    NSString *distMeasure;
    if (distance < 1) {
        double feet = distance * 5280; //5280 ft/mile
        if (feet < 2) distMeasure = @"foot";
        else distMeasure = @"feet";
        lblDistance.text = [NSString stringWithFormat:@"%.0f %@", feet, distMeasure];
    } else {
        if (distance < 2) distMeasure = @"mile";
        else distMeasure = @"miles";
        lblDistance.text = [NSString stringWithFormat:@"%.0f %@", distance, distMeasure];
    }
    
    lblDistance.backgroundColor = [UIColor lightGrayColor];
    lblDistance.textColor = [UIColor whiteColor];
    
    UIView *v = (UIView *)[cell viewWithTag:300];
    [imgUser addSubview:v];
    
    UIImageView *imgOnline = (UIImageView *)[cell viewWithTag:1];
    for (CALayer *layer in cell.layer.sublayers) {
        if ([layer isKindOfClass:[PulsingHaloLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }
    
    NSDate *dateLastLogin = user[@"lastLogin"];
    NSInteger diff = [dateLastLogin minutesBeforeDate:[NSDate date]];
    if (diff <= 10) { // online
        imgOnline.hidden = NO;
        PulsingHaloLayer *halo = [PulsingHaloLayer layer];
        halo.position = imgOnline.center;
        halo.radius = 10;
        halo.animationDuration = 2;
        halo.backgroundColor = [UIColor whiteColor].CGColor;
        [cell.layer addSublayer:halo];
        imgOnline.layer.cornerRadius = imgOnline.frame.size.height / 2;
        imgOnline.layer.borderWidth = 2;
        imgOnline.layer.borderColor = [UIColor whiteColor].CGColor;
    } else {
        imgOnline.hidden = YES;
    }
    
    [cell bringSubviewToFront:imgOnline];
    [cell sendSubviewToBack:imgUser];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //return CGSizeMake(100, 100);
    
    float x = ([UIScreen mainScreen].bounds.size.width - 35) / 3;
    x = floorf(x/2.f)*2.f;
    return CGSizeMake(x, x);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    
    userToOpen = self.arrayOfUsers[indexPath.row];
    [self performSegueWithIdentifier:@"profile" sender:self];
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/


-(NSMutableArray *)arrayOfUsers {
    if (!_arrayOfUsers) {
        _arrayOfUsers = [[NSMutableArray alloc] init];
    }
    return _arrayOfUsers;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"profile"]) {
        ProfileTableViewController *vc = [segue destinationViewController];
        vc.userProfile = userToOpen;
    }
}
@end
