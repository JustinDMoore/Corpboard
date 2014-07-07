//
//  CBCorpsViewController.m
//  CorpBoard
//
//  Created by Isaias Favela on 7/1/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBCorpsViewController.h"
#import "CSSingle.h"
#import "CBCorpsDetailViewController.h"
#import "ILTranslucentView.h"

CSSingle *data;
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
    [self.tableCorps reloadData];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:NO animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    data = [CSSingle data];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableCorps.hidden = YES;
    [self startTimer];

}

-(void)showTable {
    
    [self sortCorpsAlphabetically];
    self.tableCorps.hidden = NO;
    [self.tableCorps reloadData];
}

-(void)checkForCorps {
    
    if (data.updatedCorps) {
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
                                           selector:@selector(checkForCorps)
                                           userInfo:nil
                                            repeats:YES];
}

-(void)sortCorpsAlphabetically {
    
    NSSortDescriptor *sortCorps = [[NSSortDescriptor alloc] initWithKey:@"corpsName" ascending:YES];
    NSArray *sortCorpsDescriptor = [NSArray arrayWithObject: sortCorps];
    
    if ([data.arrayOfWorldClass count]) [data.arrayOfWorldClass sortUsingDescriptors:sortCorpsDescriptor];
    if ([data.arrayOfOpenClass count]) [data.arrayOfOpenClass sortUsingDescriptors:sortCorpsDescriptor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) return @"World Class";
    else if (section == 1) return @"Open Class";
    else return @"Error";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) return [data.arrayOfWorldClass count];
    else if (section == 1) return [data.arrayOfOpenClass count];
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
            imgCorps.image = [UIImage imageNamed:corps[@"corpsName"]];
   
        }
    } else if (indexPath.section == 1) {
        if ([data.arrayOfOpenClass count]) {

            PFObject *corps;
            corps = [data.arrayOfOpenClass objectAtIndex:indexPath.row];
            lblcorpsName.text = corps[@"corpsName"];
            imgCorps.image = [UIImage imageNamed:corps[@"corpsName"]];
            
        }
    }
    
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];

    [view setBackgroundColor: [UIColor darkGrayColor]];
   
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)];
    if (section == 0) label.text = @"World Class";
    else if (section == 1) label.text = @"Open Class";
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
    }
    
    [self performSegueWithIdentifier:@"corpDetail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    CBCorpsDetailViewController *vc = [segue destinationViewController];
    vc.corps = corpsToOpen;
}

@end
