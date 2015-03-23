//
//  CBCorpsViewController.m
//  CorpBoard
//
//  Created by Isaias Favela on 7/1/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBCorpsViewController.h"
#import "CBSingle.h"
#import "CBCorpsDetailViewController.h"
#import "ILTranslucentView.h"

CBSingle *data;
NSTimer *timer;

@interface CBCorpsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableCorps;
@property (weak, nonatomic) IBOutlet UILabel *lblactivity;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end

@implementation CBCorpsViewController

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
    UIImage *backBtnImage = [UIImage imageNamed:@"arrowLeft"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self.tableCorps reloadData];
}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    data = [CBSingle data];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableCorps.hidden = YES;
    [self startTimer];

}

-(void)showTable {
    
    [self sortCorpsAlphabetically];
    self.tableCorps.hidden = NO;
    [self.tableCorps reloadData];
}

-(void)checkForCorp {
    
    if (data.dataLoaded) {
        [timer invalidate];
        self.lblactivity.hidden = YES;
        [self.activity stopAnimating];
        self.activity.hidden = YES;
        [self showTable];
    }
}

-(void)startTimer {
    
    self.tableCorps.hidden = YES;
    self.lblactivity.hidden = NO;
    self.activity.hidden = NO;
    [self.activity startAnimating];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.5
                                             target:self
                                           selector:@selector(checkForCorp)
                                           userInfo:nil
                                            repeats:YES];

}

-(void)sortCorpsAlphabetically {
    
    NSSortDescriptor *sortCorps = [[NSSortDescriptor alloc] initWithKey:@"corpsName" ascending:YES];
    NSArray *sortCorpsDescriptor = [NSArray arrayWithObject: sortCorps];
    
    if ([data.arrayOfWorldClass count]) [data.arrayOfWorldClass sortUsingDescriptors:sortCorpsDescriptor];
    if ([data.arrayOfOpenClass count]) [data.arrayOfOpenClass sortUsingDescriptors:sortCorpsDescriptor];
    if ([data.arrayOfAllAgeClass count]) [data.arrayOfAllAgeClass sortUsingDescriptors:sortCorpsDescriptor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) return @"World Class";
    else if (section == 1) return @"Open Class";
    else if (section == 2) return @"All Age Class";
    else return @"Error";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) return [data.arrayOfWorldClass count];
    else if (section == 1) return [data.arrayOfOpenClass count];
    else if (section == 2) return [data.arrayOfAllAgeClass count];
    else return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"corps"];
    UILabel *lblcorpsName = (UILabel *)[cell viewWithTag:2];
    UIImageView *imgCorps = (UIImageView *)[cell viewWithTag:3];
    
    if (indexPath.section == 0) {
        if ([data.arrayOfWorldClass count]) {
            
            PFObject *corps;
            corps = [data.arrayOfWorldClass objectAtIndex:indexPath.row];
           
            lblcorpsName.text = corps[@"corpsName"];
            PFFile *imageFile = corps[@"logo"];
            if (imageFile) {
                [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                    if (!error) {
                        imgCorps.image = [UIImage imageWithData:data];
                    } else {
                        imgCorps.image = nil;
                        NSLog(@"Could not display logo for %@", corps[@"corpsName"]);
                    }
                }];
            } else {
                imgCorps.image = nil;
                NSLog(@"Could not display logo for %@", corps[@"corpsName"]);
            }
        }
    } else if (indexPath.section == 1) {
        if ([data.arrayOfOpenClass count]) {

            PFObject *corps;
            corps = [data.arrayOfOpenClass objectAtIndex:indexPath.row];
            lblcorpsName.text = corps[@"corpsName"];
            PFFile *imageFile = corps[@"logo"];
            if (imageFile) {
                [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                    if (!error) {
                        imgCorps.image = [UIImage imageWithData:data];
                    } else {
                        imgCorps.image = nil;
                        NSLog(@"Could not display logo for %@", corps[@"corpsName"]);
                    }
                }];
            } else {
                imgCorps.image = nil;
                NSLog(@"Could not display logo for %@", corps[@"corpsName"]);
            }
        }
    }  else if (indexPath.section == 2) {
        if ([data.arrayOfAllAgeClass count]) {
            
            PFObject *corps;
            corps = [data.arrayOfAllAgeClass objectAtIndex:indexPath.row];
            lblcorpsName.text = corps[@"corpsName"];
            PFFile *imageFile = corps[@"logo"];
            if (imageFile) {
                [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                    if (!error) {
                        imgCorps.image = [UIImage imageWithData:data];
                    } else {
                        imgCorps.image = nil;
                        NSLog(@"Could not display logo for %@", corps[@"corpsName"]);
                    }
                }];
            } else {
                imgCorps.image = nil;
                NSLog(@"Could not display logo for %@", corps[@"corpsName"]);
            }
        }
    }
    
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];

    [view setBackgroundColor: [UIColor darkGrayColor]];
   
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)];
    if (section == 0) label.text = @"World Class";
    else if (section == 1) label.text = @"Open Class";
    else if (section == 2) label.text = @"All Age Class";
    label.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.75];
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    return view;
}

PFObject *corpsToOpen;

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        corpsToOpen = [data.arrayOfWorldClass objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        corpsToOpen = [data.arrayOfOpenClass objectAtIndex:indexPath.row];
    } else if (indexPath.section == 2) {
        corpsToOpen = [data.arrayOfAllAgeClass objectAtIndex:indexPath.row];
    }
    
    [self performSegueWithIdentifier:@"corpDetail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    CBCorpsDetailViewController *vc = [segue destinationViewController];
    vc.corps = corpsToOpen;
}

@end
