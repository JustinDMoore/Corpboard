//
//  CBProblemDescribe.m
//  CorpBoard
//
//  Created by Isaias Favela on 1/4/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBProblemDescribe.h"

@implementation CBProblemDescribe

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        self.txtProblem.placeholder = @"Briefly explain what happened...";
        self.txtProblem.placeholderColor = [UIColor lightGrayColor];
        self.txtProblem.textColor = [UIColor whiteColor];
    }
    return self;
}

@end
