//
//  Configuration.m
//  CorpsJudge
//
//  Created by Justin Moore on 6/18/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "Configuration.h"
#import "Corpsboard-Swift.h"

//105 shows
//804 blank scores
//22 world class
//27 open class
//49 corps

NSInteger const JUNE = 6;
NSInteger const JULY = 7;
NSInteger const AUGUST = 8;
NSInteger const YEAR = 2016;

// World Class - 22 Corps
NSString *const CADETS = @"The Cadets";
NSString *const THE_ACADEMY = @"The Academy";
NSString *const BLUEDEVILS = @"Blue Devils";
NSString *const BLUEKNIGHTS = @"Blue Knights";
NSString *const BLUECOATS = @"Bluecoats";
NSString *const BLUESTARS = @"Blue Stars";
NSString *const BOSTONCRUSADERS = @"Boston Crusaders";
NSString *const CROWN = @"Carolina Crown";
NSString *const CASCADES = @"Cascades";
NSString *const CAVALIERS = @"The Cavaliers";
NSString *const COLTS = @"Colts";
NSString *const CROSSMEN = @"Crossmen";
NSString *const JERSEYSURF = @"Jersey Surf";
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
NSString *const BLUEDEVILSB = @"Blue Devils B";
NSString *const BLUEDEVILSC = @"Blue Devils C";
NSString *const BLUESAINTS = @"Blue Saints";
NSString *const CITYSOUND = @"City Sound";
NSString *const COASTALSURGE = @"Coastal Surge";
NSString *const COLTCADETS = @"Colt Cadets";
NSString *const COLUMBIANS = @"Columbians";
NSString *const ERUPTION = @"Eruption";
NSString *const GENESIS = @"Genesis";
NSString *const GOLD = @"Gold";
NSString *const GOLDENEMPIRE = @"Golden Empire";
NSString *const GUARDIANS = @"Guardians";
NSString *const IMPULSE = @"Impulse";
NSString *const INCOGNITO = @"Incognito";
NSString *const LEGENDS = @"Legends";
NSString *const LESSTENTORS = @"Les Stentors";
NSString *const LOUISIANA_STARS = @"Louisiana Stars";
NSString *const MUSICCITY = @"Music City";
NSString *const RACINESCOUTS = @"Racine Scouts";
NSString *const RAIDERS = @"Raiders";
NSString *const SPARTANS = @"Spartans";
NSString *const THUNDER = @"Thunder";
NSString *const VANGUARDCADETS = @"Vanguard Cadets";
NSString *const WATCHMEN = @"Watchmen";
NSString *const RIVERCITYRHYTHM = @"River City Rhythm";
NSString *const SOUTHWIND = @"Southwind";
NSString *const HEATWAVE = @"Heat Wave";
NSString *const SHADOW = @"Shadow";
NSString *const THE_BATTALION = @"The Battalion";

//DCA
NSString *const JUBAL = @"Jubal"; //from the netherlands
NSString *const CADETS2 = @"Cadets 2";
NSString *const HAWTHORNE_CABALLEROS = @"Hawthorne Caballeros";
NSString *const CONNECTICUT_HURRICANES = @"Connecticut Hurricanes";
NSString *const ALLIANCE = @"Alliance";

// All Age - 10 Corps
NSString *const THE_MUCHACHOS = @"The Muchachos";
NSString *const MINNESOTABRASS = @"Minnesota Brass";
NSString *const GOVENAIRES = @"Govenaires";
NSString *const DEFENDERS = @"Defenders";
NSString *const CRUSADERSSENIOR = @"Crusaders Senior";
NSString *const CAROLINAGOLD = @"Carolina Gold";
NSString *const BRIDGEMENALUMNI = @"Bridgemen Alumni";
NSString *const ATLANTACV = @"Atlanta CV";
NSString *const CINCINNATITRADITION = @"Cincinnati Tradition";
NSString *const KILTIES = @"Kilties";
NSString *const SOUTHERN_KNIGHTS = @"Southern Knights";
NSString *const NORTHSTAR = @"North Star";
NSString *const FREELANCERS_ALUMNI = @"Freelancers Alumni Corps";

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
    [self addCorps:CADETS corpClass:@"World"];
    [self addCorps:THE_ACADEMY corpClass:@"World"];
    [self addCorps:BLUEDEVILS corpClass:@"World"];
    [self addCorps:BLUEKNIGHTS corpClass:@"World"];
    [self addCorps:BLUECOATS corpClass:@"World"];
    [self addCorps:BLUESTARS corpClass:@"World"];
    [self addCorps:BOSTONCRUSADERS corpClass:@"World"];
    [self addCorps:CROWN corpClass:@"World"];
    [self addCorps:CASCADES corpClass:@"World"];
    [self addCorps:CAVALIERS corpClass:@"World"];
    [self addCorps:COLTS corpClass:@"World"];
    [self addCorps:CROSSMEN corpClass:@"World"];
    [self addCorps:JERSEYSURF corpClass:@"World"];
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
    [self addCorps:BLUEDEVILSB corpClass:@"Open"];
    [self addCorps:BLUEDEVILSC corpClass:@"Open"];
    [self addCorps:BLUESAINTS corpClass:@"Open"];
    [self addCorps:CITYSOUND corpClass:@"Open"];
    [self addCorps:COASTALSURGE corpClass:@"Open"];
    [self addCorps:COLTCADETS corpClass:@"Open"];
    [self addCorps:COLUMBIANS corpClass:@"Open"];
    [self addCorps:ERUPTION corpClass:@"Open"];
    [self addCorps:GENESIS corpClass:@"Open"];
    [self addCorps:GOLD corpClass:@"Open"];
    [self addCorps:GOLDENEMPIRE corpClass:@"Open"];
    [self addCorps:GUARDIANS corpClass:@"Open"];
    [self addCorps:IMPULSE corpClass:@"Open"];
    [self addCorps:INCOGNITO corpClass:@"Open"];
    [self addCorps:LEGENDS corpClass:@"Open"];
    [self addCorps:LESSTENTORS corpClass:@"Open"];
    [self addCorps:LOUISIANA_STARS corpClass:@"Open"];
    [self addCorps:MUSICCITY corpClass:@"Open"];
    [self addCorps:RACINESCOUTS corpClass:@"Open"];
    [self addCorps:RAIDERS corpClass:@"Open"];
    [self addCorps:SPARTANS corpClass:@"Open"];
    [self addCorps:THUNDER corpClass:@"Open"];
    [self addCorps:VANGUARDCADETS corpClass:@"Open"];
    [self addCorps:WATCHMEN corpClass:@"Open"];
    [self addCorps:RIVERCITYRHYTHM corpClass:@"Open"];
    [self addCorps:SOUTHWIND corpClass:@"Open"];
    [self addCorps:HEATWAVE corpClass:@"Open"];
    [self addCorps:SHADOW corpClass:@"Open"];
    [self addCorps:THE_BATTALION corpClass:@"Open"];
    
    //dca
    [self addCorps:JUBAL corpClass:@"Open"];
    [self addCorps:CADETS2 corpClass:@"Open"];
    [self addCorps:HAWTHORNE_CABALLEROS corpClass:@"Open"];
    [self addCorps:CONNECTICUT_HURRICANES corpClass:@"Open"];
    [self addCorps:ALLIANCE corpClass:@"Open"];
    
    // All Age Class
    [self addCorps:THE_MUCHACHOS corpClass:@"All Age"];
    [self addCorps:MINNESOTABRASS corpClass:@"All Age"];
    [self addCorps:GOVENAIRES corpClass:@"All Age"];
    [self addCorps:DEFENDERS corpClass:@"All Age"];
    [self addCorps:CRUSADERSSENIOR corpClass:@"All Age"];
    [self addCorps:CAROLINAGOLD corpClass:@"All Age"];
    [self addCorps:BRIDGEMENALUMNI corpClass:@"All Age"];
    [self addCorps:ATLANTACV corpClass:@"All Age"];
    [self addCorps:CINCINNATITRADITION corpClass:@"All Age"];
    [self addCorps:KILTIES corpClass:@"All Age"];
    [self addCorps:SOUTHERN_KNIGHTS corpClass:@"All Age"];
    [self addCorps:NORTHSTAR corpClass:@"All Age"];
    [self addCorps:FREELANCERS_ALUMNI corpClass:@"All Age"];
}

// This method checks the array of corps from the server to make sure it matches
// what is hard coded as constants in the app
-(void)checkAllCorps {
    
    // World class
    [self getCorpsByName: CADETS];
    [self getCorpsByName: THE_ACADEMY];
    [self getCorpsByName: BLUEDEVILS];
    [self getCorpsByName: BLUEKNIGHTS];
    [self getCorpsByName: BLUECOATS];
    [self getCorpsByName: BLUESTARS];
    [self getCorpsByName: BOSTONCRUSADERS];
    [self getCorpsByName: CROWN];
    [self getCorpsByName: CASCADES];
    [self getCorpsByName: CAVALIERS];
    [self getCorpsByName: COLTS];
    [self getCorpsByName: CROSSMEN];
    [self getCorpsByName: JERSEYSURF];
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
    [self getCorpsByName: BLUEDEVILSB];
    [self getCorpsByName: BLUEDEVILSC];
    [self getCorpsByName: BLUESAINTS];
    [self getCorpsByName: CITYSOUND];
    [self getCorpsByName: COASTALSURGE];
    [self getCorpsByName: COLTCADETS];
    [self getCorpsByName: COLUMBIANS];
    [self getCorpsByName: ERUPTION];
    [self getCorpsByName: GENESIS];
    [self getCorpsByName: GOLD];
    [self getCorpsByName: GOLDENEMPIRE];
    [self getCorpsByName: GUARDIANS];
    [self getCorpsByName: IMPULSE];
    [self getCorpsByName: INCOGNITO];
    [self getCorpsByName: LEGENDS];
    [self getCorpsByName: LESSTENTORS];
    [self getCorpsByName: LOUISIANA_STARS];
    [self getCorpsByName: MUSICCITY];
    [self getCorpsByName: RACINESCOUTS];
    [self getCorpsByName: RAIDERS];
    [self getCorpsByName: SPARTANS];
    [self getCorpsByName: THUNDER];
    [self getCorpsByName: VANGUARDCADETS];
    [self getCorpsByName: WATCHMEN];
    [self getCorpsByName: RIVERCITYRHYTHM];
    [self getCorpsByName: SOUTHWIND];
    [self getCorpsByName: HEATWAVE];
    [self getCorpsByName: SHADOW];
    [self getCorpsByName: THE_BATTALION];
    
    //DCA
    [self getCorpsByName: JUBAL];
    [self getCorpsByName: CADETS2];
    [self getCorpsByName: HAWTHORNE_CABALLEROS];
    [self getCorpsByName: CONNECTICUT_HURRICANES];
    [self getCorpsByName: ALLIANCE];
    
    // All Age Class
    [self getCorpsByName: THE_MUCHACHOS];
    [self getCorpsByName: MINNESOTABRASS];
    [self getCorpsByName: GOVENAIRES];
    [self getCorpsByName: DEFENDERS];
    [self getCorpsByName: CRUSADERSSENIOR];
    [self getCorpsByName: CAROLINAGOLD];
    [self getCorpsByName: BRIDGEMENALUMNI];
    [self getCorpsByName: ATLANTACV];
    [self getCorpsByName: CINCINNATITRADITION];
    [self getCorpsByName: KILTIES];
    [self getCorpsByName: SOUTHERN_KNIGHTS];
    [self getCorpsByName: NORTHSTAR];
    [self getCorpsByName: FREELANCERS_ALUMNI];
}

//needed before creating shows
-(void)getAllCorps {
    
    [self.arrayOfCorpsObjects removeAllObjects];
    PFQuery *query = [PFQuery queryWithClassName:@"Corps"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu corps.", (unsigned long)objects.count);
            [self.arrayOfCorpsObjects addObjectsFromArray:objects];
            NSLog(@"%lu", (unsigned long)[self.arrayOfCorpsObjects count]);
            [self createAllShowsFor2016];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


// **THIS SHOULD NOT BE CALLED DIRECTLY. [SELF GETALLCORPS] IS NECESSARY FIRST AND CALLS CREATEALLSHOWS
// AUTOMATICALLY
-(void)createAllShowsFor2014 {
    
    
//    [self addShowWithName:<#(NSString *)#>
//               atLocation:<#(NSString *)#>
//                 forMonth:<#(NSInteger *)#>
//                   forDay:<#(NSInteger *)#>
//      withPerformingCorps:<#(NSMutableArray *)#>];
    
//    [self addShowWithName:@"DCI Opening Night"
//               atLocation:@"Indianapolis, IN"
//                 forMonth:JUNE
//                   forDay:18
//      withPerformingCorps:@[CAROLINA_CROWN, THE_CADETS, PHANTOM_REGIMENT, THE_CAVALIERS, TROOPERS]];
//
//    [self addShowWithName:@"MidCal Champions Showcase"
//               atLocation:@"Clovis, CA"
//                 forMonth:JUNE
//                   forDay:20
//      withPerformingCorps:@[CROSSMEN, BLUE_DEVILS, SANTA_CLARA_VANGUARD, BLUE_KNIGHTS, MANDARINS, PACIFIC_CREST, VANGUARD_CADETS, BLUE_DEVILS_B, BLUE_DEVILS_C, GOLDEN_EMPIRE]];
//    
//    [self addShowWithName:@"Show of Shows"
//               atLocation:@"Rockford, IL"
//                 forMonth:JUNE
//                   forDay:20
//      withPerformingCorps:@[PHANTOM_REGIMENT, CAROLINA_CROWN, THE_CAVALIERS, MADISON_SCOUTS, SPIRIT_OF_ATLANTA, BLUE_STARS, TROOPERS, PIONEER, COLT_CADETS]];
//     
//    [self addShowWithName:@"DCI West"
//               atLocation:@"Stanford, CA"
//                 forMonth:JUNE
//                   forDay:21
//      withPerformingCorps:@[BLUE_DEVILS, SANTA_CLARA_VANGUARD, CROSSMEN, BLUE_KNIGHTS, MANDARINS, PACIFIC_CREST, BLUE_DEVILS_B, BLUE_DEVILS_C, VANGUARD_CADETS]];
//    
//    [self addShowWithName:@"Innovations in Brass"
//               atLocation:@"Akron, OH"
//                 forMonth:JUNE
//                   forDay:21
//      withPerformingCorps:@[BLUECOATS, CAROLINA_CROWN, THE_CADETS, PHANTOM_REGIMENT, BOSTON_CRUSADERS, MADISON_SCOUTS, THE_CAVALIERS]];
//    
//    [self addShowWithName:@"Legends Drum Corps Preview"
//               atLocation:@"Plainwell, MI"
//                 forMonth:JUNE
//                   forDay:21
//       withPerformingCorps:@[LEGENDS, BLUE_STARS, SPIRIT_OF_ATLANTA, TROOPERS, COLTS, PIONEER, COLT_CADETS]];
//
//    [self addShowWithName:@"DCI All Star Review"
//               atLocation:@"Bowling Green, OH"
//                 forMonth:JUNE
//                   forDay:22
//      withPerformingCorps:@[CAROLINA_CROWN, THE_CADETS, BOSTON_CRUSADERS, MADISON_SCOUTS, TROOPERS, PIONEER]];
//    
//    [self addShowWithName:@"Drums in the Bluegrass"
//               atLocation:@"Lexington, KY"
//                 forMonth:JUNE
//                   forDay:22
//      withPerformingCorps:@[BLUE_STARS, BLUECOATS, CINCINNATI_TRADITION, SPIRIT_OF_ATLANTA, THE_CAVALIERS]];
//    
//    [self addShowWithName:@"Moonlight Classic"
//               atLocation:@"Sacramento, CA"
//                 forMonth:JUNE
//                   forDay:22
//      withPerformingCorps:@[SANTA_CLARA_VANGUARD, BLUE_KNIGHTS, BLUE_DEVILS, PACIFIC_CREST, MANDARINS, CROSSMEN, BLUE_DEVILS_B, VANGUARD_CADETS, BLUE_DEVILS_C]];
//    
//    [self addShowWithName:@"Merrillville Music Festival"
//               atLocation:@"Merrillville, IN"
//                 forMonth:JUNE
//                   forDay:24
//      withPerformingCorps:@[MADISON_SCOUTS, PHANTOM_REGIMENT, BOSTON_CRUSADERS, COLTS, TROOPERS, PIONEER]];
//    
//    [self addShowWithName:@"Summer Music Games"
//               atLocation:@"Fairfield, OH"
//                 forMonth:JUNE
//                   forDay:24
//      withPerformingCorps:@[THE_CADETS, BLUECOATS, THE_CAVALIERS, BLUE_STARS, SPIRIT_OF_ATLANTA, CINCINNATI_TRADITION]];
//    
//    [self addShowWithName:@"Drums on the Ohio"
//               atLocation:@"Evansville, IN"
//                 forMonth:JUNE
//                   forDay:25
//      withPerformingCorps:@[MADISON_SCOUTS, PHANTOM_REGIMENT, BLUE_STARS, COLTS, TROOPERS, PIONEER]];
//    
//    [self addShowWithName:@"Innovations in Brass"
//               atLocation:@"Pittsburgh, PA"
//                 forMonth:JUNE
//                   forDay:25
//      withPerformingCorps:@[BLUECOATS, THE_CADETS, THE_CAVALIERS, BOSTON_CRUSADERS, SPIRIT_OF_ATLANTA]];
//    
//    [self addShowWithName:@"Southwest Corps Connection"
//               atLocation:@"Mesa, AZ"
//                 forMonth:JUNE
//                   forDay:26
//      withPerformingCorps:@[THE_ACADEMY, SANTA_CLARA_VANGUARD, BLUE_KNIGHTS, CROSSMEN, CITY_SOUND]];
//    
//    [self addShowWithName:@"Corps at the Crest"
//               atLocation:@"Oceanside, CA"
//                 forMonth:JUNE
//                   forDay:27
//      withPerformingCorps:@[BLUE_KNIGHTS, CROSSMEN, SANTA_CLARA_VANGUARD, PACIFIC_CREST, MANDARINS, THE_ACADEMY, IMPULSE, GOLD, CITY_SOUND, GOLDEN_EMPIRE, WATCHMEN, INCOGNITO]];
//    
//    [self addShowWithName:@"DCI Central Indiana"
//               atLocation:@"Muncie, IN"
//                 forMonth:JUNE
//                   forDay:27
//      withPerformingCorps:@[BLUE_STARS, CAROLINA_CROWN, COLTS, PHANTOM_REGIMENT, PIONEER, THE_CAVALIERS, TROOPERS]];
//
//    [self addShowWithName:@"Drum Corps: An American Tradition"
//               atLocation:@"Chambersburg, PA"
//                 forMonth:JUNE
//                   forDay:27
//      withPerformingCorps:@[THE_CADETS, BLUECOATS, BOSTON_CRUSADERS, SPIRIT_OF_ATLANTA]];
//    
//    [self addShowWithName:@"Corps at the Crest"
//               atLocation:@"Glendora, CA"
//                 forMonth:JUNE
//                   forDay:28
//      withPerformingCorps:@[SANTA_CLARA_VANGUARD, BLUE_DEVILS, PACIFIC_CREST, CROSSMEN, BLUE_KNIGHTS, THE_ACADEMY, MANDARINS, GOLD, IMPULSE, CITY_SOUND, INCOGNITO, GOLDEN_EMPIRE, WATCHMEN]];
//
//    [self addShowWithName:@"Drum Corps: An American Tradition"
//               atLocation:@"Jackson, NJ"
//                 forMonth:JUNE
//                   forDay:28
//      withPerformingCorps:@[THE_CADETS, BLUECOATS, BOSTON_CRUSADERS, SPIRIT_OF_ATLANTA, SEVENTH_REGIMENT, RAIDERS]];
//
//    [self addShowWithName:@"Drums on Parade"
//               atLocation:@"Madison, WI"
//                 forMonth:JUNE
//                   forDay:28
//      withPerformingCorps:@[MADISON_SCOUTS, PHANTOM_REGIMENT, THE_CAVALIERS, BLUE_STARS, COLTS, TROOPERS, PIONEER, COLT_CADETS, RACINE_SCOUTS, KILTIES]];
//    
//    [self addShowWithName:@"East Coast Classic"
//               atLocation:@"Lawrence, MA"
//                 forMonth:JUNE
//                   forDay:29
//      withPerformingCorps:@[BOSTON_CRUSADERS, THE_CADETS, CAROLINA_CROWN, BLUECOATS, SPIRIT_OF_ATLANTA, SEVENTH_REGIMENT, SPARTANS]];
//    
//    [self addShowWithName:@"River City Rhapsody"
//               atLocation:@"Rochester, MN"
//                 forMonth:JUNE
//                   forDay:29
//      withPerformingCorps:@[BLUE_STARS, PHANTOM_REGIMENT, MADISON_SCOUTS, THE_CAVALIERS, TROOPERS, COLTS, PIONEER]];
//
//    [self addShowWithName:@"Western Corps Connection"
//               atLocation:@"Riverside, CA"
//                 forMonth:JUNE
//                   forDay:29
//      withPerformingCorps:@[BLUE_DEVILS, CROSSMEN, SANTA_CLARA_VANGUARD, BLUE_KNIGHTS, THE_ACADEMY, PACIFIC_CREST, MANDARINS, GOLD, IMPULSE, CITY_SOUND, WATCHMEN, INCOGNITO, GOLDEN_EMPIRE]];
//    
//    [self addShowWithName:@"The Thunder of Drums"
//               atLocation:@"Mankato, MN"
//                 forMonth:JUNE
//                   forDay:30
//      withPerformingCorps:@[MADISON_SCOUTS, BLUE_STARS, TROOPERS, PIONEER, RACINE_SCOUTS]];
//    
//    [self addShowWithName:@"Brass Impact"
//               atLocation:@"Overland Park, KS"
//                 forMonth:JULY
//                   forDay:1
//      withPerformingCorps:@[COLTS, PHANTOM_REGIMENT, THE_CAVALIERS, JERSEY_SURF, COLT_CADETS]];
//    
//    [self addShowWithName:@"Pacific Procession"
//               atLocation:@"Santa Clara, CA"
//                 forMonth:JULY
//                   forDay:1
//      withPerformingCorps:@[SANTA_CLARA_VANGUARD, BLUE_KNIGHTS, CROSSMEN, MANDARINS, VANGUARD_CADETS, BLUE_DEVILS_B]];
//    
//    [self addShowWithName:@"Beat of the Rogue"
//               atLocation:@"Medford, OR"
//                 forMonth:JULY
//                   forDay:2
//      withPerformingCorps:@[SANTA_CLARA_VANGUARD, CROSSMEN, BLUE_KNIGHTS, OREGON_CRUSADERS]];
//    
//    [self addShowWithName:@"Celebration in Brass"
//               atLocation:@"Waukee, IA"
//                 forMonth:JULY
//                   forDay:2
//      withPerformingCorps:@[COLTS, BLUE_DEVILS, PHANTOM_REGIMENT, THE_CAVALIERS, BLUE_STARS, TROOPERS, JERSEY_SURF, COLT_CADETS]];
//    
//    [self addShowWithName:@"Connecticut Drums"
//               atLocation:@"New Haven, CT"
//                 forMonth:JULY
//                   forDay:2
//      withPerformingCorps:@[BOSTON_CRUSADERS, THE_CADETS, CAROLINA_CROWN, BLUECOATS, SPIRIT_OF_ATLANTA, SEVENTH_REGIMENT, SPARTANS]];
//    
//    [self addShowWithName:@"Drums of Fire"
//               atLocation:@"McMinnville, OR"
//                 forMonth:JULY
//                   forDay:3
//      withPerformingCorps:@[OREGON_CRUSADERS, BLUE_KNIGHTS, SANTA_CLARA_VANGUARD, CROSSMEN, CASCADES, COLUMBIANS, ERUPTION]];
//    
//    [self addShowWithName:@"Rotary Music Festival"
//               atLocation:@"Cedarburg, WI"
//                 forMonth:JULY
//                   forDay:3
//      withPerformingCorps:@[BLUE_DEVILS, MADISON_SCOUTS, JERSEY_SURF, PIONEER, GENESIS, LEGENDS, RACINE_SCOUTS]];
//    
//    [self addShowWithName:@"Summer Music Preview"
//               atLocation:@"Bristol, RI"
//                 forMonth:JULY
//                   forDay:3
//      withPerformingCorps:@[THE_CADETS, CAROLINA_CROWN, BLUECOATS, BOSTON_CRUSADERS, SPIRIT_OF_ATLANTA, SEVENTH_REGIMENT, SPARTANS]];
//    
//    [self addShowWithName:@"DCI Capital Classic Corps Show"
//               atLocation:@"Sacramento, CA"
//                 forMonth:JULY
//                   forDay:5
//      withPerformingCorps:@[MANDARINS, VANGUARD_CADETS, BLUE_DEVILS_B, IMPULSE, CITY_SOUND, BLUE_DEVILS_C, GOLDEN_EMPIRE, INCOGNITO]];
//    
//    [self addShowWithName:@"Pageant of Drums"
//               atLocation:@"Michigan City, IN"
//                 forMonth:JULY
//                   forDay:5
//      withPerformingCorps:@[THE_CAVALIERS, PHANTOM_REGIMENT, TROOPERS, COLTS, GENESIS, COLT_CADETS, LEGENDS]];
//    
//    [self addShowWithName:@"Seattle Summer Music Games"
//               atLocation:@"Renton, WA"
//                 forMonth:JULY
//                   forDay:5
//      withPerformingCorps:@[SANTA_CLARA_VANGUARD, BLUE_KNIGHTS, OREGON_CRUSADERS, CROSSMEN, CASCADES, COLUMBIANS, ERUPTION]];
//    
//    [self addShowWithName:@"The Beanpot Invitational"
//               atLocation:@"Lynn, MA"
//                 forMonth:JULY
//                   forDay:5
//      withPerformingCorps:@[CAROLINA_CROWN, THE_CADETS, BLUECOATS, BOSTON_CRUSADERS, SPIRIT_OF_ATLANTA, SPARTANS, SEVENTH_REGIMENT]];
//    
//    [self addShowWithName:@"The Whitewater Classic"
//               atLocation:@"Whitewater, WI"
//                 forMonth:JULY
//                   forDay:5
//      withPerformingCorps:@[BLUE_DEVILS, BLUE_STARS, JERSEY_SURF, KILTIES, MADISON_SCOUTS, PIONEER, RACINE_SCOUTS]];
//    
//    [self addShowWithName:@"Cavalcade of Brass"
//               atLocation:@"Lisle, IL"
//                 forMonth:JULY
//                   forDay:JUNE
//      withPerformingCorps:@[THE_CAVALIERS, BLUE_DEVILS, PHANTOM_REGIMENT, MADISON_SCOUTS, BLUE_STARS, TROOPERS, RACINE_SCOUTS]];
//    
//    [self addShowWithName:@"Dixon Petunia Festival"
//               atLocation:@"Dixon, IL"
//                 forMonth:JULY
//                   forDay:JUNE
//      withPerformingCorps:@[COLTS, JERSEY_SURF, PIONEER, COLT_CADETS, GENESIS, LEGENDS]];
//    
//    [self addShowWithName:@"Drum Corps: An American Tradition"
//               atLocation:@"Chester, PA"
//                 forMonth:JULY
//                   forDay:JUNE
//      withPerformingCorps:@[BLUECOATS, BOSTON_CRUSADERS, CAROLINA_CROWN, SPIRIT_OF_ATLANTA, THE_CADETS]];
//    
//    [self addShowWithName:@"Drums Along the Columbia"
//               atLocation:@"Tri Cities, WA"
//                 forMonth:JULY
//                   forDay:JUNE
//      withPerformingCorps:@[BLUE_KNIGHTS, SANTA_CLARA_VANGUARD, CROSSMEN, OREGON_CRUSADERS, CASCADES, COLUMBIANS, ERUPTION]];
//    
//    [self addShowWithName:@"Loudest Show on Earth"
//               atLocation:@"Pleasant Hill, CA"
//                 forMonth:JULY
//                   forDay:JUNE
//      withPerformingCorps:@[BLUE_DEVILS_B, BLUE_DEVILS_C, CITY_SOUND, GOLDEN_EMPIRE, IMPULSE, INCOGNITO, MANDARINS, VANGUARD_CADETS]];
//    
//    [self addShowWithName:@"Boise Summer Music Games"
//               atLocation:@"Boise, ID"
//                 forMonth:JULY
//                   forDay:AUGUST
//      withPerformingCorps:@[CROSSMEN, BLUE_KNIGHTS, SANTA_CLARA_VANGUARD, OREGON_CRUSADERS, THE_ACADEMY, CASCADES, IMPULSE]];
//    
//    [self addShowWithName:@"DCI Ft. Wayne"
//               atLocation:@"Ft. Wayne, IN"
//                 forMonth:JULY
//                   forDay:AUGUST
//      withPerformingCorps:@[BLUE_DEVILS, BLUE_SAINTS, BLUECOATS, BOSTON_CRUSADERS, JERSEY_SURF, LEGENDS, MUSIC_CITY, SPIRIT_OF_ATLANTA]];
//    
//    [self addShowWithName:@"Music On The March"
//               atLocation:@"Dubuque, IA"
//                 forMonth:JULY
//                   forDay:AUGUST
//      withPerformingCorps:@[COLTS, THE_CAVALIERS, MADISON_SCOUTS, BLUE_STARS, TROOPERS, PIONEER, COLT_CADETS, GENESIS, RACINE_SCOUTS]];
//
//    [self addShowWithName:@"Corps Encore"
//               atLocation:@"Ogden, UT"
//                 forMonth:JULY
//                   forDay:9
//      withPerformingCorps:@[BLUE_KNIGHTS, SANTA_CLARA_VANGUARD, OREGON_CRUSADERS, PACIFIC_CREST, THE_ACADEMY, CROSSMEN, CASCADES, IMPULSE]];
//    
//    [self addShowWithName:@"Show of Shows"
//               atLocation:@"Metamora, IL"
//                 forMonth:JULY
//                   forDay:9
//      withPerformingCorps:@[PHANTOM_REGIMENT, BLUE_DEVILS, THE_CADETS, COLTS, PIONEER, MUSIC_CITY, LEGENDS, BLUE_SAINTS]];
//    
//    [self addShowWithName:@"Music on the Border"
//               atLocation:@"Salem, WI"
//                 forMonth:JULY
//                   forDay:10
//      withPerformingCorps:@[PHANTOM_REGIMENT, THE_CADETS, SPIRIT_OF_ATLANTA, JERSEY_SURF, PIONEER, COLT_CADETS, RACINE_SCOUTS]];
//    
//    [self addShowWithName:@"DCI Eden Prairie"
//               atLocation:@"Eden Prairie, MN"
//                 forMonth:JULY
//                   forDay:11
//      withPerformingCorps:@[BLUE_DEVILS, BLUE_SAINTS, BLUECOATS, BOSTON_CRUSADERS, JERSEY_SURF, LEGENDS]];
//    
//    [self addShowWithName:@"Drums Along the Rockies - Cheyenne Edition"
//               atLocation:@"Cheyenne, WY"
//                 forMonth:JULY
//                   forDay:11
//      withPerformingCorps:@[TROOPERS, MADISON_SCOUTS, OREGON_CRUSADERS, THE_ACADEMY, CASCADES, PACIFIC_CREST]];
//     
//     [self addShowWithName:@"DCI La Crosse"
//                atLocation:@"La Crosse, WI"
//                  forMonth:JULY
//                    forDay:12
//       withPerformingCorps:@[BLUE_SAINTS, BLUE_STARS, BLUECOATS, BOSTON_CRUSADERS, CAROLINA_CROWN, COLTS, JERSEY_SURF, LEGENDS, MUSIC_CITY, PHANTOM_REGIMENT, RACINE_SCOUTS, SPIRIT_OF_ATLANTA, THE_CADETS, THE_CAVALIERS]];
//    
//    [self addShowWithName:@"Drums Along the Rockies"
//               atLocation:@"Denver, CO"
//                 forMonth:JULY
//                   forDay:12
//      withPerformingCorps:@[BLUE_KNIGHTS, SANTA_CLARA_VANGUARD, MADISON_SCOUTS, TROOPERS, CROSSMEN, PACIFIC_CREST, OREGON_CRUSADERS, MANDARINS, CASCADES, THE_ACADEMY]];
//    
//    [self addShowWithName:@"Gold Showcase at the Ranch"
//               atLocation:@"Vista, CA"
//                 forMonth:JULY
//                   forDay:12
//      withPerformingCorps:@[GOLD, VANGUARD_CADETS, BLUE_DEVILS_B, IMPULSE, CITY_SOUND, BLUE_DEVILS_C, INCOGNITO, WATCHMEN, GOLDEN_EMPIRE]];
//    
//    [self addShowWithName:@"Percussion at the Pearl"
//               atLocation:@"Muscatine, IA"
//                 forMonth:JULY
//                   forDay:13
//      withPerformingCorps:@[COLTS, BOSTON_CRUSADERS, SPIRIT_OF_ATLANTA, PIONEER, COLT_CADETS, LEGENDS, LOUISIANA_STARS]];
//    
//    [self addShowWithName:@"So Cal Classic Open Class Championships"
//               atLocation:@"Cerritos, CA"
//                 forMonth:JULY
//                   forDay:13
//      withPerformingCorps:@[BLUE_DEVILS_B, BLUE_DEVILS_C, CITY_SOUND, GOLD, IMPULSE, VANGUARD_CADETS, GOLDEN_EMPIRE, INCOGNITO, WATCHMEN]];
//    
//    [self addShowWithName:@"Tour of Champions - Northern Illinois"
//               atLocation:@"DeKalb, IL"
//                 forMonth:JULY
//                   forDay:13
//      withPerformingCorps:@[PHANTOM_REGIMENT, THE_CAVALIERS, THE_CADETS, CAROLINA_CROWN, BLUE_STARS, BLUECOATS, BLUE_DEVILS]];
//    
//    [self addShowWithName:@"DCI St. Louis"
//               atLocation:@"Lebanon, IL"
//                 forMonth:JULY
//                   forDay:14
//      withPerformingCorps:@[BOSTON_CRUSADERS, COLTS, JERSEY_SURF, LOUISIANA_STARS, MUSIC_CITY, PIONEER, SPIRIT_OF_ATLANTA]];
//    
//    [self addShowWithName:@"Drums Across Nebraska"
//               atLocation:@"Omaha, NE"
//                 forMonth:JULY
//                   forDay:14
//      withPerformingCorps:@[MADISON_SCOUTS, BLUE_KNIGHTS, CROSSMEN, OREGON_CRUSADERS, PACIFIC_CREST, THE_ACADEMY, CASCADES]];
//    
//    [self addShowWithName:@"Tour of Champions - Central Missouri"
//               atLocation:@"Warrensburg, MO"
//                 forMonth:JULY
//                   forDay:14
//      withPerformingCorps:@[BLUE_DEVILS, BLUECOATS, CAROLINA_CROWN, PHANTOM_REGIMENT, SANTA_CLARA_VANGUARD, THE_CADETS, THE_CAVALIERS]];
//    
//    [self addShowWithName:@"Drums Across Kansas"
//               atLocation:@"Wichita, KS"
//                 forMonth:JULY
//                   forDay:15
//      withPerformingCorps:@[BLUE_DEVILS, MADISON_SCOUTS, BLUE_KNIGHTS, TROOPERS, OREGON_CRUSADERS, MANDARINS, THE_ACADEMY]];
//    
//    [self addShowWithName:@"Music on the Move"
//               atLocation:@"Bentonville, AR"
//                 forMonth:JULY
//                   forDay:15
//      withPerformingCorps:@[CAROLINA_CROWN, BLUE_STARS, CROSSMEN, COLTS, PIONEER, CASCADES, MUSIC_CITY, GENESIS, LOUISIANA_STARS]];
//    
//    [self addShowWithName:@"Drums of Summer"
//               atLocation:@"Tulsa, OK"
//                 forMonth:JULY
//                   forDay:16
//      withPerformingCorps:@[THE_CADETS, PHANTOM_REGIMENT, BLUE_KNIGHTS, SPIRIT_OF_ATLANTA, TROOPERS, PACIFIC_CREST, MANDARINS, THE_ACADEMY, JERSEY_SURF, CASCADES]];
//    
//    [self addShowWithName:@"DCI Austin"
//               atLocation:@"Round Rock, TX"
//                 forMonth:JULY
//                   forDay:17
//      withPerformingCorps:@[BLUE_STARS, BOSTON_CRUSADERS, COLTS, CROSSMEN, GENESIS, GUARDIANS, MADISON_SCOUTS, THE_CADETS, TROOPERS]];
//    
//    [self addShowWithName:@"DCI Denton"
//               atLocation:@"Denton, TX"
//                 forMonth:JULY
//                   forDay:17
//      withPerformingCorps:@[BLUECOATS, CAROLINA_CROWN, CASCADES, JERSEY_SURF, MANDARINS, OREGON_CRUSADERS, PACIFIC_CREST, PIONEER, SANTA_CLARA_VANGUARD, THE_ACADEMY, THE_CAVALIERS]];
//    
//    [self addShowWithName:@"Tour of Champions"
//               atLocation:@"Houston, TX"
//                 forMonth:JULY
//                   forDay:18
//      withPerformingCorps:@[BLUE_DEVILS, BLUE_KNIGHTS, BLUECOATS, CAROLINA_CROWN, PHANTOM_REGIMENT, SANTA_CLARA_VANGUARD, THE_CAVALIERS]];
//    
//    [self addShowWithName:@"DCI Southwestern Championships"
//               atLocation:@"San Antonio, TX"
//                 forMonth:JULY
//                   forDay:19
//      withPerformingCorps:@[BLUE_DEVILS, BLUE_KNIGHTS, BLUE_STARS, BLUECOATS, BOSTON_CRUSADERS, CAROLINA_CROWN, CASCADES, COLTS, CROSSMEN, GENESIS, GUARDIANS, JERSEY_SURF, MADISON_SCOUTS, MANDARINS, OREGON_CRUSADERS, PACIFIC_CREST, PHANTOM_REGIMENT, PIONEER, SANTA_CLARA_VANGUARD, SPIRIT_OF_ATLANTA, THE_ACADEMY, THE_CADETS, THE_CAVALIERS, TROOPERS]];
//    
//    [self addShowWithName:@"Fiesta De Musica"
//               atLocation:@"Manchester, NH"
//                 forMonth:JULY
//                   forDay:19
//      withPerformingCorps:@[SPARTANS, SEVENTH_REGIMENT, LES_STENTORS, LEGENDS, RACINE_SCOUTS]];
//    
//    [self addShowWithName:@"DCI Dallas"
//               atLocation:@"Dallas, TX"
//                 forMonth:JULY
//                   forDay:21
//      withPerformingCorps:@[BLUE_KNIGHTS, BLUECOATS, CAROLINA_CROWN, CASCADES, CROSSMEN, GENESIS, JERSEY_SURF, MADISON_SCOUTS, THE_ACADEMY, THE_CADETS]];
//    
//    [self addShowWithName:@"Drums Across Cajun Field"
//               atLocation:@"Lafayette, LA"
//                 forMonth:JULY
//                   forDay:21
//      withPerformingCorps:@[PHANTOM_REGIMENT, BLUE_DEVILS, THE_CAVALIERS, SPIRIT_OF_ATLANTA, BLUE_STARS, COLTS, PACIFIC_CREST, MANDARINS, PIONEER, LOUISIANA_STARS]];
//    
//    [self addShowWithName:@"DCI in the Heartland"
//               atLocation:@"Mustang, OK"
//                 forMonth:JULY
//                   forDay:22
//      withPerformingCorps:@[CAROLINA_CROWN, THE_CADETS, BLUECOATS, BLUE_KNIGHTS, CROSSMEN, OREGON_CRUSADERS, THE_ACADEMY, CASCADES]];
//    
//    [self addShowWithName:@"Mississippi Sound Spectacular"
//               atLocation:@"Ocean Springs, MS"
//                 forMonth:JULY
//                   forDay:22
//      withPerformingCorps:@[SANTA_CLARA_VANGUARD, THE_CAVALIERS, SPIRIT_OF_ATLANTA, BLUE_STARS, PACIFIC_CREST, MANDARINS, PIONEER]];
//    
//    [self addShowWithName:@"DCI Arkansas"
//               atLocation:@"Little Rock, AR"
//                 forMonth:JULY
//                   forDay:23
//      withPerformingCorps:@[BLUE_KNIGHTS, BLUECOATS, BOSTON_CRUSADERS, CAROLINA_CROWN, CASCADES, CROSSMEN, OREGON_CRUSADERS, THE_ACADEMY, THE_CADETS]];
//    
//    [self addShowWithName:@"DCI Southern Mississippi"
//               atLocation:@"Hattiesburg, MS"
//                 forMonth:JULY
//                   forDay:23
//      withPerformingCorps:@[BLUE_DEVILS, COLTS, JERSEY_SURF, MADISON_SCOUTS, PACIFIC_CREST, PIONEER, TROOPERS]];
//    
//    [self addShowWithName:@"A Blast in the Burg"
//               atLocation:@"Johnsonburg, PA"
//                 forMonth:JULY
//                   forDay:24
//      withPerformingCorps:@[SPARTANS, SEVENTH_REGIMENT, LEGENDS, RAIDERS, LES_STENTORS, COASTAL_SURGE]];
//    
//    [self addShowWithName:@"Alabma Sounds of Summer"
//               atLocation:@"Opelika, AL"
//                 forMonth:JULY
//                   forDay:24
//      withPerformingCorps:@[SPIRIT_OF_ATLANTA, MADISON_SCOUTS, BLUE_STARS, COLTS, MANDARINS, PIONEER]];
//    
//    [self addShowWithName:@"DCI North Alabama"
//               atLocation:@"Huntsville, AL"
//                 forMonth:JULY
//                   forDay:25
//      withPerformingCorps:@[BLUE_KNIGHTS, BLUE_STARS, CASCADES, COLTS, CROSSMEN, JERSEY_SURF, MADISON_SCOUTS, PACIFIC_CREST, PIONEER, SPIRIT_OF_ATLANTA, THE_ACADEMY, TROOPERS]];
//    
//    [self addShowWithName:@"The Masters of the Summer Music Games"
//               atLocation:@"Nashville, TN"
//                 forMonth:JULY
//                   forDay:25
//      withPerformingCorps:@[BLUE_DEVILS, BLUECOATS, BOSTON_CRUSADERS, CAROLINA_CROWN, MUSIC_CITY, PHANTOM_REGIMENT, SANTA_CLARA_VANGUARD, THE_CADETS, THE_CAVALIERS]];
//    
//    [self addShowWithName:@"DCI Southeastern Championships"
//               atLocation:@"Atlanta, GA"
//                 forMonth:JULY
//                   forDay:26
//      withPerformingCorps:@[BLUE_DEVILS, BLUE_KNIGHTS, BLUE_STARS, BLUECOATS, BOSTON_CRUSADERS, CAROLINA_CROWN, CASCADES, COLTS, CROSSMEN, JERSEY_SURF, MADISON_SCOUTS, MANDARINS, OREGON_CRUSADERS, PACIFIC_CREST, PHANTOM_REGIMENT, PIONEER, SANTA_CLARA_VANGUARD, SPIRIT_OF_ATLANTA, THE_ACADEMY, THE_CADETS, THE_CAVALIERS, TROOPERS]];
//    
//    [self addShowWithName:@"Legends Drum Corps Open"
//               atLocation:@"Paw Paw, MI"
//                 forMonth:JULY
//                   forDay:26
//      withPerformingCorps:@[LEGENDS, VANGUARD_CADETS, GENESIS, SEVENTH_REGIMENT, RAIDERS, LES_STENTORS, COASTAL_SURGE]];
//    
//    [self addShowWithName:@"Drum Corps Competition"
//               atLocation:@"Greendale, WI"
//                 forMonth:JULY
//                   forDay:27
//      withPerformingCorps:@[BLUE_DEVILS_B, SPARTANS, COLT_CADETS, RACINE_SCOUTS, BLUE_SAINTS, KILTIES]];
//    
//    [self addShowWithName:@"NightBEAT Tour of Champions"
//               atLocation:@"Charlotte, NC"
//                 forMonth:JULY
//                   forDay:27
//      withPerformingCorps:@[CAROLINA_CROWN, PHANTOM_REGIMENT, BLUE_DEVILS, SANTA_CLARA_VANGUARD, SPIRIT_OF_ATLANTA, THE_CAVALIERS, THE_CADETS]];
//    
//    [self addShowWithName:@"Drums Across the Tri-State"
//               atLocation:@"Charleston, WV"
//                 forMonth:JULY
//                   forDay:28
//      withPerformingCorps:@[PHANTOM_REGIMENT, BLUECOATS, BOSTON_CRUSADERS, SPIRIT_OF_ATLANTA, CROSSMEN, MANDARINS, OREGON_CRUSADERS]];
//    
//    [self addShowWithName:@"Emerald City Music Games"
//               atLocation:@"Dublin, OH"
//                 forMonth:JULY
//                   forDay:28
//      withPerformingCorps:@[SANTA_CLARA_VANGUARD, MADISON_SCOUTS, BLUE_KNIGHTS, TROOPERS, PACIFIC_CREST, JERSEY_SURF, CASCADES, VANGUARD_CADETS]];
//    
//    [self addShowWithName:@"Rhythm Across Rice Lake"
//               atLocation:@"Rice Lake, WI"
//                 forMonth:JULY
//                   forDay:28
//      withPerformingCorps:@[BLUE_DEVILS_B, SPARTANS, RACINE_SCOUTS, MUSIC_CITY, BLUE_SAINTS]];
//    
//    [self addShowWithName:@"Lake Erie Fanfare"
//               atLocation:@"Erie, PA"
//                 forMonth:JULY
//                   forDay:29
//      withPerformingCorps:@[MADISON_SCOUTS, BLUE_KNIGHTS, TROOPERS, OREGON_CRUSADERS, MANDARINS, PACIFIC_CREST, JERSEY_SURF, CASCADES, LES_STENTORS]];
//    
//    [self addShowWithName:@"Legends Drum Corps Invitational"
//               atLocation:@"Troy, MI"
//                 forMonth:JULY
//                   forDay:29
//      withPerformingCorps:@[LEGENDS, VANGUARD_CADETS, GENESIS, SEVENTH_REGIMENT, RAIDERS, LES_STENTORS, COASTAL_SURGE]];
//    
//    [self addShowWithName:@"Summer Music Games of Southwest Virginia"
//               atLocation:@"Salem, VA"
//                 forMonth:JULY
//                   forDay:29
//      withPerformingCorps:@[BLUE_DEVILS, CAROLINA_CROWN, THE_CAVALIERS, BLUE_STARS, COLTS, THE_ACADEMY, PIONEER]];
//    
//    [self addShowWithName:@"A Knight of Music and Motion"
//               atLocation:@"St. Paul, MN"
//                 forMonth:JULY
//                   forDay:30
//      withPerformingCorps:@[BLUE_DEVILS_B, SPARTANS, MUSIC_CITY, GOLD, COLT_CADETS, RACINE_SCOUTS, BLUE_SAINTS]];
//    
//    [self addShowWithName:@"Drum Corps: An American Tradition"
//               atLocation:@"West Chester, PA"
//                 forMonth:JULY
//                   forDay:30
//      withPerformingCorps:@[THE_CADETS, CAROLINA_CROWN, BLUECOATS, THE_CAVALIERS, SPIRIT_OF_ATLANTA, BLUE_STARS, CROSSMEN, COLTS, JERSEY_SURF]];
//    
//    [self addShowWithName:@"Drums Along the Mohawk"
//               atLocation:@"Rome, NY"
//                 forMonth:JULY
//                   forDay:30
//      withPerformingCorps:@[BOSTON_CRUSADERS, MADISON_SCOUTS, BLUE_KNIGHTS, TROOPERS, PACIFIC_CREST, OREGON_CRUSADERS, MANDARINS, CASCADES]];
//    
//    [self addShowWithName:@"CYO Nationals Tribute"
//               atLocation:@"Quincy, MA"
//                 forMonth:JULY
//                   forDay:30
//      withPerformingCorps:@[BOSTON_CRUSADERS, MADISON_SCOUTS, TROOPERS, CROSSMEN, JERSEY_SURF]];
//    
//    [self addShowWithName:@"Tour of Champions"
//               atLocation:@"Piscataway, NJ"
//                 forMonth:JULY
//                   forDay:30
//      withPerformingCorps:@[THE_CADETS, THE_CAVALIERS, BLUECOATS, BLUE_DEVILS, PHANTOM_REGIMENT, SANTA_CLARA_VANGUARD, CAROLINA_CROWN]];
//    
//    [self addShowWithName:@"DCI Eastern Classic"
//               atLocation:@"Allentown, PA"
//                 forMonth:AUGUST
//                   forDay:1
//      withPerformingCorps:@[BLUE_DEVILS, BLUE_KNIGHTS, BLUE_STARS, BOSTON_CRUSADERS, CASCADES, COLTS, OREGON_CRUSADERS, PACIFIC_CREST, PHANTOM_REGIMENT, PIONEER, SANTA_CLARA_VANGUARD]];
//    
//    [self addShowWithName:@"North Iowa Festival of Brass"
//               atLocation:@"Forest City, IA"
//                 forMonth:AUGUST
//                   forDay:1
//      withPerformingCorps:@[BLUE_DEVILS_B, SPARTANS, MUSIC_CITY, GOLD, COLT_CADETS, RACINE_SCOUTS, BLUE_SAINTS]];
//    
//    [self addShowWithName:@"DCI Eastern Classic"
//               atLocation:@"Allentown, PA"
//                 forMonth:AUGUST
//                   forDay:2
//      withPerformingCorps:@[BLUECOATS, CAROLINA_CROWN, CROSSMEN, JERSEY_SURF, MADISON_SCOUTS, MANDARINS, SPIRIT_OF_ATLANTA, THE_ACADEMY, THE_CADETS, THE_CAVALIERS, TROOPERS]];
//    
//    [self addShowWithName:@"Shoremen Brass Classic"
//               atLocation:@"Avon Lake, OH"
//                 forMonth:AUGUST
//                   forDay:2
//      withPerformingCorps:@[VANGUARD_CADETS, GENESIS, SEVENTH_REGIMENT, LEGENDS, RAIDERS, LES_STENTORS, COASTAL_SURGE]];
//    
//    [self addShowWithName:@"DCI Pittsburgh"
//               atLocation:@"Pittsburgh, PA"
//                 forMonth:AUGUST
//                   forDay:3
//      withPerformingCorps:@[PHANTOM_REGIMENT, BOSTON_CRUSADERS, BLUE_STARS, BLUE_KNIGHTS, COLTS, PACIFIC_CREST, MANDARINS, CASCADES]];
//
//
//    [self addShowWithName:@"Tour of Champions"
//               atLocation:@"Buffalo, NY"
//                 forMonth:AUGUST
//                   forDay:3
//      withPerformingCorps:@[BLUE_DEVILS, THE_CADETS, THE_CAVALIERS, CAROLINA_CROWN, TROOPERS, BLUECOATS, SANTA_CLARA_VANGUARD]];
//    
//    [self addShowWithName:@"Tour of Champions"
//               atLocation:@"Massillon, OH"
//                 forMonth:AUGUST
//                   forDay:4
//      withPerformingCorps:@[BLUECOATS, SANTA_CLARA_VANGUARD, CAROLINA_CROWN, THE_CADETS, PHANTOM_REGIMENT, CROSSMEN, BOSTON_CRUSADERS]];
//    
//    [self addShowWithName:@"DCI World Championships Open Class Prelims"
//               atLocation:@"Michigan City, IN"
//                 forMonth:AUGUST
//                   forDay:4
//      withPerformingCorps:@[SEVENTH_REGIMENT, BLUE_DEVILS_B, BLUE_SAINTS, COASTAL_SURGE, COLT_CADETS, GENESIS, GOLD, LEGENDS, LES_STENTORS, MUSIC_CITY, RACINE_SCOUTS, RAIDERS, SPARTANS, VANGUARD_CADETS]];
//    
//    [self addShowWithName:@"Soaring Sounds 35"
//               atLocation:@"Centerville, OH"
//                 forMonth:AUGUST
//                   forDay:4
//      withPerformingCorps:@[THE_CAVALIERS, BLUE_KNIGHTS, BLUE_STARS, SPIRIT_OF_ATLANTA, COLTS, OREGON_CRUSADERS, PACIFIC_CREST, JERSEY_SURF, THE_ACADEMY, CINCINNATI_TRADITION]];
//    
//    [self addShowWithName:@"DCI World Championships Open Class Finals"
//               atLocation:@"Michigan City, IN"
//                 forMonth:AUGUST
//                   forDay:5
//      withPerformingCorps:@[]];
    
//    [self addShowWithName:@"DCI World Championships Prelims"
//               atLocation:@"Indianapolis, IN"
//                 forMonth:AUGUST
//                   forDay:7
//      withPerformingCorps:@[BLUE_DEVILS, THE_CADETS, BLUECOATS, SANTA_CLARA_VANGUARD, CAROLINA_CROWN, THE_CAVALIERS, BLUE_KNIGHTS, PHANTOM_REGIMENT, BLUE_STARS, BOSTON_CRUSADERS, MADISON_SCOUTS, CROSSMEN, COLTS, TROOPERS, SPIRIT_OF_ATLANTA, THE_ACADEMY, OREGON_CRUSADERS, PACIFIC_CREST, MANDARINS, JERSEY_SURF, CASCADES, PIONEER]];
    
//    [self addShowWithName:@"DCI World Championships Semifinals"
//               atLocation:@"Indianapolis, IN"
//                 forMonth:AUGUST
//                   forDay:8
//      withPerformingCorps:@[]];
//    
//    [self addShowWithName:@"DCI World Championships Finals"
//               atLocation:@"Indianapolis, IN"
//                 forMonth:AUGUST
//                   forDay:9
//      withPerformingCorps:@[]];

}


-(void)addShowWithName:(NSString *)showName
            atLocation:(NSString *)showLocation
              forMonth:(NSInteger)month
                forDay:(NSInteger)day
   withPerformingCorps:(NSArray *)corpsArray {
    
    PFObject *newShow = [PFObject objectWithClassName:@"Shows"];
    
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
    
    PFObject *score = [PFObject objectWithClassName:@"Scores"];
    [score setObject:corps forKey:@"corps"];
    [score setObject:show forKey:@"show"];
    score[@"corpsName"] = corps[@"corpsName"];
    score[@"isOfficial"] = [NSNumber numberWithBool:YES];
    score[@"classification"] = corps[@"classification"];
    score[@"showDate"] = show[@"showDate"];
    [score saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) NSLog(@"Empty score created for %@                      %@", corps[@"corpsName"], show[@"showLocation"]);
    }];
}

-(void)addCorps:(NSString *)corpsName corpClass:(NSString *)corpsClass {
    
    PFObject *newCorps = [PFObject objectWithClassName:@"Corps"];
    newCorps[@"corpsName"] = corpsName;
    newCorps[@"classification"] = corpsClass;
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
    configuration.statusFont = [UIFont systemFontOfSize:15];
 //   configuration.circleStrokeForegroundColor = [UIColor colorWithRed:0/255.0 green:174/255.0 blue:237/255.0 alpha:1];
    configuration.circleStrokeForegroundColor = [UIColor whiteColor];
    configuration.circleStrokeBackgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    configuration.circleFillBackgroundColor = [UIColor clearColor];
    configuration.backgroundFillColor = [UIColor clearColor];
    configuration.backgroundTintColor = [UIColor blueColor];
    configuration.successColor = [UIColor whiteColor];
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
    configuration.statusFont = [UIFont systemFontOfSize:15];
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

// **THIS SHOULD NOT BE CALLED DIRECTLY. [SELF GETALLCORPS] IS NECESSARY FIRST AND CALLS CREATEALLSHOWS
// AUTOMATICALLY
-(void)createAllShowsFor2016 {
    
    
    //    [self addShowWithName:<#(NSString *)#>
    //               atLocation:<#(NSString *)#>
    //                 forMonth:<#(NSInteger *)#>
    //                   forDay:<#(NSInteger *)#>
    //      withPerformingCorps:<#(NSMutableArray *)#>];
    

    [self addShowWithName:@"DCI Tour Premiere"
               atLocation:@"Indianapolis, IN"
                 forMonth:JUNE
                   forDay:23
      withPerformingCorps:@[BOSTONCRUSADERS, CAVALIERS, PHANTOM_REGIMENT, CADETS, BLUECOATS, CROWN]];
    
    [self addShowWithName:@"MidCal Champions Showcase"
               atLocation:@"Fresno, CA"
                 forMonth:JUNE
                   forDay:24
      withPerformingCorps:@[BLUEDEVILSC, GOLDENEMPIRE, VANGUARDCADETS, BLUEDEVILSB, PACIFIC_CREST, MANDARINS, THE_ACADEMY, SANTA_CLARA_VANGUARD, BLUEKNIGHTS, MADISON_SCOUTS, BLUEDEVILS]];

    [self addShowWithName:@"Innovations in Brass"
               atLocation:@"Massillon, OH"
                 forMonth:JUNE
                   forDay:25
      withPerformingCorps:@[BOSTONCRUSADERS, CROSSMEN, PHANTOM_REGIMENT, CROWN, BLUECOATS]];
    
    [self addShowWithName:@"The Whitewater Classic"
               atLocation:@"Whitewater, WI"
                 forMonth:JUNE
                   forDay:25
      withPerformingCorps:@[KILTIES, COLTCADETS, PIONEER, TROOPERS, COLTS, BLUESTARS, CAVALIERS, CADETS]];
    
    [self addShowWithName:@"Moonlight Classic"
               atLocation:@"Sacramento, CA"
                 forMonth:JUNE
                   forDay:25
      withPerformingCorps:@[GOLDENEMPIRE, BLUEDEVILSC, BLUEDEVILSB, VANGUARDCADETS, MANDARINS, THE_ACADEMY, PACIFIC_CREST, MADISON_SCOUTS, BLUEDEVILS, SANTA_CLARA_VANGUARD, BLUEKNIGHTS, FREELANCERS_ALUMNI]];
    
    [self addShowWithName:@"Pageant of Drums"
               atLocation:@"Michigan City, IN"
                 forMonth:JUNE
                   forDay:26
      withPerformingCorps:@[KILTIES, COLTCADETS, GENESIS, PIONEER, COLTS, TROOPERS, CADETS, CAVALIERS]];
    
    [self addShowWithName:@"DCI West"
               atLocation:@"Stanford, CA"
                 forMonth:JUNE
                   forDay:26
      withPerformingCorps:@[GOLDENEMPIRE, VANGUARDCADETS, BLUEDEVILSB, BLUEDEVILSC, THE_ACADEMY, PACIFIC_CREST, MANDARINS, BLUEKNIGHTS, MADISON_SCOUTS, SANTA_CLARA_VANGUARD, BLUEDEVILS]];
    
    [self addShowWithName:@"Summer Music Games in Cincinnati"
               atLocation:@"Hamilton, OH"
                 forMonth:JUNE
                   forDay:27
      withPerformingCorps:@[CINCINNATITRADITION, COLTS, BOSTONCRUSADERS, CROSSMEN, BLUESTARS, CROWN, BLUECOATS]];
    
    [self addShowWithName:@"Emerald City Music Games"
               atLocation:@"Dublin, OH"
                 forMonth:JUNE
                   forDay:28
      withPerformingCorps:@[CINCINNATITRADITION, GENESIS, LEGENDS, PIONEER, TROOPERS, BLUESTARS, CAVALIERS]];
    
    [self addShowWithName:@"Innovations in Brass"
               atLocation:@"Pittsburgh, PA"
                 forMonth:JUNE
                   forDay:28
      withPerformingCorps:@[CROSSMEN, BOSTONCRUSADERS, PHANTOM_REGIMENT, CADETS, BLUECOATS]];
    
    [self addShowWithName:@"Drums on the Ohio"
               atLocation:@"Evansville, IN"
                 forMonth:JUNE
                   forDay:29
      withPerformingCorps:@[MUSICCITY, LEGENDS, GENESIS, PIONEER, TROOPERS, COLTS, BLUESTARS, CAVALIERS]];
    
    [self addShowWithName:@"DCI on the SoCal Coast"
               atLocation:@"Oxnard, CA"
                 forMonth:JUNE
                   forDay:29
      withPerformingCorps:@[MADISON_SCOUTS, BLUEKNIGHTS, BLUEDEVILS]];
    
    [self addShowWithName:@"Drum Corps: An American Tradition"
               atLocation:@"Allentown, PA"
                 forMonth:JUNE
                   forDay:30
      withPerformingCorps:@[CADETS2, JERSEYSURF, BOSTONCRUSADERS, CROSSMEN, PHANTOM_REGIMENT, BLUECOATS, CADETS]];
    
    [self addShowWithName:@"Corps at the Crest"
               atLocation:@"Oceanside, CA"
                 forMonth:JULY
                   forDay:1
      withPerformingCorps:@[INCOGNITO, WATCHMEN, IMPULSE, GOLDENEMPIRE, GOLD, MANDARINS, THE_ACADEMY, PACIFIC_CREST, BLUEKNIGHTS, MADISON_SCOUTS]];
    
    [self addShowWithName:@"DCI Central Indiana"
               atLocation:@"Muncie, IN"
                 forMonth:JULY
                   forDay:1
      withPerformingCorps:@[GENESIS, LEGENDS, PIONEER, COLTS, TROOPERS, BLUESTARS, CAVALIERS, CROWN]];
    
    [self addShowWithName:@"Seattle Summer Music Games"
               atLocation:@"Auburn, WA"
                 forMonth:JULY
                   forDay:1
      withPerformingCorps:@[THUNDER, COLUMBIANS, OREGON_CRUSADERS, SANTA_CLARA_VANGUARD, THE_BATTALION, CASCADES]];
    
    [self addShowWithName:@"East Coast Classic"
               atLocation:@"Chestnut Hill, MA"
                 forMonth:JULY
                   forDay:2
      withPerformingCorps:@[THE_MUCHACHOS, CRUSADERSSENIOR, SEVENTH_REGIMENT, SPARTANS, JERSEYSURF, CROSSMEN, PHANTOM_REGIMENT, CADETS, BLUECOATS, BOSTONCRUSADERS]];
    
    [self addShowWithName:@"Cavalcade of Brass"
               atLocation:@"Lisle, IL"
                 forMonth:JULY
                   forDay:2
      withPerformingCorps:@[KILTIES, COLTCADETS, LEGENDS, GENESIS, TROOPERS, COLTS, BLUESTARS, CROWN, CAVALIERS]];
    
    [self addShowWithName:@"Corps at the Crest"
               atLocation:@"Pasadena, CA"
                 forMonth:JULY
                   forDay:2
      withPerformingCorps:@[GOLDENEMPIRE, WATCHMEN, INCOGNITO, IMPULSE, GOLD, MANDARINS, THE_ACADEMY, PACIFIC_CREST, MADISON_SCOUTS, BLUEKNIGHTS, BLUEDEVILS]];
    
    [self addShowWithName:@"Drums of Fire"
               atLocation:@"Tigard, OR"
                 forMonth:JULY
                   forDay:2
      withPerformingCorps:@[COLUMBIANS, THUNDER, SANTA_CLARA_VANGUARD, THE_BATTALION, CASCADES, OREGON_CRUSADERS]];
    
    [self addShowWithName:@"The Beanpot Invitational"
               atLocation:@"Lynn, MA"
                 forMonth:JULY
                   forDay:3
      withPerformingCorps:@[THE_MUCHACHOS, SEVENTH_REGIMENT, SPARTANS, BOSTONCRUSADERS, CROSSMEN, PHANTOM_REGIMENT,CADETS, BLUECOATS, NORTHSTAR]];
    
    [self addShowWithName:@"Rotary Music Festival"
               atLocation:@"Cedarburg, WI"
                 forMonth:JULY
                   forDay:3
      withPerformingCorps:@[KILTIES, COLTCADETS, MUSICCITY, PIONEER, COLTS, TROOPERS, BLUESTARS, CAVALIERS, CROWN]];
    
    [self addShowWithName:@"Western Corps Connection"
               atLocation:@"Riverside, CA"
                 forMonth:JULY
                   forDay:3
      withPerformingCorps:@[IMPULSE, INCOGNITO, WATCHMEN, GOLDENEMPIRE, GOLD, PACIFIC_CREST, MANDARINS, THE_ACADEMY, BLUEKNIGHTS, MADISON_SCOUTS, BLUEDEVILS]];
    
    [self addShowWithName:@"Summer Music Preview"
               atLocation:@"Cranston, RI"
                 forMonth:JULY
                   forDay:5
      withPerformingCorps:@[SPARTANS, SEVENTH_REGIMENT, BOSTONCRUSADERS, CROSSMEN, PHANTOM_REGIMENT, CADETS]];
    
    [self addShowWithName:@"River City Rhapsody"
               atLocation:@"La Crosse, WI"
                 forMonth:JULY
                   forDay:5
      withPerformingCorps:@[COLTCADETS, MUSICCITY, GENESIS, RIVERCITYRHYTHM, PIONEER, COLTS, TROOPERS, CROWN, BLUESTARS]];
    
    [self addShowWithName:@"Drums Across the Desert"
               atLocation:@"Mesa, AZ"
                 forMonth:JULY
                   forDay:5
      withPerformingCorps:@[WATCHMEN, PACIFIC_CREST, MADISON_SCOUTS, THE_ACADEMY]];
    
    [self addShowWithName:@"Drums Along the Columbia"
               atLocation:@"Tri Cities, WA"
                 forMonth:JULY
                   forDay:5
      withPerformingCorps:@[THUNDER, OREGON_CRUSADERS, SANTA_CLARA_VANGUARD, COLUMBIANS, THE_BATTALION, CASCADES]];
    
    [self addShowWithName:@"The Thunder of Drums"
               atLocation:@"Mankato, MN"
                 forMonth:JULY
                   forDay:6
      withPerformingCorps:@[GOVENAIRES, MINNESOTABRASS, COLTCADETS, RIVERCITYRHYTHM, PIONEER, COLTS, BLUESTARS, CROWN]];
    
    [self addShowWithName:@"Drums Along the Rockies"
               atLocation:@"Boise, ID"
                 forMonth:JULY
                   forDay:6
      withPerformingCorps:@[COLUMBIANS, THUNDER, OREGON_CRUSADERS, SANTA_CLARA_VANGUARD, THE_BATTALION, CASCADES]];
    
    [self addShowWithName:@"Live in Chickasha"
               atLocation:@"Chickasha, OK"
                 forMonth:JULY
                   forDay:7
      withPerformingCorps:@[PACIFIC_CREST, THE_ACADEMY, MADISON_SCOUTS]];
    
    [self addShowWithName:@"Corps Encore"
               atLocation:@"Ogden, UT"
                 forMonth:JULY
                   forDay:7
      withPerformingCorps:@[THUNDER, COLUMBIANS, GOLDENEMPIRE, GOLD, OREGON_CRUSADERS, SANTA_CLARA_VANGUARD, BLUEDEVILS, BLUEKNIGHTS, THE_BATTALION, CASCADES]];
    
    [self addShowWithName:@"CrownBEAT"
               atLocation:@"Lexington, SC"
                 forMonth:JULY
                   forDay:8
      withPerformingCorps:@[LEGENDS, JERSEYSURF, SPIRIT_OF_ATLANTA, CROSSMEN, BOSTONCRUSADERS, CADETS, BLUECOATS]];
    
    [self addShowWithName:@"Loudest Show on Earth"
               atLocation:@"Mountain House, CA"
                 forMonth:JULY
                   forDay:8
      withPerformingCorps:@[BLUEDEVILSC, WATCHMEN, INCOGNITO, THUNDER, VANGUARDCADETS, BLUEDEVILSB, MANDARINS]];
    
    [self addShowWithName:@"Drums Along the Rockies"
               atLocation:@"Casper, WY"
                 forMonth:JULY
                   forDay:8
      withPerformingCorps:@[OREGON_CRUSADERS, CAVALIERS, TROOPERS, CASCADES]];
    
    [self addShowWithName:@"DCI Central Florida"
               atLocation:@"Lakeland, FL"
                 forMonth:JULY
                   forDay:9
      withPerformingCorps:@[HEATWAVE, LEGENDS, JERSEYSURF, SPIRIT_OF_ATLANTA, BOSTONCRUSADERS, CROSSMEN, CADETS, BLUECOATS]];
    
    [self addShowWithName:@"Show of Shows"
               atLocation:@"Rockford, IL"
                 forMonth:JULY
                   forDay:9
      withPerformingCorps:@[KILTIES, RACINESCOUTS, COLTCADETS, PIONEER, PACIFIC_CREST, COLTS, THE_ACADEMY, BLUESTARS, CROWN, PHANTOM_REGIMENT]];
    
    [self addShowWithName:@"Drums Along the Rockies"
               atLocation:@"Denver, CO"
                 forMonth:JULY
                   forDay:9
      withPerformingCorps:@[COLUMBIANS, GOLDENEMPIRE, GOLD, TROOPERS, OREGON_CRUSADERS, CAVALIERS, SANTA_CLARA_VANGUARD, BLUEDEVILS, BLUEKNIGHTS]];
    
    [self addShowWithName:@"DCI Capital Classic Corps Show"
               atLocation:@"Sacramento, CA"
                 forMonth:JULY
                   forDay:9
      withPerformingCorps:@[INCOGNITO, BLUEDEVILSC, WATCHMEN, THUNDER, BLUEDEVILSB, VANGUARDCADETS, MANDARINS]];
    
    [self addShowWithName:@"Drums on Parade"
               atLocation:@"Madison, WI"
                 forMonth:JULY
                   forDay:10
      withPerformingCorps:@[KILTIES, MUSICCITY, GENESIS, PIONEER, PACIFIC_CREST, THE_ACADEMY, BLUESTARS, CROWN, MADISON_SCOUTS, SHADOW]];
    
    [self addShowWithName:@"DCI Jupiter"
               atLocation:@"Jupiter, FL"
                 forMonth:JULY
                   forDay:11
      withPerformingCorps:@[HEATWAVE, LEGENDS, JERSEYSURF, SPIRIT_OF_ATLANTA, CROSSMEN, BOSTONCRUSADERS, BLUECOATS, CADETS]];
    
    [self addShowWithName:@"Drums Across Nebraska"
               atLocation:@"Omaha, NE"
                 forMonth:JULY
                   forDay:11
      withPerformingCorps:@[COLTCADETS, OREGON_CRUSADERS, TROOPERS, CAVALIERS, BLUEKNIGHTS, BLUEDEVILS, CASCADES]];
    
    [self addShowWithName:@"DCI St. Louis"
               atLocation:@"Lebanon, IL"
                 forMonth:JULY
                   forDay:11
      withPerformingCorps:@[RACINESCOUTS, MUSICCITY, PACIFIC_CREST, THE_ACADEMY, PHANTOM_REGIMENT, CROWN, SHADOW]];
    
    [self addShowWithName:@"DCI Daytona Beach"
               atLocation:@"Daytona Beach, FL"
                 forMonth:JULY
                   forDay:12
      withPerformingCorps:@[HEATWAVE, LEGENDS, JERSEYSURF, SPIRIT_OF_ATLANTA, CROSSMEN, BOSTONCRUSADERS, CADETS, BLUECOATS]];
    
    [self addShowWithName:@"Brass Impact"
               atLocation:@"Overland Park, KS"
                 forMonth:JULY
                   forDay:12
      withPerformingCorps:@[RACINESCOUTS, COLTCADETS, TROOPERS, SANTA_CLARA_VANGUARD, BLUEDEVILS, COLTS]];
    
    [self addShowWithName:@"DCI Morningside"
               atLocation:@"Sioux City, IA"
                 forMonth:JULY
                   forDay:13
      withPerformingCorps:@[OREGON_CRUSADERS, TROOPERS, COLTS, CAVALIERS, SANTA_CLARA_VANGUARD]];
    
    [self addShowWithName:@"Show of Shows"
               atLocation:@"Metamora, IL"
                 forMonth:JULY
                   forDay:13
      withPerformingCorps:@[SHADOW, RACINESCOUTS, GENESIS, PACIFIC_CREST, MANDARINS, MADISON_SCOUTS, PHANTOM_REGIMENT]];
    
    [self addShowWithName:@"Music On The March"
               atLocation:@"Dubuque, IA"
                 forMonth:JULY
                   forDay:14
      withPerformingCorps:@[RACINESCOUTS, GENESIS, COLTCADETS, OREGON_CRUSADERS, THE_ACADEMY, CAVALIERS, SANTA_CLARA_VANGUARD, COLTS]];
    
    [self addShowWithName:@"River City Rhapsody"
               atLocation:@"Wausau, WI"
                 forMonth:JULY
                   forDay:14
      withPerformingCorps:@[PIONEER, PACIFIC_CREST, MANDARINS, PHANTOM_REGIMENT, BLUESTARS]];
    
    [self addShowWithName:@"DCI North Alabama"
               atLocation:@"Huntsville, AL"
                 forMonth:JULY
                   forDay:15
      withPerformingCorps:@[SOUTHERN_KNIGHTS, SOUTHWIND, LOUISIANA_STARS, MUSICCITY, LEGENDS, JERSEYSURF, SPIRIT_OF_ATLANTA, CROSSMEN, BOSTONCRUSADERS, CADETS, BLUECOATS]];
    
    [self addShowWithName:@"River City Rhapsody"
               atLocation:@"Rochester, MN"
                 forMonth:JULY
                   forDay:15
      withPerformingCorps:@[MINNESOTABRASS, GENESIS, RIVERCITYRHYTHM, PIONEER, MADISON_SCOUTS, BLUEKNIGHTS, BLUESTARS]];
    
    [self addShowWithName:@"Resound"
               atLocation:@"Bakersfield, CA"
                 forMonth:JULY
                   forDay:15
      withPerformingCorps:@[IMPULSE, INCOGNITO, WATCHMEN, BLUEDEVILSC, BLUEDEVILSB, VANGUARDCADETS, GOLDENEMPIRE]];
    
    [self addShowWithName:@"DCI Minnesota"
               atLocation:@"Minneapolis, MN"
                 forMonth:JULY
                   forDay:16
      withPerformingCorps:@[GENESIS, RACINESCOUTS, RIVERCITYRHYTHM, COLTCADETS, GOVENAIRES, PIONEER, PACIFIC_CREST, MANDARINS, OREGON_CRUSADERS, THE_ACADEMY, COLTS, TROOPERS, BLUESTARS, CAVALIERS, MADISON_SCOUTS, PHANTOM_REGIMENT, BLUEKNIGHTS, SANTA_CLARA_VANGUARD, BLUEDEVILS, MINNESOTABRASS]];
    
    [self addShowWithName:@"Atlanta Brass Classic"
               atLocation:@"Dallas, GA"
                 forMonth:JULY
                   forDay:16
      withPerformingCorps:@[SOUTHERN_KNIGHTS, CAROLINAGOLD, ATLANTACV, ALLIANCE, SOUTHWIND, LOUISIANA_STARS, MUSICCITY, LEGENDS]];
    
    [self addShowWithName:@"DCI Kentucky"
               atLocation:@"Alexandria, KY"
                 forMonth:JULY
                   forDay:16
      withPerformingCorps:@[CINCINNATITRADITION, JERSEYSURF, SPIRIT_OF_ATLANTA, CROSSMEN, BOSTONCRUSADERS, CADETS, BLUECOATS, CROWN]];
    
    [self addShowWithName:@"Gold Showcase at the Ranch"
               atLocation:@"Escondido, CA"
                 forMonth:JULY
                   forDay:16
      withPerformingCorps:@[IMPULSE, GOLDENEMPIRE, INCOGNITO, WATCHMEN, BLUEDEVILSC, VANGUARDCADETS, BLUEDEVILSB, GOLD]];
    
    [self addShowWithName:@"SoCal Classic Open Class Championship"
               atLocation:@"Bellflower, CA"
                 forMonth:JULY
                   forDay:17
      withPerformingCorps:@[BLUEDEVILSB, BLUEDEVILSC, GOLD, GOLDENEMPIRE, IMPULSE, INCOGNITO, VANGUARDCADETS, WATCHMEN]];
    
    [self addShowWithName:@"Celebration in Brass"
               atLocation:@"Waukee, IA"
                 forMonth:JULY
                   forDay:17
      withPerformingCorps:@[COLTCADETS, PIONEER, OREGON_CRUSADERS, THE_ACADEMY, MADISON_SCOUTS, COLTS]];
    
    [self addShowWithName:@"Tour of Champions"
               atLocation:@"DeKalb, IL"
                 forMonth:JULY
                   forDay:17
      withPerformingCorps:@[BLUEDEVILS, BLUEKNIGHTS, SANTA_CLARA_VANGUARD, CROWN, BLUECOATS, CADETS, CAVALIERS, PHANTOM_REGIMENT]];
    
    [self addShowWithName:@"Drums Across Kansas"
               atLocation:@"El Dorado, KS"
                 forMonth:JULY
                   forDay:18
      withPerformingCorps:@[PIONEER, JERSEYSURF, PACIFIC_CREST, MANDARINS, TROOPERS, BOSTONCRUSADERS, MADISON_SCOUTS]];
    
    [self addShowWithName:@"Tour of Champions"
               atLocation:@"Warrensburg, MO"
                 forMonth:JULY
                   forDay:18
      withPerformingCorps:@[CADETS, BLUEDEVILS, BLUECOATS, BLUESTARS, SANTA_CLARA_VANGUARD, PHANTOM_REGIMENT, CROWN, CAVALIERS]];
    
    [self addShowWithName:@"Music on the Move"
               atLocation:@"Bentonville, AR"
                 forMonth:JULY
                   forDay:19
      withPerformingCorps:@[GENESIS, PACIFIC_CREST, SPIRIT_OF_ATLANTA, MANDARINS, TROOPERS, THE_ACADEMY, BLUEDEVILS, CROWN]];
    
    [self addShowWithName:@"Drums of Summer"
               atLocation:@"Broken Arrow, OK"
                 forMonth:JULY
                   forDay:20
      withPerformingCorps:@[PIONEER, CASCADES, SPIRIT_OF_ATLANTA, OREGON_CRUSADERS, COLTS, BLUESTARS, CROSSMEN, BLUEKNIGHTS, CADETS]];
    
    [self addShowWithName:@"DCI Central Texas"
               atLocation:@"Belton, TX"
                 forMonth:JULY
                   forDay:21
      withPerformingCorps:@[GENESIS, CASCADES, JERSEYSURF, SPIRIT_OF_ATLANTA, OREGON_CRUSADERS, TROOPERS, COLTS, CROSSMEN, BLUESTARS, BOSTONCRUSADERS, MADISON_SCOUTS, PHANTOM_REGIMENT]];
    
    [self addShowWithName:@"DCI Denton"
               atLocation:@"Denton, TX"
                 forMonth:JULY
                   forDay:21
      withPerformingCorps:@[GUARDIANS, PACIFIC_CREST, MANDARINS, THE_ACADEMY, SANTA_CLARA_VANGUARD, BLUEKNIGHTS, CADETS, CROWN, BLUECOATS, CAVALIERS]];
    
    [self addShowWithName:@"Tour of Champions"
               atLocation:@"Houston, TX"
                 forMonth:JULY
                   forDay:22
      withPerformingCorps:@[PHANTOM_REGIMENT, CROSSMEN, BLUECOATS, CROWN, BLUEDEVILS, CAVALIERS, CADETS, SANTA_CLARA_VANGUARD]];
    
    [self addShowWithName:@"DCI Southwestern Championship"
               atLocation:@"San Antonio, TX"
                 forMonth:JULY
                   forDay:23
      withPerformingCorps:@[THE_ACADEMY, BLUEDEVILS, BLUEKNIGHTS, BLUESTARS, BLUECOATS, BOSTONCRUSADERS, CADETS, CROWN, CAVALIERS, COLTS, CROSSMEN, GENESIS, GUARDIANS, JERSEYSURF, LOUISIANA_STARS, MADISON_SCOUTS, MANDARINS, OREGON_CRUSADERS, PACIFIC_CREST, PHANTOM_REGIMENT, SANTA_CLARA_VANGUARD, CASCADES, SPIRIT_OF_ATLANTA, TROOPERS]];
    
    [self addShowWithName:@"Fiesta De Musica"
               atLocation:@"Manchester, NH"
                 forMonth:JULY
                   forDay:23
      withPerformingCorps:@[THE_MUCHACHOS, NORTHSTAR, LESSTENTORS, SEVENTH_REGIMENT, LEGENDS, SPARTANS]];
    
    [self addShowWithName:@"DCI Dallas"
               atLocation:@"Dallas, TX"
                 forMonth:JULY
                   forDay:25
      withPerformingCorps:@[GUARDIANS, GENESIS, TROOPERS, CROSSMEN, BOSTONCRUSADERS, PHANTOM_REGIMENT, BLUEKNIGHTS, BLUECOATS, BLUEDEVILS]];
    
    [self addShowWithName:@"Drums Across Cajun Field"
               atLocation:@"Lafayette, LA"
                 forMonth:JULY
                   forDay:25
      withPerformingCorps:@[LOUISIANA_STARS, JERSEYSURF, SPIRIT_OF_ATLANTA, MANDARINS, COLTS, BLUESTARS, CROWN]];
    
    [self addShowWithName:@"Mississippi Sound Spectacular"
               atLocation:@"Biloxi, MS"
                 forMonth:JULY
                   forDay:26
      withPerformingCorps:@[HEATWAVE, SOUTHWIND, CASCADES, PACIFIC_CREST, SPIRIT_OF_ATLANTA, COLTS, BLUESTARS, CROWN]];
    
    [self addShowWithName:@"DCI in the Heartland"
               atLocation:@"Mustang, OK"
                 forMonth:JULY
                   forDay:26
      withPerformingCorps:@[GUARDIANS, PIONEER, THE_ACADEMY, TROOPERS, CAVALIERS, PHANTOM_REGIMENT, BLUEKNIGHTS]];
    
    [self addShowWithName:@"DCI Arkansas"
               atLocation:@"Little Rock, AR"
                 forMonth:JULY
                   forDay:27
      withPerformingCorps:@[PIONEER, SPIRIT_OF_ATLANTA, TROOPERS, THE_ACADEMY, BOSTONCRUSADERS, CROSSMEN, MADISON_SCOUTS, CAVALIERS, BLUECOATS]];
    
    [self addShowWithName:@"DCI Southern Mississippi"
               atLocation:@"Hattiesburg, MS"
                 forMonth:JULY
                   forDay:27
      withPerformingCorps:@[SOUTHWIND, HEATWAVE, JERSEYSURF, PACIFIC_CREST, OREGON_CRUSADERS, MANDARINS, BLUESTARS, CADETS, BLUEDEVILS]];
    
    [self addShowWithName:@"Drum Corps Mid-America"
               atLocation:@"Oskaloosa, IA"
                 forMonth:JULY
                   forDay:27
      withPerformingCorps:@[SHADOW, COLTCADETS, RACINESCOUTS, GENESIS, VANGUARDCADETS]];
    
    [self addShowWithName:@"DCI Birmingham"
               atLocation:@"Birmingham, AL"
                 forMonth:JULY
                   forDay:28
      withPerformingCorps:@[SOUTHERN_KNIGHTS, SOUTHWIND, PACIFIC_CREST, JERSEYSURF, SPIRIT_OF_ATLANTA, THE_ACADEMY, TROOPERS, CROSSMEN, CAVALIERS, BLUEKNIGHTS]];
    
    [self addShowWithName:@"Alabama Sounds of Summer"
               atLocation:@"Opelika, AL"
                 forMonth:JULY
                   forDay:29
      withPerformingCorps:@[SOUTHERN_KNIGHTS, HEATWAVE, PIONEER, CASCADES, MANDARINS, OREGON_CRUSADERS, COLTS, BLUESTARS, BOSTONCRUSADERS, SPIRIT_OF_ATLANTA]];
    
    [self addShowWithName:@"Music on the Mountain"
               atLocation:@"Sheffield, PA"
                 forMonth:JULY
                   forDay:29
      withPerformingCorps:@[LESSTENTORS, RAIDERS, SEVENTH_REGIMENT, LEGENDS, SPARTANS]];
    
    [self addShowWithName:@"Tournament of Drums"
               atLocation:@"Cedar Rapids, IA"
                 forMonth:JULY
                   forDay:29
      withPerformingCorps:@[SHADOW, RACINESCOUTS, GENESIS, BLUEDEVILSB, VANGUARDCADETS, COLTCADETS]];
    
    [self addShowWithName:@"The Masters of the Summer Music Games"
               atLocation:@"Nashville, TN"
                 forMonth:JULY
                   forDay:29
      withPerformingCorps:@[MUSICCITY, CROWN, CADETS, BLUEKNIGHTS, BLUECOATS, SANTA_CLARA_VANGUARD, BLUEDEVILS, PHANTOM_REGIMENT, MADISON_SCOUTS]];
    
    [self addShowWithName:@"DCI Southeastern Championship"
               atLocation:@"Atlanta, GA"
                 forMonth:JULY
                   forDay:30
      withPerformingCorps:@[ALLIANCE, ATLANTACV, THE_ACADEMY, BLUEDEVILS, BLUEKNIGHTS, BLUESTARS, BLUECOATS, BOSTONCRUSADERS, CADETS, CROWN, CAROLINAGOLD, CAVALIERS, COLTS, CROSSMEN, HEATWAVE, JERSEYSURF, MADISON_SCOUTS, MANDARINS, OREGON_CRUSADERS, PACIFIC_CREST, PHANTOM_REGIMENT, PIONEER, SANTA_CLARA_VANGUARD, CASCADES, SOUTHWIND, SPIRIT_OF_ATLANTA, TROOPERS]];
    
    [self addShowWithName:@"Legends Drum Corps Invitational"
               atLocation:@"Troy, MI"
                 forMonth:JULY
                   forDay:30
      withPerformingCorps:@[LESSTENTORS, RAIDERS, SEVENTH_REGIMENT, SPARTANS, LEGENDS]];
    
    [self addShowWithName:@"TBD"
               atLocation:@"Minneapolis Area, MN"
                 forMonth:JULY
                   forDay:30
      withPerformingCorps:@[COLTCADETS, RIVERCITYRHYTHM, GENESIS, VANGUARDCADETS, BLUEDEVILSB, GOVENAIRES, MINNESOTABRASS]];
    
    [self addShowWithName:@"NightBEAT Tour of Champions"
               atLocation:@"Winston-Salem, NC"
                 forMonth:JULY
                   forDay:31
      withPerformingCorps:@[SANTA_CLARA_VANGUARD, MADISON_SCOUTS, CAVALIERS, PHANTOM_REGIMENT, BLUECOATS, CADETS, BLUEDEVILS, CROWN]];
    
    [self addShowWithName:@"Legends Drum Corps Open"
               atLocation:@"Three Rivers, MI"
                 forMonth:JULY
                   forDay:31
      withPerformingCorps:@[LESSTENTORS, RAIDERS, MUSICCITY, SEVENTH_REGIMENT, LEGENDS]];
    
    [self addShowWithName:@"Show of Shows"
               atLocation:@"Waukesha, WI"
                 forMonth:JULY
                   forDay:31
      withPerformingCorps:@[KILTIES, SHADOW, IMPULSE, RACINESCOUTS, COLTCADETS, SPARTANS, BLUEDEVILSB]];
    
    [self addShowWithName:@"Summer Music Games of Southwest Virginia"
               atLocation:@"Salem, VA"
                 forMonth:AUGUST
                   forDay:1
      withPerformingCorps:@[JERSEYSURF, MANDARINS, SPIRIT_OF_ATLANTA, OREGON_CRUSADERS, CROSSMEN, CAVALIERS, BLUEKNIGHTS]];
    
    [self addShowWithName:@"Drums Across the Tri-State"
               atLocation:@"Charleston, WV"
                 forMonth:AUGUST
                   forDay:1
      withPerformingCorps:@[PIONEER, CASCADES, TROOPERS, COLTS, BLUECOATS, PHANTOM_REGIMENT]];
    
    [self addShowWithName:@"DCI Ft. Wayne"
               atLocation:@"Ft. Wayne, IN"
                 forMonth:AUGUST
                   forDay:2
      withPerformingCorps:@[LESSTENTORS, RAIDERS, MUSICCITY, LEGENDS, SEVENTH_REGIMENT, BLUEDEVILSB, SPARTANS]];
    
    [self addShowWithName:@"Soaring Sounds 37"
               atLocation:@"Centerville, OH"
                 forMonth:AUGUST
                   forDay:2
      withPerformingCorps:@[CINCINNATITRADITION, PACIFIC_CREST, SPIRIT_OF_ATLANTA, THE_ACADEMY, COLTS, BLUESTARS, MADISON_SCOUTS, CROWN]];
    
    [self addShowWithName:@"Drum Corps: An American Tradition"
               atLocation:@"Annapolis, MD"
                 forMonth:AUGUST
                   forDay:2
      withPerformingCorps:@[JERSEYSURF, MANDARINS, OREGON_CRUSADERS, CROSSMEN, BOSTONCRUSADERS, SANTA_CLARA_VANGUARD, BLUEKNIGHTS, BLUEDEVILS, CADETS]];
    
    [self addShowWithName:@"DCI Western Illinois"
               atLocation:@"Macomb, IL"
                 forMonth:AUGUST
                   forDay:2
      withPerformingCorps:@[SHADOW, LOUISIANA_STARS, IMPULSE, COLTCADETS, GOLD, GENESIS, VANGUARDCADETS]];
    
    [self addShowWithName:@"DCI Pittsburgh"
               atLocation:@"Pittsburgh, PA"
                 forMonth:AUGUST
                   forDay:3
      withPerformingCorps:@[PACIFIC_CREST, THE_ACADEMY, COLTS, TROOPERS, BLUESTARS, MADISON_SCOUTS, CROWN]];
    
    [self addShowWithName:@"Petunia City Brass"
               atLocation:@"Dixon, IL"
                 forMonth:AUGUST
                   forDay:3
      withPerformingCorps:@[SHADOW, IMPULSE, LOUISIANA_STARS, RACINESCOUTS, GOLD, GENESIS, BLUEDEVILSB, VANGUARDCADETS]];
    
    [self addShowWithName:@"CYO Nationals Tribute"
               atLocation:@"Quincy, MA"
                 forMonth:AUGUST
                   forDay:4
      withPerformingCorps:@[CRUSADERSSENIOR, THE_MUCHACHOS, OREGON_CRUSADERS, MANDARINS, BOSTONCRUSADERS, CAVALIERS]];
    
    [self addShowWithName:@"Tour of Champions"
               atLocation:@"Chester, PA"
                 forMonth:AUGUST
                   forDay:4
      withPerformingCorps:@[CROSSMEN, BLUEKNIGHTS, CROWN, MADISON_SCOUTS, PHANTOM_REGIMENT, BLUECOATS, SANTA_CLARA_VANGUARD, CADETS]];
    
    [self addShowWithName:@"DCI Eastern Classic"
               atLocation:@"Allentown, PA"
                 forMonth:AUGUST
                   forDay:5
      withPerformingCorps:@[THE_ACADEMY, BLUEDEVILS, BLUEKNIGHTS, BLUECOATS, CADETS2, COLTS, MADISON_SCOUTS, PIONEER, CASCADES, SPIRIT_OF_ATLANTA, TROOPERS]];
    
    [self addShowWithName:@"A Blast in the Burg"
               atLocation:@"Johnsonburg, PA"
                 forMonth:AUGUST
                   forDay:5
      withPerformingCorps:@[IMPULSE, LESSTENTORS, RAIDERS, MUSICCITY, SEVENTH_REGIMENT, LEGENDS, SPARTANS]];
    
    [self addShowWithName:@"North Iowa Festival of Brass"
               atLocation:@"Forest City, IA"
                 forMonth:AUGUST
                   forDay:5
      withPerformingCorps:@[LOUISIANA_STARS, RACINESCOUTS, COLTCADETS, GOLD, VANGUARDCADETS, BLUEDEVILSB]];
    
    [self addShowWithName:@"DCI Eastern Classic"
               atLocation:@"Allentown, PA"
                 forMonth:AUGUST
                   forDay:6
      withPerformingCorps:@[BLUESTARS, BOSTONCRUSADERS, BRIDGEMENALUMNI, CADETS, CROWN, CAVALIERS, CROSSMEN, JERSEYSURF, MANDARINS, OREGON_CRUSADERS, PACIFIC_CREST, PHANTOM_REGIMENT, SANTA_CLARA_VANGUARD]];
    
    [self addShowWithName:@"Shoremen Brass Classic"
               atLocation:@"Avon Lake, OH"
                 forMonth:AUGUST
                   forDay:6
      withPerformingCorps:@[IMPULSE, RAIDERS, LESSTENTORS, MUSICCITY, LEGENDS, GENESIS, SEVENTH_REGIMENT, SPARTANS]];
    
    [self addShowWithName:@"Shadow Showcase"
               atLocation:@"Oregon, WI"
                 forMonth:AUGUST
                   forDay:6
      withPerformingCorps:@[GUARDIANS, LOUISIANA_STARS, RACINESCOUTS, COLTCADETS, GOLD, RIVERCITYRHYTHM, BLUEDEVILSB, VANGUARDCADETS, SHADOW]];
    
    [self addShowWithName:@"Drums Along the Mohawk"
               atLocation:@"Rome, NY"
                 forMonth:AUGUST
                   forDay:7
      withPerformingCorps:@[CASCADES, SPIRIT_OF_ATLANTA, TROOPERS, THE_ACADEMY, COLTS, BLUESTARS, MADISON_SCOUTS, SANTA_CLARA_VANGUARD]];
    
    [self addShowWithName:@"Tour of Champions"
               atLocation:@"Buffalo, NY"
                 forMonth:AUGUST
                   forDay:7
      withPerformingCorps:@[BLUECOATS, BOSTONCRUSADERS, CADETS, CROWN, CAVALIERS, PHANTOM_REGIMENT, BLUEDEVILS]];
    
    [self addShowWithName:@"DCI Open Class World Championship Prelims"
               atLocation:@"Michigan City, IN"
                 forMonth:AUGUST
                   forDay:8
      withPerformingCorps:@[SEVENTH_REGIMENT, BLUEDEVILSB, COLTCADETS, GENESIS, GOLD, GUARDIANS, IMPULSE, LEGENDS, LESSTENTORS, LOUISIANA_STARS, MUSICCITY, RACINESCOUTS, RAIDERS, RIVERCITYRHYTHM, SHADOW, SPARTANS, VANGUARDCADETS]];
    
    [self addShowWithName:@"Lake Erie Fanfare"
               atLocation:@"Eria, PA"
                 forMonth:AUGUST
                   forDay:8
      withPerformingCorps:@[PACIFIC_CREST, JERSEYSURF, MANDARINS, OREGON_CRUSADERS, TROOPERS, BLUESTARS, BOSTONCRUSADERS, CROSSMEN]];
    
    [self addShowWithName:@"DCI Tour of Champions"
               atLocation:@"Massillon, OH"
                 forMonth:AUGUST
                   forDay:8
      withPerformingCorps:@[CAVALIERS, BLUEKNIGHTS, PHANTOM_REGIMENT, MADISON_SCOUTS, CADETS, CROWN, SANTA_CLARA_VANGUARD, BLUECOATS]];
    
    [self addShowWithName:@"DCI Open Class World Championship Finals"
               atLocation:@"Michigan City, IN"
                 forMonth:AUGUST
                   forDay:9
      withPerformingCorps:@[]];
    
    [self addShowWithName:@"DCI World Championship Prelims"
               atLocation:@"Indianapolis, IN"
                 forMonth:AUGUST
                   forDay:11
      withPerformingCorps:@[THE_ACADEMY, SEVENTH_REGIMENT, BLUEDEVILS, BLUEDEVILSB, BLUEKNIGHTS, BLUESTARS, BLUECOATS, BOSTONCRUSADERS, CADETS, CROWN, CAVALIERS, COLTCADETS, COLTS, CROSSMEN, GENESIS, GOLD, GUARDIANS, IMPULSE, JERSEYSURF, LEGENDS, LESSTENTORS, LOUISIANA_STARS, MADISON_SCOUTS, MANDARINS, MUSICCITY, OREGON_CRUSADERS, PACIFIC_CREST, PHANTOM_REGIMENT, PIONEER, RACINESCOUTS, RAIDERS, RIVERCITYRHYTHM, SANTA_CLARA_VANGUARD, CASCADES, SHADOW, SPARTANS, SPIRIT_OF_ATLANTA, TROOPERS, VANGUARDCADETS]];
    
    [self addShowWithName:@"DCI World Championship Semifinals"
               atLocation:@"Indianapolis, IN"
                 forMonth:AUGUST
                   forDay:12
      withPerformingCorps:@[]];
    
    [self addShowWithName:@"DCI World Championship Finals"
               atLocation:@"Indianapolis, IN"
                 forMonth:AUGUST
                   forDay:13
      withPerformingCorps:@[]];
}



















@end
