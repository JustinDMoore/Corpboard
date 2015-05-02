//
//  CBSegueNoAnimation.m
//  CorpBoard
//
//  Created by Justin Moore on 5/1/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBSegueNoAnimation.h"

@implementation CBSegueNoAnimation

-(void) perform {
    //[[[self sourceViewController] navigationController] pushViewController:[self   destinationViewController] animated:NO];
    [[[self sourceViewController] navigationController] presentViewController:[self destinationViewController] animated:NO completion:nil];
}

@end
