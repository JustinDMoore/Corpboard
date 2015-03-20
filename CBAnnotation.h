//
//  CBAnnotation.h
//  CorpBoard
//
//  Created by Justin Moore on 3/15/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface CBAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) PFObject *show;
@property (nonatomic) BOOL champs;
@property (nonatomic) BOOL TOC;

-(id)initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location;
-(MKAnnotationView *)annotationView;

@end
