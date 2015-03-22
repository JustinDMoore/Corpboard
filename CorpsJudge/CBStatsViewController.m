//
//  CBStatsViewController.m
//  CorpsBoard
//
//  Created by Isaias Favela on 6/23/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBStatsViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "NSDate+Utilities.h"
#import "UserScore.h"
#import "CBSingle.h"
#import "CBAppDelegate.h"
#import "KVNProgress.h"
#import "Configuration.h"

CBAppDelegate *appDel;
CBSingle *data;
PFQuery *queryUserRanks;
PFQuery *queryOfficialHornlineScores;
PFQuery *queryUserHornlineRanks;
PFQuery *queryUserPercussionRanks;
PFQuery *queryUserColorguardRanks;
PFQuery *queryUserLoudestRanks;
PFQuery *queryUserFavorites;

int totalWorldHornlineVotes, totalOpenHornlineVotes, totalAllAgeHornlineVotes;
int totalWorldPercussionVotes, totalOpenPercussionVotes, totalAllAgePercussionVotes;
int totalWorldColorguardVotes, totalOpenColorguardVotes, totalAllAgeColorguardVotes;
int totalWorldLoudestVotes, totalOpenLoudestVotes, totalAllAgeLoudestVotes;
int totalWorldFavoriteCorpsVotes, totalOpenFavoriteCorpsVotes, totalAllAgeFavoriteCorpsVotes;

typedef enum : int {
    phaseScore = 0,
    phaseBestdrums = 1,
    phaseBesthornline = 2,
    phaseLoudesthornline = 3,
    phaseBestguard = 4,
    phaseFavorite = 5
} phase;

@interface CBStatsViewController () {
    BOOL favoritesComplete;
    BOOL scoresComplete;
}

- (IBAction)btnInfo_clicked:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableCorps;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UIButton *btnInfo;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentOfficial;
@property (nonatomic) phase scorePhase;

@property (nonatomic, strong) NSMutableArray *arrayOfWorldFavs;
@property (nonatomic, strong) NSMutableArray *arrayOfOpenFavs;
@property (nonatomic, strong) NSMutableArray *arrayOfAllAgeFavs;

@property (nonatomic, strong) NSMutableArray *arrayOfWorldHornlineFavs;
@property (nonatomic, strong) NSMutableArray *arrayOfOpenHornlineFavs;
@property (nonatomic, strong) NSMutableArray *arrayOfAllAgeHornlineFavs;

@property (nonatomic, strong) NSMutableArray *arrayOfWorldPercussionFavs;
@property (nonatomic, strong) NSMutableArray *arrayOfOpenPercussionFavs;
@property (nonatomic, strong) NSMutableArray *arrayOfAllAgePercussionFavs;

@property (nonatomic, strong) NSMutableArray *arrayOfWorldColorguardFavs;
@property (nonatomic, strong) NSMutableArray *arrayOfOpenColorguardFavs;
@property (nonatomic, strong) NSMutableArray *arrayOfAllAgeColorguardFavs;

@property (nonatomic, strong) NSMutableArray *arrayOfWorldLoudestFavs;
@property (nonatomic, strong) NSMutableArray *arrayOfOpenLoudestFavs;
@property (nonatomic, strong) NSMutableArray *arrayOfAllAgeLoudestFavs;

@end

@implementation CBStatsViewController

#pragma mark
#pragma mark - View Lifecycle
#pragma mark

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

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [queryUserRanks cancel];
    [queryOfficialHornlineScores cancel];
    [queryUserHornlineRanks cancel];
    
    [data.arrayOfAllFavorites removeAllObjects];
    
    [self.arrayOfWorldColorguardFavs removeAllObjects];
    [self.arrayOfWorldFavs removeAllObjects];
    [self.arrayOfWorldHornlineFavs removeAllObjects];
    [self.arrayOfWorldLoudestFavs removeAllObjects];
    [self.arrayOfWorldPercussionFavs removeAllObjects];
    
    [self.arrayOfOpenColorguardFavs removeAllObjects];
    [self.arrayOfOpenFavs removeAllObjects];
    [self.arrayOfOpenHornlineFavs removeAllObjects];
    [self.arrayOfOpenLoudestFavs removeAllObjects];
    [self.arrayOfOpenPercussionFavs removeAllObjects];
    
    [self.arrayOfAllAgeColorguardFavs removeAllObjects];
    [self.arrayOfAllAgeFavs removeAllObjects];
    [self.arrayOfAllAgeHornlineFavs removeAllObjects];
    [self.arrayOfAllAgeLoudestFavs removeAllObjects];
    [self.arrayOfAllAgePercussionFavs removeAllObjects];
    
    [data.arrayofWorldColorguardVotes removeAllObjects];
    [data.arrayofWorldFavorites removeAllObjects];
    [data.arrayOfWorldHornlineVotes removeAllObjects];
    [data.arrayofWorldLoudestVotes removeAllObjects];
    [data.arrayOfWorldPercussionVotes removeAllObjects];
    
    [data.arrayofOpenColorguardVotes removeAllObjects];
    [data.arrayofOpenFavorites removeAllObjects];
    [data.arrayOfOpenHornlineVotes removeAllObjects];
    [data.arrayofOpenLoudestVotes removeAllObjects];
    [data.arrayOfOpenPercussionVotes removeAllObjects];
    
    [data.arrayofAllAgeColorguardVotes removeAllObjects];
    [data.arrayofAllAgeFavorites removeAllObjects];
    [data.arrayOfAllAgeHornlineVotes removeAllObjects];
    [data.arrayofAllAgeLoudestVotes removeAllObjects];
    [data.arrayOfAllAgePercussionVotes removeAllObjects];
    
    rank = 0;
    sort = 0;
    
    self.tableCorps.hidden = YES;
    self.tabBar.userInteractionEnabled = NO;
    self.segmentOfficial.userInteractionEnabled = NO;
    
    totalWorldHornlineVotes = 0;
    totalOpenHornlineVotes = 0;
    totalAllAgeHornlineVotes = 0;
    totalWorldPercussionVotes = 0;
    totalOpenPercussionVotes = 0;
    totalAllAgePercussionVotes = 0;
    totalWorldColorguardVotes = 0;
    totalOpenColorguardVotes = 0;
    totalAllAgeColorguardVotes = 0;
    totalWorldLoudestVotes = 0;
    totalOpenLoudestVotes = 0;
    totalAllAgeLoudestVotes = 0;
    totalWorldFavoriteCorpsVotes = 0;
    totalOpenFavoriteCorpsVotes = 0;
    totalAllAgeFavoriteCorpsVotes = 0;
}


-(void)goback {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress dismiss];
    });
    
    [self.navigationController popViewControllerAnimated:YES];
}

int fetchCount = 0;
-(void)viewDidLoad {
    
    [super viewDidLoad];
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress setConfiguration:[Configuration standardProgressConfig]];
        [KVNProgress showWithStatus:@"Connecting"];
    });
    
    // reset bools for loading
    favoritesComplete = NO;
    scoresComplete = NO;
    
    [self initVariables];
    [self initUI];
    
    [self getAllCorps];
    // get all the favorites from server, then sort them and tally the votes
    [self getAllFavorites];
}

-(void)initVariables {
    
    data = [CBSingle data];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableCorps.hidden = YES;
    self.scorePhase = phaseScore;
    self.segmentOfficial.userInteractionEnabled = NO;
    self.tabBar.userInteractionEnabled = NO;
    
}

-(void)initUI {
    
    self.tableCorps.hidden = YES;
    self.tabBar.userInteractionEnabled = NO;
    self.segmentOfficial.userInteractionEnabled = NO;
    self.segmentOfficial.tintColor = appDel.appTintColor;
    self.btnInfo.tintColor = appDel.appTintColor;
    [self.segmentOfficial addTarget:self
                             action:@selector(officialChanged)
                   forControlEvents:UIControlEventValueChanged];
    
    UITabBarItem *item = [self.tabBar.items objectAtIndex:0];
    [self.tabBar setSelectedItem:item];
}

#pragma mark
#pragma mark - Loading Data
#pragma mark

-(void)getAllFavorites {
    
    PFQuery *allFavorites = [PFQuery queryWithClassName:@"favorites"];
    [allFavorites includeKey:@"corps"];
    [allFavorites findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if ([objects count]) {
                [data.arrayOfAllFavorites removeAllObjects];
                [data.arrayOfAllFavorites addObjectsFromArray:objects];
                [self sortAllFavorites];
            }
        } else {
            NSLog(@"Could not get user favorites.");
        }
    }];
}

-(void)getAllCorps {
    
    //for user rankings
    [data.arrayOfUserWorldClassRankings removeAllObjects];
    [data.arrayOfUserOpenClassRankings removeAllObjects];
    [data.arrayOfUserAllAgeClassRankings removeAllObjects];
    
    for (PFObject *corps in data.arrayOfAllCorps) {
        numC++;
        [corps fetchInBackground];
        [self getUserRankForCorps:corps];
        
    }
}

-(void)sortAllFavorites {
    
    // clear all of the votes
    [data.arrayOfWorldHornlineVotes removeAllObjects];
    [data.arrayOfOpenHornlineVotes removeAllObjects];
    [data.arrayOfAllAgeHornlineVotes removeAllObjects];
    
    [data.arrayOfWorldPercussionVotes removeAllObjects];
    [data.arrayOfOpenPercussionVotes removeAllObjects];
    [data.arrayOfAllAgePercussionVotes removeAllObjects];
    
    [data.arrayofWorldColorguardVotes removeAllObjects];
    [data.arrayofOpenColorguardVotes removeAllObjects];
    [data.arrayofAllAgeColorguardVotes removeAllObjects];
    
    [data.arrayofWorldLoudestVotes removeAllObjects];
    [data.arrayofOpenLoudestVotes removeAllObjects];
    [data.arrayofAllAgeLoudestVotes removeAllObjects];
    
    [data.arrayofWorldFavorites removeAllObjects];
    [data.arrayofOpenFavorites removeAllObjects];
    [data.arrayofAllAgeFavorites removeAllObjects];
    
    // loop through each vote and sort it by category and class
    // keep a tally of the number of votes per category and class to get an average later
    if ([data.arrayOfAllFavorites count]) {
        
        for (PFObject *fav in data.arrayOfAllFavorites) {
            
            NSString *corpClass = fav[@"class"];
            
            if ([fav[@"category"] isEqualToString:@"Favorite Brass"]) {
                
                if ([corpClass isEqualToString:@"World"]) {
                    totalWorldHornlineVotes++;
                    [data.arrayOfWorldHornlineVotes addObject:fav];
                } else if ([corpClass isEqualToString:@"Open"]) {
                    totalOpenHornlineVotes++;
                    [data.arrayOfOpenHornlineVotes addObject:fav];
                } else if ([corpClass isEqualToString:@"All Age"]) {
                    totalAllAgeHornlineVotes++;
                    [data.arrayOfAllAgeHornlineVotes addObject:fav];
                }
                
            } else if ([fav[@"category"] isEqualToString:@"Favorite Drums"]) {
                
                if ([corpClass isEqualToString:@"World"]) {
                    totalWorldPercussionVotes++;
                    [data.arrayOfWorldPercussionVotes addObject:fav];
                } else if ([corpClass isEqualToString:@"Open"]) {
                    totalOpenPercussionVotes++;
                    [data.arrayOfOpenPercussionVotes addObject:fav];
                } else if ([corpClass isEqualToString:@"All Age"]) {
                    totalAllAgePercussionVotes++;
                    [data.arrayOfAllAgePercussionVotes addObject:fav];
                }
            } else if ([fav[@"category"] isEqualToString:@"Favorite Color Guard"]) {
                
                if ([corpClass isEqualToString:@"World"]) {
                    totalWorldColorguardVotes++;
                    [data.arrayofWorldColorguardVotes addObject:fav];
                } else if ([corpClass isEqualToString:@"Open"]) {
                    totalOpenColorguardVotes++;
                    [data.arrayofOpenColorguardVotes addObject:fav];
                } else if ([corpClass isEqualToString:@"All Age"]) {
                    totalAllAgeColorguardVotes++;
                    [data.arrayofAllAgeColorguardVotes addObject:fav];
                }
                
            } else if ([fav[@"category"] isEqualToString:@"Loudest Brass"]) {
                
                if ([corpClass isEqualToString:@"World"]) {
                    totalWorldLoudestVotes++;
                    [data.arrayofWorldLoudestVotes addObject:fav];
                } else if ([corpClass isEqualToString:@"Open"]) {
                    totalOpenLoudestVotes++;
                    [data.arrayofOpenLoudestVotes addObject:fav];
                } else if ([corpClass isEqualToString:@"All Age"]) {
                    totalAllAgeLoudestVotes++;
                    [data.arrayofAllAgeLoudestVotes addObject:fav];
                }
                
            } else if ([fav[@"category"] isEqualToString:@"Favorite Corps"]) {
                
                if ([corpClass isEqualToString:@"World"]) {
                    totalWorldFavoriteCorpsVotes++;
                    [data.arrayofWorldFavorites addObject:fav];
                } else if ([corpClass isEqualToString:@"Open"]) {
                    totalOpenFavoriteCorpsVotes++;
                    [data.arrayofOpenFavorites addObject:fav];
                } else if ([corpClass isEqualToString:@"All Age"]) {
                    totalAllAgeFavoriteCorpsVotes++;
                    [data.arrayofAllAgeFavorites addObject:fav];
                }
            }
        }
        
        // now we have the favorites seperated into arrays by category
        // now go through each corps and count the votes
        
        for (PFObject *corps in data.arrayOfWorldClass) {
            
            //world favs
            {
                int score = 0;
                for (PFObject *fav in data.arrayofWorldFavorites) { // get a corps
                    if ([fav[@"corpsName"] isEqualToString: corps[@"corpsName"]]) { // see if the fav is for that corps
                        score++;  // if so, increment
                    }
                }
                if (score > 0) { // if the final score > 0 (some votes for that corp), create a final score for that corps and that category
                    UserScore *uc = [[UserScore alloc] init];
                    uc.corps = corps;
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
                    uc.corps = corps;
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
                    uc.corps = corps;
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
                    uc.corps = corps;
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
                    uc.corps = corps;
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
                    uc.corps = corps;
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
                    uc.corps = corps;
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
                    uc.corps = corps;
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
                    uc.corps = corps;
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
                    uc.corps = corps;
                    uc.score = score;
                    [self.arrayOfOpenLoudestFavs addObject:uc];
                }
            }
        }
        
        for (PFObject *corps in data.arrayOfAllAgeClass) {
            
            
            //all age favs
            {
                int score = 0;
                for (PFObject *fav in data.arrayofAllAgeFavorites) {
                    if ([fav[@"corpsName"] isEqualToString: corps[@"corpsName"]]) {
                        score++;
                    }
                }
                if (score > 0) {
                    UserScore *uc = [[UserScore alloc] init];
                    uc.corps = corps;
                    uc.score = score;
                    [self.arrayOfAllAgeFavs addObject:uc];
                }
            }
            
            //all age hornline favs
            {
                int score = 0;
                for (PFObject *fav in data.arrayOfAllAgeHornlineVotes) {
                    if ([fav[@"corpsName"] isEqualToString: corps[@"corpsName"]]) {
                        score++;
                    }
                }
                if (score > 0) {
                    UserScore *uc = [[UserScore alloc] init];
                    uc.corps = corps;
                    uc.score = score;
                    [self.arrayOfAllAgeHornlineFavs addObject:uc];
                }
            }
            
            //all age percussion favs
            {
                int score = 0;
                for (PFObject *fav in data.arrayOfAllAgePercussionVotes) {
                    if ([fav[@"corpsName"] isEqualToString: corps[@"corpsName"]]) {
                        score++;
                    }
                }
                if (score > 0) {
                    UserScore *uc = [[UserScore alloc] init];
                    uc.corps = corps;
                    uc.score = score;
                    [self.arrayOfAllAgePercussionFavs addObject:uc];
                }
            }
            
            //all age colorguard favs
            {
                int score = 0;
                for (PFObject *fav in data.arrayofAllAgeColorguardVotes) {
                    if ([fav[@"corpsName"] isEqualToString: corps[@"corpsName"]]) {
                        score++;
                    }
                }
                if (score > 0) {
                    UserScore *uc = [[UserScore alloc] init];
                    uc.corps = corps;
                    uc.score = score;
                    [self.arrayOfAllAgeColorguardFavs addObject:uc];
                }
            }
            
            //all age loudest
            {
                int score = 0;
                for (PFObject *fav in data.arrayofAllAgeLoudestVotes) {
                    if ([fav[@"corpsName"] isEqualToString: corps[@"corpsName"]]) {
                        score++;
                    }
                }
                if (score > 0) {
                    UserScore *uc = [[UserScore alloc] init];
                    uc.corps = corps;
                    uc.score = score;
                    [self.arrayOfAllAgeLoudestFavs addObject:uc];
                }
            }
        }
    }
    
    favoritesComplete = YES;
}

int rank;
int numberOfRanks = 0;
-(void)getUserRankForCorps:(PFObject *)corps {
    
    queryUserRanks = [PFQuery queryWithClassName:@"scores"];
    [queryUserRanks whereKey:@"isOfficial" equalTo:[NSNumber numberWithBool:NO]];
    [queryUserRanks whereKey:@"corps" equalTo:corps];
    [queryUserRanks whereKeyExists:@"score"];
    [queryUserRanks orderByDescending:@"showDate"];
    [queryUserRanks setLimit:100];
    [queryUserRanks includeKey:@"corps"];
    
    
    [queryUserRanks findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        rank++;
        NSLog(@"ranking %i", rank);
        
        
        if (rank == 10) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [KVNProgress updateStatus:@"Getting official scores"];
            });
            
        }
        if (rank == 30) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [KVNProgress updateStatus:@"Getting caption scores"];
            });
            
        }
        if (rank == 50) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [KVNProgress updateStatus:@"Calculating"];
            });
            
        }
        
        if ([array count]) {
            numberOfRanks++;
            double scoresTotal = 0;
            for (PFObject *obj in array) {
                double i = [obj[@"score"] doubleValue];
                scoresTotal += i;
            }
            double grand = scoresTotal / [array count];
            PFObject *score = [array objectAtIndex:0];
            UserScore *us = [[UserScore alloc] init];
            us.corps = score[@"corps"];
            us.score = grand;
            
            if ([score[@"class"] isEqualToString:@"World"]) {
                
                [data.arrayOfUserWorldClassRankings addObject:us];
                
            } else if ([score[@"class"] isEqualToString:@"Open"]) {
                
                [data.arrayOfUserOpenClassRankings addObject:us];
                
            } else if ([score[@"class"] isEqualToString:@"All Age"]) {
                
                [data.arrayOfUserAllAgeClassRankings addObject:us];
                
            }
        }
        
        if (rank >= 57) {
            [self sortScores];
            [self reloadTable];
        }
    }];
}

int numC = 0;

int sort;
-(void)sortScores {
    
    sort++;
    NSLog(@"sorting %i", sort);
    switch (self.scorePhase) {
        {case phaseScore:
            
            if (self.segmentOfficial.selectedSegmentIndex == 0) {
                
                {
                    NSSortDescriptor *sortOfficialScores = [[NSSortDescriptor alloc] initWithKey:@"lastScore" ascending:NO];
                    NSArray *sortOfficialScoresDescriptor = [NSArray arrayWithObject: sortOfficialScores];
                    
                    if ([data.arrayOfWorldClass count]) [data.arrayOfWorldClass sortUsingDescriptors:sortOfficialScoresDescriptor];
                    if ([data.arrayOfOpenClass count]) [data.arrayOfOpenClass sortUsingDescriptors:sortOfficialScoresDescriptor];
                    if ([data.arrayOfAllAgeClass count]) [data.arrayOfAllAgeClass sortUsingDescriptors:sortOfficialScoresDescriptor];
                }
            } else if (self.segmentOfficial.selectedSegmentIndex == 1) {
                
                {
                    NSSortDescriptor *sortUserRankings = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
                    NSArray *sortUserRankingsDescriptor = [NSArray arrayWithObject: sortUserRankings];
                    
                    if ([data.arrayOfUserWorldClassRankings count]) [data.arrayOfUserWorldClassRankings sortUsingDescriptors:sortUserRankingsDescriptor];
                    if ([data.arrayOfUserOpenClassRankings count]) [data.arrayOfUserOpenClassRankings sortUsingDescriptors:sortUserRankingsDescriptor];
                    if ([data.arrayOfUserAllAgeClassRankings count]) [data.arrayOfUserAllAgeClassRankings sortUsingDescriptors:sortUserRankingsDescriptor];
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
                    if ([data.arrayOfAllAgeClass count]) [data.arrayOfAllAgeClass sortUsingDescriptors:sortDescriptorsForOfficialBrass];
                }
            } else if (self.segmentOfficial.selectedSegmentIndex == 1) {
                
                {
                    NSSortDescriptor *sortUserHornline = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
                    NSArray *sortDescriptorForUserHornline = [NSArray arrayWithObject: sortUserHornline];
                    
                    if ([self.arrayOfWorldHornlineFavs count]) [self.arrayOfWorldHornlineFavs sortUsingDescriptors:sortDescriptorForUserHornline];
                    if ([self.arrayOfOpenHornlineFavs count]) [self.arrayOfOpenHornlineFavs sortUsingDescriptors:sortDescriptorForUserHornline];
                    if ([self.arrayOfAllAgeHornlineFavs count]) [self.arrayOfAllAgeHornlineFavs sortUsingDescriptors:sortDescriptorForUserHornline];
                    
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
                    if ([data.arrayOfAllAgeClass count]) [data.arrayOfAllAgeClass sortUsingDescriptors:sortDescriptorsForOfficialPercussion];
                }
            } else if (self.segmentOfficial.selectedSegmentIndex == 1) {
                
                {
                    NSSortDescriptor *sortUserPercussion = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
                    NSArray *sortDescriptorForUserPercussion = [NSArray arrayWithObject: sortUserPercussion];
                    
                    if ([self.arrayOfWorldPercussionFavs count]) [self.arrayOfWorldPercussionFavs sortUsingDescriptors:sortDescriptorForUserPercussion];
                    if ([self.arrayOfOpenPercussionFavs count]) [self.arrayOfOpenPercussionFavs sortUsingDescriptors:sortDescriptorForUserPercussion];
                    if ([self.arrayOfAllAgePercussionFavs count]) [self.arrayOfAllAgePercussionFavs sortUsingDescriptors:sortDescriptorForUserPercussion];
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
                    if ([data.arrayOfAllAgeClass count]) [data.arrayOfAllAgeClass sortUsingDescriptors:sortDescriptorsForOfficialColorguard];
                }
            } else if (self.segmentOfficial.selectedSegmentIndex == 1) {
                
                {
                    NSSortDescriptor *sortUserColorguardVotes = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
                    NSArray *sortDescriptorsForUserColorguardVotes = [NSArray arrayWithObject: sortUserColorguardVotes];
                    
                    if ([self.arrayOfWorldColorguardFavs count]) [self.arrayOfWorldColorguardFavs sortUsingDescriptors:sortDescriptorsForUserColorguardVotes];
                    if ([self.arrayOfOpenColorguardFavs count]) [self.arrayOfOpenColorguardFavs sortUsingDescriptors:sortDescriptorsForUserColorguardVotes];
                    if ([self.arrayOfAllAgeColorguardFavs count]) [self.arrayOfAllAgeColorguardFavs sortUsingDescriptors:sortDescriptorsForUserColorguardVotes];
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
                    if ([self.arrayOfAllAgeLoudestFavs count]) [self.arrayOfAllAgeLoudestFavs sortUsingDescriptors:sortDescriptorsForLoudestHornline];
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
                    if ([self.arrayOfAllAgeFavs count]) [self.arrayOfAllAgeFavs sortUsingDescriptors:sortDescriptorsForFavoriteCorps];
                }
            }
            
            break;}
            
        default:
            break;
    }
    
    self.segmentOfficial.userInteractionEnabled = YES;
    self.tabBar.userInteractionEnabled = YES;
    [self reloadTable];
}

#pragma mark
#pragma mark - UITableView Methods
#pragma mark

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
    
    return 3;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0: return @"World Class";
        case 1: return @"Open Class";
        case 2: return @"All Age Class";
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
                } else if (section == 2) {
                    
                    if ([data.arrayOfAllAgeClass count]) return [data.arrayOfAllAgeClass count];
                }
            } else if (self.segmentOfficial.selectedSegmentIndex == 1) {
                
                if (section == 0) {
                    if ([data.arrayOfUserWorldClassRankings count]) return [data.arrayOfUserWorldClassRankings count];
                } else if (section == 1) {
                    
                    if ([data.arrayOfUserOpenClassRankings count]) return [data.arrayOfUserOpenClassRankings count];
                } else if (section == 2) {
                    
                    if ([data.arrayOfUserAllAgeClassRankings count]) return [data.arrayOfUserAllAgeClassRankings count];
                }
            }
            break;
            
        case phaseBesthornline:
            
            if (self.segmentOfficial.selectedSegmentIndex == 0) {
                
                if (section == 0) {
                    
                    if ([data.arrayOfWorldClass count]) return [data.arrayOfWorldClass count];
                } else if (section == 1) {
                    
                    if ([data.arrayOfOpenClass count]) return [data.arrayOfOpenClass count];
                    
                } else if (section == 2) {
                    
                    if ([data.arrayOfAllAgeClass count]) return [data.arrayOfAllAgeClass count];
                }
            } else if (self.segmentOfficial.selectedSegmentIndex == 1) {
                
                if (section == 0) {
                    
                    if ([self.arrayOfWorldHornlineFavs count]) return [self.arrayOfWorldHornlineFavs count];
                } else if (section == 1) {
                    
                    if ([self.arrayOfOpenHornlineFavs count]) return [self.arrayOfOpenHornlineFavs count];
                    
                } else if (section == 2) {
                    
                    if ([self.arrayOfAllAgeHornlineFavs count]) return [self.arrayOfAllAgeHornlineFavs count];
                }
            }
            break;
            
        case phaseBestdrums:
            
            if (self.segmentOfficial.selectedSegmentIndex == 0) {
                
                if (section == 0) {
                    
                    if ([data.arrayOfWorldClass count]) return [data.arrayOfWorldClass count];
                } else if (section == 1) {
                    
                    if ([data.arrayOfOpenClass count]) return [data.arrayOfOpenClass count];
                    
                } else if (section == 2) {
                    
                    if ([data.arrayOfAllAgeClass count]) return [data.arrayOfAllAgeClass count];
                }
                
            } else if (self.segmentOfficial.selectedSegmentIndex == 1) {
                
                if (section == 0) {
                    
                    if ([self.arrayOfWorldPercussionFavs count]) return [self.arrayOfWorldPercussionFavs count];
                } else if (section == 1) {
                    
                    if ([self.arrayOfOpenPercussionFavs count]) return [self.arrayOfOpenPercussionFavs count];
                    
                } else if (section == 2) {
                    
                    if ([self.arrayOfAllAgePercussionFavs count]) return [self.arrayOfAllAgePercussionFavs count];
                }
            }
            
            break;
            
        case phaseBestguard:
            
            if (self.segmentOfficial.selectedSegmentIndex == 0) {
                
                if (section == 0) {
                    
                    if ([data.arrayOfWorldClass count]) return [data.arrayOfWorldClass count];
                    
                } else if (section == 1) {
                    
                    if ([data.arrayOfOpenClass count]) return [data.arrayOfOpenClass count];
                    
                } else if (section == 2) {
                    
                    if ([data.arrayOfAllAgeClass count]) return [data.arrayOfAllAgeClass count];
                }
                
            }  else if (self.segmentOfficial.selectedSegmentIndex == 1) {
                
                if (section == 0) {
                    
                    if ([self.arrayOfWorldColorguardFavs count]) return [self.arrayOfWorldColorguardFavs count];
                } else if (section == 1) {
                    
                    if ([self.arrayOfOpenColorguardFavs count]) return [self.arrayOfOpenColorguardFavs count];
                    
                } else if (section == 2) {
                    
                    if ([self.arrayOfAllAgeColorguardFavs count]) return [self.arrayOfAllAgeColorguardFavs count];
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
                    
                } else if (section == 1) {
                    
                    if ([self.arrayOfOpenLoudestFavs count]) return [self.arrayOfOpenLoudestFavs count];
                    
                } else if (section == 2) {
                    
                    if ([self.arrayOfAllAgeLoudestFavs count]) return [self.arrayOfAllAgeLoudestFavs count];
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
                    
                } else if (section == 1) {
                    
                    if ([self.arrayOfOpenFavs count]) return [self.arrayOfOpenFavs count];
                    
                } else if (section == 2) {
                    
                    if ([self.arrayOfAllAgeFavs count]) return [self.arrayOfAllAgeFavs count];
                }
            }
            
            break;
        default:
            return 1;
            break;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *blankCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"blank"];
    blankCell.backgroundColor = [UIColor blackColor];
    blankCell.textLabel.font = [UIFont systemFontOfSize:12];
    blankCell.textLabel.textColor = [UIColor whiteColor];
    
    UITableViewCell *cell;
    UILabel *lblCorpsName;
    UILabel *lblScore;
    UILabel *lblDay;
    UILabel *lblPercent;
    UILabel *lblRank;
    UIView *bar;
    UILabel *lbldiff;
    PFImageView *imgLogo;
    
    int barWidth = 0;
    NSMutableArray *array;
    switch (self.scorePhase) {
            
        case phaseScore:
            
            if (self.segmentOfficial.selectedSegmentIndex == 0) { //OFFICIAL
                
                if (indexPath.section == 0) array = data.arrayOfWorldClass;
                if (indexPath.section == 1) array = data.arrayOfOpenClass;
                if (indexPath.section == 2) array = data.arrayOfAllAgeClass;
                
                cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"officialRank"];
                lblCorpsName = (UILabel *)[cell viewWithTag:1];
                lblScore = (UILabel *)[cell viewWithTag:2];
                lblDay = (UILabel *)[cell viewWithTag:3];
                lblRank = (UILabel *)[cell viewWithTag:4];
                lbldiff = (UILabel *)[cell viewWithTag:5];
                imgLogo = (PFImageView *)[cell viewWithTag:8];
                
                PFObject *corps;
                if ([array count]) corps = [array objectAtIndex:indexPath.row];
                
                if (corps) {
                    PFFile *imageFile = corps[@"logo"];
                    if (imageFile) {
                        [imgLogo setFile:imageFile];
                        [imgLogo loadInBackground];
                    }
                    lblRank.text = [NSString stringWithFormat:@"%li", (long)indexPath.row + 1];
                    lblCorpsName.text = corps[@"corpsName"];
                    if ([corps[@"lastScore"] length]) {
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
                            } else lblDay.text = [NSString stringWithFormat:@"%li day ago", (long)days];
                        }
                    } else { //no data
                        cell = blankCell;
                        cell.textLabel.text = corps[@"corpsName"];
                        cell.textLabel.textColor = [UIColor whiteColor];
                        cell.textLabel.font = [UIFont systemFontOfSize:16];
                        cell.detailTextLabel.text = @"No score yet";
                        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
                        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
                        
                    }
                    
                    
                    
                }
            } else { // USER REVIEWS
                
                if (indexPath.section == 0) array = data.arrayOfUserWorldClassRankings;
                if (indexPath.section == 1) array = data.arrayOfUserOpenClassRankings;
                if (indexPath.section == 2) array = data.arrayOfUserAllAgeClassRankings;
                
                cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"userScore"];
                lblRank = (UILabel *)[cell viewWithTag:1];
                lblCorpsName = (UILabel *)[cell viewWithTag:2];
                lblScore = (UILabel *)[cell viewWithTag:3];
                imgLogo = (PFImageView *)[cell viewWithTag:8];
                UserScore *us;
                if ([array count]) us = [array objectAtIndex:indexPath.row];
                if (us) {
                    PFFile *imageFile = us.corps[@"logo"];
                    if (imageFile) {
                        [imgLogo setFile:imageFile];
                        [imgLogo loadInBackground];
                    }
                    lblRank.text = [NSString stringWithFormat:@"%li", (long)indexPath.row + 1];
                    lblCorpsName.text = us.corps[@"corpsName"];
                    lblScore.text = [NSString stringWithFormat:@"%.2f", us.score];
                }
            }
            break;
            
        case phaseBesthornline:
            
            if (self.segmentOfficial.selectedSegmentIndex == 0) { //OFFICIAL
                
                if (indexPath.section == 0) array = data.arrayOfWorldClass;
                if (indexPath.section == 1) array = data.arrayOfOpenClass;
                if (indexPath.section == 2) array = data.arrayOfAllAgeClass;
                
                cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"userScore"];
                lblCorpsName = (UILabel *)[cell viewWithTag:2];
                lblScore = (UILabel *)[cell viewWithTag:3];
                lblRank = (UILabel *)[cell viewWithTag:1];
                imgLogo = (PFImageView *)[cell viewWithTag:8];
                PFObject *corps;
                if ([array count]) corps = [array objectAtIndex:indexPath.row];
                
                if (corps) {
                    PFFile *imageFile = corps[@"logo"];
                    if (imageFile) {
                        [imgLogo setFile:imageFile];
                        [imgLogo loadInBackground];
                    }
                    if ([corps[@"lastBrass"] length]) {
                        lblRank.text = [NSString stringWithFormat:@"%li", (long)indexPath.row + 1];
                        lblCorpsName.text = corps[@"corpsName"];
                        lblScore.text = corps[@"lastBrass"];
                    } else { //no data
                        cell = blankCell;
                        cell.textLabel.text = corps[@"corpsName"];
                        cell.textLabel.textColor = [UIColor whiteColor];
                        cell.textLabel.font = [UIFont systemFontOfSize:16];
                        cell.detailTextLabel.text = @"No brass score yet";
                        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
                        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
                        
                    }
                }
            } else { // USER REVIEWS
                
                if (indexPath.section == 0) array = self.arrayOfWorldHornlineFavs;
                if (indexPath.section == 1) array = self.arrayOfOpenHornlineFavs;
                if (indexPath.section == 2) array = self.arrayOfAllAgeHornlineFavs;
                
                cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"vote"];
                lblCorpsName = (UILabel *)[cell viewWithTag:1];
                bar = (UIView *)[cell.contentView viewWithTag:2];
                lblPercent = (UILabel *)[cell viewWithTag:3];
                imgLogo = (PFImageView *)[cell viewWithTag:8];
                UserScore *score;
                if ([array count]) score = [array objectAtIndex:indexPath.row];
                
                if (score) {
                    PFFile *imageFile = score.corps[@"logo"];
                    if (imageFile) {
                        [imgLogo setFile:imageFile];
                        [imgLogo loadInBackground];
                    }
                    lblRank.text = [NSString stringWithFormat:@"%li", (long)indexPath.row + 1];
                    lblCorpsName.text = score.corps[@"corpsName"];
                    //calculate percentage
                    float result = 0.0;
                    if (indexPath.section == 0) result = (score.score/totalWorldHornlineVotes) * 100;
                    if (indexPath.section == 1) result = (score.score/totalOpenHornlineVotes) * 100;
                    if (indexPath.section == 2) result = (score.score/totalAllAgeHornlineVotes) * 100;
                    lblPercent.text = [NSString stringWithFormat:@"%.2f%@", result, @"%"];
                    barWidth = 2.5 * result;
                }
            }
            
            break;
            
        case phaseBestdrums:
            
            if (self.segmentOfficial.selectedSegmentIndex == 0) { //OFFICIAL
                
                if (indexPath.section == 0) array = data.arrayOfWorldClass;
                if (indexPath.section == 1) array = data.arrayOfOpenClass;
                if (indexPath.section == 2) array = data.arrayOfAllAgeClass;
                
                cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"userScore"];
                lblCorpsName = (UILabel *)[cell viewWithTag:2];
                lblScore = (UILabel *)[cell viewWithTag:3];
                lblRank = (UILabel *)[cell viewWithTag:1];
                imgLogo = (PFImageView *)[cell viewWithTag:8];
                
                PFObject *corps;
                if ([array count]) corps = [array objectAtIndex:indexPath.row];
                
                if (corps) {
                    PFFile *imageFile = corps[@"logo"];
                    if (imageFile) {
                        [imgLogo setFile:imageFile];
                        [imgLogo loadInBackground];
                    }
                    if ([corps[@"lastPercussion"] length]) {
                        lblRank.text = [NSString stringWithFormat:@"%li", (long)indexPath.row + 1];
                        lblCorpsName.text = corps[@"corpsName"];
                        lblScore.text = corps[@"lastPercussion"];
                    } else { //no data
                        cell = blankCell;
                        cell.textLabel.text = corps[@"corpsName"];
                        cell.textLabel.textColor = [UIColor whiteColor];
                        cell.textLabel.font = [UIFont systemFontOfSize:16];
                        cell.detailTextLabel.text = @"No percussion score yet";
                        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
                        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
                        
                    }
                }
            } else if (self.segmentOfficial.selectedSegmentIndex == 1) {
                
                if (indexPath.section == 0) array = self.arrayOfWorldPercussionFavs;
                if (indexPath.section == 1) array = self.arrayOfOpenPercussionFavs;
                if (indexPath.section == 2) array = self.arrayOfAllAgePercussionFavs;
                
                cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"vote"];
                lblCorpsName = (UILabel *)[cell viewWithTag:1];
                bar = (UIView *)[cell.contentView viewWithTag:2];
                lblPercent = (UILabel *)[cell viewWithTag:3];
                imgLogo = (PFImageView *)[cell viewWithTag:8];
                
                UserScore *score;
                if ([array count]) score = [array objectAtIndex:indexPath.row];
                
                if (score) {
                    PFFile *imageFile = score.corps[@"logo"];
                    if (imageFile) {
                        [imgLogo setFile:imageFile];
                        [imgLogo loadInBackground];
                    }
                    lblRank.text = [NSString stringWithFormat:@"%li", (long)indexPath.row + 1];
                    lblCorpsName.text = score.corps[@"corpsName"];
                    //calculate percentage
                    float result = 0.0;
                    if (indexPath.section == 0) result = (score.score/totalWorldPercussionVotes) * 100;
                    if (indexPath.section == 1) result = (score.score/totalOpenPercussionVotes) * 100;
                    if (indexPath.section == 2) result = (score.score/totalAllAgePercussionVotes) * 100;
                    lblPercent.text = [NSString stringWithFormat:@"%.2f%@", result, @"%"];
                    barWidth = 2.5 * result;
                }
            }
            
            break;
            
        case phaseBestguard:
            
            if (self.segmentOfficial.selectedSegmentIndex == 0) { //OFFICIAL
                
                if (indexPath.section == 0) array = data.arrayOfWorldClass;
                if (indexPath.section == 1) array = data.arrayOfOpenClass;
                if (indexPath.section == 2) array = data.arrayOfAllAgeClass;
                
                cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"userScore"];
                lblCorpsName = (UILabel *)[cell viewWithTag:2];
                lblScore = (UILabel *)[cell viewWithTag:3];
                lblRank = (UILabel *)[cell viewWithTag:1];
                imgLogo = (PFImageView *)[cell viewWithTag:8];
                
                PFObject *corps;
                if ([array count]) corps = [array objectAtIndex:indexPath.row];
                
                if (corps) {
                    PFFile *imageFile = corps[@"logo"];
                    if (imageFile) {
                        [imgLogo setFile:imageFile];
                        [imgLogo loadInBackground];
                    }
                    if ([corps[@"lastColorguard"] length]) {
                        lblRank.text = [NSString stringWithFormat:@"%li", (long)indexPath.row + 1];
                        lblCorpsName.text = corps[@"corpsName"];
                        lblScore.text = corps[@"lastColorguard"];
                    } else { //no data
                        cell = blankCell;
                        cell.textLabel.text = corps[@"corpsName"];
                        cell.textLabel.textColor = [UIColor whiteColor];
                        cell.textLabel.font = [UIFont systemFontOfSize:16];
                        cell.detailTextLabel.text = @"No color guard score yet";
                        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
                        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
                        
                    }
                    
                }
            } else if (self.segmentOfficial.selectedSegmentIndex == 1) {
                
                if (indexPath.section == 0) array = self.arrayOfWorldColorguardFavs;
                if (indexPath.section == 1) array = self.arrayOfOpenColorguardFavs;
                if (indexPath.section == 2) array = self.arrayOfAllAgeColorguardFavs;
                
                cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"vote"];
                lblCorpsName = (UILabel *)[cell viewWithTag:1];
                bar = (UIView *)[cell.contentView viewWithTag:2];
                lblPercent = (UILabel *)[cell viewWithTag:3];
                imgLogo = (PFImageView *)[cell viewWithTag:8];
                
                UserScore *score;
                if ([array count]) score = [array objectAtIndex:indexPath.row];
                
                if (score) {
                    PFFile *imageFile = score.corps[@"logo"];
                    if (imageFile) {
                        [imgLogo setFile:imageFile];
                        [imgLogo loadInBackground];
                    }
                    lblRank.text = [NSString stringWithFormat:@"%li", (long)indexPath.row + 1];
                    lblCorpsName.text = score.corps[@"corpsName"];
                    //calculate percentage
                    float result = 0.0;
                    if (indexPath.section == 0) result = (score.score/totalWorldColorguardVotes) * 100;
                    if (indexPath.section == 1) result = (score.score/totalOpenColorguardVotes) * 100;
                    if (indexPath.section == 2) result = (score.score/totalAllAgeColorguardVotes) * 100;
                    lblPercent.text = [NSString stringWithFormat:@"%.2f%@", result, @"%"];
                    barWidth = 2.5 * result;
                }
            }
            
            break;
            
        case phaseLoudesthornline:
            
            if (self.segmentOfficial.selectedSegmentIndex == 1) {
                
                if (indexPath.section == 0) array = self.arrayOfWorldLoudestFavs;
                if (indexPath.section == 1) array = self.arrayOfOpenLoudestFavs;
                if (indexPath.section == 2) array = self.arrayOfAllAgeLoudestFavs;
                
                cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"vote"];
                lblCorpsName = (UILabel *)[cell viewWithTag:1];
                bar = (UIView *)[cell.contentView viewWithTag:2];
                lblPercent = (UILabel *)[cell viewWithTag:3];
                imgLogo = (PFImageView *)[cell viewWithTag:8];
                
                UserScore *score;
                if ([array count]) score = [array objectAtIndex:indexPath.row];
                
                if (score) {
                    PFFile *imageFile = score.corps[@"logo"];
                    if (imageFile) {
                        [imgLogo setFile:imageFile];
                        [imgLogo loadInBackground];
                    }
                    lblRank.text = [NSString stringWithFormat:@"%li", (long)indexPath.row + 1];
                    lblCorpsName.text = score.corps[@"corpsName"];
                    //calculate percentage
                    float result = 0.0;
                    if (indexPath.section == 0) result = (score.score/totalWorldLoudestVotes) * 100;
                    if (indexPath.section == 1) result = (score.score/totalOpenLoudestVotes) * 100;
                    if (indexPath.section == 2) result = (score.score/totalAllAgeLoudestVotes) * 100;
                    lblPercent.text = [NSString stringWithFormat:@"%.2f%@", result, @"%"];
                    barWidth = 2.5 * result;
                }
            }
            
            break;
            
        case phaseFavorite:
            
            if (self.segmentOfficial.selectedSegmentIndex == 1) {
                
                if (indexPath.section == 0) array = self.arrayOfWorldFavs;
                if (indexPath.section == 1) array = self.arrayOfOpenFavs;
                if (indexPath.section == 2) array = self.arrayOfAllAgeFavs;
                
                cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"vote"];
                lblCorpsName = (UILabel *)[cell viewWithTag:1];
                bar = (UIView *)[cell.contentView viewWithTag:2];
                lblPercent = (UILabel *)[cell viewWithTag:3];
                imgLogo = (PFImageView *)[cell viewWithTag:8];
                
                UserScore *score;
                if ([array count]) score = [array objectAtIndex:indexPath.row];
                
                if (score) {
                    PFFile *imageFile = score.corps[@"logo"];
                    if (imageFile) {
                        [imgLogo setFile:imageFile];
                        [imgLogo loadInBackground];
                    }
                    lblRank.text = [NSString stringWithFormat:@"%li", (long)indexPath.row + 1];
                    lblCorpsName.text = score.corps[@"corpsName"];
                    //calculate percentage
                    float result = 0.0;
                    if (indexPath.section == 0) result = (score.score/totalWorldFavoriteCorpsVotes) * 100;
                    if (indexPath.section == 1) result = (score.score/totalOpenFavoriteCorpsVotes) * 100;
                    if (indexPath.section == 2) result = (score.score/totalAllAgeFavoriteCorpsVotes) * 100;
                    lblPercent.text = [NSString stringWithFormat:@"%.2f%@", result, @"%"];
                    barWidth = 2.5 * result;
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
    
    //barWidth = barWidth - bar.frame.origin.x;
    
    bar.hidden = YES;
    UIView *bar1 = [[UIView alloc] initWithFrame:CGRectMake(bar.frame.origin.x, bar.frame.origin.y, oldWidth, bar.frame.size.height)];
    bar1.backgroundColor = self.segmentOfficial.tintColor;
    bar1.tag = 10;
    [cell addSubview:bar1];
    
    [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:2 options:0 animations:^{
        bar1.frame = CGRectMake(bar1.frame.origin.x, bar1.frame.origin.y, barWidth, bar1.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    if (![array count]) {
        blankCell.backgroundColor = [UIColor blackColor];
        blankCell.textLabel.textColor = [UIColor whiteColor];
        blankCell.textLabel.font = [UIFont systemFontOfSize:12];
        blankCell.textLabel.text = @"No votes yet";
        return blankCell;
    } else {
        return cell;
    }
}

-(void)reloadTable {
    
    self.tableCorps.hidden = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress dismiss];
    });
    
    [self.tableCorps reloadData];
}

#pragma mark
#pragma mark - UITabBar Methods
#pragma mark
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
}

#pragma mark
#pragma mark - Properties
#pragma mark

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

-(NSMutableArray *)arrayOfAllAgeFavs {
    
    if (!_arrayOfAllAgeFavs) {
        _arrayOfAllAgeFavs = [[NSMutableArray alloc] init];
    }
    return _arrayOfAllAgeFavs;
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

-(NSMutableArray *)arrayOfAllAgeHornlineFavs {
    
    if (!_arrayOfAllAgeHornlineFavs) {
        _arrayOfAllAgeHornlineFavs = [[NSMutableArray alloc] init];
    }
    return _arrayOfAllAgeHornlineFavs;
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

-(NSMutableArray *)arrayOfAllAgePercussionFavs {
    
    if (!_arrayOfAllAgePercussionFavs) {
        _arrayOfAllAgePercussionFavs = [[NSMutableArray alloc] init];
    }
    return _arrayOfAllAgePercussionFavs;
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

-(NSMutableArray *)arrayOfAllAgeColorguardFavs {
    
    if (!_arrayOfAllAgeColorguardFavs) {
        _arrayOfAllAgeColorguardFavs = [[NSMutableArray alloc] init];
    }
    return _arrayOfAllAgeColorguardFavs;
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

-(NSMutableArray *)arrayOfAllAgeLoudestFavs {
    
    if (!_arrayOfAllAgeLoudestFavs) {
        _arrayOfAllAgeLoudestFavs = [[NSMutableArray alloc] init];
    }
    return _arrayOfAllAgeLoudestFavs;
}

#pragma mark
#pragma mark - Actions & Helpers
#pragma mark

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

-(void)officialChanged {
    
    [self sortScores];
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
                self.title = @"High Color Guard";
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
                self.title = @"User Loudest Brass";
                break;
            case phaseBestdrums:
                self.title = @"User Favorite Percussion";
                break;
            case phaseBestguard:
                self.title = @"User Favorite Color Guard";
                break;
            case phaseBesthornline:
                self.title = @"User Favorite Brass";
                break;
                
            default:
                break;
        }
    }
}

-(UIColor *)darkerColorForColor:(UIColor *)c {
    
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.2, 0.0)
                               green:MAX(g - 0.2, 0.0)
                                blue:MAX(b - 0.2, 0.0)
                               alpha:a];
    return nil;
}

@end
