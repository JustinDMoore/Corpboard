//
//  CBAboutCorpsViewController.h
//  CorpBoard
//
//  Created by Justin Moore on 12/27/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CBAboutCorpsViewController : UIViewController
@property (nonatomic, strong) NSString *about;
@property (weak, nonatomic) IBOutlet UITextView *lblAbout;

@end
