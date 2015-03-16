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
    annotationView.image = [UIImage imageNamed:@"pin"];
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}



@end
