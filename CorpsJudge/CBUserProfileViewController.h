//
//  CBUserProfileViewController.h
//  CorpBoard
//
//  Created by Isaias Favela on 12/10/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "CBUserCategories.h"
#import "CBChooseCorp.h"
#import "CBEditName.h"
#import "CBEditDescription.h"
#import "CBCorpExperienceList.h"
#import "MWPhotoBrowser.h"

@interface CBUserProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CBUserCategoriesProtocol, UIScrollViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, corpExperienceProtocol, editNameProtocol, editDescriptionProtocol, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, corpExperienceListProtocol, MWPhotoBrowserDelegate> {
    
}

@property (nonatomic, strong) NSMutableArray *arrayOfPhotos;
@property (nonatomic, strong) NSMutableArray *arrayOfThumbs;
@property (weak, nonatomic) PFUser *userProfile;

-(void)setUser:(PFUser*)user;
@end
