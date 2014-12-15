//
//  CBUserProfileViewController.m
//  CorpBoard
//
//  Created by Isaias Favela on 12/10/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBUserProfileViewController.h"
#import "NSDate+Utilities.h"
#import "CBSingle.h"


@interface CBUserProfileViewController () {
    CBSingle *data;
}

@property (nonatomic, strong) NSMutableArray *arrayOfCorpExperience;
@property (nonatomic, strong) NSMutableArray *arrayOfCorpExperienceLabels;
@property (nonatomic, strong) UILabel *lblBackground;
@property (weak, nonatomic) IBOutlet UIButton *btnEditCategories;
@property (weak, nonatomic) IBOutlet UIButton *btnEditName;
@property (nonatomic, strong) CBUserCategories *userCat;
@property (nonatomic, strong) CBChooseCorp *corpExperience;
@property (weak, nonatomic) IBOutlet UIButton *btnEditPicture;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollProfile;
@property (weak, nonatomic) IBOutlet UIView *viewProfile;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollCoverPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *imgCoverPhoto;
@property (nonatomic, strong) NSMutableArray *arrayOfBadges;
@property (nonatomic, strong) NSMutableArray *arrayOfSectionLabels;

//UI
@property (weak, nonatomic) IBOutlet PFImageView *imgUser;
@property (weak, nonatomic) IBOutlet UILabel *lblUserNickname;
@property (weak, nonatomic) IBOutlet UILabel *lblUserLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblViews;

@property (weak, nonatomic) IBOutlet UIView *viewControls;
@property (weak, nonatomic) IBOutlet UILabel *lblAboutMe;

@property (weak, nonatomic) IBOutlet UILabel *lblMyBadges;


@property (weak, nonatomic) IBOutlet UIButton *btnReport;
@property (weak, nonatomic) IBOutlet UIButton *btnChat;
@property (weak, nonatomic) IBOutlet UIButton *btnEditCorpExperience;





@end

@implementation CBUserProfileViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:NO animated:NO];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"BackArrow"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    PFUser *cUser = [PFUser currentUser];
    if ([self.userProfile.objectId isEqualToString: cUser.objectId]) {
        UIButton *configBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *configBtnImage = [UIImage imageNamed:@"Config"];
        [configBtn setBackgroundImage:configBtnImage forState:UIControlStateNormal];
        [configBtn addTarget:self action:@selector(configProfile) forControlEvents:UIControlEventTouchUpInside];
        configBtn.frame = CGRectMake(0, 0, 30, 30);
        UIBarButtonItem *configBarButton = [[UIBarButtonItem alloc] initWithCustomView:configBtn] ;
        self.navigationItem.rightBarButtonItem = configBarButton;
        self.btnReport.enabled = NO;
        self.btnChat.enabled = NO;
    } else {
        self.btnReport.enabled = YES;
        self.btnChat.enabled = YES;
        NSMutableDictionary * params = [NSMutableDictionary new];
        params[@"userObjectId"] = self.userProfile.objectId;
        [PFCloud callFunctionInBackground:@"incrementUserProfileViews" withParameters:params];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    data = [CBSingle data];
    
    self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2;
    self.imgUser.layer.masksToBounds = YES;
    
    
    editingProfile = NO;
    self.btnEditPicture.frame = CGRectMake(self.btnEditPicture.frame.origin.x + 40, self.btnEditPicture.frame.origin.y, self.btnEditPicture.frame.size.width, self.btnEditPicture.frame.size.height);
    
    self.btnEditName.frame = CGRectMake(self.btnEditName.frame.origin.x + 40, self.btnEditName.frame.origin.y, self.btnEditName.frame.size.width, self.btnEditName.frame.size.height);
    
    self.btnEditCategories.frame = CGRectMake(self.btnEditCategories.frame.origin.x + 40, self.btnEditCategories.frame.origin.y, self.btnEditCategories.frame.size.width, self.btnEditCategories.frame.size.height);
    
    self.btnEditCorpExperience.frame = CGRectMake(self.btnEditCorpExperience.frame.origin.x + 40, self.btnEditCorpExperience.frame.origin.y, self.btnEditCorpExperience.frame.size.width, self.btnEditCorpExperience.frame.size.height);
    
    self.btnEditPicture.hidden = YES;
    self.btnEditName.hidden = YES;
    self.btnEditCategories.hidden = YES;
    self.btnEditCorpExperience.hidden = YES;
    
    [self getUserCorpExperiences];
    [self setParallex];
}

-(void)getUserCorpExperiences {
    [self.arrayOfCorpExperience removeAllObjects];
    PFQuery *query = [PFQuery queryWithClassName:@"userCorpExperience"];
    [query whereKey:@"user" equalTo:self.userProfile];
    [query orderByDescending:@"year"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count]) {
            [self.arrayOfCorpExperience addObjectsFromArray:objects];
            [self initUI];
        }
    }];
}

-(void)setParallex {
    // Set vertical effect
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-20);
    verticalMotionEffect.maximumRelativeValue = @(20);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-20);
    horizontalMotionEffect.maximumRelativeValue = @(20);
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    // Add both effects to your view
    [self.scrollProfile addMotionEffect:group];
}

-(void)toggleEditButtons:(BOOL)show {
    
    if (editingProfile) {
        self.btnEditPicture.hidden = !show;
        self.btnEditName.hidden = !show;
        self.btnEditCategories.hidden = !show;
        self.btnEditCorpExperience.hidden = !show;
        
        
        [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:10 options:0 animations:^{
            
            self.btnEditPicture.frame = CGRectMake(self.btnEditPicture.frame.origin.x - 40, self.btnEditPicture.frame.origin.y, self.btnEditPicture.frame.size.width, self.btnEditPicture.frame.size.height);
            
            self.btnEditName.frame = CGRectMake(self.btnEditName.frame.origin.x - 40, self.btnEditName.frame.origin.y, self.btnEditName.frame.size.width, self.btnEditName.frame.size.height);
            
            self.btnEditCategories.frame = CGRectMake(self.btnEditCategories.frame.origin.x - 40, self.btnEditCategories.frame.origin.y, self.btnEditCategories.frame.size.width, self.btnEditCategories.frame.size.height);
            
            self.btnEditCorpExperience.frame = CGRectMake(self.btnEditCorpExperience.frame.origin.x - 40, self.btnEditCorpExperience.frame.origin.y, self.btnEditCorpExperience.frame.size.width, self.btnEditCorpExperience.frame.size.height);
            
        } completion:^(BOOL finished) {
            
            
        }];
    } else {
        
        [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:10 options:0 animations:^{
            
            self.btnEditPicture.frame = CGRectMake(self.btnEditPicture.frame.origin.x + 40, self.btnEditPicture.frame.origin.y, self.btnEditPicture.frame.size.width, self.btnEditPicture.frame.size.height);
            
            self.btnEditName.frame = CGRectMake(self.btnEditName.frame.origin.x +40, self.btnEditName.frame.origin.y, self.btnEditName.frame.size.width, self.btnEditName.frame.size.height);
            
            self.btnEditCategories.frame = CGRectMake(self.btnEditCategories.frame.origin.x + 40, self.btnEditCategories.frame.origin.y, self.btnEditCategories.frame.size.width, self.btnEditCategories.frame.size.height);
            
            self.btnEditCorpExperience.frame = CGRectMake(self.btnEditCorpExperience.frame.origin.x + 40, self.btnEditCorpExperience.frame.origin.y, self.btnEditCorpExperience.frame.size.width, self.btnEditCorpExperience.frame.size.height);
            
        } completion:^(BOOL finished) {
            
            self.btnEditPicture.hidden = show;
            self.btnEditName.hidden = show;
            self.btnEditCategories.hidden = show;
            self.btnEditCorpExperience.hidden = show;
        }];
    }
}

-(void)initUI {

    PFFile *imgFile = self.userProfile[@"picture"];
    
    [self.imgUser setFile:imgFile];
    [self.imgUser loadInBackground];
    
    self.lblUserNickname.text = self.userProfile[@"nickname"];
    self.lblUserLocation.text = @"Lives in Twentynine Palms, CA";
    
    // joined date
    NSString *dd = [self.userProfile.createdAt stringWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
    
    // profile views
    NSString *views;
    int profileViews = [self.userProfile[@"profileViews"] intValue];
    if (profileViews == 1) {
        views = @"1 View";
    } else {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInt:profileViews]];
        
        views = [NSString stringWithFormat:@"%@ Views", formatted];
    }
    
    //show reviews
    NSString *reviews;
    int showReviews = [self.userProfile[@"showReviews"] intValue];
    if (showReviews == 1) {
        reviews = @"1 Show Review";
    } else {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInt:showReviews]];
        reviews = [NSString stringWithFormat:@"%@ Show Reviews", formatted];
    }
    
    self.lblViews.text = [NSString stringWithFormat:@"Joined %@  |  %@  |  %@", dd, views, reviews];
    
    //clear the current badges
    for (UILabel *badge in self.arrayOfBadges) {
        [badge removeFromSuperview];
    }
    [self.arrayOfBadges removeAllObjects];
    
    //clear the current section labels
    for (UILabel *lbl in self.arrayOfSectionLabels) {
        [lbl removeFromSuperview];
    }
    [self.arrayOfSectionLabels removeAllObjects];
    
    //clear the current experiences
    
    for (UILabel *lbl in self.arrayOfCorpExperienceLabels) {
        [lbl removeFromSuperview];
    }
    [self.arrayOfCorpExperienceLabels removeAllObjects];

    
    //user badges
    int y = self.lblMyBadges.frame.origin.y + 30;
    
    if ([self.userProfile[@"arrayOfCategories"] count]) {
        for(int i = 0; i < [self.userProfile[@"arrayOfCategories"] count]; i++) {
            
            UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.lblMyBadges.frame.origin.x, y, 200, 50)];
            [myLabel setBackgroundColor:[UIColor clearColor]];
            [myLabel setTextColor:[UIColor lightGrayColor]];
            [[myLabel layer] setBorderColor:[UIColor lightGrayColor].CGColor];
            [[myLabel layer] setBorderWidth:1];
            [myLabel setText:[NSString stringWithFormat:@" %@ ",[self.userProfile[@"arrayOfCategories"] objectAtIndex:i]]];
            [myLabel setFont:[UIFont systemFontOfSize:14]];
            [myLabel sizeToFit];
            [[self viewProfile] addSubview:myLabel];
            [self.arrayOfBadges addObject:myLabel];
            y+= 5 + myLabel.frame.size.height;
        }
    } else {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.lblMyBadges.frame.origin.x, y, 200, 40)];
        lbl.text = @"No badges yet";
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textColor = [UIColor lightGrayColor];
        [lbl setFont:[UIFont systemFontOfSize:12]];
        [lbl sizeToFit];
        [self.viewProfile addSubview:lbl];
        [self.arrayOfBadges addObject:lbl];
    }
    
    
    // corp experience
    y+= 20;
    
    UILabel *lblCorpExperience = [[UILabel alloc]initWithFrame:CGRectMake(self.lblMyBadges.frame.origin.x, y, 200, 40)];
    lblCorpExperience.text = @"Corp Experience";
    lblCorpExperience.font = self.lblMyBadges.font;
    lblCorpExperience.textColor = self.lblMyBadges.textColor;
    [lblCorpExperience sizeToFit];
    [self.viewProfile addSubview:lblCorpExperience];
    [self.arrayOfSectionLabels addObject:lblCorpExperience];
    y = lblCorpExperience.frame.origin.y;
    
    if ([self.arrayOfCorpExperience count]) { //we have experience
        
        for (PFObject *exp in self.arrayOfCorpExperience) {
            NSString *str = [NSString stringWithFormat:@"%@, %@ - %@", exp[@"corpsName"], exp[@"year"], exp[@"position"]];
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(lblCorpExperience.frame.origin.x, y+30, 200, 40)];
            lbl.text = str;
            lbl.backgroundColor = [UIColor clearColor];
            lbl.textColor = [UIColor lightGrayColor];
            [lbl setFont:[UIFont systemFontOfSize:12]];
            [lbl sizeToFit];
            [self.viewProfile addSubview:lbl];
            [self.arrayOfCorpExperienceLabels addObject:lbl];
            y+=5 + lbl.frame.size.height;
        }
        
    } else { //we have no experience
        y+=30;
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(lblCorpExperience.frame.origin.x, y, 200, 40)];
        lbl.text = @"No corp experience listed";
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textColor = [UIColor lightGrayColor];
        [lbl setFont:[UIFont systemFontOfSize:12]];
        [lbl sizeToFit];
        [self.viewProfile addSubview:lbl];
        [self.arrayOfCorpExperienceLabels addObject:lbl];
    }
    
    //user background
    y+= 40;
    UILabel *lblUserBackground = [[UILabel alloc]initWithFrame:CGRectMake(self.lblMyBadges.frame.origin.x, y, self.view.frame.size.width, 40)];
    lblUserBackground.text = @"My Background";
    lblUserBackground.font = self.lblMyBadges.font;
    lblUserBackground.textColor = self.lblMyBadges.textColor;
    [lblUserBackground sizeToFit];
    [self.viewProfile addSubview:lblUserBackground];
    [self.arrayOfSectionLabels addObject:lblUserBackground];
    y = lblUserBackground.frame.origin.y;

    self.lblBackground = nil;
    y+= 30;
    if ([self.userProfile[@"background"] length]) { // we have a background
        
        self.lblBackground = [[UILabel alloc] initWithFrame:CGRectMake(lblCorpExperience.frame.origin.x, y, self.view.frame.size.width - lblCorpExperience.frame.origin.x, 40)];
        self.lblBackground.text = self.userProfile[@"background"];
        self.lblBackground.backgroundColor = [UIColor clearColor];
        self.lblBackground.textColor = [UIColor lightGrayColor];
        [self.lblBackground setFont:[UIFont systemFontOfSize:12]];
        self.lblBackground.numberOfLines = 0;
        self.lblBackground.lineBreakMode = NSLineBreakByWordWrapping;
        [self.lblBackground sizeToFit];
        [self.viewProfile addSubview:self.lblBackground];

    } else { // we don't have a background
        
        self.lblBackground = [[UILabel alloc] initWithFrame:CGRectMake(lblCorpExperience.frame.origin.x, y, 200, 40)];
        self.lblBackground.text = @"No background listed";
        self.lblBackground.backgroundColor = [UIColor clearColor];
        self.lblBackground.textColor = [UIColor lightGrayColor];
        [self.lblBackground sizeToFit];
        [self.lblBackground setFont:[UIFont systemFontOfSize:12]];
        [self.lblBackground sizeToFit];
        [self.viewProfile addSubview:self.lblBackground];
        
    }

    
    //profile scrollview
    self.scrollProfile.contentSize = CGSizeMake(self.scrollProfile.frame.size.width, self.scrollProfile.frame.size.height + 200);
    [self.view bringSubviewToFront:self.scrollProfile];

    //cover photo scrollview
    self.imgCoverPhoto.frame = CGRectMake(self.imgCoverPhoto.frame.origin.x, self.imgCoverPhoto.frame.origin.y, self.imgCoverPhoto.frame.size.width, self.imgCoverPhoto.frame.size.height + 100);
    self.scrollCoverPhoto.contentSize = CGSizeMake(self.imgCoverPhoto.frame.size.width, self.imgCoverPhoto.frame.size.height);
    
    ht = self.scrollCoverPhoto.frame.size.height;
    
    
    //recalculate the scrollview content height
    
    self.scrollProfile.contentSize = CGSizeMake(self.scrollProfile.frame.size.width, 950 + self.lblBackground.frame.size.height);
    
    //needed to set the content offset of the cover picture
    [self scrollViewDidScroll:self.scrollProfile];
}

-(void)goback {
    [self.navigationController popViewControllerAnimated:YES];
}

bool editingProfile = NO;
-(void)configProfile {
    if (editingProfile) {
        editingProfile = NO;
    } else {
        editingProfile = YES;
    }
    [self toggleEditButtons:editingProfile];
    
    
}
#pragma mark
#pragma mark - IBActions
#pragma mark
- (IBAction)btnEditCategories_clicked:(id)sender {

    [self.view addSubview:self.userCat];
    [self.userCat showInParent:self.view.frame];
    [self.userCat setCategories:self.userProfile[@"arrayOfCategories"]];
    
    
    [self.userCat setDelegate:self];
    [self.userCat.tableCategories reloadData];
}

UIPickerView *yearPicker;
UIPickerView *positionPicker;
UIPickerView *corpPicker;
- (IBAction)btnEditCorpExperience_clicked:(id)sender {
    
    [self.view addSubview:self.corpExperience];
    [self.corpExperience showInParent:self.view.frame];
    
    [self.corpExperience setDelegate:self];

    yearPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 300)];
    [yearPicker setDataSource: self];
    [yearPicker setDelegate: self];
    yearPicker.showsSelectionIndicator = YES;
    self.corpExperience.txtYear.inputView = yearPicker;

    positionPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 300)];
    [positionPicker setDataSource: self];
    [positionPicker setDelegate: self];
    positionPicker.showsSelectionIndicator = YES;
    self.corpExperience.txtPosition.inputView = positionPicker;
    
    corpPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 300)];
    [corpPicker setDataSource: self];
    [corpPicker setDelegate: self];
    corpPicker.showsSelectionIndicator = YES;
    self.corpExperience.txtCorpsName.inputView = corpPicker;
    self.corpExperience.corpPicker = corpPicker;
}


-(void)categoriesClosed {
    self.userCat = nil;
}

-(void)savedCategories {
    self.userProfile = [PFUser currentUser];
    [self initUI];
}

-(void)savedCorpExperience {
    [self getUserCorpExperiences];
}

-(void)closedCorpExperience {
    self.corpExperience = nil;
}

-(void)setUser:(PFUser *)user {
    self.userProfile = user;
    
    
}


-(void)incrementProfileViews {
    //call cloud code
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CBUserCategories *)userCat {
    if (!_userCat) {
        _userCat = [[[NSBundle mainBundle] loadNibNamed:@"CBUserCategories"
                                                      owner:self
                                                    options:nil]
                        objectAtIndex:0];
        [_userCat setDelegate:self];
    }
    return _userCat;
}

-(CBChooseCorp *)corpExperience {
    if (!_corpExperience) {
        _corpExperience = [[[NSBundle mainBundle] loadNibNamed:@"CBChooseCorp"
                                                  owner:self
                                                options:nil]
                    objectAtIndex:0];
        [_corpExperience setDelegate:self];
    }
    return _corpExperience;
}

#pragma mark
#pragma mark - UITableview delegates
#pragma mark

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.userCat.arrayOfCategories count];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = (NSString *)[self.userCat.arrayOfCategories objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14];

    NSString *str = [self.userCat.dict objectForKey:cell.textLabel.text];
    if ([str isEqualToString:@"YES"]) {
        [self selectCell:cell atIndexPath:indexPath onOrOff:YES fromMethod:NO];
    } else {
        [self selectCell:cell atIndexPath:indexPath onOrOff:NO fromMethod:NO];
    }

    return cell;
}

-(void)selectCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)path onOrOff:(BOOL)on fromMethod:(BOOL)method {
    
    if (on) {
        if (!method) [self.userCat.tableCategories selectRowAtIndexPath:path animated:NO scrollPosition: UITableViewScrollPositionNone];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        if ([self.userCat.dict objectForKey:cell.textLabel.text]) {
            [self.userCat.dict setObject:@"YES" forKey:cell.textLabel.text];
        }
    } else {
        if (!method) [self.userCat.tableCategories deselectRowAtIndexPath:path animated:NO];
        cell.accessoryType = UITableViewCellAccessoryNone;
        if ([self.userCat.dict objectForKey:cell.textLabel.text]) {
            [self.userCat.dict setObject:@"NO" forKey:cell.textLabel.text];
        }
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    [self selectCell:tableViewCell atIndexPath:indexPath onOrOff:YES fromMethod:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    [self selectCell:tableViewCell atIndexPath:indexPath onOrOff:NO fromMethod:YES];
}

#pragma mark
#pragma mark - UIPickerview Delegates
#pragma mark
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == yearPicker) {
        return [self.corpExperience.arrayOfYears objectAtIndex:row];
    } else if (pickerView == positionPicker) {
        return [self.corpExperience.arrayOfPositions objectAtIndex:row];
    } else if (pickerView == corpPicker) {
        PFObject *corp = [data.arrayOfAllCorps objectAtIndex:row];
        return corp[@"corpsName"];
    } else {
        return @"error";
    }
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == yearPicker) {
        return [self.corpExperience.arrayOfYears count];
    } else if (pickerView == positionPicker) {
        return [self.corpExperience.arrayOfPositions count];
    } else if (pickerView == corpPicker) {
        return [data.arrayOfAllCorps count];
    } else {
        return 1;
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    if (pickerView == yearPicker) {
        self.corpExperience.txtYear.text = [self.corpExperience.arrayOfYears objectAtIndex:row];
    } else if (pickerView == positionPicker) {
        self.corpExperience.txtPosition.text = [self.corpExperience.arrayOfPositions objectAtIndex:row];
    } else if (pickerView == corpPicker) {
        PFObject *corps = [data.arrayOfAllCorps objectAtIndex:row];
        self.corpExperience.selectedCorp = corps;
        self.corpExperience.txtCorpsName.text = corps[@"corpsName"];
    }
}

#pragma mark
#pragma mark - Scrollview Delegates
#pragma mark

float ht;
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView == self.scrollProfile) {
        CGPoint offset = scrollView.contentOffset;
        if (scrollView.contentOffset.y < 0) {
            self.scrollCoverPhoto.frame = CGRectMake(self.scrollCoverPhoto.frame.origin.x, self.scrollCoverPhoto.frame.origin.y, self.scrollCoverPhoto.frame.size.width, ht - self.scrollProfile.contentOffset.y);
            
        } else if (scrollView.contentOffset.y == 0) {
             self.scrollCoverPhoto.frame = CGRectMake(self.scrollCoverPhoto.frame.origin.x, self.scrollCoverPhoto.frame.origin.y, self.scrollCoverPhoto.frame.size.width, ht);
        } else {
            
            
        }
        
        offset.y = offset.y / 3;
        self.scrollCoverPhoto.contentOffset = offset;
        
        NSLog(@"%f", self.scrollCoverPhoto.frame.origin.y);
    }

}

-(NSMutableArray *)arrayOfBadges {
    if (!_arrayOfBadges) {
        _arrayOfBadges = [[NSMutableArray alloc] init];
    }
    return _arrayOfBadges;
}

-(NSMutableArray *)arrayOfSectionLabels {
    if (!_arrayOfSectionLabels) {
        _arrayOfSectionLabels = [[NSMutableArray alloc] init];
    }
    return _arrayOfSectionLabels;
}

-(NSMutableArray *)arrayOfCorpExperience {
    if (!_arrayOfCorpExperience) {
        _arrayOfCorpExperience = [[NSMutableArray alloc] init];
    }
    return _arrayOfCorpExperience;
}

-(NSMutableArray *)arrayOfCorpExperienceLabels {
    if (!_arrayOfCorpExperienceLabels) {
        _arrayOfCorpExperienceLabels = [[NSMutableArray alloc] init];
    }
    return _arrayOfCorpExperienceLabels;
}

@end
