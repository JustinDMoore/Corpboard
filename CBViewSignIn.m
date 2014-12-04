//
//  CBViewSignIn.m
//  CorpBoard
//
//  Created by Isaias Favela on 11/22/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//


#import "CBViewSignIn.h"

#import "AFNetworking.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "ProgressHUD.h"

#import "AppConstant.h"
#import "pushnotification.h"
#import "utilities.h"

#import "WelcomeView.h"
#import "LoginView.h"
#import "RegisterView.h"

#import "ParseErrors.h"


@implementation CBViewSignIn

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        
    }
    return self;
}

-(void)setTitleMessage:(NSString *)message {
    self.lblTitle.text = message;
}

-(void)setDelegate:(id)newDelegate {
    delegate = newDelegate;
}

- (IBAction)btnBack_clicked:(id)sender {
    [delegate SignInCancelled];
}

#pragma mark
#pragma mark - Facebook
#pragma mark
- (IBAction)btnFacebook_clicked:(id)sender {
//    NSArray *permissions = @[@"email", @"public_profile"];
//    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
//        NSString *nickname;
//        BOOL needsNickname = NO;
//        if (!user) {
//            NSLog(@"Uh oh. The user cancelled the Facebook login.");
//        } else if (user.isNew) {
//            NSLog(@"User signed up and logged in through Facebook!");
//            nickname = user[@"nickname"];
//            if (![nickname length]) needsNickname = YES;
//            [delegate loginSuccessful:needsNickname];
//        } else {
//            NSLog(@"User logged in through Facebook!");
//            nickname = user[@"nickname"];
//            if (![nickname length]) needsNickname = YES;
//            [delegate loginSuccessful:needsNickname];
//        }
//    }];
    
    // ----
    [delegate loggingIn];
    [PFFacebookUtils logInWithPermissions:@[@"public_profile", @"email", @"user_friends"] block:^(PFUser *user, NSError *error) {
        if (user != nil) {
             if (user[PF_USER_FACEBOOKID] == nil) {
                 [self requestFacebook:user];
             } else {
                [self userLoggedIn:user];
             }
         } else {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[ParseErrors getErrorStringForCode:error.code] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [delegate errorLoggingIn];
         }
     }];
}

- (void)requestFacebook:(PFUser *)user {
    
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
         if (error == nil) {
             NSDictionary *userData = (NSDictionary *)result;
             [self processFacebook:user UserData:userData];
         } else {
             [PFUser logOut];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[ParseErrors getErrorStringForCode:error.code] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
             [delegate errorLoggingIn];
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
         [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
              if (error == nil) {
                  [ProgressHUD dismiss];
                  [self userLoggedIn:user];
              } else {
                  [PFUser logOut];
                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[ParseErrors getErrorStringForCode:error.code] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                  [alert show];
                  [delegate errorLoggingIn];
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
    
    ParsePushUserAssign();
    BOOL needsNickname = NO;
    NSString *nickname = user[@"nickname"];
    if (![nickname length]) needsNickname = YES;
    [delegate loginSuccessful:needsNickname];
}

#pragma mark
#pragma mark - Email
#pragma mark

- (IBAction)btnEmail_clicked:(id)sender {
    
    [delegate emailSelected];
}

@end
