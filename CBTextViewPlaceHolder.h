//
//  CBTextViewPlaceHolder.h
//  CorpBoard
//
//  Created by Justin Moore on 7/6/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBTextViewPlaceHolder : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;


@end
