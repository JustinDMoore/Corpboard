//
//  CBUserProfileViewController.m
//  CorpBoard
//
//  Created by Isaias Favela on 12/10/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBUserProfileViewController.h"
#import "NSDate+Utilities.h"


@interface CBUserProfileViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnEditCategories;
@property (weak, nonatomic) IBOutlet UIButton *btnEditName;
@property (nonatomic, strong) CBUserCategories *userCat;
@property (weak, nonatomic) IBOutlet UIButton *btnEditPicture;
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
        self.viewControls.hidden = YES;
    } else {
        self.viewControls.hidden = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2;
    self.imgUser.layer.masksToBounds = YES;
    
    
    editingProfile = NO;
    self.btnEditPicture.frame = CGRectMake(self.btnEditPicture.frame.origin.x + 40, self.btnEditPicture.frame.origin.y, self.btnEditPicture.frame.size.width, self.btnEditPicture.frame.size.height);
    
    self.btnEditName.frame = CGRectMake(self.btnEditName.frame.origin.x + 40, self.btnEditName.frame.origin.y, self.btnEditName.frame.size.width, self.btnEditName.frame.size.height);
    
    self.btnEditCategories.frame = CGRectMake(self.btnEditCategories.frame.origin.x + 40, self.btnEditCategories.frame.origin.y, self.btnEditCategories.frame.size.width, self.btnEditCategories.frame.size.height);
    
    self.btnEditPicture.hidden = YES;
    self.btnEditName.hidden = YES;
    self.btnEditCategories.hidden = YES;
    
    [self initUI];
    
}

-(void)toggleEditButtons:(BOOL)show {
    
    if (editingProfile) {
        self.btnEditPicture.hidden = !show;
        self.btnEditName.hidden = !show;
        self.btnEditCategories.hidden = !show;
        
        
        [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:10 options:0 animations:^{
            
            self.btnEditPicture.frame = CGRectMake(self.btnEditPicture.frame.origin.x - 40, self.btnEditPicture.frame.origin.y, self.btnEditPicture.frame.size.width, self.btnEditPicture.frame.size.height);
            
            self.btnEditName.frame = CGRectMake(self.btnEditName.frame.origin.x - 40, self.btnEditName.frame.origin.y, self.btnEditName.frame.size.width, self.btnEditName.frame.size.height);
            
            self.btnEditCategories.frame = CGRectMake(self.btnEditCategories.frame.origin.x - 40, self.btnEditCategories.frame.origin.y, self.btnEditCategories.frame.size.width, self.btnEditCategories.frame.size.height);
            
        } completion:^(BOOL finished) {
            
            
        }];
    } else {
        
        [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:10 options:0 animations:^{
            
            self.btnEditPicture.frame = CGRectMake(self.btnEditPicture.frame.origin.x + 40, self.btnEditPicture.frame.origin.y, self.btnEditPicture.frame.size.width, self.btnEditPicture.frame.size.height);
            
            self.btnEditName.frame = CGRectMake(self.btnEditName.frame.origin.x +40, self.btnEditName.frame.origin.y, self.btnEditName.frame.size.width, self.btnEditName.frame.size.height);
            
            self.btnEditCategories.frame = CGRectMake(self.btnEditCategories.frame.origin.x + 40, self.btnEditCategories.frame.origin.y, self.btnEditCategories.frame.size.width, self.btnEditCategories.frame.size.height);
            
        } completion:^(BOOL finished) {
            
            self.btnEditPicture.hidden = show;
            self.btnEditName.hidden = show;
            self.btnEditCategories.hidden = show;
        }];
    }
}

-(void)initUI {
    
    PFFile *imgFile = self.userProfile[@"picture"];
    
    [self.imgUser setFile:imgFile];
    [self.imgUser loadInBackground];
    
    self.lblUserNickname.text = self.userProfile[@"nickname"];
    self.lblUserLocation.text = @"Lives in Twentynine Palms, CA";
    NSString *dd = [self.userProfile.createdAt stringWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
    
    NSString *views;
    int profileViews = (int)self.userProfile[@"profileViews"];
    if (profileViews == 1) {
        views = @"1 View";
    } else {
        views = [NSString stringWithFormat:@"%i Views", profileViews];
    }
    self.lblViews.text = [NSString stringWithFormat:@"Joined %@  |  %@  |  3 Show Reviews", dd, views];
    BOOL first = YES;
    NSString *result;
    for (NSString *str in self.userProfile[@"arrayOfCategories"]) {
        if (first) {
            result = str;
        } else {
            result = [NSString stringWithFormat:@"%@\n%@",result, str];
        }
        if (first) first = NO;
    }
    self.lblUserCategories.numberOfLines = 0;
    self.lblUserCategories.text = result;

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

- (IBAction)btnEditCategories_clicked:(id)sender {

    [self.view addSubview:self.userCat];
    [self.userCat showInParent:self.view.frame];
    [self.userCat setCategories:self.userProfile[@"arrayOfCategories"]];
    
    
    [self.userCat setDelegate:self];
    [self.userCat.tableCategories reloadData];
}

-(void)categoriesClosed {
    self.userCat = nil;
}

-(void)savedCategories {
    self.userProfile = [PFUser currentUser];
    [self initUI];
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

@end
