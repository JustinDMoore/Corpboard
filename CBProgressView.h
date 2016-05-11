//
//  CBProgressView.h
//  CorpBoard
//
//  Created by Isaias Favela on 11/22/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KVNProgress.h"

@protocol ProgressProtocol <NSObject>
@required
-(void)progressComplete;
-(void)tick;
@end

@interface CBProgressView : UIView {
    id delegate;
}
@property (nonatomic, strong) IBOutlet UIView *viewProgress;
@property (nonatomic, strong) IBOutlet UILabel *lblFactHeader;
@property (nonatomic, strong) IBOutlet UILabel *lblFact;
@property (nonatomic, weak) NSTimer *tmrProgress;

-(void)setDelegate:(id)newDelegate;
-(void)startProgress;
-(void)completeProgress;
-(void)errorProgress:(NSString *)error;
-(void)setFact:(NSString*)fact;

@end
