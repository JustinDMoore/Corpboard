//
//  UINavigationController+Orientation.m
//  CorpsJudge
//
//  Created by Isaias Favela on 6/23/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "UINavigationController+Orientation.h"

@implementation UINavigationController (Orientation)

-(NSUInteger)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

-(BOOL)shouldAutorotate
{
    return YES;
}

@end
