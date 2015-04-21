//
//  CBTourMapViewController.m
//  CorpBoard
//
//  Created by Justin Moore on 3/13/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBTourMapViewController.h"
#import "CBSingle.h"
#import "CBAnnotation.h"
#import "CBShowDetailsViewController.h"
#import "MKMapView+ZoomLevel.h"
#import "NSMutableArray+Shuffling.h"
#import "CBMapMenu.h"
#import "CBMapCell.h"
#import <ParseUI/ParseUI.h>

@interface CBTourMapViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentMapType;
@property (nonatomic, strong) CBMapMenu *mapMenu;
@end


CBSingle *datas;

@implementation CBTourMapViewController
- (IBAction)segmentMapType_changed:(id)sender {
    switch (self.segmentMapType.selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Tour Map";
    datas = [CBSingle data];
    self.mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [self.locationManager requestWhenInUseAuthorization];
    }
#endif
    [self.locationManager startUpdatingLocation];
    
    self.mapView.showsUserLocation = NO;
    [self.mapView setMapType:MKMapTypeStandard];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    
    if (!self.individualShow) {
        self.segmentMapType.selectedSegmentIndex = 0;
        CLLocationCoordinate2D centerCoord = {39.8282, -98.5795};
        [self.mapView setCenterCoordinate:centerCoord zoomLevel:2 animated:YES];
    } else {
        self.segmentMapType.selectedSegmentIndex = 2;
    }
}

-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    
    if (!self.individualShow) {
        if (!showsPlotted) [self plotAllShowsForCorps:nil];
    } else {
        if (!showPlotted) [self plotShow:self.show];
    }
}

-(void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered {
    
    if (!self.individualShow) {
        if (!showsPlotted) [self plotAllShowsForCorps:nil];
    } else {
        if (!showPlotted) [self plotShow:self.show];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:NO animated:NO];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"arrowLeft"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIButton *btnMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *menuButtonImage = [UIImage imageNamed:@"filter"];
    [btnMenu setBackgroundImage:menuButtonImage forState:UIControlStateNormal];
    btnMenu.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:btnMenu];
    [btnMenu addTarget:self action:@selector(showMapMenu) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = menuButton;
    
    if (self.individualShow) {
        self.navigationItem.rightBarButtonItem = nil;
        self.mapView.mapType = MKMapTypeSatellite;
    } else {
        self.navigationItem.rightBarButtonItem = menuButton;
        self.mapView.mapType = MKMapTypeStandard;
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    showsPlotted = NO;
    showPlotted = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{

}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[CBAnnotation class]]) {
        
        CBAnnotation *myLocation = (CBAnnotation *)annotation;
        
        MKAnnotationView *annotationView;
        
        if ([myLocation.show[@"showName"] isEqualToString:@"Tour of Champions"]) {

            annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"TOC"];
            
        } else if ([myLocation.show[@"showName"] containsString:@"World Championship"]) {

            annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"champs"];
            
        } else {

            annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"standard"];
            
        }
        
        if (annotationView == nil) {
            annotationView = myLocation.annotationView;
        } else {
            annotationView.annotation = annotation;
        }
        annotationView.canShowCallout = YES;
        return annotationView;
    }
    else return nil;
}

- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
}
- (NSString *)deviceLat {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.latitude];
}
- (NSString *)deviceLon {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.longitude];
}
- (NSString *)deviceAlt {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.altitude];
}

BOOL showsPlotted;
-(void)plotAllShowsForCorps:(PFObject *)corps {
    
    [self.arrayOfShowsToDisplay removeAllObjects];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.arrayOfCoordinates removeAllObjects];
    
    if (corps) { // ONLY SHOWING SHOWS FOR A CORPS
        for (PFObject *show in datas.arrayOfAllShows) {
            for (NSString *name in show[@"arrayOfCorps"]) {
                if ([name isEqualToString:corps[@"corpsName"]]) {
                    [self plotShow:show];
                    break;
                }
            }
        }
        
    } else { // ALL SHOWS
        for (PFObject *show in datas.arrayOfAllShows) {
            [self plotShow:show];
        }
    }
    
    showsPlotted = YES;
}

BOOL showPlotted;
-(void)plotShow:(PFObject *)show {
    
    PFObject *stadium = show[@"stadium"];
    PFGeoPoint *location = stadium[@"coordinates"];
    if (location.longitude && location.latitude) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MMMM d"];
        NSString *dateString = [format stringFromDate:show[@"showDate"]];
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(location.latitude, location.longitude);
        CBAnnotation *custom = [[CBAnnotation alloc] initWithTitle:show[@"showName"] andSubTitle:dateString atLocation:coord];
        custom.show = show;
        custom.showObjectId = show.objectId;
        [self.mapView addAnnotation:custom];
        
        if (self.individualShow) {
            //zoom into it
            showPlotted = YES;
            MKCoordinateRegion mapRegion;
            mapRegion.center = coord;
            mapRegion.span.latitudeDelta = 0.003;
            mapRegion.span.longitudeDelta = 0.003;
            
            [self.mapView setRegion:mapRegion animated: YES];
            [self.mapView regionThatFits:mapRegion];
        }
    }
}

- (void)goback {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    CBAnnotation *ann = (CBAnnotation *)view.annotation;
    NSString * storyboardName = @"Main";
    NSString * viewControllerID = @"showDetails";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    CBShowDetailsViewController * showDetails = (CBShowDetailsViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    showDetails.show = ann.show;
    showDetails.fromMaps = YES;
    [self.navigationController pushViewController:showDetails animated:YES];
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"tapped view");
//    UITapGestureRecognizer *tapGesture =
//    [[UITapGestureRecognizer alloc] initWithTarget:self
//                                            action:@selector(calloutTapped:)];
//    [view addGestureRecognizer:tapGesture];
}

-(void)calloutTapped:(id)sender {

//    CBAnnotation *ann = (CBAnnotation *)sender;
//    NSLog(@"%@", ann.show[@"showName"]);
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)annotationViews {
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:annotationViews];
    [arr shuffle];
    
    float delay = .3;
    
    for (MKAnnotationView *annView in arr) {

        CLLocation *loc = [[CLLocation alloc] initWithLatitude:annView.annotation.coordinate.latitude longitude:annView.annotation.coordinate.longitude];
        
        CBAnnotation *a = (CBAnnotation *)annView.annotation;
        
        if (![self doesCoordinateAlreadyExist:loc]) {
            
            if (a.champs || a.TOC) {
                [annView.superview bringSubviewToFront:annView];
            } else {
                [annView.superview sendSubviewToBack:annView];
            }
            
            [self.arrayOfCoordinates addObject:loc];
            annView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            
            [UIView animateWithDuration:.3
                                  delay:delay
                 usingSpringWithDamping:.3
                  initialSpringVelocity:10
                                options:0
                             animations:^{
                                 annView.transform = CGAffineTransformIdentity;
                                 
                             } completion:^(BOOL finished) {
                                 
                             }];
            delay += .02;
        } else {
            annView.hidden = YES;
        }
    }
}

-(BOOL)doesCoordinateAlreadyExist:(CLLocation*)coordinate {
    
    if (![self.arrayOfCoordinates count]) return NO;
    else {
        for (CLLocation *coord in self.arrayOfCoordinates) {
            if (coord.coordinate.latitude == coordinate.coordinate.latitude &&
                coord.coordinate.longitude == coordinate.coordinate.longitude) {
                return YES;
            }
        }
        return NO;
    }
}

#pragma mark
#pragma mark - MapMenu Delegates
#pragma mark

-(void)toggleSatellite:(BOOL)on {
    
    if (on) self.mapView.mapType = MKMapTypeSatellite;
    else self.mapView.mapType = MKMapTypeStandard;
}

-(void)filterShowByCorps:(PFObject *)corps {
    
    [self plotAllShowsForCorps:corps];
}

#pragma mark
#pragma mark - Slide Delegates
#pragma mark

-(BOOL)slideNavigationControllerShouldDisplayRightMenu {
    
    return YES;
}

-(NSMutableArray *)arrayOfShowsToDisplay {
    if (!_arrayOfShowsToDisplay) {
        _arrayOfShowsToDisplay = [[NSMutableArray alloc] init];
    }
    return _arrayOfShowsToDisplay;
}


-(NSMutableArray *)arrayOfCoordinates {
    if (!_arrayOfCoordinates) {
        _arrayOfCoordinates = [[NSMutableArray alloc] init];
    }
    return _arrayOfCoordinates;
}

-(CBMapMenu *)mapMenu {
    
    if (!_mapMenu) {
        _mapMenu =
        [[[NSBundle mainBundle] loadNibNamed:@"CBMapMenu"
                                       owner:self
                                     options:nil]
         objectAtIndex:0];
        [_mapMenu setDelegate:self];
        _mapMenu.tableCorps.delegate = self;
        _mapMenu.tableCorps.dataSource = self;
    }
    return _mapMenu;
}

#pragma mark
#pragma mark - UITableView Delegate/Datasource
#pragma mark

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [datas.arrayOfAllCorps count] + 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mapMenu.tableCorps.frame.size.width, 20)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //UITableViewCell *cell = [self.tableMenu dequeueReusableCellWithIdentifier:@"rightMenuCell"];
    
    CBMapCell *cell = [self.mapMenu.tableCorps dequeueReusableCellWithIdentifier:@"myCell"];
    if (!cell) {
        [self.mapMenu.tableCorps registerNib:[UINib nibWithNibName:@"CBMapCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
        cell = [self.mapMenu.tableCorps dequeueReusableCellWithIdentifier:@"myCell"];
    }
    
    UIView *viewCell = (UIView *)[cell viewWithTag:1];
    UILabel *lblCorpName = (UILabel *)[cell viewWithTag:3];
    PFImageView *imgLogo = (PFImageView *)[cell viewWithTag:2];
    
    if (indexPath.row == 0) {
        lblCorpName.text = @"View All Shows";
        lblCorpName.font = [UIFont boldSystemFontOfSize:12];
        imgLogo.image = [UIImage imageNamed:@"allShows"];
    } else {
        PFObject *corps = datas.arrayOfAllCorps[indexPath.row - 1];
        lblCorpName.text = corps[@"corpsName"];
        lblCorpName.font = [UIFont systemFontOfSize:12];
        PFFile *imgFile = corps[@"logo"];
        [imgLogo setFile:imgFile];
        [imgLogo loadInBackground];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.backgroundColor = [UIColor clearColor];
    viewCell.backgroundColor = [UIColor clearColor];
    lblCorpName.textColor = [UIColor whiteColor];
    
    
    return cell;
}

-(void)animateCells {
    
    for (int i = 0; i > 5; i++) {
        UITableViewCell *cell = [self.mapMenu.tableCorps cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        UIView *viewCell = (UIView *)[cell viewWithTag:1];
        viewCell.frame = CGRectMake(200, viewCell.frame.origin.y, viewCell.frame.size.width, viewCell.frame.size.height);
        
        [UIView animateWithDuration:1
                              delay:0
             usingSpringWithDamping:.9
              initialSpringVelocity:1
                            options:0
                         animations:^{
                             viewCell.frame = CGRectMake(0, viewCell.frame.origin.y, viewCell.frame.size.width, viewCell.frame.size.height);
                         } completion:^(BOOL finished) {
                             
                         }];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) { //all shows
        [self filterShowByCorps:nil];
    } else {
        PFObject *corps = datas.arrayOfAllCorps[indexPath.row - 1];
        [self filterShowByCorps:corps];
    }
    
    [self closeMapMenu];
}

BOOL mapOpen;
-(void)showMapMenu {
    if (mapOpen) {
        [self closeMapMenu];
    } else {
        mapOpen = YES;
        self.mapMenu.alpha = 0;
        [self.navigationController.view addSubview:self.mapMenu];
        [self.mapMenu showInParent:self.mapMenu.frame];
        
        [UIView animateWithDuration:.3
                         animations:^{
                             self.mapView.transform = CGAffineTransformScale(self.view.transform, 0.85, 0.85);
                             self.segmentMapType.alpha = 0;
                             [self animateCells];
                         }];
    }
}

-(void)closeMapMenu {
    mapOpen = NO;
    [self.mapMenu closeView];
    [UIView animateWithDuration:.3
                     animations:^{
                         self.mapView.transform = CGAffineTransformIdentity;
                         self.segmentMapType.alpha = 1;
                     }];
}

@end
