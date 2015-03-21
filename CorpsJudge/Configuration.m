//
//  Configuration.m
//  CorpsJudge
//
//  Created by Justin Moore on 6/18/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "Configuration.h"

//105 shows
//804 blank scores
//22 world class
//27 open class
//49 corps

NSInteger const JUNE = 6;
NSInteger const JULY = 7;
NSInteger const AUGUST = 8;
NSInteger const YEAR = 2014;

// World Class - 22 Corps
NSString *const THE_CADETS = @"The Cadets";
NSString *const THE_ACADEMY = @"The Academy";
NSString *const BLUE_DEVILS = @"Blue Devils";
NSString *const BLUE_KNIGHTS = @"Blue Knights";
NSString *const BLUECOATS = @"Bluecoats";
NSString *const BLUE_STARS = @"Blue Stars";
NSString *const BOSTON_CRUSADERS = @"Boston Crusaders";
NSString *const CAROLINA_CROWN = @"Carolina Crown";
NSString *const CASCADES = @"Cascades";
NSString *const THE_CAVALIERS = @"The Cavaliers";
NSString *const COLTS = @"Colts";
NSString *const CROSSMEN = @"Crossmen";
NSString *const JERSEY_SURF = @"Jersey Surf";
NSString *const MADISON_SCOUTS = @"Madison Scouts";
NSString *const MANDARINS = @"Mandarins";
NSString *const OREGON_CRUSADERS = @"Oregon Crusaders";
NSString *const PACIFIC_CREST = @"Pacific Crest";
NSString *const PHANTOM_REGIMENT = @"Phantom Regiment";
NSString *const PIONEER = @"Pioneer";
NSString *const SANTA_CLARA_VANGUARD = @"Santa Clara Vanguard";
NSString *const SPIRIT_OF_ATLANTA = @"Spirit of Atlanta";
NSString *const TROOPERS = @"Troopers";

// Open class - 25 Corps
NSString *const SEVENTH_REGIMENT = @"7th Regiment";
NSString *const BLUE_DEVILS_B = @"Blue Devils B";
NSString *const BLUE_DEVILS_C = @"Blue Devils C";
NSString *const BLUE_SAINTS = @"Blue Saints";
NSString *const CITY_SOUND = @"City Sound";
NSString *const COASTAL_SURGE = @"Coastal Surge";
NSString *const COLT_CADETS = @"Colt Cadets";
NSString *const COLUMBIANS = @"Columbians";
NSString *const ERUPTION = @"Eruption";
NSString *const GENESIS = @"Genesis";
NSString *const GOLD = @"Gold";
NSString *const GOLDEN_EMPIRE = @"Golden Empire";
NSString *const GUARDIANS = @"Guardians";
NSString *const IMPULSE = @"Impulse";
NSString *const INCOGNITO = @"Incognito";
NSString *const LEGENDS = @"Legends";
NSString *const LES_STENTORS = @"Les Stentors";
NSString *const LOUISIANA_STARS = @"Louisiana Stars";
NSString *const MUSIC_CITY = @"Music City";
NSString *const RACINE_SCOUTS = @"Racine Scouts";
NSString *const RAIDERS = @"Raiders";
NSString *const SPARTANS = @"Spartans";
NSString *const THUNDER = @"Thunder";
NSString *const VANGUARD_CADETS = @"Vanguard Cadets";
NSString *const WATCHMEN = @"Watchmen";

// All Age - 10 Corps
NSString *const THE_MUCHACHOS = @"The Muchachos";
NSString *const MINNESOTA_BRASS = @"Minnesota Brass";
NSString *const GOVENAIRES = @"Govenaires";
NSString *const DEFENDERS = @"Defenders";
NSString *const CRUSADERS_SENIOR = @"Crusaders Senior";
NSString *const CAROLINA_GOLD = @"Carolina Gold";
NSString *const BRIDGEMEN_ALUMNI = @"Bridgemen Alumni";
NSString *const ATLANTA_CV = @"Atlanta CV";
NSString *const CINCINNATI_TRADITION = @"Cincinnati Tradition";
NSString *const KILTIES = @"Kilties";


// 25 + 22 + 10 = 57 CORPS TOTAL


@implementation Configuration

-(id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)createAllShowsAndEmptyScores {
    [self getAllCorps];
}

-(void)createAllCorps {
    
    // World class
    [self addCorps:THE_CADETS corpClass:@"World"];
    [self addCorps:THE_ACADEMY corpClass:@"World"];
    [self addCorps:BLUE_DEVILS corpClass:@"World"];
    [self addCorps:BLUE_KNIGHTS corpClass:@"World"];
    [self addCorps:BLUECOATS corpClass:@"World"];
    [self addCorps:BLUE_STARS corpClass:@"World"];
    [self addCorps:BOSTON_CRUSADERS corpClass:@"World"];
    [self addCorps:CAROLINA_CROWN corpClass:@"World"];
    [self addCorps:CASCADES corpClass:@"World"];
    [self addCorps:THE_CAVALIERS corpClass:@"World"];
    [self addCorps:COLTS corpClass:@"World"];
    [self addCorps:CROSSMEN corpClass:@"World"];
    [self addCorps:JERSEY_SURF corpClass:@"World"];
    [self addCorps:MADISON_SCOUTS corpClass:@"World"];
    [self addCorps:MANDARINS corpClass:@"World"];
    [self addCorps:OREGON_CRUSADERS corpClass:@"World"];
    [self addCorps:PACIFIC_CREST corpClass:@"World"];
    [self addCorps:PHANTOM_REGIMENT corpClass:@"World"];
    [self addCorps:PIONEER corpClass:@"World"];
    [self addCorps:SANTA_CLARA_VANGUARD corpClass:@"World"];
    [self addCorps:SPIRIT_OF_ATLANTA corpClass:@"World"];
    [self addCorps:TROOPERS corpClass:@"World"];
    
    // Open class
    [self addCorps:SEVENTH_REGIMENT corpClass:@"Open"];
    [self addCorps:BLUE_DEVILS_B corpClass:@"Open"];
    [self addCorps:BLUE_DEVILS_C corpClass:@"Open"];
    [self addCorps:BLUE_SAINTS corpClass:@"Open"];
    [self addCorps:CITY_SOUND corpClass:@"Open"];
    [self addCorps:COASTAL_SURGE corpClass:@"Open"];
    [self addCorps:COLT_CADETS corpClass:@"Open"];
    [self addCorps:COLUMBIANS corpClass:@"Open"];
    [self addCorps:ERUPTION corpClass:@"Open"];
    [self addCorps:GENESIS corpClass:@"Open"];
    [self addCorps:GOLD corpClass:@"Open"];
    [self addCorps:GOLDEN_EMPIRE corpClass:@"Open"];
    [self addCorps:GUARDIANS corpClass:@"Open"];
    [self addCorps:IMPULSE corpClass:@"Open"];
    [self addCorps:INCOGNITO corpClass:@"Open"];
    [self addCorps:LEGENDS corpClass:@"Open"];
    [self addCorps:LES_STENTORS corpClass:@"Open"];
    [self addCorps:LOUISIANA_STARS corpClass:@"Open"];
    [self addCorps:MUSIC_CITY corpClass:@"Open"];
    [self addCorps:RACINE_SCOUTS corpClass:@"Open"];
    [self addCorps:RAIDERS corpClass:@"Open"];
    [self addCorps:SPARTANS corpClass:@"Open"];
    [self addCorps:THUNDER corpClass:@"Open"];
    [self addCorps:VANGUARD_CADETS corpClass:@"Open"];
    [self addCorps:WATCHMEN corpClass:@"Open"];
    
    // All Age Class
    [self addCorps:THE_MUCHACHOS corpClass:@"All Age"];
    [self addCorps:MINNESOTA_BRASS corpClass:@"All Age"];
    [self addCorps:GOVENAIRES corpClass:@"All Age"];
    [self addCorps:DEFENDERS corpClass:@"All Age"];
    [self addCorps:CRUSADERS_SENIOR corpClass:@"All Age"];
    [self addCorps:CAROLINA_GOLD corpClass:@"All Age"];
    [self addCorps:BRIDGEMEN_ALUMNI corpClass:@"All Age"];
    [self addCorps:ATLANTA_CV corpClass:@"All Age"];
    [self addCorps:CINCINNATI_TRADITION corpClass:@"All Age"];
    [self addCorps:KILTIES corpClass:@"All Age"];
}

// This method checks the array of corps from the server to make sure it matches
// what is hard coded as constants in the app
-(void)checkAllCorps {
    
    // World class
    [self getCorpsByName: THE_CADETS];
    [self getCorpsByName: THE_ACADEMY];
    [self getCorpsByName: BLUE_DEVILS];
    [self getCorpsByName: BLUE_KNIGHTS];
    [self getCorpsByName: BLUECOATS];
    [self getCorpsByName: BLUE_STARS];
    [self getCorpsByName: BOSTON_CRUSADERS];
    [self getCorpsByName: CAROLINA_CROWN];
    [self getCorpsByName: CASCADES];
    [self getCorpsByName: THE_CAVALIERS];
    [self getCorpsByName: COLTS];
    [self getCorpsByName: CROSSMEN];
    [self getCorpsByName: JERSEY_SURF];
    [self getCorpsByName: MADISON_SCOUTS];
    [self getCorpsByName: MANDARINS];
    [self getCorpsByName: OREGON_CRUSADERS];
    [self getCorpsByName: PACIFIC_CREST];
    [self getCorpsByName: PHANTOM_REGIMENT];
    [self getCorpsByName: PIONEER];
    [self getCorpsByName: SANTA_CLARA_VANGUARD];
    [self getCorpsByName: SPIRIT_OF_ATLANTA];
    [self getCorpsByName: TROOPERS];
    
    // Open class
    [self getCorpsByName: SEVENTH_REGIMENT];
    [self getCorpsByName: BLUE_DEVILS_B];
    [self getCorpsByName: BLUE_DEVILS_C];
    [self getCorpsByName: BLUE_SAINTS];
    [self getCorpsByName: CITY_SOUND];
    [self getCorpsByName: COASTAL_SURGE];
    [self getCorpsByName: COLT_CADETS];
    [self getCorpsByName: COLUMBIANS];
    [self getCorpsByName: ERUPTION];
    [self getCorpsByName: GENESIS];
    [self getCorpsByName: GOLD];
    [self getCorpsByName: GOLDEN_EMPIRE];
    [self getCorpsByName: GUARDIANS];
    [self getCorpsByName: IMPULSE];
    [self getCorpsByName: INCOGNITO];
    [self getCorpsByName: LEGENDS];
    [self getCorpsByName: LES_STENTORS];
    [self getCorpsByName: LOUISIANA_STARS];
    [self getCorpsByName: MUSIC_CITY];
    [self getCorpsByName: RACINE_SCOUTS];
    [self getCorpsByName: RAIDERS];
    [self getCorpsByName: SPARTANS];
    [self getCorpsByName: THUNDER];
    [self getCorpsByName: VANGUARD_CADETS];
    [self getCorpsByName: WATCHMEN];
    
    // All Age Class
    [self getCorpsByName: THE_MUCHACHOS];
    [self getCorpsByName: MINNESOTA_BRASS];
    [self getCorpsByName: GOVENAIRES];
    [self getCorpsByName: DEFENDERS];
    [self getCorpsByName: CRUSADERS_SENIOR];
    [self getCorpsByName: CAROLINA_GOLD];
    [self getCorpsByName: BRIDGEMEN_ALUMNI];
    [self getCorpsByName: ATLANTA_CV];
    [self getCorpsByName: CINCINNATI_TRADITION];
    [self getCorpsByName: KILTIES];
}

//needed before creating shows
-(void)getAllCorps {
    
    PFQuery *query = [PFQuery queryWithClassName:@"corps"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu corps.", (unsigned long)objects.count);
            [self.arrayOfCorpsObjects addObjectsFromArray:objects];
            NSLog(@"%lu", (unsigned long)[self.arrayOfCorpsObjects count]);
            [self createAllShows];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)createAllShows {

//    [self addShowWithName:<#(NSString *)#>
//               atLocation:<#(NSString *)#>
//                 forMonth:<#(NSInteger *)#>
//                   forDay:<#(NSInteger *)#>
//      withPerformingCorps:<#(NSMutableArray *)#>];
    
    [self addShowWithName:@"DCI Opening Night"
               atLocation:@"Indianapolis, IN"
                 forMonth:JUNE
                   forDay:18
      withPerformingCorps:@[CAROLINA_CROWN, THE_CADETS, PHANTOM_REGIMENT, THE_CAVALIERS, TROOPERS]];

    [self addShowWithName:@"MidCal Champions Showcase"
               atLocation:@"Clovis, CA"
                 forMonth:JUNE
                   forDay:20
      withPerformingCorps:@[CROSSMEN, BLUE_DEVILS, SANTA_CLARA_VANGUARD, BLUE_KNIGHTS, MANDARINS, PACIFIC_CREST, VANGUARD_CADETS, BLUE_DEVILS_B, BLUE_DEVILS_C, GOLDEN_EMPIRE]];
    
    [self addShowWithName:@"Show of Shows"
               atLocation:@"Rockford, IL"
                 forMonth:JUNE
                   forDay:20
      withPerformingCorps:@[PHANTOM_REGIMENT, CAROLINA_CROWN, THE_CAVALIERS, MADISON_SCOUTS, SPIRIT_OF_ATLANTA, BLUE_STARS, TROOPERS, PIONEER, COLT_CADETS]];
     
    [self addShowWithName:@"DCI West"
               atLocation:@"Stanford, CA"
                 forMonth:JUNE
                   forDay:21
      withPerformingCorps:@[BLUE_DEVILS, SANTA_CLARA_VANGUARD, CROSSMEN, BLUE_KNIGHTS, MANDARINS, PACIFIC_CREST, BLUE_DEVILS_B, BLUE_DEVILS_C, VANGUARD_CADETS]];
    
    [self addShowWithName:@"Innovations in Brass"
               atLocation:@"Akron, OH"
                 forMonth:JUNE
                   forDay:21
      withPerformingCorps:@[BLUECOATS, CAROLINA_CROWN, THE_CADETS, PHANTOM_REGIMENT, BOSTON_CRUSADERS, MADISON_SCOUTS, THE_CAVALIERS]];
    
    [self addShowWithName:@"Legends Drum Corps Preview"
               atLocation:@"Plainwell, MI"
                 forMonth:JUNE
                   forDay:21
       withPerformingCorps:@[LEGENDS, BLUE_STARS, SPIRIT_OF_ATLANTA, TROOPERS, COLTS, PIONEER, COLT_CADETS]];

    [self addShowWithName:@"DCI All Star Review"
               atLocation:@"Bowling Green, OH"
                 forMonth:JUNE
                   forDay:22
      withPerformingCorps:@[CAROLINA_CROWN, THE_CADETS, BOSTON_CRUSADERS, MADISON_SCOUTS, TROOPERS, PIONEER]];
    
    [self addShowWithName:@"Drums in the Bluegrass"
               atLocation:@"Lexington, KY"
                 forMonth:JUNE
                   forDay:22
      withPerformingCorps:@[BLUE_STARS, BLUECOATS, CINCINNATI_TRADITION, SPIRIT_OF_ATLANTA, THE_CAVALIERS]];
    
    [self addShowWithName:@"Moonlight Classic"
               atLocation:@"Sacramento, CA"
                 forMonth:JUNE
                   forDay:22
      withPerformingCorps:@[SANTA_CLARA_VANGUARD, BLUE_KNIGHTS, BLUE_DEVILS, PACIFIC_CREST, MANDARINS, CROSSMEN, BLUE_DEVILS_B, VANGUARD_CADETS, BLUE_DEVILS_C]];
    
    [self addShowWithName:@"Merrillville Music Festival"
               atLocation:@"Merrillville, IN"
                 forMonth:JUNE
                   forDay:24
      withPerformingCorps:@[MADISON_SCOUTS, PHANTOM_REGIMENT, BOSTON_CRUSADERS, COLTS, TROOPERS, PIONEER]];
    
    [self addShowWithName:@"Summer Music Games"
               atLocation:@"Fairfield, OH"
                 forMonth:JUNE
                   forDay:24
      withPerformingCorps:@[THE_CADETS, BLUECOATS, THE_CAVALIERS, BLUE_STARS, SPIRIT_OF_ATLANTA, CINCINNATI_TRADITION]];
    
    [self addShowWithName:@"Drums on the Ohio"
               atLocation:@"Evansville, IN"
                 forMonth:JUNE
                   forDay:25
      withPerformingCorps:@[MADISON_SCOUTS, PHANTOM_REGIMENT, BLUE_STARS, COLTS, TROOPERS, PIONEER]];
    
    [self addShowWithName:@"Innovations in Brass"
               atLocation:@"Pittsburgh, PA"
                 forMonth:JUNE
                   forDay:25
      withPerformingCorps:@[BLUECOATS, THE_CADETS, THE_CAVALIERS, BOSTON_CRUSADERS, SPIRIT_OF_ATLANTA]];
    
    [self addShowWithName:@"Southwest Corps Connection"
               atLocation:@"Mesa, AZ"
                 forMonth:JUNE
                   forDay:26
      withPerformingCorps:@[THE_ACADEMY, SANTA_CLARA_VANGUARD, BLUE_KNIGHTS, CROSSMEN, CITY_SOUND]];
    
    [self addShowWithName:@"Corps at the Crest"
               atLocation:@"Oceanside, CA"
                 forMonth:JUNE
                   forDay:27
      withPerformingCorps:@[BLUE_KNIGHTS, CROSSMEN, SANTA_CLARA_VANGUARD, PACIFIC_CREST, MANDARINS, THE_ACADEMY, IMPULSE, GOLD, CITY_SOUND, GOLDEN_EMPIRE, WATCHMEN, INCOGNITO]];
    
    [self addShowWithName:@"DCI Central Indiana"
               atLocation:@"Muncie, IN"
                 forMonth:JUNE
                   forDay:27
      withPerformingCorps:@[BLUE_STARS, CAROLINA_CROWN, COLTS, PHANTOM_REGIMENT, PIONEER, THE_CAVALIERS, TROOPERS]];

    [self addShowWithName:@"Drum Corps: An American Tradition"
               atLocation:@"Chambersburg, PA"
                 forMonth:JUNE
                   forDay:27
      withPerformingCorps:@[THE_CADETS, BLUECOATS, BOSTON_CRUSADERS, SPIRIT_OF_ATLANTA]];
    
    [self addShowWithName:@"Corps at the Crest"
               atLocation:@"Glendora, CA"
                 forMonth:JUNE
                   forDay:28
      withPerformingCorps:@[SANTA_CLARA_VANGUARD, BLUE_DEVILS, PACIFIC_CREST, CROSSMEN, BLUE_KNIGHTS, THE_ACADEMY, MANDARINS, GOLD, IMPULSE, CITY_SOUND, INCOGNITO, GOLDEN_EMPIRE, WATCHMEN]];

    [self addShowWithName:@"Drum Corps: An American Tradition"
               atLocation:@"Jackson, NJ"
                 forMonth:JUNE
                   forDay:28
      withPerformingCorps:@[THE_CADETS, BLUECOATS, BOSTON_CRUSADERS, SPIRIT_OF_ATLANTA, SEVENTH_REGIMENT, RAIDERS]];

    [self addShowWithName:@"Drums on Parade"
               atLocation:@"Madison, WI"
                 forMonth:JUNE
                   forDay:28
      withPerformingCorps:@[MADISON_SCOUTS, PHANTOM_REGIMENT, THE_CAVALIERS, BLUE_STARS, COLTS, TROOPERS, PIONEER, COLT_CADETS, RACINE_SCOUTS, KILTIES]];
    
    [self addShowWithName:@"East Coast Classic"
               atLocation:@"Lawrence, MA"
                 forMonth:JUNE
                   forDay:29
      withPerformingCorps:@[BOSTON_CRUSADERS, THE_CADETS, CAROLINA_CROWN, BLUECOATS, SPIRIT_OF_ATLANTA, SEVENTH_REGIMENT, SPARTANS]];
    
    [self addShowWithName:@"River City Rhapsody"
               atLocation:@"Rochester, MN"
                 forMonth:JUNE
                   forDay:29
      withPerformingCorps:@[BLUE_STARS, PHANTOM_REGIMENT, MADISON_SCOUTS, THE_CAVALIERS, TROOPERS, COLTS, PIONEER]];

    [self addShowWithName:@"Western Corps Connection"
               atLocation:@"Riverside, CA"
                 forMonth:JUNE
                   forDay:29
      withPerformingCorps:@[BLUE_DEVILS, CROSSMEN, SANTA_CLARA_VANGUARD, BLUE_KNIGHTS, THE_ACADEMY, PACIFIC_CREST, MANDARINS, GOLD, IMPULSE, CITY_SOUND, WATCHMEN, INCOGNITO, GOLDEN_EMPIRE]];
    
    [self addShowWithName:@"The Thunder of Drums"
               atLocation:@"Mankato, MN"
                 forMonth:JUNE
                   forDay:30
      withPerformingCorps:@[MADISON_SCOUTS, BLUE_STARS, TROOPERS, PIONEER, RACINE_SCOUTS]];
    
    [self addShowWithName:@"Brass Impact"
               atLocation:@"Overland Park, KS"
                 forMonth:JULY
                   forDay:1
      withPerformingCorps:@[COLTS, PHANTOM_REGIMENT, THE_CAVALIERS, JERSEY_SURF, COLT_CADETS]];
    
    [self addShowWithName:@"Pacific Procession"
               atLocation:@"Santa Clara, CA"
                 forMonth:JULY
                   forDay:1
      withPerformingCorps:@[SANTA_CLARA_VANGUARD, BLUE_KNIGHTS, CROSSMEN, MANDARINS, VANGUARD_CADETS, BLUE_DEVILS_B]];
    
    [self addShowWithName:@"Beat of the Rogue"
               atLocation:@"Medford, OR"
                 forMonth:JULY
                   forDay:2
      withPerformingCorps:@[SANTA_CLARA_VANGUARD, CROSSMEN, BLUE_KNIGHTS, OREGON_CRUSADERS]];
    
    [self addShowWithName:@"Celebration in Brass"
               atLocation:@"Waukee, IA"
                 forMonth:JULY
                   forDay:2
      withPerformingCorps:@[COLTS, BLUE_DEVILS, PHANTOM_REGIMENT, THE_CAVALIERS, BLUE_STARS, TROOPERS, JERSEY_SURF, COLT_CADETS]];
    
    [self addShowWithName:@"Connecticut Drums"
               atLocation:@"New Haven, CT"
                 forMonth:JULY
                   forDay:2
      withPerformingCorps:@[BOSTON_CRUSADERS, THE_CADETS, CAROLINA_CROWN, BLUECOATS, SPIRIT_OF_ATLANTA, SEVENTH_REGIMENT, SPARTANS]];
    
    [self addShowWithName:@"Drums of Fire"
               atLocation:@"McMinnville, OR"
                 forMonth:JULY
                   forDay:3
      withPerformingCorps:@[OREGON_CRUSADERS, BLUE_KNIGHTS, SANTA_CLARA_VANGUARD, CROSSMEN, CASCADES, COLUMBIANS, ERUPTION]];
    
    [self addShowWithName:@"Rotary Music Festival"
               atLocation:@"Cedarburg, WI"
                 forMonth:JULY
                   forDay:3
      withPerformingCorps:@[BLUE_DEVILS, MADISON_SCOUTS, JERSEY_SURF, PIONEER, GENESIS, LEGENDS, RACINE_SCOUTS]];
    
    [self addShowWithName:@"Summer Music Preview"
               atLocation:@"Bristol, RI"
                 forMonth:JULY
                   forDay:3
      withPerformingCorps:@[THE_CADETS, CAROLINA_CROWN, BLUECOATS, BOSTON_CRUSADERS, SPIRIT_OF_ATLANTA, SEVENTH_REGIMENT, SPARTANS]];
    
    [self addShowWithName:@"DCI Capital Classic Corps Show"
               atLocation:@"Sacramento, CA"
                 forMonth:JULY
                   forDay:5
      withPerformingCorps:@[MANDARINS, VANGUARD_CADETS, BLUE_DEVILS_B, IMPULSE, CITY_SOUND, BLUE_DEVILS_C, GOLDEN_EMPIRE, INCOGNITO]];
    
    [self addShowWithName:@"Pageant of Drums"
               atLocation:@"Michigan City, IN"
                 forMonth:JULY
                   forDay:5
      withPerformingCorps:@[THE_CAVALIERS, PHANTOM_REGIMENT, TROOPERS, COLTS, GENESIS, COLT_CADETS, LEGENDS]];
    
    [self addShowWithName:@"Seattle Summer Music Games"
               atLocation:@"Renton, WA"
                 forMonth:JULY
                   forDay:5
      withPerformingCorps:@[SANTA_CLARA_VANGUARD, BLUE_KNIGHTS, OREGON_CRUSADERS, CROSSMEN, CASCADES, COLUMBIANS, ERUPTION]];
    
    [self addShowWithName:@"The Beanpot Invitational"
               atLocation:@"Lynn, MA"
                 forMonth:JULY
                   forDay:5
      withPerformingCorps:@[CAROLINA_CROWN, THE_CADETS, BLUECOATS, BOSTON_CRUSADERS, SPIRIT_OF_ATLANTA, SPARTANS, SEVENTH_REGIMENT]];
    
    [self addShowWithName:@"The Whitewater Classic"
               atLocation:@"Whitewater, WI"
                 forMonth:JULY
                   forDay:5
      withPerformingCorps:@[BLUE_DEVILS, BLUE_STARS, JERSEY_SURF, KILTIES, MADISON_SCOUTS, PIONEER, RACINE_SCOUTS]];
    
    [self addShowWithName:@"Cavalcade of Brass"
               atLocation:@"Lisle, IL"
                 forMonth:JULY
                   forDay:JUNE
      withPerformingCorps:@[THE_CAVALIERS, BLUE_DEVILS, PHANTOM_REGIMENT, MADISON_SCOUTS, BLUE_STARS, TROOPERS, RACINE_SCOUTS]];
    
    [self addShowWithName:@"Dixon Petunia Festival"
               atLocation:@"Dixon, IL"
                 forMonth:JULY
                   forDay:JUNE
      withPerformingCorps:@[COLTS, JERSEY_SURF, PIONEER, COLT_CADETS, GENESIS, LEGENDS]];
    
    [self addShowWithName:@"Drum Corps: An American Tradition"
               atLocation:@"Chester, PA"
                 forMonth:JULY
                   forDay:JUNE
      withPerformingCorps:@[BLUECOATS, BOSTON_CRUSADERS, CAROLINA_CROWN, SPIRIT_OF_ATLANTA, THE_CADETS]];
    
    [self addShowWithName:@"Drums Along the Columbia"
               atLocation:@"Tri Cities, WA"
                 forMonth:JULY
                   forDay:JUNE
      withPerformingCorps:@[BLUE_KNIGHTS, SANTA_CLARA_VANGUARD, CROSSMEN, OREGON_CRUSADERS, CASCADES, COLUMBIANS, ERUPTION]];
    
    [self addShowWithName:@"Loudest Show on Earth"
               atLocation:@"Pleasant Hill, CA"
                 forMonth:JULY
                   forDay:JUNE
      withPerformingCorps:@[BLUE_DEVILS_B, BLUE_DEVILS_C, CITY_SOUND, GOLDEN_EMPIRE, IMPULSE, INCOGNITO, MANDARINS, VANGUARD_CADETS]];
    
    [self addShowWithName:@"Boise Summer Music Games"
               atLocation:@"Boise, ID"
                 forMonth:JULY
                   forDay:AUGUST
      withPerformingCorps:@[CROSSMEN, BLUE_KNIGHTS, SANTA_CLARA_VANGUARD, OREGON_CRUSADERS, THE_ACADEMY, CASCADES, IMPULSE]];
    
    [self addShowWithName:@"DCI Ft. Wayne"
               atLocation:@"Ft. Wayne, IN"
                 forMonth:JULY
                   forDay:AUGUST
      withPerformingCorps:@[BLUE_DEVILS, BLUE_SAINTS, BLUECOATS, BOSTON_CRUSADERS, JERSEY_SURF, LEGENDS, MUSIC_CITY, SPIRIT_OF_ATLANTA]];
    
    [self addShowWithName:@"Music On The March"
               atLocation:@"Dubuque, IA"
                 forMonth:JULY
                   forDay:AUGUST
      withPerformingCorps:@[COLTS, THE_CAVALIERS, MADISON_SCOUTS, BLUE_STARS, TROOPERS, PIONEER, COLT_CADETS, GENESIS, RACINE_SCOUTS]];

    [self addShowWithName:@"Corps Encore"
               atLocation:@"Ogden, UT"
                 forMonth:JULY
                   forDay:9
      withPerformingCorps:@[BLUE_KNIGHTS, SANTA_CLARA_VANGUARD, OREGON_CRUSADERS, PACIFIC_CREST, THE_ACADEMY, CROSSMEN, CASCADES, IMPULSE]];
    
    [self addShowWithName:@"Show of Shows"
               atLocation:@"Metamora, IL"
                 forMonth:JULY
                   forDay:9
      withPerformingCorps:@[PHANTOM_REGIMENT, BLUE_DEVILS, THE_CADETS, COLTS, PIONEER, MUSIC_CITY, LEGENDS, BLUE_SAINTS]];
    
    [self addShowWithName:@"Music on the Border"
               atLocation:@"Salem, WI"
                 forMonth:JULY
                   forDay:10
      withPerformingCorps:@[PHANTOM_REGIMENT, THE_CADETS, SPIRIT_OF_ATLANTA, JERSEY_SURF, PIONEER, COLT_CADETS, RACINE_SCOUTS]];
    
    [self addShowWithName:@"DCI Eden Prairie"
               atLocation:@"Eden Prairie, MN"
                 forMonth:JULY
                   forDay:11
      withPerformingCorps:@[BLUE_DEVILS, BLUE_SAINTS, BLUECOATS, BOSTON_CRUSADERS, JERSEY_SURF, LEGENDS]];
    
    [self addShowWithName:@"Drums Along the Rockies - Cheyenne Edition"
               atLocation:@"Cheyenne, WY"
                 forMonth:JULY
                   forDay:11
      withPerformingCorps:@[TROOPERS, MADISON_SCOUTS, OREGON_CRUSADERS, THE_ACADEMY, CASCADES, PACIFIC_CREST]];
     
     [self addShowWithName:@"DCI La Crosse"
                atLocation:@"La Crosse, WI"
                  forMonth:JULY
                    forDay:12
       withPerformingCorps:@[BLUE_SAINTS, BLUE_STARS, BLUECOATS, BOSTON_CRUSADERS, CAROLINA_CROWN, COLTS, JERSEY_SURF, LEGENDS, MUSIC_CITY, PHANTOM_REGIMENT, RACINE_SCOUTS, SPIRIT_OF_ATLANTA, THE_CADETS, THE_CAVALIERS]];
    
    [self addShowWithName:@"Drums Along the Rockies"
               atLocation:@"Denver, CO"
                 forMonth:JULY
                   forDay:12
      withPerformingCorps:@[BLUE_KNIGHTS, SANTA_CLARA_VANGUARD, MADISON_SCOUTS, TROOPERS, CROSSMEN, PACIFIC_CREST, OREGON_CRUSADERS, MANDARINS, CASCADES, THE_ACADEMY]];
    
    [self addShowWithName:@"Gold Showcase at the Ranch"
               atLocation:@"Vista, CA"
                 forMonth:JULY
                   forDay:12
      withPerformingCorps:@[GOLD, VANGUARD_CADETS, BLUE_DEVILS_B, IMPULSE, CITY_SOUND, BLUE_DEVILS_C, INCOGNITO, WATCHMEN, GOLDEN_EMPIRE]];
    
    [self addShowWithName:@"Percussion at the Pearl"
               atLocation:@"Muscatine, IA"
                 forMonth:JULY
                   forDay:13
      withPerformingCorps:@[COLTS, BOSTON_CRUSADERS, SPIRIT_OF_ATLANTA, PIONEER, COLT_CADETS, LEGENDS, LOUISIANA_STARS]];
    
    [self addShowWithName:@"So Cal Classic Open Class Championships"
               atLocation:@"Cerritos, CA"
                 forMonth:JULY
                   forDay:13
      withPerformingCorps:@[BLUE_DEVILS_B, BLUE_DEVILS_C, CITY_SOUND, GOLD, IMPULSE, VANGUARD_CADETS, GOLDEN_EMPIRE, INCOGNITO, WATCHMEN]];
    
    [self addShowWithName:@"Tour of Champions - Northern Illinois"
               atLocation:@"DeKalb, IL"
                 forMonth:JULY
                   forDay:13
      withPerformingCorps:@[PHANTOM_REGIMENT, THE_CAVALIERS, THE_CADETS, CAROLINA_CROWN, BLUE_STARS, BLUECOATS, BLUE_DEVILS]];
    
    [self addShowWithName:@"DCI St. Louis"
               atLocation:@"Lebanon, IL"
                 forMonth:JULY
                   forDay:14
      withPerformingCorps:@[BOSTON_CRUSADERS, COLTS, JERSEY_SURF, LOUISIANA_STARS, MUSIC_CITY, PIONEER, SPIRIT_OF_ATLANTA]];
    
    [self addShowWithName:@"Drums Across Nebraska"
               atLocation:@"Omaha, NE"
                 forMonth:JULY
                   forDay:14
      withPerformingCorps:@[MADISON_SCOUTS, BLUE_KNIGHTS, CROSSMEN, OREGON_CRUSADERS, PACIFIC_CREST, THE_ACADEMY, CASCADES]];
    
    [self addShowWithName:@"Tour of Champions - Central Missouri"
               atLocation:@"Warrensburg, MO"
                 forMonth:JULY
                   forDay:14
      withPerformingCorps:@[BLUE_DEVILS, BLUECOATS, CAROLINA_CROWN, PHANTOM_REGIMENT, SANTA_CLARA_VANGUARD, THE_CADETS, THE_CAVALIERS]];
    
    [self addShowWithName:@"Drums Across Kansas"
               atLocation:@"Wichita, KS"
                 forMonth:JULY
                   forDay:15
      withPerformingCorps:@[BLUE_DEVILS, MADISON_SCOUTS, BLUE_KNIGHTS, TROOPERS, OREGON_CRUSADERS, MANDARINS, THE_ACADEMY]];
    
    [self addShowWithName:@"Music on the Move"
               atLocation:@"Bentonville, AR"
                 forMonth:JULY
                   forDay:15
      withPerformingCorps:@[CAROLINA_CROWN, BLUE_STARS, CROSSMEN, COLTS, PIONEER, CASCADES, MUSIC_CITY, GENESIS, LOUISIANA_STARS]];
    
    [self addShowWithName:@"Drums of Summer"
               atLocation:@"Tulsa, OK"
                 forMonth:JULY
                   forDay:16
      withPerformingCorps:@[THE_CADETS, PHANTOM_REGIMENT, BLUE_KNIGHTS, SPIRIT_OF_ATLANTA, TROOPERS, PACIFIC_CREST, MANDARINS, THE_ACADEMY, JERSEY_SURF, CASCADES]];
    
    [self addShowWithName:@"DCI Austin"
               atLocation:@"Round Rock, TX"
                 forMonth:JULY
                   forDay:17
      withPerformingCorps:@[BLUE_STARS, BOSTON_CRUSADERS, COLTS, CROSSMEN, GENESIS, GUARDIANS, MADISON_SCOUTS, THE_CADETS, TROOPERS]];
    
    [self addShowWithName:@"DCI Denton"
               atLocation:@"Denton, TX"
                 forMonth:JULY
                   forDay:17
      withPerformingCorps:@[BLUECOATS, CAROLINA_CROWN, CASCADES, JERSEY_SURF, MANDARINS, OREGON_CRUSADERS, PACIFIC_CREST, PIONEER, SANTA_CLARA_VANGUARD, THE_ACADEMY, THE_CAVALIERS]];
    
    [self addShowWithName:@"Tour of Champions"
               atLocation:@"Houston, TX"
                 forMonth:JULY
                   forDay:18
      withPerformingCorps:@[BLUE_DEVILS, BLUE_KNIGHTS, BLUECOATS, CAROLINA_CROWN, PHANTOM_REGIMENT, SANTA_CLARA_VANGUARD, THE_CAVALIERS]];
    
    [self addShowWithName:@"DCI Southwestern Championships"
               atLocation:@"San Antonio, TX"
                 forMonth:JULY
                   forDay:19
      withPerformingCorps:@[BLUE_DEVILS, BLUE_KNIGHTS, BLUE_STARS, BLUECOATS, BOSTON_CRUSADERS, CAROLINA_CROWN, CASCADES, COLTS, CROSSMEN, GENESIS, GUARDIANS, JERSEY_SURF, MADISON_SCOUTS, MANDARINS, OREGON_CRUSADERS, PACIFIC_CREST, PHANTOM_REGIMENT, PIONEER, SANTA_CLARA_VANGUARD, SPIRIT_OF_ATLANTA, THE_ACADEMY, THE_CADETS, THE_CAVALIERS, TROOPERS]];
    
    [self addShowWithName:@"Fiesta De Musica"
               atLocation:@"Manchester, NH"
                 forMonth:JULY
                   forDay:19
      withPerformingCorps:@[SPARTANS, SEVENTH_REGIMENT, LES_STENTORS, LEGENDS, RACINE_SCOUTS]];
    
    [self addShowWithName:@"DCI Dallas"
               atLocation:@"Dallas, TX"
                 forMonth:JULY
                   forDay:21
      withPerformingCorps:@[BLUE_KNIGHTS, BLUECOATS, CAROLINA_CROWN, CASCADES, CROSSMEN, GENESIS, JERSEY_SURF, MADISON_SCOUTS, THE_ACADEMY, THE_CADETS]];
    
    [self addShowWithName:@"Drums Across Cajun Field"
               atLocation:@"Lafayette, LA"
                 forMonth:JULY
                   forDay:21
      withPerformingCorps:@[PHANTOM_REGIMENT, BLUE_DEVILS, THE_CAVALIERS, SPIRIT_OF_ATLANTA, BLUE_STARS, COLTS, PACIFIC_CREST, MANDARINS, PIONEER, LOUISIANA_STARS]];
    
    [self addShowWithName:@"DCI in the Heartland"
               atLocation:@"Mustang, OK"
                 forMonth:JULY
                   forDay:22
      withPerformingCorps:@[CAROLINA_CROWN, THE_CADETS, BLUECOATS, BLUE_KNIGHTS, CROSSMEN, OREGON_CRUSADERS, THE_ACADEMY, CASCADES]];
    
    [self addShowWithName:@"Mississippi Sound Spectacular"
               atLocation:@"Ocean Springs, MS"
                 forMonth:JULY
                   forDay:22
      withPerformingCorps:@[SANTA_CLARA_VANGUARD, THE_CAVALIERS, SPIRIT_OF_ATLANTA, BLUE_STARS, PACIFIC_CREST, MANDARINS, PIONEER]];
    
    [self addShowWithName:@"DCI Arkansas"
               atLocation:@"Little Rock, AR"
                 forMonth:JULY
                   forDay:23
      withPerformingCorps:@[BLUE_KNIGHTS, BLUECOATS, BOSTON_CRUSADERS, CAROLINA_CROWN, CASCADES, CROSSMEN, OREGON_CRUSADERS, THE_ACADEMY, THE_CADETS]];
    
    [self addShowWithName:@"DCI Southern Mississippi"
               atLocation:@"Hattiesburg, MS"
                 forMonth:JULY
                   forDay:23
      withPerformingCorps:@[BLUE_DEVILS, COLTS, JERSEY_SURF, MADISON_SCOUTS, PACIFIC_CREST, PIONEER, TROOPERS]];
    
    [self addShowWithName:@"A Blast in the Burg"
               atLocation:@"Johnsonburg, PA"
                 forMonth:JULY
                   forDay:24
      withPerformingCorps:@[SPARTANS, SEVENTH_REGIMENT, LEGENDS, RAIDERS, LES_STENTORS, COASTAL_SURGE]];
    
    [self addShowWithName:@"Alabma Sounds of Summer"
               atLocation:@"Opelika, AL"
                 forMonth:JULY
                   forDay:24
      withPerformingCorps:@[SPIRIT_OF_ATLANTA, MADISON_SCOUTS, BLUE_STARS, COLTS, MANDARINS, PIONEER]];
    
    [self addShowWithName:@"DCI North Alabama"
               atLocation:@"Huntsville, AL"
                 forMonth:JULY
                   forDay:25
      withPerformingCorps:@[BLUE_KNIGHTS, BLUE_STARS, CASCADES, COLTS, CROSSMEN, JERSEY_SURF, MADISON_SCOUTS, PACIFIC_CREST, PIONEER, SPIRIT_OF_ATLANTA, THE_ACADEMY, TROOPERS]];
    
    [self addShowWithName:@"The Masters of the Summer Music Games"
               atLocation:@"Nashville, TN"
                 forMonth:JULY
                   forDay:25
      withPerformingCorps:@[BLUE_DEVILS, BLUECOATS, BOSTON_CRUSADERS, CAROLINA_CROWN, MUSIC_CITY, PHANTOM_REGIMENT, SANTA_CLARA_VANGUARD, THE_CADETS, THE_CAVALIERS]];
    
    [self addShowWithName:@"DCI Southeastern Championships"
               atLocation:@"Atlanta, GA"
                 forMonth:JULY
                   forDay:26
      withPerformingCorps:@[BLUE_DEVILS, BLUE_KNIGHTS, BLUE_STARS, BLUECOATS, BOSTON_CRUSADERS, CAROLINA_CROWN, CASCADES, COLTS, CROSSMEN, JERSEY_SURF, MADISON_SCOUTS, MANDARINS, OREGON_CRUSADERS, PACIFIC_CREST, PHANTOM_REGIMENT, PIONEER, SANTA_CLARA_VANGUARD, SPIRIT_OF_ATLANTA, THE_ACADEMY, THE_CADETS, THE_CAVALIERS, TROOPERS]];
    
    [self addShowWithName:@"Legends Drum Corps Open"
               atLocation:@"Paw Paw, MI"
                 forMonth:JULY
                   forDay:26
      withPerformingCorps:@[LEGENDS, VANGUARD_CADETS, GENESIS, SEVENTH_REGIMENT, RAIDERS, LES_STENTORS, COASTAL_SURGE]];
    
    [self addShowWithName:@"Drum Corps Competition"
               atLocation:@"Greendale, WI"
                 forMonth:JULY
                   forDay:27
      withPerformingCorps:@[BLUE_DEVILS_B, SPARTANS, COLT_CADETS, RACINE_SCOUTS, BLUE_SAINTS, KILTIES]];
    
    [self addShowWithName:@"NightBEAT Tour of Champions"
               atLocation:@"Charlotte, NC"
                 forMonth:JULY
                   forDay:27
      withPerformingCorps:@[CAROLINA_CROWN, PHANTOM_REGIMENT, BLUE_DEVILS, SANTA_CLARA_VANGUARD, SPIRIT_OF_ATLANTA, THE_CAVALIERS, THE_CADETS]];
    
    [self addShowWithName:@"Drums Across the Tri-State"
               atLocation:@"Charleston, WV"
                 forMonth:JULY
                   forDay:28
      withPerformingCorps:@[PHANTOM_REGIMENT, BLUECOATS, BOSTON_CRUSADERS, SPIRIT_OF_ATLANTA, CROSSMEN, MANDARINS, OREGON_CRUSADERS]];
    
    [self addShowWithName:@"Emerald City Music Games"
               atLocation:@"Dublin, OH"
                 forMonth:JULY
                   forDay:28
      withPerformingCorps:@[SANTA_CLARA_VANGUARD, MADISON_SCOUTS, BLUE_KNIGHTS, TROOPERS, PACIFIC_CREST, JERSEY_SURF, CASCADES, VANGUARD_CADETS]];
    
    [self addShowWithName:@"Rhythm Across Rice Lake"
               atLocation:@"Rice Lake, WI"
                 forMonth:JULY
                   forDay:28
      withPerformingCorps:@[BLUE_DEVILS_B, SPARTANS, RACINE_SCOUTS, MUSIC_CITY, BLUE_SAINTS]];
    
    [self addShowWithName:@"Lake Erie Fanfare"
               atLocation:@"Erie, PA"
                 forMonth:JULY
                   forDay:29
      withPerformingCorps:@[MADISON_SCOUTS, BLUE_KNIGHTS, TROOPERS, OREGON_CRUSADERS, MANDARINS, PACIFIC_CREST, JERSEY_SURF, CASCADES, LES_STENTORS]];
    
    [self addShowWithName:@"Legends Drum Corps Invitational"
               atLocation:@"Troy, MI"
                 forMonth:JULY
                   forDay:29
      withPerformingCorps:@[LEGENDS, VANGUARD_CADETS, GENESIS, SEVENTH_REGIMENT, RAIDERS, LES_STENTORS, COASTAL_SURGE]];
    
    [self addShowWithName:@"Summer Music Games of Southwest Virginia"
               atLocation:@"Salem, VA"
                 forMonth:JULY
                   forDay:29
      withPerformingCorps:@[BLUE_DEVILS, CAROLINA_CROWN, THE_CAVALIERS, BLUE_STARS, COLTS, THE_ACADEMY, PIONEER]];
    
    [self addShowWithName:@"A Knight of Music and Motion"
               atLocation:@"St. Paul, MN"
                 forMonth:JULY
                   forDay:30
      withPerformingCorps:@[BLUE_DEVILS_B, SPARTANS, MUSIC_CITY, GOLD, COLT_CADETS, RACINE_SCOUTS, BLUE_SAINTS]];
    
    [self addShowWithName:@"Drum Corps: An American Tradition"
               atLocation:@"West Chester, PA"
                 forMonth:JULY
                   forDay:30
      withPerformingCorps:@[THE_CADETS, CAROLINA_CROWN, BLUECOATS, THE_CAVALIERS, SPIRIT_OF_ATLANTA, BLUE_STARS, CROSSMEN, COLTS, JERSEY_SURF]];
    
    [self addShowWithName:@"Drums Along the Mohawk"
               atLocation:@"Rome, NY"
                 forMonth:JULY
                   forDay:30
      withPerformingCorps:@[BOSTON_CRUSADERS, MADISON_SCOUTS, BLUE_KNIGHTS, TROOPERS, PACIFIC_CREST, OREGON_CRUSADERS, MANDARINS, CASCADES]];
    
    [self addShowWithName:@"CYO Nationals Tribute"
               atLocation:@"Quincy, MA"
                 forMonth:JULY
                   forDay:30
      withPerformingCorps:@[BOSTON_CRUSADERS, MADISON_SCOUTS, TROOPERS, CROSSMEN, JERSEY_SURF]];
    
    [self addShowWithName:@"Tour of Champions"
               atLocation:@"Piscataway, NJ"
                 forMonth:JULY
                   forDay:30
      withPerformingCorps:@[THE_CADETS, THE_CAVALIERS, BLUECOATS, BLUE_DEVILS, PHANTOM_REGIMENT, SANTA_CLARA_VANGUARD, CAROLINA_CROWN]];
    
    [self addShowWithName:@"DCI Eastern Classic"
               atLocation:@"Allentown, PA"
                 forMonth:AUGUST
                   forDay:1
      withPerformingCorps:@[BLUE_DEVILS, BLUE_KNIGHTS, BLUE_STARS, BOSTON_CRUSADERS, CASCADES, COLTS, OREGON_CRUSADERS, PACIFIC_CREST, PHANTOM_REGIMENT, PIONEER, SANTA_CLARA_VANGUARD]];
    
    [self addShowWithName:@"North Iowa Festival of Brass"
               atLocation:@"Forest City, IA"
                 forMonth:AUGUST
                   forDay:1
      withPerformingCorps:@[BLUE_DEVILS_B, SPARTANS, MUSIC_CITY, GOLD, COLT_CADETS, RACINE_SCOUTS, BLUE_SAINTS]];
    
    [self addShowWithName:@"DCI Eastern Classic"
               atLocation:@"Allentown, PA"
                 forMonth:AUGUST
                   forDay:2
      withPerformingCorps:@[BLUECOATS, CAROLINA_CROWN, CROSSMEN, JERSEY_SURF, MADISON_SCOUTS, MANDARINS, SPIRIT_OF_ATLANTA, THE_ACADEMY, THE_CADETS, THE_CAVALIERS, TROOPERS]];
    
    [self addShowWithName:@"Shoremen Brass Classic"
               atLocation:@"Avon Lake, OH"
                 forMonth:AUGUST
                   forDay:2
      withPerformingCorps:@[VANGUARD_CADETS, GENESIS, SEVENTH_REGIMENT, LEGENDS, RAIDERS, LES_STENTORS, COASTAL_SURGE]];
    
    [self addShowWithName:@"DCI Pittsburgh"
               atLocation:@"Pittsburgh, PA"
                 forMonth:AUGUST
                   forDay:3
      withPerformingCorps:@[PHANTOM_REGIMENT, BOSTON_CRUSADERS, BLUE_STARS, BLUE_KNIGHTS, COLTS, PACIFIC_CREST, MANDARINS, CASCADES]];


    [self addShowWithName:@"Tour of Champions"
               atLocation:@"Buffalo, NY"
                 forMonth:AUGUST
                   forDay:3
      withPerformingCorps:@[BLUE_DEVILS, THE_CADETS, THE_CAVALIERS, CAROLINA_CROWN, TROOPERS, BLUECOATS, SANTA_CLARA_VANGUARD]];
    
    [self addShowWithName:@"Tour of Champions"
               atLocation:@"Massillon, OH"
                 forMonth:AUGUST
                   forDay:4
      withPerformingCorps:@[BLUECOATS, SANTA_CLARA_VANGUARD, CAROLINA_CROWN, THE_CADETS, PHANTOM_REGIMENT, CROSSMEN, BOSTON_CRUSADERS]];
    
    [self addShowWithName:@"DCI World Championships Open Class Prelims"
               atLocation:@"Michigan City, IN"
                 forMonth:AUGUST
                   forDay:4
      withPerformingCorps:@[SEVENTH_REGIMENT, BLUE_DEVILS_B, BLUE_SAINTS, COASTAL_SURGE, COLT_CADETS, GENESIS, GOLD, LEGENDS, LES_STENTORS, MUSIC_CITY, RACINE_SCOUTS, RAIDERS, SPARTANS, VANGUARD_CADETS]];
    
    [self addShowWithName:@"Soaring Sounds 35"
               atLocation:@"Centerville, OH"
                 forMonth:AUGUST
                   forDay:4
      withPerformingCorps:@[THE_CAVALIERS, BLUE_KNIGHTS, BLUE_STARS, SPIRIT_OF_ATLANTA, COLTS, OREGON_CRUSADERS, PACIFIC_CREST, JERSEY_SURF, THE_ACADEMY, CINCINNATI_TRADITION]];
    
    [self addShowWithName:@"DCI World Championships Open Class Finals"
               atLocation:@"Michigan City, IN"
                 forMonth:AUGUST
                   forDay:5
      withPerformingCorps:@[]];
    
    [self addShowWithName:@"DCI World Championships Prelims"
               atLocation:@"Indianapolis, IN"
                 forMonth:AUGUST
                   forDay:JULY
      withPerformingCorps:@[]];
    
    [self addShowWithName:@"DCI World Championships Semifinals"
               atLocation:@"Indianapolis, IN"
                 forMonth:AUGUST
                   forDay:AUGUST
      withPerformingCorps:@[]];
    
    [self addShowWithName:@"DCI World Championships Finals"
               atLocation:@"Indianapolis, IN"
                 forMonth:AUGUST
                   forDay:9
      withPerformingCorps:@[]];

}


-(void)addShowWithName:(NSString *)showName
            atLocation:(NSString *)showLocation
              forMonth:(NSInteger)month
                forDay:(NSInteger)day
   withPerformingCorps:(NSArray *)corpsArray {
    
    PFObject *newShow = [PFObject objectWithClassName:@"shows"];
    
    newShow[@"isShowOver"] = [NSNumber numberWithBool:NO];
    newShow[@"showName"] = showName;
    newShow[@"showLocation"] = showLocation;
    newShow[@"showDate"] = [NSDate dateWithTimeInterval:60*60*50 sinceDate:[JustinHelper dateWithMonth:month day:day year:YEAR]];
    newShow[@"showDate"] = [JustinHelper dateWithMonth:month
                                                   day:day
                                                  year:YEAR];
    
    for (NSString *corps in corpsArray) {
        [newShow addUniqueObject:corps forKey:@"arrayOfCorps"];
    }
    
    [newShow saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) NSLog(@"Show created: %@", newShow[@"showName"]);
    }];
    
    for (NSString *corps in corpsArray) {
        [self createEmptyScoreForCorps:[self getCorpsByName:corps] atShow:newShow];
    }
}

-(void)createEmptyScoreForCorps:(PFObject *)corps atShow:(PFObject *)show {
    
    PFObject *score = [PFObject objectWithClassName:@"scores"];
    [score setObject:corps forKey:@"corps"];
    [score setObject:show forKey:@"show"];
    score[@"corpsName"] = corps[@"corpsName"];
    score[@"isOfficial"] = [NSNumber numberWithBool:YES];
    score[@"class"] = corps[@"class"];
    score[@"showDate"] = show[@"showDate"];
    [score saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) NSLog(@"Empty score created for %@                      %@", corps[@"corpsName"], show[@"showLocation"]);
    }];
}

-(void)addCorps:(NSString *)corpsName corpClass:(NSString *)corpsClass {
    
    PFObject *newCorps = [PFObject objectWithClassName:@"corps"];
    newCorps[@"corpsName"] = corpsName;
    newCorps[@"class"] = corpsClass;
    [newCorps saveInBackground];
}

-(PFObject *)getCorpsByName:(NSString *)name {
    
    for (PFObject *corps in self.arrayOfCorpsObjects) {
        if ([corps[@"corpsName"]  isEqualToString: name]) {
            return corps;
        }
    }
    NSLog(@"couldnt find %@", name);
    return nil;
}

#pragma mark
#pragma mark - KVNProgress Configurations
#pragma mark
+(KVNProgressConfiguration *)standardProgressConfig {
    [KVNProgress dismiss];
    KVNProgressConfiguration *configuration = [[KVNProgressConfiguration alloc] init];
    configuration.backgroundType = KVNProgressBackgroundTypeSolid;
    configuration.statusColor = [UIColor whiteColor];
    configuration.statusFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0f];
    configuration.circleStrokeForegroundColor = [UIColor colorWithRed:0/255.0 green:174/255.0 blue:237/255.0 alpha:1];
    configuration.circleStrokeBackgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    configuration.circleFillBackgroundColor = [UIColor clearColor];
    configuration.backgroundFillColor = [UIColor clearColor];
    configuration.backgroundTintColor = [UIColor clearColor];
    configuration.successColor = [UIColor greenColor];
    configuration.errorColor = [UIColor redColor];
    configuration.circleSize = 75.0f;
    configuration.lineWidth = 2.0f;
    configuration.fullScreen = NO;
    configuration.minimumSuccessDisplayTime = .5;
    configuration.minimumErrorDisplayTime = 5;
    configuration.allowUserInteraction = YES;
    
    return configuration;
}

+(KVNProgressConfiguration *)errorProgressConfig {
    [KVNProgress dismiss];
    KVNProgressConfiguration *configuration = [[KVNProgressConfiguration alloc] init];
    configuration.backgroundType = KVNProgressBackgroundTypeBlurred;
    configuration.statusColor = [UIColor whiteColor];
    configuration.statusFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0f];
    //configuration.backgroundFillColor = [UIColor blackColor];
    configuration.backgroundTintColor = [UIColor blackColor];
    configuration.errorColor = [UIColor redColor];
    configuration.circleSize = 75.0f;
    configuration.lineWidth = 2.0f;
    configuration.fullScreen = NO;
    configuration.minimumSuccessDisplayTime = .5;
    configuration.minimumErrorDisplayTime = 4;

    // See the documentation of KVNProgressConfiguration
//    configuration.statusColor = [UIColor whiteColor];
//    configuration.statusFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0f];
//    configuration.circleStrokeForegroundColor = [UIColor whiteColor];
//    configuration.circleStrokeBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
//    configuration.circleFillBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.1f];
//    configuration.backgroundFillColor = [UIColor colorWithRed:0.173f green:0.263f blue:0.856f alpha:0.9f];
//    configuration.backgroundTintColor = [UIColor colorWithRed:0.173f green:0.263f blue:0.856f alpha:0.4f];
//    configuration.successColor = [UIColor whiteColor];
//    configuration.errorColor = [UIColor whiteColor];
//    configuration.circleSize = 110.0f;
//    configuration.lineWidth = 1.0f;
//    configuration.backgroundType = KVNProgressBackgroundTypeBlurred;
    configuration.allowUserInteraction = NO;
    configuration.fullScreen = YES;
    configuration.tapBlock = ^(KVNProgress *progressView) {
        KVNProgress.configuration.tapBlock = nil;
        [KVNProgress dismiss];
    };
    return configuration;
}

-(NSMutableArray *)arrayOfCorpsObjects {
    if (!_arrayOfCorpsObjects) {
        _arrayOfCorpsObjects = [[NSMutableArray alloc] init];
    }
    return _arrayOfCorpsObjects;
}


@end
