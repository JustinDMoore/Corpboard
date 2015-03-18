//
//  CBTourMapViewController.h
//  CorpBoard
//
//  Created by Justin Moore on 3/13/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SlideNavigationController.h"
#import <Parse/Parse.h>
#import "CBTourMapMenuViewController.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface CBTourMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, mapMenuProtocol, SlideNavigationControllerDelegate> {
    
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *arrayOfShowsToDisplay;

@end
