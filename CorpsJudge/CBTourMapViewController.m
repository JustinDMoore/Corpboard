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

@interface CBTourMapViewController ()

@end


CBSingle *data;

@implementation CBTourMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    data = [CBSingle data];
    CBTourMapMenuViewController *menu = (CBTourMapMenuViewController *)[SlideNavigationController sharedInstance].rightMenu;
    menu.delegate = self;
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
    
    self.mapView.showsUserLocation = YES;
    [self.mapView setMapType:MKMapTypeStandard];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];

    [self plotAllShowsForCorps:nil];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:NO animated:NO];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"BackArrow"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIButton *btnMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *menuButtonImage = [UIImage imageNamed:@"menu"];
    [btnMenu setBackgroundImage:menuButtonImage forState:UIControlStateNormal];
    [btnMenu addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    btnMenu.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:btnMenu] ;
    self.navigationItem.rightBarButtonItem = menuButton;

}

-(void)showMenu {

    
    
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    NSLog(@"%@", [self deviceLocation]);
    
//    // define span for map: how much area will be shown
//    MKCoordinateSpan span;
//    span.latitudeDelta = 0.2;
//    span.longitudeDelta = 0.2;
//    
//    // define starting point for map
//    CLLocationCoordinate2D start;
//    start.latitude = 39.828328;
//    start.longitude = -98.579416;
//    
//    // create region, consisting of span and location
//    MKCoordinateRegion region;
//    region.span = span;
//    region.center = start;
//    
//    // move the map to our location
//    [self.mapView setRegion:region animated:YES];
    
    
    
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
        
        
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MyCustomAnnotation"];
        
        if (annotationView == nil) {
            annotationView = myLocation.annotationView;
        } else {
            annotationView.annotation = annotation;
        }
    
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

-(void)plotAllShowsForCorps:(PFObject *)corps {
    
    [self.arrayOfShowsToDisplay removeAllObjects];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    if (corps) { //add only the shows for the corps passed in
        for (PFObject *show in data.arrayOfAllShows) {
            
            for (NSString *name in show[@"arrayOfCorps"]) {
                if ([name isEqualToString:corps[@"corpsName"]]) {
                    [self plotShow:show];
                    break;
                }
            }
        }
    } else { // add all the shows
        for (PFObject *show in data.arrayOfAllShows) {
            [self plotShow:show];
        }
    }
}

-(void)plotShow:(PFObject *)show {
    
    PFObject *stadium = show[@"stadium"];
    PFGeoPoint *location = stadium[@"coordinates"];
    if (location.longitude && location.latitude) {
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(location.latitude, location.longitude);
        CBAnnotation *custom = [[CBAnnotation alloc] initWithTitle:show[@"showName"] Location:coord];
        custom.show = show;
        [self.mapView addAnnotation:custom];
    }
}

- (void)goback {
    
    [self.navigationController popViewControllerAnimated:YES];
}
//-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
//    
//        CBAnnotation *ann = (CBAnnotation *)view;
//    
//        NSString * storyboardName = @"Main";
//        NSString * viewControllerID = @"showDetails";
//        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
//        CBShowDetailsViewController * showDetails = (CBShowDetailsViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
//        showDetails.show = ann.show;
//    
//        [self presentViewController:showDetails animated:YES completion:nil];
//}

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

@end
