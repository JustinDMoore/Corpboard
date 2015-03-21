//
//  CBAnnotation.m
//  CorpBoard
//
//  Created by Justin Moore on 3/15/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBAnnotation.h"

@implementation CBAnnotation

-(id)initWithTitle:(NSString *)newTitle andSubTitle:(NSString *)subtitle atLocation:(CLLocationCoordinate2D)location {
    
    self = [super init];
    
    if (self) {
        _title = newTitle;
        _coordinate = location;
        _subtitle = subtitle;
    }
    
    return self;
}

-(MKAnnotationView *)annotationView {
    
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self
                                                                    reuseIdentifier:@"MyCustomAnnotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    if ([self.title containsString:@"Tour of Champions"]) {
        annotationView.image = [UIImage imageNamed:@"goldstar"];
        self.TOC = YES;
        annotationView.frame = CGRectMake(annotationView.frame.origin.x, annotationView.frame.origin.y, 30, 30);
    } else if ([self.title isEqualToString:@"DCI World Championship Finals"] || [self.title isEqualToString:@"DCI World Championship Semifinals"] || [self.title isEqualToString:@"DCI World Championship Prelims"]) {
        self.title = @"DCI World Championships";
        annotationView.image = [UIImage imageNamed:@"champs"];
        self.champs = YES;
        annotationView.frame = CGRectMake(annotationView.frame.origin.x, annotationView.frame.origin.y, 35, 25);
    } else {
        annotationView.image = [UIImage imageNamed:@"bluedot"];
        annotationView.frame = CGRectMake(annotationView.frame.origin.x, annotationView.frame.origin.y, 20, 20);
    }

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    [btn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    
//    UITableViewCell *showArrow = [[UITableViewCell alloc] init];
//    [btn addSubview:showArrow];
//    showArrow.frame = btn.bounds;
//    showArrow.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    showArrow.userInteractionEnabled = NO;
//    showArrow.tintColor = [UIColor redColor];
    
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}



@end
