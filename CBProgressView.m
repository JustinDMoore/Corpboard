//
//  CBProgressView.m
//  CorpBoard
//
//  Created by Isaias Favela on 11/22/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBProgressView.h"

@implementation CBProgressView

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        self.clipsToBounds = YES;

    }
    return self;
}

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

@end
