//
//  CBHoleView.h
//  Corpboard
//
//  Created by Isaias Favela on 8/23/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBHoleView : UIView {
    NSArray *rectsArray;
    UIColor *backgroundColor;
}

-(id)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)color andTransparentRects:(NSArray *)rects;

@end
