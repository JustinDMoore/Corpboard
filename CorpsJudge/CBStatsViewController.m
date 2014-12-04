//
//  CBStatsViewController.m
//  CorpsBoard
//
//  Created by Isaias Favela on 6/23/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBStatsViewController.h"
#import <Parse/Parse.h>
#import <Parse/Parse.h>
#import "NSDate+Utilities.h"
#import "UserScore.h"
#import "CBSingle.h"
#import "CSAppDelegate.h"

CSAppDelegate *appDel;
CBSingle *data;
NSTimer *timer;
PFQuery *queryUserRanks;
PFQuery *queryOfficialHornlineScores;
PFQuery *queryUserHornlineRanks;
PFQuery *queryUserPercussionRanks;
PFQuery *queryUserColorguardRanks;
PFQuery *queryUserLoudestRanks;
PFQuery *queryUserFavorites;

int totalWorldHornlineVotes, totalOpenHornlineVotes;
int totalWorldPercussionVotes, totalOpenPercussionVotes;
int totalWorldColorguardVotes, totalOpenColorguardVotes;
int totalWorldLoudestVotes, totalOpenLoudestVotes;
int totalWorldFavoriteCorpsVotes, totalOpenFavoriteCorpsVotes;


typedef enum : int {
    phaseScore = 0,
    phaseBestdrums = 1,
    phaseBesthornline = 2,
    phaseLoudesthornline = 3,
    phaseBestguard = 4,
    phaseFavorite = 5
} phase;

@interface CBStatsViewController ()
- (IBAction)btnInfo_clicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UILabel *lblactivity;

@property (weak, nonatomic) IBOutlet UITableView *tableCorps;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (nonatomic, strong) NSMutableArray *arrayOfOpenClass;
@property (weak, nonatomic) IBOutlet UIButton *btnInfo;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentOfficial;
@property (nonatomic) phase scorePhase;
@property (weak, nonatomic) IBOutlet UILabel *lblActivity2;

@property (nonatomic, strong) NSMutableArray *arrayOfWorldFavs;
@property (nonatomic, strong) NSMutableArray *arrayOfOpenFavs;

@property (nonatomic, strong) NSMutableArray *arrayOfWorldHornlineFavs;
@property (nonatomic, strong) NSMutableArray *arrayOfOpenHornlineFavs;

@property (nonatomic, strong) NSMutableArray *arrayOfWorldPercussionFavs;
@property (nonatomic, strong) NSMutableArray *arrayOfOpenPercussionFavs;

@property (nonatomic, strong) NSMutableArray *arrayOfWorldColorguardFavs;
@property (nonatomic, strong) NSMutableArray *arrayOfOpenColorguardFavs;

@property (nonatomic, strong) NSMutableArray *arrayOfWorldLoudestFavs;
@property (nonatomic, strong) NSMutableArray *arrayOfOpenLoudestFavs;


@end

@implementation CBStatsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:NO animated:NO];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"BackArrow"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initVariables];
    [self initUI];

    [self startTimer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"Notification"
                                               object:nil];

}

- (void) receiveNotification:(NSNotification *) notification
{
    if (self.scorePhase == phaseBesthornline) {
        for (UITableViewCell *cell in [self.tableCorps visibleCells])
        {
            UIView *block = (UIView *)[cell viewWithTag:2];
            CGRect newFrame = CGRectMake(block.frame.origin.x, block.frame.origin.y, 2.8, block.frame.size.height); // different frame width
            [UIView animateWithDuration:0.5 animations:^{
                
                block.frame = newFrame; // where block is the custom subview
                [block setNeedsDisplay];
            }];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [queryUserRanks cancel];
    [queryOfficialHornlineScores cancel];
    [queryUserHornlineRanks cancel];

}

-(void)checkForCorps {
    
    if (data.updatedCorps) {
        [timer invalidate];
        [self getAllCorps];
    }
}

-(void)startTimer {
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.5
                                             target:self
                                           selector:@selector(checkForCorps)
                                           userInfo:nil
                                            repeats:YES];
}

-(void)initVariables {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableCorps.hidden = YES;
    self.scorePhase = phaseScore;
    self.segmentOfficial.userInteractionEnabled = NO;
    self.tabBar.userInteractionEnabled = NO;
    self.lblactivity.hidden = NO;
    self.lblActivity2.hidden = NO;
    self.activity.hidden = NO;
}

-(void)initUI {
    
    self.segmentOfficial.tintColor = appDel.appTintColor;
    self.btnInfo.tintColor = appDel.appTintColor;
    [self.activity startAnimating];
    [self.segmentOfficial addTarget:self
                             action:@selector(officialChanged)
                   forControlEvents:UIControlEventValueChanged];
    
    UITabBarItem *item = [self.tabBar.items objectAtIndex:0];
    [self.tabBar setSelectedItem:item];
}

-(void)officialChanged {
    if (!isDoneSortingFavorites) {
        self.tableCorps.hidden = YES;
        self.activity.hidden = NO;
        [self.activity startAnimating];
        self.lblactivity.hidden = NO;
        self.lblActivity2.hidden = NO;
    }
    [self sortScores];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getAllCorps {
    
    //all votes for best caption
    if ([data.arrayOfAllFavorites count]) {
        [self sortAllFavorites];
    } else {
        [self getAllFavorites];
    }
    
//    if (![data.arrayofWorldHornlineVotes count]) {
//        for (PFObject *corps in data.arrayOfAllCorps) {
//            BOOL isWorld = [corps[@"isWorldClass"] boolValue];
//            if (isWorld) [self getUserHornlineRankForCorps:corps];
//        }
//    }
//    
//    if (![data.arrayofOpenHornlineVotes count]) {
//        for (PFObject *corps in data.arrayOfAllCorps) {
//            BOOL isWorld = [corps[@"isWorldClass"] boolValue];
//            if (!isWorld) [self getUserHornlineRankForCorps:corps];
//        }
//    }
//    
//    if (![data.arrayofWorldPercussionVotes count]) {
//        for (PFObject *corps in data.arrayOfAllCorps) {
//            BOOL isWorld = [corps[@"isWorldClass"] boolValue];
//            if (isWorld) [self getUserPercussionRankForCorps:corps];
//        }
//    }
//    
//    if (![data.arrayofOpenPercussionVotes count]) {
//        for (PFObject *corps in data.arrayOfAllCorps) {
//            BOOL isWorld = [corps[@"isWorldClass"] boolValue];
//            if (!isWorld) [self getUserPercussionRankForCorps:corps];
//        }
//    }
//    
//    if (![data.arrayofWorldColorguardVotes count]) {
//        for (PFObject *corps in data.arrayOfAllCorps) {
//            BOOL isWorld = [corps[@"isWorldClass"] boolValue];
//            if (isWorld) [self getUserColorguardRankForCorps:corps];
//        }
//    }
//    
//    if (![data.arrayofOpenColorguardVotes count]) {
//        for (PFObject *corps in data.arrayOfAllCorps) {
//            BOOL isWorld = [corps[@"isWorldClass"] boolValue];
//            if (!isWorld) [self getUserColorguardRankForCorps:corps];
//        }
//    }
//    
//    if (![data.arrayofWorldLoudestVotes count]) {
//        for (PFObject *corps in data.arrayOfAllCorps) {
//            BOOL isWorld = [corps[@"isWorldClass"] boolValue];
//            if (isWorld) [self getUserLoudestRankForCorps:corps];
//        }
//    }
//    
//    if (![data.arrayofOpenLoudestVotes count]) {
//        for (PFObject *corps in data.arrayOfAllCorps) {
//            BOOL isWorld = [corps[@"isWorldClass"] boolValue];
//            if (!isWorld) [self getUserLoudestRankForCorps:corps];
//        }
//    }
//    
//    if (![data.arrayofWorldFavorites count]) {
//        for (PFObject *corps in data.arrayOfAllCorps) {
//            BOOL isWorld = [corps[@"isWorldClass"] boolValue];
//            if (isWorld) [self getUserFavoritesForCorps:corps];
//        }
//    }
//    
//    if (![data.arrayofOpenFavorites count]) {
//        for (PFObject *corps in data.arrayOfAllCorps) {
//            BOOL isWorld = [corps[@"isWorldClass"] boolValue];
//            if (!isWorld) [self getUserFavoritesForCorps:corps];
//        }
//    }
    
    //for user rankings
    for (PFObject *corps in data.arrayOfAllCorps) {
        
        [self getUserRankForCorps:corps];
        
    }
    
    [self sortScores];
}

-(void)getAllFavorites {
    
    PFQuery *allFavorites = [PFQuery queryWithClassName:@"favorites"];
    [allFavorites includeKey:@"corps"];
    [allFavorites findObjectsInBackgroundWithTarget:self selector:@selector(sortAllFavorites:error:)];
}

-(void)sortAllFavorites:(NSArray *)objects error:(NSError *)error {
    
    if ([objects count]) {
        [data.arrayOfAllFavorites addObjectsFromArray:objects];
        [self sortAllFavorites];
    } else {
        NSLog(@"Error getting user votes: %@ %@", error, [error userInfo]);
    }
    
}

bool isDoneSortingFavorites = NO;
-(void)sortAllFavorites {
    
    if ([data.arrayOfAllFavorites count]) {
        
        for (PFObject *fav in data.arrayOfAllFavorites) {
            
            BOOL isWorld = [fav[@"isWorldClass"] boolValue];
            
            if ([fav[@"category"] isEqualToString:@"Favorite Hornline"]) {
                
                if (isWorld) {
                    totalWorldHornlineVotes++;
                    [data.arrayOfWorldHornlineVotes addObject:fav];
                }
                else {
                    totalOpenHornlineVotes++;
                    [data.arrayOfOpenHornlineVotes addObject:fav];
                }
                
            } else if ([fav[@"category"] isEqualToString:@"Favorite Drums"]) {
                
                if (isWorld) {
                    totalWorldPercussionVotes++;
                    [data.arrayOfWorldPercussionVotes addObject:fav];
                }
                else {
                    totalOpenPercussionVotes++;
                    [data.arrayOfOpenPercussionVotes addObject:fav];
                }
            } else if ([fav[@"category"] isEqualToString:@"Favorite Colorguard"]) {
                
                if (isWorld) {
                    totalWorldColorguardVotes++;
                    [data.arrayofWorldColorguardVotes addObject:fav];
                }
                else {
                    totalOpenColorguardVotes++;
                    [data.arrayofOpenColorguardVotes addObject:fav];
                }
            } else if ([fav[@"category"] isEqualToString:@"Loudest Hornline"]) {
                
                if (isWorld) {
                    totalWorldLoudestVotes++;
                    [data.arrayofWorldLoudestVotes addObject:fav];
                }
                else {
                    totalOpenLoudestVotes++;
                    [data.arrayofOpenLoudestVotes addObject:fav];
                }
                
            } else if ([fav[@"category"] isEqualToString:@"Favorite Corps"]) {
                
                if (isWorld) {
                    totalWorldFavoriteCorpsVotes++;
                    [data.arrayofWorldFavorites addObject:fav];
                }
                else {
                    totalOpenFavoriteCorpsVotes++;
                    [data.arrayofOpenFavorites addObject:fav];
                }
            }
        }
        
        
        //now we have the favorites seperated into arrays by category
        //now go through each corps and count the votes
       
      
        for (PFObject *corps in data.arrayOfWorldClass) {
            
            //world favs
            {
                int score = 0;
                for (PFObject *fav in data.arrayofWorldFavorites) {
                    if ([fav[@"corpsName"] isEqualToString: corps[@"corpsName"]]) {
                        score++;
                    }
                }
                if (score > 0) {
                    UserScore *uc = [[UserScore alloc] init];
                    uc.corpsName = corps[@"corpsName"];
                    uc.score = score;
                    [self.arrayOfWorldFavs addObject:uc];
                }
            }
        
            //world hornline favs
            {
                int score = 0;
                for (PFObject *fav in data.arrayOfWorldHornlineVotes) {
                    if ([fav[@"corpsName"] isEqualToString: corps[@"corpsName"]]) {
                        score++;
                    }
                }
                if (score > 0) {
                    UserScore *uc = [[UserScore alloc] init];
                    uc.corpsName = corps[@"corpsName"];
                    uc.score = score;
                    [self.arrayOfWorldHornlineFavs addObject:uc];
                }
            }
            
            //world percussion favs
            {
                int score = 0;
                for (PFObject *fav in data.arrayOfWorldPercussionVotes) {
                    if ([fav[@"corpsName"] isEqualToString: corps[@"corpsName"]]) {
                        score++;
                    }
                }
                if (score > 0) {
                    UserScore *uc = [[UserScore alloc] init];
                    uc.corpsName = corps[@"corpsName"];
                    uc.score = score;
                    [self.arrayOfWorldPercussionFavs addObject:uc];
                }
            }
            
            //world colorguard favs
            {
                int score = 0;
                for (PFObject *fav in data.arrayofWorldColorguardVotes) {
                    if ([fav[@"corpsName"] isEqualToString: corps[@"corpsName"]]) {
                        score++;
                    }
                }
                if (score > 0) {
                    UserScore *uc = [[UserScore alloc] init];
                    uc.corpsName = corps[@"corpsName"];
                    uc.score = score;
                    [self.arrayOfWorldColorguardFavs addObject:uc];
                }
            }
            
            //world loudest
            {
                int score = 0;
                for (PFObject *fav in data.arrayofWorldLoudestVotes) {
                    if ([fav[@"corpsName"] isEqualToString: corps[@"corpsName"]]) {
                        score++;
                    }
                }
                if (score > 0) {
                    UserScore *uc = [[UserScore alloc] init];
                    uc.corpsName = corps[@"corpsName"];
                    uc.score = score;
                    [self.arrayOfWorldLoudestFavs addObject:uc];
                }
            }
        }
        
        for (PFObject *corps in data.arrayOfOpenClass) {
         
            
            //open favs
            {
                int score = 0;
                for (PFObject *fav in data.arrayofOpenFavorites) {
                    if ([fav[@"corpsName"] isEqualToString: corps[@"corpsName"]]) {
                        score++;
                    }
                }
                if (score > 0) {
                    UserScore *uc = [[UserScore alloc] init];
                    uc.corpsName = corps[@"corpsName"];
                    uc.score = score;
                    [self.arrayOfOpenFavs addObject:uc];
                }
            }
            
            //open hornline favs
            {
                int score = 0;
                for (PFObject *fav in data.arrayOfOpenHornlineVotes) {
                    if ([fav[@"corpsName"] isEqualToString: corps[@"corpsName"]]) {
                        score++;
                    }
                }
                if (score > 0) {
                    UserScore *uc = [[UserScore alloc] init];
                    uc.corpsName = corps[@"corpsName"];
                    uc.score = score;
                    [self.arrayOfOpenHornlineFavs addObject:uc];
                }
            }
            
            //open percussion favs
            {
                int score = 0;
                for (PFObject *fav in data.arrayOfOpenPercussionVotes) {
                    if ([fav[@"corpsName"] isEqualToString: corps[@"corpsName"]]) {
                        score++;
                    }
                }
                if (score > 0) {
                    UserScore *uc = [[UserScore alloc] init];
                    uc.corpsName = corps[@"corpsName"];
                    uc.score = score;
                    [self.arrayOfOpenPercussionFavs addObject:uc];
                }
            }
            
            //open colorguard favs
            {
                int score = 0;
                for (PFObject *fav in data.arrayofOpenColorguardVotes) {
                    if ([fav[@"corpsName"] isEqualToString: corps[@"corpsName"]]) {
                        score++;
                    }
                }
                if (score > 0) {
                    UserScore *uc = [[UserScore alloc] init];
                    uc.corpsName = corps[@"corpsName"];
                    uc.score = score;
                    [self.arrayOfOpenColorguardFavs addObject:uc];
                }
            }
            
            //open loudest
            {
                int score = 0;
                for (PFObject *fav in data.arrayofOpenLoudestVotes) {
                    if ([fav[@"corpsName"] isEqualToString: corps[@"corpsName"]]) {
                        score++;
                    }
                }
                if (score > 0) {
                    UserScore *uc = [[UserScore alloc] init];
                    uc.corpsName = corps[@"corpsName"];
                    uc.score = score;
                    [self.arrayOfOpenLoudestFavs addObject:uc];
                }
            }
        }
       
        [self.activity stopAnimating];
        self.activity.hidden = YES;
        self.lblactivity.hidden = YES;
        self.lblActivity2.hidden = YES;
        self.tableCorps.hidden = NO;
        [self sortScores];
        isDoneSortingFavorites = YES;
        
    }

}


-(int)getNumberOfFavoritesForCorps:(PFObject *)corps forArray:(NSMutableArray *)array {
    
    int results;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"corps == %@", corps]];
    [array filterUsingPredicate:predicate];
    results = (int)[data.arrayOfAllFavorites count];
    return results;
}

-(void)getUserRankForCorps:(PFObject *)corps {
    
    queryUserRanks = [PFQuery queryWithClassName:@"scores"];
    [queryUserRanks whereKey:@"isOfficial" equalTo:[NSNumber numberWithBool:NO]];
    [queryUserRanks whereKey:@"corps" equalTo:corps];
    [queryUserRanks whereKeyExists:@"score"];
    [queryUserRanks orderByDescending:@"showDate"];
    [queryUserRanks setLimit:100];
    [queryUserRanks includeKey:@"corps"];
    
    [queryUserRanks findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (![array count]) return ;
        double scoresTotal = 0;
        for (PFObject *obj in array) {
            double i = [obj[@"score"] doubleValue];
            scoresTotal += i;
        }
        double grand = scoresTotal / [array count];
        PFObject *score = [array objectAtIndex:0];
        UserScore *us = [[UserScore alloc] init];
        us.corpsName = score[@"corpsName"];
        us.score = grand;
        BOOL isWorld = [score[@"isWorldClass"] boolValue];
        if (isWorld) [data.arrayOfUserWorldClassRankings addObject:us];
        else [data.arrayOfUserOpenClassRankings addObject:us];
    }];
}

-(void)getUserHornlineRankForCorps:(PFObject *)corps {
    
    queryUserHornlineRanks = [PFQuery queryWithClassName:@"favorites"];
    [queryUserHornlineRanks whereKey:@"corps" equalTo:corps];
    [queryUserHornlineRanks whereKey:@"category" equalTo:@"Favorite Hornline"];
    [queryUserHornlineRanks findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0) {
            UserScore *us = [[UserScore alloc] init];
            us.corpsName = corps[@"corpsName"];
            us.score = [objects count];
            BOOL isWorld = [corps[@"isWorldClass"] boolValue];
            if (isWorld) [data.arrayOfWorldHornlineVotes addObject:us];
            else [data.arrayOfOpenHornlineVotes addObject:us];
        }
    }];
}

-(void)getUserPercussionRankForCorps:(PFObject *)corps {
    
    queryUserPercussionRanks = [PFQuery queryWithClassName:@"favorites"];
    [queryUserPercussionRanks whereKey:@"corps" equalTo:corps];
    [queryUserPercussionRanks whereKey:@"category" equalTo:@"Favorite Drums"];
    [queryUserPercussionRanks findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0) {
            UserScore *us = [[UserScore alloc] init];
            us.corpsName = corps[@"corpsName"];
            us.score = [objects count];
            BOOL isWorld = [corps[@"isWorldClass"] boolValue];
            if (isWorld) [data.arrayOfWorldPercussionVotes addObject:us];
            else [data.arrayOfOpenPercussionVotes addObject:us];
        }
    }];
}

-(void)getUserColorguardRankForCorps:(PFObject *)corps {
    
    queryUserColorguardRanks = [PFQuery queryWithClassName:@"favorites"];
    [queryUserColorguardRanks whereKey:@"corps" equalTo:corps];
    [queryUserColorguardRanks whereKey:@"category" equalTo:@"Favorite Colorguard"];
    [queryUserColorguardRanks findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0) {
            UserScore *us = [[UserScore alloc] init];
            us.corpsName = corps[@"corpsName"];
            us.score = [objects count];
            BOOL isWorld = [corps[@"isWorldClass"] boolValue];
            if (isWorld) [data.arrayofWorldColorguardVotes addObject:us];
            else [data.arrayofOpenColorguardVotes addObject:us];
        }
    }];
}

-(void)getUserLoudestRankForCorps:(PFObject *)corps {
    
    queryUserLoudestRanks = [PFQuery queryWithClassName:@"favorites"];
    [queryUserLoudestRanks whereKey:@"corps" equalTo:corps];
    [queryUserLoudestRanks whereKey:@"category" equalTo:@"Loudest Hornline"];
    [queryUserLoudestRanks findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0) {
            UserScore *us = [[UserScore alloc] init];
            us.corpsName = corps[@"corpsName"];
            us.score = [objects count];
            BOOL isWorld = [corps[@"isWorldClass"] boolValue];
            if (isWorld) [data.arrayofWorldLoudestVotes addObject:us];
            else [data.arrayofOpenLoudestVotes addObject:us];
        }
    }];
}

-(void)getUserFavoritesForCorps:(PFObject *)corps {
    
    queryUserFavorites = [PFQuery queryWithClassName:@"favorites"];
    [queryUserFavorites whereKey:@"corps" equalTo:corps];
    [queryUserFavorites whereKey:@"category" equalTo:@"Favorite Corps"];
    [queryUserFavorites findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0) {
            UserScore *us = [[UserScore alloc] init];
            us.corpsName = corps[@"corpsName"];
            us.score = [objects count];
            BOOL isWorld = [corps[@"isWorldClass"] boolValue];
            if (isWorld) [data.arrayofWorldFavorites addObject:us];
            else [data.arrayofOpenFavorites addObject:us];
        }
    }];
}

-(BOOL)canWeSort {
    if ([data.arrayOfWorldClass count] > 17) return YES;
    else return NO;
}

-(void)test {
 

}

-(void)sortScores {

    switch (self.scorePhase) {
        {case phaseScore:
            
            if (self.segmentOfficial.selectedSegmentIndex == 0) {
                
                {
                    NSSortDescriptor *sortOfficialScores = [[NSSortDescriptor alloc] initWithKey:@"lastScore" ascending:NO];
                    NSArray *sortOfficialScoresDescriptor = [NSArray arrayWithObject: sortOfficialScores];
                    
                    if ([data.arrayOfWorldClass count]) [data.arrayOfWorldClass sortUsingDescriptors:sortOfficialScoresDescriptor];
                    if ([data.arrayOfOpenClass count]) [data.arrayOfOpenClass sortUsingDescriptors:sortOfficialScoresDescriptor];
                }
            } else if (self.segmentOfficial.selectedSegmentIndex == 1) {
                
                {
                    NSSortDescriptor *sortUserRankings = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
                    NSArray *sortUserRankingsDescriptor = [NSArray arrayWithObject: sortUserRankings];
                    
                    if ([data.arrayOfUserWorldClassRankings count]) [data.arrayOfUserWorldClassRankings sortUsingDescriptors:sortUserRankingsDescriptor];
                    if ([data.arrayOfUserOpenClassRankings count]) [data.arrayOfUserOpenClassRankings sortUsingDescriptors:sortUserRankingsDescriptor];
                }
            }

            break;}
            
        {case phaseBesthornline:
            
            if (self.segmentOfficial.selectedSegmentIndex == 0) {

                {
                    NSSortDescriptor *sortOfficialBrass = [[NSSortDescriptor alloc] initWithKey:@"lastBrass" ascending:NO];
                    NSArray *sortDescriptorsForOfficialBrass = [NSArray arrayWithObject: sortOfficialBrass];
                    
                    if ([data.arrayOfWorldClass count]) [data.arrayOfWorldClass sortUsingDescriptors:sortDescriptorsForOfficialBrass];
                    if ([data.arrayOfOpenClass count]) [data.arrayOfOpenClass sortUsingDescriptors:sortDescriptorsForOfficialBrass];
                }
            } else if (self.segmentOfficial.selectedSegmentIndex == 1) {
                
                {
                    NSSortDescriptor *sortUserHornline = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
                    NSArray *sortDescriptorForUserHornline = [NSArray arrayWithObject: sortUserHornline];
                    
                    if ([self.arrayOfWorldHornlineFavs count]) [self.arrayOfWorldHornlineFavs sortUsingDescriptors:sortDescriptorForUserHornline];
                    if ([self.arrayOfOpenHornlineFavs count]) [self.arrayOfOpenHornlineFavs sortUsingDescriptors:sortDescriptorForUserHornline];
                    
                }
            }
            
            break;}
            
        {case phaseBestdrums:
            
            if (self.segmentOfficial.selectedSegmentIndex == 0) {
                
                {
                    NSSortDescriptor *sortOfficialPercussion = [[NSSortDescriptor alloc] initWithKey:@"lastPercussion" ascending:NO];
                    NSArray *sortDescriptorsForOfficialPercussion = [NSArray arrayWithObject: sortOfficialPercussion];
                    
                    if ([data.arrayOfWorldClass count]) [data.arrayOfWorldClass sortUsingDescriptors:sortDescriptorsForOfficialPercussion];
                    if ([data.arrayOfOpenClass count]) [data.arrayOfOpenClass sortUsingDescriptors:sortDescriptorsForOfficialPercussion];
                }
            } else if (self.segmentOfficial.selectedSegmentIndex == 1) {
                
                {
                    NSSortDescriptor *sortUserPercussion = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
                    NSArray *sortDescriptorForUserPercussion = [NSArray arrayWithObject: sortUserPercussion];
                    
                    if ([self.arrayOfWorldPercussionFavs count]) [self.arrayOfWorldPercussionFavs sortUsingDescriptors:sortDescriptorForUserPercussion];
                    if ([self.arrayOfOpenPercussionFavs count]) [self.arrayOfOpenPercussionFavs sortUsingDescriptors:sortDescriptorForUserPercussion];
                }
            }
    
            break;}
            
            
        {case phaseBestguard:
            
            if (self.segmentOfficial.selectedSegmentIndex == 0) {
                
                {
                    NSSortDescriptor *sortOfficialColorguard = [[NSSortDescriptor alloc] initWithKey:@"lastColorguard" ascending:NO];
                    NSArray *sortDescriptorsForOfficialColorguard = [NSArray arrayWithObject: sortOfficialColorguard];
                    
                    if ([data.arrayOfWorldClass count]) [data.arrayOfWorldClass sortUsingDescriptors:sortDescriptorsForOfficialColorguard];
                    if ([data.arrayOfOpenClass count]) [data.arrayOfOpenClass sortUsingDescriptors:sortDescriptorsForOfficialColorguard];
                }
            } else if (self.segmentOfficial.selectedSegmentIndex == 1) {
                
                {
                    NSSortDescriptor *sortUserColorguardVotes = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
                    NSArray *sortDescriptorsForUserColorguardVotes = [NSArray arrayWithObject: sortUserColorguardVotes];
                    
                    if ([self.arrayOfWorldColorguardFavs count]) [self.arrayOfWorldColorguardFavs sortUsingDescriptors:sortDescriptorsForUserColorguardVotes];
                    if ([self.arrayOfOpenColorguardFavs count]) [self.arrayOfOpenColorguardFavs sortUsingDescriptors:sortDescriptorsForUserColorguardVotes];
                }
            }
            
            break;}
            
        {case phaseLoudesthornline:
            //only index 1 - there is no index 0
            if (self.segmentOfficial.selectedSegmentIndex == 1) {
                
                {
                    NSSortDescriptor *sortLoudestHornline = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
                    NSArray *sortDescriptorsForLoudestHornline = [NSArray arrayWithObject: sortLoudestHornline];
                    
                    if ([self.arrayOfWorldLoudestFavs count]) [self.arrayOfWorldLoudestFavs sortUsingDescriptors:sortDescriptorsForLoudestHornline];
                    if ([self.arrayOfOpenLoudestFavs count]) [self.arrayOfOpenLoudestFavs sortUsingDescriptors:sortDescriptorsForLoudestHornline];
                }
            }
        break;}
            
        {case phaseFavorite:
            
            //only index 1 - there is no index 0
            if (self.segmentOfficial.selectedSegmentIndex == 1) {
                
                {
                    NSSortDescriptor *sortFavoriteCorps = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
                    NSArray *sortDescriptorsForFavoriteCorps = [NSArray arrayWithObject: sortFavoriteCorps];
                    
                    if ([self.arrayOfWorldFavs count]) [self.arrayOfWorldFavs sortUsingDescriptors:sortDescriptorsForFavoriteCorps];
                    if ([self.arrayOfOpenFavs count]) [self.arrayOfOpenFavs sortUsingDescriptors:sortDescriptorsForFavoriteCorps];
                }
            }
            
            break;}
    
        default:
            break;
    }
    
    self.segmentOfficial.userInteractionEnabled = YES;
    self.tabBar.userInteractionEnabled = YES;
    self.tableCorps.hidden = NO;
    self.lblactivity.hidden = YES;
    self.lblActivity2.hidden = YES;
    self.activity.hidden = YES;
    [self.activity stopAnimating];
    [self reloadTable];
}

#pragma mark - TableView

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.scorePhase == phaseLoudesthornline) {
        if (self.segmentOfficial.selectedSegmentIndex == 0) {
            return 0;
        }
    }
    
    if (self.scorePhase == phaseFavorite) {
        if (self.segmentOfficial.selectedSegmentIndex == 0) {
            return 0;
        }
    }
    
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0: return @"World Class";
        case 1: return @"Open Class";
        default: return @"Error";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (self.scorePhase) {
            
        case phaseScore:
            
            if (self.segmentOfficial.selectedSegmentIndex == 0) {
                
                if (section == 0) {
                    if ([data.arrayOfWorldClass count]) return [data.arrayOfWorldClass count];
                } else if (section ==1) {
                    
                    if ([data.arrayOfOpenClass count]) return [data.arrayOfOpenClass count];
                }
            } else if (self.segmentOfficial.selectedSegmentIndex == 1) {
                
                if (section == 0) {
                    if ([data.arrayOfUserWorldClassRankings count]) return [data.arrayOfUserWorldClassRankings count];
                } else if (section == 1) {
                    
                    if ([data.arrayOfUserOpenClassRankings count]) return [data.arrayOfUserOpenClassRankings count];
                }
            }
            break;
            
        case phaseBesthornline:
            
            if (self.segmentOfficial.selectedSegmentIndex == 0) {
                
                if (section == 0) {
                    
                    if ([data.arrayOfWorldClass count]) return [data.arrayOfWorldClass count];
                } else if (section ==1) {
                    
                    if ([data.arrayOfOpenClass count]) return [data.arrayOfOpenClass count];
                }
            } else if (self.segmentOfficial.selectedSegmentIndex == 1) {
                
                if (section == 0) {
                    
                    if ([self.arrayOfWorldHornlineFavs count]) return [self.arrayOfWorldHornlineFavs count];
                } else if (section ==1) {
                    
                    if ([self.arrayOfOpenHornlineFavs count]) return [self.arrayOfOpenHornlineFavs count];
                }
            }
            break;
            
        case phaseBestdrums:
            
            if (self.segmentOfficial.selectedSegmentIndex == 0) {
                
                if (section == 0) {
                    
                    if ([data.arrayOfWorldClass count]) return [data.arrayOfWorldClass count];
                } else if (section ==1) {
                    
                    if ([data.arrayOfOpenClass count]) return [data.arrayOfOpenClass count];
                }
            } else if (self.segmentOfficial.selectedSegmentIndex == 1) {
                
                if (section == 0) {
                    
                    if ([self.arrayOfWorldPercussionFavs count]) return [self.arrayOfWorldPercussionFavs count];
                } else if (section ==1) {
                    
                    if ([self.arrayOfOpenPercussionFavs count]) return [self.arrayOfOpenPercussionFavs count];
                }
            }
            
            break;
            
        case phaseBestguard:
            
            if (self.segmentOfficial.selectedSegmentIndex == 0) {
                
                if (section == 0) {
                    
                    if ([data.arrayOfWorldClass count]) return [data.arrayOfWorldClass count];
                } else if (section ==1) {
                    
                    if ([data.arrayOfOpenClass count]) return [data.arrayOfOpenClass count];
                }
            }  else if (self.segmentOfficial.selectedSegmentIndex == 1) {
                
                if (section == 0) {
                    
                    if ([self.arrayOfWorldColorguardFavs count]) return [self.arrayOfWorldColorguardFavs count];
                } else if (section ==1) {
                    
                    if ([self.arrayOfOpenColorguardFavs count]) return [self.arrayOfOpenColorguardFavs count];
                }
            }

            break;
            
        case phaseLoudesthornline:
            
            if (self.segmentOfficial.selectedSegmentIndex == 0) {
                
                if (section == 0) {
                    
                    return 0;
                }
                
            }  else if (self.segmentOfficial.selectedSegmentIndex == 1) {
                
                if (section == 0) {
                    
                    if ([self.arrayOfWorldLoudestFavs count]) return [self.arrayOfWorldLoudestFavs count];
                } else if (section ==1) {
                    
                    if ([self.arrayOfOpenLoudestFavs count]) return [self.arrayOfOpenLoudestFavs count];
                }
            }
            
            break;
            
        case phaseFavorite:
            
            if (self.segmentOfficial.selectedSegmentIndex == 0) {
                
                if (section == 0) {
                    
                    return 0;
                }
                
            }  else if (self.segmentOfficial.selectedSegmentIndex == 1) {
                
                if (section == 0) {
                    
                    if ([self.arrayOfWorldFavs count]) return [self.arrayOfWorldFavs count];
                } else if (section ==1) {
                    
                    if ([self.arrayOfOpenFavs count]) return [self.arrayOfOpenFavs count];
                }
            }
            
            break;
        default:
            return 0;
            break;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell;
    UILabel *lblCorpsName;
    UILabel *lblScore;
    UILabel *lblDay;
    UILabel *lblPercent;
    UILabel *lblRank;
    UIView *bar;
    UILabel *lbldiff;

    int barWidth = 0;
    NSMutableArray *array;
    switch (self.scorePhase) {
            
        case phaseScore:
            
            if (self.segmentOfficial.selectedSegmentIndex == 0) { //OFFICIAL
                
                if (indexPath.section == 0) array = data.arrayOfWorldClass;
                if (indexPath.section == 1) array = data.arrayOfOpenClass;
                
                cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"officialRank"];
                lblCorpsName = (UILabel *)[cell viewWithTag:1];
                lblScore = (UILabel *)[cell viewWithTag:2];
                lblDay = (UILabel *)[cell viewWithTag:3];
                lblRank = (UILabel *)[cell viewWithTag:4];
                lbldiff = (UILabel *)[cell viewWithTag:5];
                
                PFObject *corps;
                if ([array count]) corps = [array objectAtIndex:indexPath.row];
                
                if (corps) {
                    lblRank.text = [NSString stringWithFormat:@"%li", (long)indexPath.row + 1];
                    lblCorpsName.text = corps[@"corpsName"];
                    lblScore.text = corps[@"lastScore"];
                    
                    float newScore = [corps[@"lastScore"] floatValue];
                    float oldScore = [corps[@"olderScore"] floatValue];
                    float difference = newScore - oldScore;
                    
                    if (difference > 0) {
                        [lbldiff setTextColor:[self darkerColorForColor:[UIColor greenColor]]];
                        lbldiff.text = [NSString stringWithFormat:@"+%.2f", difference];
                    } else if (difference < 0) {
                        [lbldiff setTextColor:[UIColor redColor]];
                        lbldiff.text = [NSString stringWithFormat:@"%.2f", difference];
                    } else {
                        [lbldiff setTextColor:[UIColor lightGrayColor]];
                        lbldiff.text = @"";
                    }
                    
                    NSDate *showD = corps[@"lastScoreDate"];
                    if ([showD isToday]) lblDay.text = @"Today";
                    else if ([showD isYesterday]) lblDay.text = @"Yesterday";
                    else {
                        NSInteger days = [showD daysBeforeDate:[NSDate date]];
                        if (days > 5) {
                            NSDateFormatter *format = [[NSDateFormatter alloc] init];
                            [format setDateFormat:@"MMMM d"];
                            
                            NSString *dateString = [format stringFromDate:corps[@"lastScoreDate"]];
                            lblDay.text = [NSString stringWithFormat:@"%@", dateString];
                        } else if (days > 1) {
                            lblDay.text = [NSString stringWithFormat:@"%li days ago", (long)days];
                        }
                        else if (days <= 0) {
                            lblDay.text = @"";
                        }else lblDay.text = [NSString stringWithFormat:@"%li day ago", (long)days];
                    }
                }
            } else { // USER REVIEWS
                
                if (indexPath.section == 0) array = data.arrayOfUserWorldClassRankings;
                if (indexPath.section == 1) array = data.arrayOfUserOpenClassRankings;
                
                cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"userScore"];
                lblRank = (UILabel *)[cell viewWithTag:1];
                lblCorpsName = (UILabel *)[cell viewWithTag:2];
                lblScore = (UILabel *)[cell viewWithTag:3];
                
                UserScore *us;
                if ([array count]) us = [array objectAtIndex:indexPath.row];
                if (us) {
                    lblRank.text = [NSString stringWithFormat:@"%li", (long)indexPath.row + 1];
                    lblCorpsName.text = us.corpsName;
                    lblScore.text = [NSString stringWithFormat:@"%.2f", us.score];
                }
            }
            break;
            
        case phaseBesthornline:
            
            if (self.segmentOfficial.selectedSegmentIndex == 0) { //OFFICIAL
                
                if (indexPath.section == 0) array = data.arrayOfWorldClass;
                if (indexPath.section == 1) array = data.arrayOfOpenClass;
                
                cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"userScore"];
                lblCorpsName = (UILabel *)[cell viewWithTag:2];
                lblScore = (UILabel *)[cell viewWithTag:3];
                lblRank = (UILabel *)[cell viewWithTag:1];
                
                PFObject *score;
                if ([array count]) score = [array objectAtIndex:indexPath.row];
                
                if (score) {
                    lblRank.text = [NSString stringWithFormat:@"%li", (long)indexPath.row + 1];
                    lblCorpsName.text = score[@"corpsName"];
                    lblScore.text = score[@"lastBrass"];
                }
            } else { // USER REVIEWS
            
                if (indexPath.section == 0) array = self.arrayOfWorldHornlineFavs;
                if (indexPath.section == 1) array = self.arrayOfOpenHornlineFavs;
                
                cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"vote"];
                lblCorpsName = (UILabel *)[cell viewWithTag:1];
                bar = (UIView *)[cell.contentView viewWithTag:2];
                lblPercent = (UILabel *)[cell viewWithTag:3];
                
                UserScore *score;
                if ([array count]) score = [array objectAtIndex:indexPath.row];
                
                if (score) {
                    lblRank.text = [NSString stringWithFormat:@"%li", (long)indexPath.row + 1];
                    lblCorpsName.text = score.corpsName;
                    //calculate percentage
                    float result = 0.0;
                    if (indexPath.section == 0) result = (score.score/totalWorldHornlineVotes) * 100;
                    if (indexPath.section == 1) result = (score.score/totalOpenHornlineVotes) * 100;
                    lblPercent.text = [NSString stringWithFormat:@"%.2f%@", result, @"%"];
                    barWidth = 2.8 * result;
                }
            }
            
            break;
  
        case phaseBestdrums:
            
            if (self.segmentOfficial.selectedSegmentIndex == 0) { //OFFICIAL
                
                if (indexPath.section == 0) array = data.arrayOfWorldClass;
                if (indexPath.section == 1) array = data.arrayOfOpenClass;
                
                cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"userScore"];
                lblCorpsName = (UILabel *)[cell viewWithTag:2];
                lblScore = (UILabel *)[cell viewWithTag:3];
                lblRank = (UILabel *)[cell viewWithTag:1];
                
                PFObject *score;
                if ([array count]) score = [array objectAtIndex:indexPath.row];
                
                if (score) {
                    lblRank.text = [NSString stringWithFormat:@"%li", (long)indexPath.row + 1];
                    lblCorpsName.text = score[@"corpsName"];
                    lblScore.text = score[@"lastPercussion"];
                }
            } else if (self.segmentOfficial.selectedSegmentIndex == 1) {
                
                if (indexPath.section == 0) array = self.arrayOfWorldPercussionFavs;
                if (indexPath.section == 1) array = self.arrayOfOpenPercussionFavs;
                
                cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"vote"];
                lblCorpsName = (UILabel *)[cell viewWithTag:1];
                bar = (UIView *)[cell.contentView viewWithTag:2];
                lblPercent = (UILabel *)[cell viewWithTag:3];
                
                UserScore *score;
                if ([array count]) score = [array objectAtIndex:indexPath.row];
                
                if (score) {
                    lblRank.text = [NSString stringWithFormat:@"%li", (long)indexPath.row + 1];
                    lblCorpsName.text = score.corpsName;
                    //calculate percentage
                    float result = 0.0;
                    if (indexPath.section == 0) result = (score.score/totalWorldPercussionVotes) * 100;
                    if (indexPath.section == 1) result = (score.score/totalOpenPercussionVotes) * 100;
                    lblPercent.text = [NSString stringWithFormat:@"%.2f%@", result, @"%"];
                    barWidth = 2.8 * result;
                }
            }
            
            break;
            
        case phaseBestguard:
            
            if (self.segmentOfficial.selectedSegmentIndex == 0) { //OFFICIAL
                
                if (indexPath.section == 0) array = data.arrayOfWorldClass;
                if (indexPath.section == 1) array = data.arrayOfOpenClass;
                
                cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"userScore"];
                lblCorpsName = (UILabel *)[cell viewWithTag:2];
                lblScore = (UILabel *)[cell viewWithTag:3];
                lblRank = (UILabel *)[cell viewWithTag:1];
                
                PFObject *score;
                if ([array count]) score = [array objectAtIndex:indexPath.row];
                
                if (score) {
                    lblRank.text = [NSString stringWithFormat:@"%li", (long)indexPath.row + 1];
                    lblCorpsName.text = score[@"corpsName"];
                    lblScore.text = score[@"lastColorguard"];
                }
            } else if (self.segmentOfficial.selectedSegmentIndex == 1) {
                
                if (indexPath.section == 0) array = self.arrayOfWorldColorguardFavs;
                if (indexPath.section == 1) array = self.arrayOfOpenColorguardFavs;
                
                cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"vote"];
                lblCorpsName = (UILabel *)[cell viewWithTag:1];
                bar = (UIView *)[cell.contentView viewWithTag:2];
                lblPercent = (UILabel *)[cell viewWithTag:3];
                
                UserScore *score;
                if ([array count]) score = [array objectAtIndex:indexPath.row];
                
                if (score) {
                    lblRank.text = [NSString stringWithFormat:@"%li", (long)indexPath.row + 1];
                    lblCorpsName.text = score.corpsName;
                    //calculate percentage
                    float result = 0.0;
                    if (indexPath.section == 0) result = (score.score/totalWorldColorguardVotes) * 100;
                    if (indexPath.section == 1) result = (score.score/totalOpenColorguardVotes) * 100;
                    lblPercent.text = [NSString stringWithFormat:@"%.2f%@", result, @"%"];
                    barWidth = 2.8 * result;
                }
            }
            
            break;
            
        case phaseLoudesthornline:
            
            if (self.segmentOfficial.selectedSegmentIndex == 1) {
                
                if (indexPath.section == 0) array = self.arrayOfWorldLoudestFavs;
                if (indexPath.section == 1) array = self.arrayOfOpenLoudestFavs;
                
                cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"vote"];
                lblCorpsName = (UILabel *)[cell viewWithTag:1];
                bar = (UIView *)[cell.contentView viewWithTag:2];
                lblPercent = (UILabel *)[cell viewWithTag:3];
                
                UserScore *score;
                if ([array count]) score = [array objectAtIndex:indexPath.row];
                
                if (score) {
                    lblRank.text = [NSString stringWithFormat:@"%li", (long)indexPath.row + 1];
                    lblCorpsName.text = score.corpsName;
                    //calculate percentage
                    float result = 0.0;
                    if (indexPath.section == 0) result = (score.score/totalWorldLoudestVotes) * 100;
                    if (indexPath.section == 1) result = (score.score/totalOpenLoudestVotes) * 100;
                    lblPercent.text = [NSString stringWithFormat:@"%.2f%@", result, @"%"];
                    barWidth = 2.8 * result;
                }
            }
        
            break;
            
        case phaseFavorite:
            
            if (self.segmentOfficial.selectedSegmentIndex == 1) {
                
                if (indexPath.section == 0) array = self.arrayOfWorldFavs;
                if (indexPath.section == 1) array = self.arrayOfOpenFavs;
                
                cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"vote"];
                lblCorpsName = (UILabel *)[cell viewWithTag:1];
                bar = (UIView *)[cell.contentView viewWithTag:2];
                lblPercent = (UILabel *)[cell viewWithTag:3];
                
                UserScore *score;
                if ([array count]) score = [array objectAtIndex:indexPath.row];
                
                if (score) {
                    lblRank.text = [NSString stringWithFormat:@"%li", (long)indexPath.row + 1];
                    lblCorpsName.text = score.corpsName;
                    //calculate percentage
                    float result = 0.0;
                    if (indexPath.section == 0) result = (score.score/totalWorldFavoriteCorpsVotes) * 100;
                    if (indexPath.section == 1) result = (score.score/totalOpenFavoriteCorpsVotes) * 100;
                    lblPercent.text = [NSString stringWithFormat:@"%.2f%@", result, @"%"];
                    barWidth = 2.8 * result;
                }
            }
            break;
            
        default:
            break;
    }

    UIView *oldBar = (UIView *)[cell viewWithTag:10];
    int oldWidth = 1;
    if (oldBar) {
        if (barWidth == oldBar.frame.size.width) {
            oldWidth = 1;
        } else {
            oldWidth = oldBar.frame.size.width;
        }
        [oldBar removeFromSuperview];
    }
    oldBar = nil;
    
    bar.hidden = YES;
    UIView *bar1 = [[UIView alloc] initWithFrame:CGRectMake(bar.frame.origin.x, bar.frame.origin.y, oldWidth, bar.frame.size.height)];
    bar1.backgroundColor = self.segmentOfficial.tintColor;
    bar1.tag = 10;
    [cell addSubview:bar1];
    
    [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:2 options:0 animations:^{
        bar1.frame = CGRectMake(bar1.frame.origin.x, bar1.frame.origin.y, barWidth, bar1.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
    return cell;
}



- (UIColor *)darkerColorForColor:(UIColor *)c
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.2, 0.0)
                               green:MAX(g - 0.2, 0.0)
                                blue:MAX(b - 0.2, 0.0)
                               alpha:a];
    return nil;
}

-(void)settitle {
    
    if (self.segmentOfficial.selectedSegmentIndex == 0) {
        
        switch (self.scorePhase) {
            case phaseScore:
                self.title = @"Official Rankings";
                break;
            case phaseFavorite:
                self.title = @"Error";
                break;
            case phaseLoudesthornline:
                self.title = @"Error";
                break;
            case phaseBestdrums:
                self.title = @"High Percussion";
                break;
            case phaseBestguard:
                self.title = @"High Colorguard";
                break;
            case phaseBesthornline:
                self.title = @"High Brass";
                break;
                
            default:
                break;
        }
    } else if (self.segmentOfficial.selectedSegmentIndex == 1) {
     
        switch (self.scorePhase) {
            case phaseScore:
                //self.navTitle.title = @"User Rankings";
                break;
            case phaseFavorite:
                self.title = @"User Favorite Show";
                break;
            case phaseLoudesthornline:
                self.title = @"User Loudest Hornline";
                break;
            case phaseBestdrums:
                self.title = @"User Favorite Percussion";
                break;
            case phaseBestguard:
                self.title = @"User Favorite Colorguard";
                break;
            case phaseBesthornline:
                self.title = @"User Favorite Brass";
                break;
                
            default:
                break;
        }
    }
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {

    switch (item.tag) {
        case 0: //rank
            self.scorePhase = phaseScore;
            [self.segmentOfficial setEnabled:YES forSegmentAtIndex:0];
            break;
        case 1: //hornline
            self.scorePhase = phaseBesthornline;
            [self.segmentOfficial setEnabled:YES forSegmentAtIndex:0];
            break;
        case 2: //Percussion
            self.scorePhase = phaseBestdrums;
            [self.segmentOfficial setEnabled:YES forSegmentAtIndex:0];
            break;
        case 3: //Colorguard
            self.scorePhase = phaseBestguard;
            [self.segmentOfficial setEnabled:YES forSegmentAtIndex:0];
            break;
        case 4: //Loudest
            self.scorePhase = phaseLoudesthornline;
            self.segmentOfficial.selectedSegmentIndex = 1;
            [self.segmentOfficial setEnabled:NO forSegmentAtIndex:0];
            break;
        case 5: //Favorite
            self.scorePhase = phaseFavorite;
            self.segmentOfficial.selectedSegmentIndex = 1;
            [self.segmentOfficial setEnabled:NO forSegmentAtIndex:0];
            break;
        default: NSLog(@"Error setting score phase");
            break;
    }
    [self sortScores];
    [self reloadTable];
}

-(void)reloadTable {
    [self.tableCorps reloadData];
}

#pragma mark - Properties

-(NSMutableArray *)arrayOfWorldFavs {
    if (!_arrayOfWorldFavs) {
        _arrayOfWorldFavs = [[NSMutableArray alloc] init];
    }
    return _arrayOfWorldFavs;
}

-(NSMutableArray *)arrayOfOpenFavs {
    if (!_arrayOfOpenFavs) {
        _arrayOfOpenFavs = [[NSMutableArray alloc] init];
    }
    return _arrayOfOpenFavs;
}



-(NSMutableArray *)arrayOfWorldHornlineFavs {
    if (!_arrayOfWorldHornlineFavs) {
        _arrayOfWorldHornlineFavs = [[NSMutableArray alloc] init];
    }
    return _arrayOfWorldHornlineFavs;
}

-(NSMutableArray *)arrayOfOpenHornlineFavs {
    if (!_arrayOfOpenHornlineFavs) {
        _arrayOfOpenHornlineFavs = [[NSMutableArray alloc] init];
    }
    return _arrayOfOpenHornlineFavs;
}



-(NSMutableArray *)arrayOfWorldPercussionFavs {
    if (!_arrayOfWorldPercussionFavs) {
        _arrayOfWorldPercussionFavs = [[NSMutableArray alloc] init];
    }
    return _arrayOfWorldPercussionFavs;
}

-(NSMutableArray *)arrayOfOpenPercussionFavs {
    if (!_arrayOfOpenPercussionFavs) {
        _arrayOfOpenPercussionFavs = [[NSMutableArray alloc] init];
    }
    return _arrayOfOpenPercussionFavs;
}



-(NSMutableArray *)arrayOfWorldColorguardFavs {
    if (!_arrayOfWorldColorguardFavs) {
        _arrayOfWorldColorguardFavs = [[NSMutableArray alloc] init];
    }
    return _arrayOfWorldColorguardFavs;
}

-(NSMutableArray *)arrayOfOpenColorguardFavs {
    if (!_arrayOfOpenColorguardFavs) {
        _arrayOfOpenColorguardFavs = [[NSMutableArray alloc] init];
    }
    return _arrayOfOpenColorguardFavs;
}




-(NSMutableArray *)arrayOfWorldLoudestFavs {
    if (!_arrayOfWorldLoudestFavs) {
        _arrayOfWorldLoudestFavs = [[NSMutableArray alloc] init];
    }
    return _arrayOfWorldLoudestFavs;
}

-(NSMutableArray *)arrayOfOpenLoudestFavs {
    if (!_arrayOfOpenLoudestFavs) {
        _arrayOfOpenLoudestFavs = [[NSMutableArray alloc] init];
    }
    return _arrayOfOpenLoudestFavs;
}
- (IBAction)btnInfo_clicked:(id)sender {
    
    CBRankingsInfoView *myCustomXIBViewObj =
    [[[NSBundle mainBundle] loadNibNamed:@"CBRankingsInfoView"
                                   owner:self
                                 options:nil]
     objectAtIndex:0];
    [self.view addSubview:myCustomXIBViewObj];
    [myCustomXIBViewObj showInParent:self.view.frame];
    
    for (UIView *sub in self.view.subviews) {
        if (![sub isKindOfClass: [CBRankingsInfoView class]]) {
            sub.userInteractionEnabled = NO;
        }
    }
    [myCustomXIBViewObj setDelegate:self];
}

-(void)viewDidClose {
    for (UIView *sub in self.view.subviews) {
        if (![sub isKindOfClass: [CBRankingsInfoView class]]) {
            sub.userInteractionEnabled = YES;
        }
    }
}

@end
