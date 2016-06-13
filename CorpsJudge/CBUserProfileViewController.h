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
#import "CBSelectCoverPhoto.h"

@interface CBUserProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CBUserCategoriesProtocol, UIScrollViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, corpExperienceProtocol, editNameProtocol, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, corpExperienceListProtocol, photoProtocol, UIAlertViewDelegate> {
    
}

@property (nonatomic) BOOL fromPrivate;
@property (nonatomic, strong) NSMutableArray *arrayOfPhotos;
@property (nonatomic, strong) NSMutableArray *arrayOfSelections;
@property (weak, nonatomic) PFUser *userProfile;

-(void)setUser:(PFUser*)user;
@end
