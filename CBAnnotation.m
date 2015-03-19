//
//  CBAnnotation.m
//  CorpBoard
//
//  Created by Justin Moore on 3/15/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBAnnotation.h"

@implementation CBAnnotation

-(id)initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location {
    
    self = [super init];
    
    if (self) {
        _title = newTitle;
        _coordinate = location;
    }
    
    return self;
}

-(MKAnnotationView *)annotationView {
    
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self
                                                                    reuseIdentifier:@"MyCustomAnnotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    if ([self.title isEqualToString:@"Tour of Champions"]) {
        annotationView.image = [UIImage imageNamed:@"goldstar"];
        annotationView.frame = CGRectMake(annotationView.frame.origin.x, annotationView.frame.origin.y, 40, 40);
    } else if ([self.title containsString:@"World Championship"]) {
        annotationView.image = [UIImage imageNamed:@"champs"];
        annotationView.frame = CGRectMake(annotationView.frame.origin.x, annotationView.frame.origin.y, 55, 45);
    } else {
        annotationView.image = [UIImage imageNamed:@"bluedot"];
        annotationView.frame = CGRectMake(annotationView.frame.origin.x, annotationView.frame.origin.y, 25, 25);
    }

    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}



@end
