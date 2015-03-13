//
//  CBTourMapViewController.h
//  CorpBoard
//
//  Created by Justin Moore on 3/13/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CBTourMapViewController : UIViewController <MKMapViewDelegate, MKAnnotation>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
