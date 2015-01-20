//
//  CBCorpsDetailViewController.m
//  CorpBoard
//
//  Created by Isaias Favela on 7/1/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBCorpsDetailViewController.h"
#import "CBWebViewController.h"
#import "CBAboutCorpsViewController.h"
#import "KVNProgress.h"
#import <SpriteKit/SpriteKit.h>
#import "CBEffect.h"

@interface CBCorpsDetailViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnAbout;
@property (weak, nonatomic) IBOutlet UITableView *tableRepertoire;
@property (weak, nonatomic) IBOutlet UITableView *tableYears;
@property (weak, nonatomic) IBOutlet UILabel *corpsName;
@property (weak, nonatomic) IBOutlet UILabel *corpsFrom;
@property (weak, nonatomic) IBOutlet UIButton *btnLink;
@property (weak, nonatomic) IBOutlet UIImageView *imgCorps;
@property (nonatomic, strong) NSMutableArray *arrayOfRepertoires;
@property (nonatomic, strong) PFObject *currentYear;
@property IBOutlet SKView *skView;
@property (nonatomic, strong) CBEffect *scene;

- (IBAction)openLink:(UIButton*)sender;

@end

@implementation CBCorpsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [KVNProgress show];
    [self initUI];
    [self getRepertoiresForCorps];
    
    
    // Configure the SKView
    SKView * skView = _skView;
    
    // Create and configure the scene.
    self.scene = [CBEffect sceneWithSize:self.view.bounds.size];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    skView.allowsTransparency = YES;
    self.scene.backgroundColor = [UIColor blackColor];
    [skView presentScene:self.scene];
    self.tableRepertoire.backgroundColor = [UIColor clearColor];
    self.tableYears.backgroundColor = [UIColor clearColor];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.title = @"Corp Details";
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

-(void)goback {

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initUI {

    self.automaticallyAdjustsScrollViewInsets = NO;
    selectedCell = 0;
    self.tableYears.hidden = YES;
    self.tableRepertoire.hidden = YES;
    
    self.btnLink.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.btnLink setTitle:self.corps[@"website_Display"] forState:UIControlStateNormal];
    self.btnLink.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UITableViewCell *disclosure = [[UITableViewCell alloc] init];
    [self.btnAbout addSubview:disclosure];
    disclosure.frame = self.btnAbout.bounds;
    disclosure.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    disclosure.userInteractionEnabled = NO;
    
    self.corpsName.text = self.corps[@"corpsName"];
    self.corpsFrom.text = self.corps[@"from"];

    
    PFFile *imageFile = self.corps[@"logo"];
    if (imageFile) {
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
            if (!error) {
                self.imgCorps.image = [UIImage imageWithData:data];
            } else {
                self.imgCorps.image = nil;
                NSLog(@"Could not display logo for %@", self.corps[@"corpsName"]);
            }
        }];
    } else {
        self.imgCorps.image = nil;
        NSLog(@"Could not display logo for %@", self.corps[@"corpsName"]);
    }
    
    self.title = self.corps[@"corpsName"];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:NO animated:NO];
    self.navigationItem.title = @"";
    
    self.tableYears.estimatedRowHeight = 20.0;
    self.tableYears.rowHeight = UITableViewAutomaticDimension;

    self.tableRepertoire.estimatedRowHeight = 122.0;
    self.tableRepertoire.rowHeight = UITableViewAutomaticDimension;

    self.tableRepertoire.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableYears.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)getRepertoiresForCorps {
    
    PFQuery *query = [PFQuery queryWithClassName:@"repertoires"];
    [query whereKey:@"corps" equalTo:self.corps];
    [query orderByDescending:@"year"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self.arrayOfRepertoires addObjectsFromArray:objects];
            if ([self.arrayOfRepertoires count]) {
                self.currentYear = [self.arrayOfRepertoires objectAtIndex:0];
                self.tableYears.hidden = NO;
                [self.tableYears reloadData];
                
                self.tableRepertoire.hidden = NO;
                [self setUpRepertoire];
            }
            [KVNProgress dismiss];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            [KVNProgress configuration].minimumErrorDisplayTime = 3;
            [KVNProgress configuration].backgroundType = KVNProgressBackgroundTypeBlurred;
            [KVNProgress showErrorWithStatus:@"Could not load the corp's history"];
        }
    }];
}

-(void)makeLineLayer:(CALayer *)layer lineFromPointA:(CGPoint)pointA toPointB:(CGPoint)pointB
{
    CAShapeLayer *line = [CAShapeLayer layer];
    UIBezierPath *linePath=[UIBezierPath bezierPath];
    [linePath moveToPoint: pointA];
    [linePath addLineToPoint:pointB];
    line.path=linePath.CGPath;
    line.fillColor = nil;
    line.lineWidth = .5;
    line.opacity = 1.0;
    line.strokeColor = [UIColor whiteColor].CGColor;
    [layer addSublayer:line];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openLink:(UIButton*)sender {
    
    //NSString *url = [NSString stringWithFormat:@"http://%@", sender.titleLabel.text];
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

#pragma mark - Table View

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (tableView == self.tableYears) return 20;
//    else {
//        switch (indexPath.row) {
//            case 0:
//                if (self.corps[@"champs"]) return 122;
//                else return 100; //fix
//                break;
//            case 1:
//                return 100; //fix
//                break;
//            default:
//                return 0;
//        }
//    }
//}

//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [self tableView:tableView heightForRowAtIndexPath:indexPath];
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSString *)getPlacement:(NSString *)placement {

    NSRange stringRange = {0, MIN([placement length], 3)};
    stringRange = [placement rangeOfComposedCharacterSequencesForRange:stringRange];
    return [placement substringWithRange:stringRange];
}

int rows;
NSMutableArray *arrayOfRows;
-(void)setUpRepertoire {
    
    rows = 0;
    arrayOfRows = nil;
    arrayOfRows = [[NSMutableArray alloc] init];
    
    if (self.corps[@"champs"]) {
        rows++;
        [arrayOfRows addObject:@"champs"];
    }
    
    if (self.currentYear[@"year"]) {
        rows++;
        [arrayOfRows addObject:@"year"];
    }
    
    if ([self.currentYear[@"score"] length] || ([self.currentYear[@"placement"] length])) {
        rows++;
        [arrayOfRows addObject:@"score"];
    }
    
    NSString *place = [self getPlacement:self.currentYear[@"placement"]];
    
         if ([place isEqualToString:@"1st"] || [place isEqualToString:@"2nd"] || [place isEqualToString:@"3rd"]) {
        rows++;
        [arrayOfRows addObject:@"medal"];
    }
    
    if ([self.currentYear[@"showTitle"] length]) {
        rows++;
        [arrayOfRows addObject:@"title"];
    }
    
    if ([self.currentYear[@"repertoire"] length]) {
        rows++;
        [arrayOfRows addObject:@"repertoire"];
    }
    
    [self.tableRepertoire reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.tableYears) return [self.arrayOfRepertoires count];
    else {
        return rows;
    }
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (tableView == self.tableYears) {
//        return 20;
//    } else if (tableView == self.tableRepertoire) {
//        if (self.corps[@"champs"]) {
//            if (indexPath.row == 0) {
//                return 122;
//            } else {
//                UITextView *txt = [self getRepertoire];
//                NSLog(@"...... %@", txt.text);
//                int x = txt.frame.size.height;
//                return 120 + x;
//            }
//        } else {
//            UITextView *txt = [self getRepertoire];
//            return 120 + txt.frame.size.height;
//        }
//        
//    } else return 0;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableYears) return [self tableYearscellForRowAtIndexPath:indexPath];
    else return [self tableRepertoirecellForRowAtIndexPath:indexPath];
}

-(UITableViewCell *)tableYearscellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    cell = [self.tableYears dequeueReusableCellWithIdentifier:@"year"];
    UILabel *lblYear = (UILabel *)[cell viewWithTag:1];
    PFObject *yr = [self.arrayOfRepertoires objectAtIndex:indexPath.row];
    NSString *year = [NSString stringWithFormat:@"%@", yr[@"year"]];
    lblYear.text = year;
    
    
    if (indexPath.row == selectedCell) {
        lblYear.textColor = self.btnLink.titleLabel.textColor;
    } else {
        lblYear.textColor = [UIColor lightGrayColor];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(UITableViewCell *)tableRepertoirecellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row <= [arrayOfRows count]) {
        NSString *str = [arrayOfRows objectAtIndex:indexPath.row];
        if ([str isEqualToString:@"champs"]) {
            
            return [self getChampsCell];
            
        } else if ([str isEqualToString:@"year"]) {
            
            return [self getYearCell];
            
        } else if ([str isEqualToString:@"score"]) {
            
           return [self getScoreCell];
            
        } else if ([str isEqualToString:@"medal"]) {
            
            return [self getMedalCell];
            
        } else if ([str isEqualToString:@"title"]) {
            
           return [self getTitleCell];
            
        } else if ([str isEqualToString:@"repertoire"]) {
            
            return [self getRepertoireCell];
        }
    }
    
    return nil;
}

-(UITableViewCell *)getChampsCell {
    
    UITableViewCell *cell;
    cell = [self.tableRepertoire dequeueReusableCellWithIdentifier:@"champs"];
    UILabel *lblNumberOfChamps = (UILabel *)[cell viewWithTag:1];
    UILabel *lblChampYears = (UILabel *)[cell viewWithTag:2];
    
    NSNumber *num = self.corps[@"numberOfChamps"];
    lblNumberOfChamps.text = [NSString stringWithFormat:@"%@ Time World Champion", self.corps[@"numberOfChamps"]];
    if ([num intValue] > 1) {
        lblNumberOfChamps.text = [NSString stringWithFormat:@"%@s", lblNumberOfChamps.text];
    }
    
    lblChampYears.text = [NSString stringWithFormat:@"%@", self.corps[@"champs"]];
    [lblChampYears sizeToFit];
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(UITableViewCell *)getYearCell {
    
    UITableViewCell *cell;
    cell = [self.tableRepertoire dequeueReusableCellWithIdentifier:@"year"];
    UILabel *lblYear = (UILabel *)[cell viewWithTag:1];
    lblYear.text = [NSString stringWithFormat:@"%@", self.currentYear[@"year"]];
    return cell;
}

-(UITableViewCell *)getScoreCell {
    
    UITableViewCell *cell;
    cell = [self.tableRepertoire dequeueReusableCellWithIdentifier:@"score"];
    UILabel *lblScore = (UILabel *)[cell viewWithTag:2];
    UILabel *lblClass = (UILabel *)[cell viewWithTag:3];
    lblClass.text = self.currentYear[@"class"];
    NSString *marker;
    if ([self.currentYear[@"score"] length] && [self.currentYear[@"placement"] length]) {
        marker = @" - ";
    } else marker = @"";
    
    lblScore.text = [NSString stringWithFormat:@"%@%@%@", self.currentYear[@"placement"], marker, self.currentYear[@"score"]];
    return cell;
}

-(UITableViewCell *)getMedalCell {
    
    UITableViewCell *cell;
    cell = [self.tableRepertoire dequeueReusableCellWithIdentifier:@"medal"];
    UILabel *lblMedal = (UILabel *)[cell viewWithTag:6];
    UIImageView *imgMedal = (UIImageView *)[cell viewWithTag:5];
    
    NSString *placement = [self getPlacement:self.currentYear[@"placement"]];
    if ([placement isEqualToString:@"1st"]) {
        
        imgMedal.image = [UIImage imageNamed:@"medal_gold"];
        lblMedal.text = @"GOLD";
        
    } else if ([placement isEqualToString:@"2nd"]) {
        
        imgMedal.image = [UIImage imageNamed:@"medal_silver"];
        lblMedal.text = @"SILVER";
        
    } else if ([placement isEqualToString:@"3rd"]) {
        
        imgMedal.image = [UIImage imageNamed:@"medal_bronze"];
        lblMedal.text = @"BRONZE";
        
    }

    return cell;
}

-(UITableViewCell *)getTitleCell {
    
    UITableViewCell *cell;
    cell = [self.tableRepertoire dequeueReusableCellWithIdentifier:@"title"];
    UILabel *lblShowTitle = (UILabel *)[cell viewWithTag:3];
    lblShowTitle.text = self.currentYear[@"showTitle"];
    
    if ([lblShowTitle.text isEqualToString:@"TILT"]) {
        UIFont *yourFont = [UIFont fontWithName:@"Helvetica-BoldOblique" size:16];
        lblShowTitle.font = yourFont;
        [self TILT:YES];
    } else if ([lblShowTitle.text isEqualToString:@"12.25"]) {
        [self.scene startCadetSnowing];
    } else if ([lblShowTitle.text isEqualToString:@"Shiver: A Winter in Colorado"]) {
        [self.scene startSnowing];
    } else if ([lblShowTitle.text isEqualToString:@"To Tame the Perilous Skies"]) {
        [self.scene startRaining];
    } else if ([lblShowTitle.text isEqualToString:@"Music of the Starry Night"]) {
        
    } else {
        lblShowTitle.font = [UIFont boldSystemFontOfSize:16];
        [self TILT:NO];
        [self.scene stop];
    }
    
    return cell;
}

-(UITableViewCell *)getRepertoireCell {
    
    UITableViewCell *cell;
    cell = [self.tableRepertoire dequeueReusableCellWithIdentifier:@"repertoire"];
    
    UILabel *txtRepertoire = (UILabel *)[cell viewWithTag:4];
    
    txtRepertoire.text = self.currentYear[@"repertoire"];
    txtRepertoire.textColor = [UIColor lightGrayColor];
    [txtRepertoire sizeToFit];
    
    return cell;
}

-(void)TILT:(BOOL)tilt {

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
    double rads;
    if (tilt) {
        rads = DEGREES_TO_RADIANS(4);
    } else {
        rads = DEGREES_TO_RADIANS(0);
    }
    
    [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:2 options:0 animations:^{
        
        CGAffineTransform transform = CGAffineTransformRotate(self.view.transform, rads);
        self.tableRepertoire.transform = transform;
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)SNOW:(BOOL)snow {

    
}

int selectedCell = 0;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (tableView == self.tableYears) {
        UILabel *lblYear;
        for (UITableViewCell *cell in self.tableYears.visibleCells) {
            
            lblYear = (UILabel *)[cell viewWithTag:1];
            lblYear.textColor = [UIColor lightGrayColor];
        }
        
        UITableViewCell *cell = [self.tableYears cellForRowAtIndexPath:indexPath];
        lblYear = (UILabel *)[cell viewWithTag:1];
        lblYear.textColor = self.btnLink.titleLabel.textColor;
        
        selectedCell = (int)indexPath.row;
        self.currentYear = [self.arrayOfRepertoires objectAtIndex:indexPath.row];
        [self setUpRepertoire];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"web"]) {
        
        CBWebViewController *vc = [segue destinationViewController];
        vc.webURL = self.corps[@"website"];
        vc.websiteTitle = self.corps[@"corpsName"];
        vc.websiteSubTitle = self.corps[@"website_Display"];
        
    } else if ([[segue identifier] isEqualToString:@"about"]) {
        
        CBAboutCorpsViewController *vc = [segue destinationViewController];
        vc.about = self.corps[@"about"];
    }
}

-(NSMutableArray *)arrayOfRepertoires {
    
    if (!_arrayOfRepertoires) {
        _arrayOfRepertoires = [[NSMutableArray alloc] init];
    }
    return _arrayOfRepertoires;
}

@end
