//
//  CBSelectCoverPhoto.h
//  CorpBoard
//
//  Created by Justin Moore on 12/19/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@protocol photoProtocol <NSObject>

-(void)photoSelected:(UIImage *)photo;
-(void)cameraSelected;

@end

@interface CBSelectCoverPhoto : UIViewController <UITableViewDataSource, UITableViewDelegate> {

}

@property(nonatomic,assign)id delegate;
@end
