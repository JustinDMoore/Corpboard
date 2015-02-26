//
//  CBPhoto.h
//  CorpBoard
//
//  Created by Justin Moore on 2/25/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@protocol BugPhotoProtocol <NSObject>
@required
-(void)imageClosed;
@end

@interface CBPhoto : UIView {
    id delegate;
}

@property (nonatomic, strong) IBOutlet PFImageView *imgView;
@property (nonatomic, strong) PFFile *imgFile;
-(void)showInParent:(CGRect)parent;
-(void)setDelegate:(id)newDelegate;
@end
