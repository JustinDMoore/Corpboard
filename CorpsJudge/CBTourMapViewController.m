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
    
    self.mapView.showsUserLocation = YES;
    [self.mapView setMapType:MKMapTypeStandard];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];

    
    CLLocationCoordinate2D centerCoord = {39.8282, -98.5795};
    [self.mapView setCenterCoordinate:centerCoord zoomLevel:3 animated:NO];
    
    
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

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)annotationViews {
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:annotationViews];
    [arr shuffle];
    
    float delay = .5;
    
    for (MKAnnotationView *annView in arr) {
        
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
        delay += .03;
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

@end
