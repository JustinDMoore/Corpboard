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

@interface CBTourMapViewController ()

@end


CBSingle *datas;

@implementation CBTourMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Tour Map";
    datas = [CBSingle data];
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
    
    self.mapView.showsUserLocation = NO;
    [self.mapView setMapType:MKMapTypeStandard];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];

    
    CLLocationCoordinate2D centerCoord = {41.7627, -72.6743};
    [self.mapView setCenterCoordinate:centerCoord zoomLevel:2 animated:YES];
    
    [self plotAllShowsForCorps:nil];
    
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
    UIImage *menuButtonImage = [UIImage imageNamed:@"menu"];
    [btnMenu setBackgroundImage:menuButtonImage forState:UIControlStateNormal];
    btnMenu.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:btnMenu] ;
    self.navigationItem.rightBarButtonItem = menuButton;

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
}

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

@end
