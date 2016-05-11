//
//  CBCorpsViewController.m
//  CorpBoard
//
//  Created by Isaias Favela on 7/1/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBCorpsViewController.h"
#import "CBCorpsDetailViewController.h"
#import "ILTranslucentView.h"
#import "KVNProgress.h"
#import "Configuration.h"
#import "Corpsboard-Swift.h"

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
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress setConfiguration:[Configuration standardProgressConfig]];
        [KVNProgress dismiss];
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

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
    
    [timer invalidate];
    self.lblactivity.hidden = YES;
    [self.activity stopAnimating];
    self.activity.hidden = YES;
    [self showTable];
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
    
    if ([Server.sharedInstance.arrayOfWorldClass count]) [Server.sharedInstance.NSarrayOfWorldClass sortUsingDescriptors:sortCorpsDescriptor];
    if ([Server.sharedInstance.arrayOfOpenClass count]) [Server.sharedInstance.NSarrayOfOpenClass sortUsingDescriptors:sortCorpsDescriptor];
    if ([Server.sharedInstance.arrayOfAllAgeClass count]) [Server.sharedInstance.NSarrayOfAllAgeClass sortUsingDescriptors:sortCorpsDescriptor];
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
    
    if (section == 0) return [Server.sharedInstance.arrayOfWorldClass count];
    else if (section == 1) return [Server.sharedInstance.arrayOfOpenClass count];
    else if (section == 2) return [Server.sharedInstance.arrayOfAllAgeClass count];
    else return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"corps"];
    UILabel *lblcorpsName = (UILabel *)[cell viewWithTag:2];
    UIImageView *imgCorps = (UIImageView *)[cell viewWithTag:3];
    
    if (indexPath.section == 0) {
        if ([Server.sharedInstance.arrayOfWorldClass count]) {
            
            PFObject *corps;
            corps = [Server.sharedInstance.arrayOfWorldClass objectAtIndex:indexPath.row];
           
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
        if ([Server.sharedInstance.arrayOfOpenClass count]) {

            PFObject *corps;
            corps = [Server.sharedInstance.arrayOfOpenClass objectAtIndex:indexPath.row];
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
        if ([Server.sharedInstance.arrayOfAllAgeClass count]) {
            
            PFObject *corps;
            corps = [Server.sharedInstance.arrayOfAllAgeClass objectAtIndex:indexPath.row];
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
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    
    return view;
}

PFObject *corpsToOpen;

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        corpsToOpen = [Server.sharedInstance.arrayOfWorldClass objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        corpsToOpen = [Server.sharedInstance.arrayOfOpenClass objectAtIndex:indexPath.row];
    } else if (indexPath.section == 2) {
        corpsToOpen = [Server.sharedInstance.arrayOfAllAgeClass objectAtIndex:indexPath.row];
    }
    
    [self performSegueWithIdentifier:@"corpDetail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    CBCorpsDetailViewController *vc = [segue destinationViewController];
    vc.corps = corpsToOpen;
}

@end
