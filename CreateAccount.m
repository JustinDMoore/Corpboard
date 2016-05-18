//
//  CreateAccount.m
//  CorpBoard
//
//  Created by Isaias Favela on 11/22/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//


#import "CreateAccount.h"

#import "AFNetworking.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "KVNProgress.h"

#import "AppConstant.h"
#import "pushnotification.h"
#import "utilities.h"

#import "ParseErrors.h"
#import "Corpsboard-Swift.h"


@implementation CreateAccount

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
    return self;
}

- (IBAction)btnBack_clicked:(id)sender {
    [self dismissView];
}

#pragma mark
#pragma mark - Facebook
#pragma mark
- (IBAction)btnFacebook_clicked:(id)sender {
    
//    [PFFacebookUtils logInInBackgroundWithReadPermissions:@[@"email", @"user_friends"] block:^(PFUser *user, NSError *error) {
//        if (user != nil) {
//            if (user[PF_USER_FACEBOOKID] == nil) {
//                [self requestFacebook:user];
//            } else {
//                [self userLoggedIn:user];
//            }
//        } else {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[ParseErrors getErrorStringForCode:error.code] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//    }];
    
    NSArray *permissionsArray = @[ @"email", @"user_friends"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
            [self dismissView];
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            [self requestFacebook:user];
        } else {
            NSLog(@"User logged in through Facebook!");
                    [self dismissView];
        }
    }];
}

- (void)requestFacebook:(PFUser *)user {

    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (error == nil) {
            NSDictionary *userData = (NSDictionary *)result;
            [self processFacebook:user UserData:userData];
        } else {
            [PFUser logOut];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[ParseErrors getErrorStringForCode:error.code] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

- (void)processFacebook:(PFUser *)user UserData:(NSDictionary *)userData {
    
    NSString *link = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", userData[@"id"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:link]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFImageResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        UIImage *image = (UIImage *)responseObject;
        
        if (image.size.width > 140) image = ResizeImage(image, 140, 140);
        
        PFFile *filePicture = [PFFile fileWithName:@"picture.jpg" data:UIImageJPEGRepresentation(image, 0.6)];
        [filePicture saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error != nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[ParseErrors getErrorStringForCode:error.code] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
        
        if (image.size.width > 30) image = ResizeImage(image, 30, 30);
        
        PFFile *fileThumbnail = [PFFile fileWithName:@"thumbnail.jpg" data:UIImageJPEGRepresentation(image, 0.6)];
        [fileThumbnail saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error != nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[ParseErrors getErrorStringForCode:error.code] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
        
        user[@"email"] = userData[@"email"];
        user[PF_USER_EMAILCOPY] = userData[@"email"];
        user[PF_USER_FULLNAME] = userData[@"name"];
        user[PF_USER_FULLNAME_LOWER] = [userData[@"name"] lowercaseString];
        user[PF_USER_FACEBOOKID] = userData[@"id"];
        user[PF_USER_PICTURE] = filePicture;
        user[PF_USER_THUMBNAIL] = fileThumbnail;
        user[@"lastLogin"] = [NSDate date];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error == nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [KVNProgress dismiss];
                });
                
                [self userLoggedIn:user];
            } else {
                [PFUser logOut];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[ParseErrors getErrorStringForCode:error.code] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         [PFUser logOut];
                                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[ParseErrors getErrorStringForCode:error.code] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                         [alert show];
                                     }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
}

- (void)userLoggedIn:(PFUser *)user {
    //FIXME: Add nickname to this view. Make sure it's unique.
    ParsePushUserAssign();
    BOOL needsNickname = NO;
    NSString *nickname = user[@"nickname"];
    if (![nickname length]) needsNickname = YES;
}

-(void)showInParent:(UINavigationController *)parentNav {
    
    
    //BUTTON
    //set button bottom corners round
    UIBezierPath *shapePath = [UIBezierPath bezierPathWithRoundedRect:self.btnSignUp.bounds
                                                    byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                          cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.btnSignUp.bounds;
    shapeLayer.path = shapePath.CGPath;
    shapeLayer.fillColor = UISingleton.sharedInstance.gold.CGColor;
    [self.btnSignUp.layer insertSublayer:shapeLayer below:self.btnSignUp.imageView.layer];

    //set dialog top rounded corners
    UIBezierPath *shapePath2 = [UIBezierPath bezierPathWithRoundedRect:self.viewDialog.bounds
                                                    byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                          cornerRadii:CGSizeMake(10.0, 10.0)];
    
    
    //DIALOG VIEW
    CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
    shapeLayer2.frame = self.viewDialog.bounds;
    shapeLayer2.path = shapePath2.CGPath;
    shapeLayer2.strokeColor = UIColor.whiteColor.CGColor;
    shapeLayer2.fillColor = UISingleton.sharedInstance.maroon.CGColor;
    [self.viewDialog.layer insertSublayer:shapeLayer2 below:self.lblMessage.layer];
    
    //set image and button tint colors to match app
    self.btnImage.tintColor = UISingleton.sharedInstance.gold;
    [self.btnSignUp setBackgroundColor:UIColor.clearColor];
    self.btnSignUp.tintColor = UISingleton.sharedInstance.maroon;
    
    
    //add top border line on button
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.btnSignUp.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.btnSignUp addSubview:lineView];
    
    self.viewDialog.backgroundColor = UIColor.clearColor;
    [self bringSubviewToFront:self.lblMessage];
    
    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    self.backgroundColor = [UIColor clearColor];

    self.viewContainer.alpha = 0;
    self.btnSignUp.alpha = 0;
    
    [parentNav.view addSubview:self];
    [UIView animateWithDuration:0.25
                          delay:0.0
         usingSpringWithDamping:.9
          initialSpringVelocity:.7
                        options:0
                     animations:^{
                         self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                     } completion:^(BOOL finished){
                         
                         self.viewContainer.transform = CGAffineTransformScale(self.viewDialog.transform, 0.8, 0.8);
                         
                         [UIView animateWithDuration:0.25
                                               delay:0
                              usingSpringWithDamping:0.6
                               initialSpringVelocity:0.7
                                             options:0
                                          animations:^{
                                              self.viewContainer.alpha = 1;
                                              self.viewContainer.transform = CGAffineTransformIdentity;
                                              
                                          } completion:^(BOOL finished) {

                                          }];
                         
                         self.btnSignUp.frame = CGRectMake(self.btnSignUp.frame.origin.x, self.btnSignUp.frame.origin.y - self.btnSignUp.frame.size.height, self.btnSignUp.frame.size.width, self.btnSignUp.frame.size.height);
                         
                         [UIView animateWithDuration:0.25
                                               delay:0.05
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              
                                              self.btnSignUp.alpha = 1;
                                              self.btnSignUp.frame = CGRectMake(self.btnSignUp.frame.origin.x, self.btnSignUp.frame.origin.y + self.btnSignUp.frame.size.height, self.btnSignUp.frame.size.width, self.btnSignUp.frame.size.height);
                                              
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                     }];
}


-(void)dismissView {
    
    [UIView animateWithDuration:0.25
                          delay:0.09
         usingSpringWithDamping:1
          initialSpringVelocity:.7
                        options:0
                     animations:^{
                         self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.frame.size.width, self.frame.size.height);
                     } completion:^(BOOL finished){
                         
                         [self removeFromSuperview];

                     }];
}

@end
