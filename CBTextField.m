//
//  CBTextField.m
//  CorpBoard
//
//  Created by Justin Moore on 12/14/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBTextField.h"

@implementation CBTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)caretRectForPosition:(UITextPosition *)position {
    return self.caretEnabled ? [super caretRectForPosition:position] : CGRectZero;
}

@end
