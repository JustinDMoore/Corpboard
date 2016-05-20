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

BOOL checkingName = NO;
BOOL linkingFacebook = NO;
Loading *loadView;

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
    return self;
}

- (IBAction)btnBack_clicked:(id)sender {
    [self dismissView:NO canProceed:NO];
}

-(void)setDelegate:(id)newDelegate {
    delegate = newDelegate;
}

#pragma mark
#pragma mark - Facebook
#pragma mark
- (IBAction)btnFacebook_clicked:(id)sender {
    if (!linkingFacebook) {
        linkingFacebook = YES;
        self.btnNotNow.hidden = YES;
        [self load];
        
        [UIView animateWithDuration:0.25
                              delay:0.05
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [self hideButton:self.btnFacebook];
                             [self hideButton:self.btnSignUp];
                         } completion:^(BOOL finished) {
                             NSArray *permissionsArray = @[ @"public_profile", @"email"];
                             
                             
                             // Login PFUser using Facebook
                             [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
                                 if (!user) {
                                     NSLog(@"Uh oh. The user cancelled the Facebook login.");
                                     [self dismissView:NO canProceed:NO];
                                 } else if (user.isNew) {
                                     NSLog(@"User signed up and logged in through Facebook!");
                                     [self requestFacebook:user];
                                 } else {
                                     NSLog(@"User logged in through Facebook!");
                                     if ([self doesUserNeedNickname:user]) [self dismissView:YES canProceed:NO];
                                     else [self dismissView:NO canProceed:YES];
                                 }
                             }];
                         }];
    }
}

- (void)requestFacebook:(PFUser *)user {
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,name,email" forKey:@"fields"];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSDictionary *userData = (NSDictionary *)result;
                 [self processFacebook:user UserData:userData];
             } else {
                 [PFUser logOut];
                 NSLog(@"Error retrieving Facebook profile.");
                 linkingFacebook = NO;
             }
         }];
    }
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
                [self userLoggedIn:user];
            } else {
                [PFUser logOut];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[ParseErrors getErrorStringForCode:error.code] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                linkingFacebook = NO;
            }
        }];
    }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         [PFUser logOut];
                                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[ParseErrors getErrorStringForCode:error.code] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                         [alert show];
                                         linkingFacebook = NO;
                                     }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
}

- (void)userLoggedIn:(PFUser *)user {
    //FIXME: Add nickname to this view. Make sure it's unique.
    ParsePushUserAssign();
    if ([self doesUserNeedNickname:user]) [self dismissView:YES canProceed:NO];
    else [self dismissView:NO canProceed:YES];
}

-(BOOL)doesUserNeedNickname:(PFUser *)user {
    NSString *nickname = user[@"nickname"];
    if (![nickname length]) return YES;
    else return NO;
}

-(void)showView:(NSString *)view InParent:(UINavigationController *)parentNav {
    
    self.alpha = 0;
    self.viewAccountLoading.backgroundColor = UIColor.clearColor;
    self.viewNicknameLoading.backgroundColor = UIColor.clearColor;
    [parentNav.view addSubview:self];
    if ([view isEqualToString:@"account"]) {
        [self showAccountView];
    } else if ([view isEqualToString:@"nickname"]) {
        [self showNicknameView];
    }
}

-(void)load {
    loadView = [[[NSBundle mainBundle] loadNibNamed:@"Loading" owner:self options:nil] objectAtIndex:0];
    if (linkingFacebook) {
        [self.viewAccountLoading addSubview:loadView];
    }
    
    if (checkingName) {
        [self.viewNicknameLoading addSubview:loadView];
    }
    [loadView animate];
}

-(void)stopLoad {
    if (loadView) {
        [loadView removeFromSuperview];
        loadView = nil;
    }
}

-(void)dismissView:(BOOL)needsNickname canProceed:(BOOL)proceed {
    
    [UIView animateWithDuration:0.25
                          delay:0.09
         usingSpringWithDamping:1
          initialSpringVelocity:.7
                        options:0
                     animations:^{
                         self.viewContainer.transform = CGAffineTransformScale(self.viewContainer.transform, 0.0, 0.0);
                         self.viewContainerNickname.transform = CGAffineTransformScale(self.viewContainerNickname.transform, 0.0, 0.0);
                         if (!needsNickname) self.alpha = 0;
                     } completion:^(BOOL finished){
                         
                         [self stopLoad];
                         if (!needsNickname) {
                            [self removeFromSuperview];
                         } else {
                             [self showNicknameView];
                         }
                         if (proceed) {
                             if ([delegate respondsToSelector:@selector(accountCreated)]) {
                                 [delegate accountCreated];
                             }
                         }
                     }];
}

-(void)showAccountView {
    linkingFacebook = NO;
    self.viewContainer.backgroundColor = UIColor.clearColor;
    self.viewContainerNickname.alpha = 0;
    
    //hide nickname view
    self.viewContainerNickname.alpha = 0;
    
    //DIALOG VIEW
    //set dialog top rounded corners
    UIBezierPath *shapePath2 = [UIBezierPath bezierPathWithRoundedRect:self.viewDialog.bounds
                                                     byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                           cornerRadii:CGSizeMake(10.0, 10.0)];
    
    
    
    CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
    shapeLayer2.frame = self.viewDialog.bounds;
    shapeLayer2.path = shapePath2.CGPath;
    shapeLayer2.strokeColor = UIColor.whiteColor.CGColor;
    shapeLayer2.fillColor = UISingleton.sharedInstance.maroon.CGColor;
    [self.viewDialog.layer insertSublayer:shapeLayer2 below:self.lblMessage.layer];
    
    self.viewDialog.backgroundColor = UIColor.clearColor;
    //[self bringSubviewToFront:self.lblMessage];
    
    //BUTTON
    //set button bottom corners round
    UIBezierPath *shapePath = [UIBezierPath bezierPathWithRoundedRect:self.btnSignUp.bounds
                                                    byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                          cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.btnSignUp.bounds;
    shapeLayer.path = shapePath.CGPath;
    shapeLayer.fillColor = UISingleton.sharedInstance.gold.CGColor;
    shapeLayer.strokeColor = UISingleton.sharedInstance.gold.CGColor;
    shapeLayer.lineWidth = 1.0;
    [self.btnSignUp.layer insertSublayer:shapeLayer below:self.btnSignUp.imageView.layer];
    
    //set image and button tint colors to match app
    self.btnImage.tintColor = UISingleton.sharedInstance.gold;
    [self.btnSignUp setBackgroundColor:UIColor.clearColor];
    self.btnSignUp.tintColor = UISingleton.sharedInstance.maroon;
    self.btnFacebook.tintColor = UISingleton.sharedInstance.maroon;
    
    //add top border line on button
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.btnSignUp.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.btnSignUp addSubview:lineView];
    
    
    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    self.backgroundColor = [UIColor clearColor];
    
    self.viewContainer.alpha = 0;
    self.btnSignUp.alpha = 0;
    self.btnFacebook.alpha = 0;
    
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.alpha = 0;
    
    
    [UIView animateWithDuration:0.50
                          delay:0.0
         usingSpringWithDamping:.9
          initialSpringVelocity:.7
                        options:0
                     animations:^{
                         
                     } completion:^(BOOL finished){
                         
                         self.viewContainer.transform = CGAffineTransformScale(self.viewDialog.transform, 0.8, 0.8);
                         
                         [UIView animateWithDuration:0.25
                                               delay:0
                              usingSpringWithDamping:0.6
                               initialSpringVelocity:0.7
                                             options:0
                                          animations:^{
                                              self.alpha = 1;
                                              self.viewContainer.alpha = 1;
                                              self.viewContainer.transform = CGAffineTransformIdentity;
                                              
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                         
                         self.btnSignUp.frame = CGRectMake(self.btnSignUp.frame.origin.x, self.btnSignUp.frame.origin.y - self.btnSignUp.frame.size.height, self.btnSignUp.frame.size.width, self.btnSignUp.frame.size.height);
                         self.btnFacebook.frame = CGRectMake(self.btnFacebook.frame.origin.x, self.btnFacebook.frame.origin.y - self.btnSignUp.frame.size.height, self.btnFacebook.frame.size.width, self.btnFacebook.frame.size.height);
                         
                         [UIView animateWithDuration:0.25
                                               delay:0.05
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              
                                              [self showButton:self.btnSignUp];
                                              
                                              [self showButton:self.btnFacebook];
                                              
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                     }];
}

-(void)showNicknameView {
    
    self.btnNotNow.hidden = NO;
    checkingName = NO;
    self.viewContainerNickname.backgroundColor = UIColor.clearColor;
    self.viewContainer.alpha = 0;
    self.txtNickname.layer.borderWidth = 0;
    
    //DIALOG VIEW
    //set dialog top rounded corners
    UIBezierPath *shapePath2 = [UIBezierPath bezierPathWithRoundedRect:self.viewDialogNickname.bounds
                                                     byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                           cornerRadii:CGSizeMake(10.0, 10.0)];
    
    
    
    CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
    shapeLayer2.frame = self.viewDialogNickname.bounds;
    shapeLayer2.path = shapePath2.CGPath;
    shapeLayer2.strokeColor = UIColor.whiteColor.CGColor;
    shapeLayer2.fillColor = UISingleton.sharedInstance.maroon.CGColor;
    [self.viewDialogNickname.layer insertSublayer:shapeLayer2 below:self.lblNicknameTitle.layer];
    
    self.viewDialogNickname.backgroundColor = UIColor.clearColor;
    //[self bringSubviewToFront:self.lblMessage];
    
    //BUTTON
    //set button bottom corners round
    UIBezierPath *shapePath = [UIBezierPath bezierPathWithRoundedRect:self.btnCheckName.bounds
                                                    byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                          cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.btnCheckName.bounds;
    shapeLayer.path = shapePath.CGPath;
    shapeLayer.fillColor = UISingleton.sharedInstance.gold.CGColor;
    shapeLayer.strokeColor = UISingleton.sharedInstance.gold.CGColor;
    shapeLayer.lineWidth = 1.0;
    [self.btnCheckName.layer insertSublayer:shapeLayer below:self.btnCheckName.imageView.layer];
    
    //set image and button tint colors to match app
    self.btnImageNickname.tintColor = UISingleton.sharedInstance.gold;
    [self.btnCheckName setBackgroundColor:UIColor.clearColor];
    self.btnCheckName.tintColor = UISingleton.sharedInstance.maroon;
    
    //add top border line on button
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.btnCheckName.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.btnCheckName addSubview:lineView];
    
    
    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    self.backgroundColor = [UIColor clearColor];
    
    self.viewContainerNickname.alpha = 0;
    self.btnCheckName.alpha = 0;
    
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

    [UIView animateWithDuration:0.50
                          delay:0.0
         usingSpringWithDamping:.9
          initialSpringVelocity:.7
                        options:0
                     animations:^{
                         
                     } completion:^(BOOL finished){
                         
                         self.viewContainerNickname.transform = CGAffineTransformScale(self.viewDialog.transform, 0.8, 0.8);
                         
                         [UIView animateWithDuration:0.25
                                               delay:0
                              usingSpringWithDamping:0.6
                               initialSpringVelocity:0.7
                                             options:0
                                          animations:^{
                                              self.alpha = 1;
                                              self.viewContainerNickname.alpha = 1;
                                              self.viewContainerNickname.transform = CGAffineTransformIdentity;
                                              
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                         
                         self.btnCheckName.frame = CGRectMake(self.btnCheckName.frame.origin.x, self.btnCheckName.frame.origin.y - self.btnCheckName.frame.size.height, self.btnCheckName.frame.size.width, self.btnCheckName.frame.size.height);
                         
                         [UIView animateWithDuration:0.25
                                               delay:0.05
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              
                                              [self showButton:self.btnCheckName];
                                              
                                          } completion:^(BOOL finished) {
                                              [self.txtNickname becomeFirstResponder];
                                          }];
                     }];
}

-(void)checkUniqueNickname {
    
    if (!checkingName) {
        if (![self.txtNickname.text length]) {
            [self shake: NO];
            return;
        } else {
            [self.txtNickname resignFirstResponder];
            
            [UIView animateWithDuration:0.25
                                  delay:0.05
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 
                                 [self hideButton:self.btnCheckName];
                                 
                             } completion:^(BOOL finished) {
                                 
                             }];

            checkingName = YES;
            [self load];
            PFQuery *query = [PFQuery queryWithClassName:@"_User"];
            [query whereKey:@"nickname" equalTo:self.txtNickname.text];
            [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
                if (!error) {
                    if (count > 0) {
                        [self shake: YES];
                    } else {
                        PFUser *user = [PFUser currentUser];
                        user[@"nickname"] = self.txtNickname.text;
                        [user saveInBackground];
                        [self stopLoad];
                        [self dismissView:NO canProceed:YES];
                    }
                } else {
                    [self shake: YES];
                }
            }];
        }
    }
}

-(void)hideButton:(UIButton *)button {
    button.alpha = 0;
    button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y - self.btnSignUp.frame.size.height, button.frame.size.width, button.frame.size.height);
}

-(void)showButton:(UIButton *)button {
    button.alpha = 1;
    button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y + self.btnSignUp.frame.size.height, button.frame.size.width, button.frame.size.height);
}

- (void)shake:(BOOL)moveButton {
    [self stopLoad];
    [UIView animateWithDuration:0.25
                          delay:0.05
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         if (moveButton) {
                             [self showButton:self.btnCheckName];
                         }
                     } completion:^(BOOL finished) {
                         [self.txtNickname becomeFirstResponder];
                     }];
    

    checkingName = NO;
    CAKeyframeAnimation * anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
    anim.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f) ], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f) ] ] ;
    anim.autoreverses = YES ;
    anim.repeatCount = 3.0f ;
    anim.duration = 0.04f ;
    
    [self.viewContainerNickname.layer addAnimation:anim forKey:nil] ;
}

- (IBAction)btnCheckName:(id)sender {
    [self checkUniqueNickname];
}


@end
