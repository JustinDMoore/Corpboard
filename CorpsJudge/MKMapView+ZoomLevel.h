//
//  MKMapView+ZoomLevels.h
//  CorpBoard
//
//  Created by Justin Moore on 3/19/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end