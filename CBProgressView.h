//
//  CBProgressView.h
//  CorpBoard
//
//  Created by Isaias Favela on 11/22/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProgressProtocol <NSObject>

@end

@interface CBProgressView : UIView {
    id delegate;
}

-(void)setDelegate:(id)newDelegate;

@end
