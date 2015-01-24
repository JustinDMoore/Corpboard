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

-(void)coverSubmitForApproval:(UIImage *)image;
-(void)coverPhotoObject:(PFObject *)photoObject;
-(void)coverImage:(UIImage *)image;

@end

@interface CBSelectCoverPhoto : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {

}

@property(nonatomic,assign)id delegate;
@end
