//
//  CBProblemTableViewController.m
//  CorpBoard
//
//  Created by Justin Moore on 11/8/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBProblemTableViewController.h"
#import "CBTextViewPlaceHolder.h"


#import "CBProblemDescribe.h"

@interface CBProblemTableViewController ()
@property (nonatomic, strong) CBProblemWhere *viewProblemWhere;
@property (nonatomic, strong) CBProblemDescribe *viewProblemDescribe;
@property (nonatomic, strong) CBTextViewPlaceHolder *txtProblem;
@property (nonatomic, strong) NSString *where;
@property (nonatomic, strong) NSString *what;
@property (nonatomic, strong) NSMutableArray *arrayOfScreenshots;
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;
@end

@implementation CBProblemTableViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Broken Feature";
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                    style:UIBarButtonItemStyleDone target:self action:@selector(cancelProblem)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Send"
                                                                    style:UIBarButtonItemStyleDone target:self action:@selector(sendProblem)];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

-(void)cancelProblem {
    
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:nil];
}

-(void)sendProblem {
    NSLog(@"sent bitch");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.what = [NSString string];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)showWhereTable {
    [self.navigationController.view addSubview:self.viewProblemWhere];
    [self.view.superview addSubview:self.viewProblemWhere];
    [self.viewProblemWhere showInParent:self.view.frame];
    [self.view.superview bringSubviewToFront:self.viewProblemWhere];
}

-(void)whatDone {
    
    [self.txtProblem resignFirstResponder];
    details = NO;
    if ([self.txtProblem.text length]) {
        self.what = self.txtProblem.text;
    }
    [self.tableView reloadData];
}

-(void)screenshotDone {
    addingScreenshot = NO;
    [self.tableView reloadData];
}

-(void)setViews {
    
    UIButton *btnDelete1 = (UIButton *)[self.view1 viewWithTag:7];
    UIButton *imgView1 = (UIButton *)[self.view1 viewWithTag:8];
    
    UIButton *btnDelete2 = (UIButton *)[self.view2 viewWithTag:7];
    UIButton *imgView2 = (UIButton *)[self.view2 viewWithTag:8];
    
    UIButton *btnDelete3 = (UIButton *)[self.view3 viewWithTag:7];
    UIButton *imgView3 = (UIButton *)[self.view3 viewWithTag:8];
    
    [imgView1 addTarget:self action:@selector(addScreenshot) forControlEvents:UIControlEventTouchUpInside];
    [imgView2 addTarget:self action:@selector(addScreenshot) forControlEvents:UIControlEventTouchUpInside];
    [imgView2 addTarget:self action:@selector(addScreenshot) forControlEvents:UIControlEventTouchUpInside];
    
    if (3 > [self.arrayOfScreenshots count]) {
        self.view3.hidden = YES;
    } else {
        self.view3.hidden = NO;
        [imgView3 setImage:(UIImage *)[self.arrayOfScreenshots objectAtIndex:2] forState:UIControlStateNormal];
        btnDelete3.hidden = NO;
    }
    
    if (2 > [self.arrayOfScreenshots count]) {
        self.view2.hidden = YES;
    } else {
        self.view2.hidden = NO;
        [imgView2 setImage:(UIImage *)[self.arrayOfScreenshots objectAtIndex:1] forState:UIControlStateNormal];
        btnDelete2.hidden = NO;
        
        self.view3.hidden = NO;
        [imgView3 setImage:[UIImage imageNamed:@"screenshot"] forState:UIControlStateNormal];
        btnDelete3.hidden = YES;
    }
    
    if (1 > [self.arrayOfScreenshots count]) {
        self.view1.hidden = NO;
        [imgView1 setImage:[UIImage imageNamed:@"screenshot"] forState:UIControlStateNormal];
        btnDelete1.hidden = YES;
    } else {
        self.view1.hidden = NO;
        [imgView1 setImage:(UIImage *)[self.arrayOfScreenshots objectAtIndex:0] forState:UIControlStateNormal];
        btnDelete1.hidden = NO;
        
        self.view2.hidden = NO;
        [imgView2 setImage:[UIImage imageNamed:@"screenshot"] forState:UIControlStateNormal];
        btnDelete2.hidden = YES;
    }
    
}

-(void)addScreenshot {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark
#pragma mark - UIImagePickerController Delegates
#pragma mark
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.arrayOfScreenshots addObject:image];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return 3;
    } else {
        return [self.viewProblemWhere.arrayOfProblemAreas count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        if (indexPath.row == 1) {
            if (details) {
                return 200;
            } else {
                return 60;
            }
        } else if (indexPath.row == 2) {
            if (addingScreenshot) return 160;
            else return 60;
        } else {
            return 60;
        }
    } else {
        return 44;
    }
    
}

bool isProblemOpen = NO;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.viewProblemWhere.tableProblem) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = [self.viewProblemWhere.arrayOfProblemAreas objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        NSString *str = [self.viewProblemWhere.arrayOfProblemAreas objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([str isEqualToString:self.where]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.selected = YES;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selected = NO;
        }
        
        return cell;
    } else if (tableView == self.tableView) {
        UITableViewCell *cell;
        UILabel *lbl;
        switch (indexPath.row) {
            case 0:
                cell = [self.tableView dequeueReusableCellWithIdentifier:@"where"];
                lbl = (UILabel *)[cell viewWithTag:1];
                if ([self.where length]) {
                    lbl.text = self.where;
                } else {
                    lbl.text = @"(Required)";
                }
                
                break;
            case 1:
                if (!details) {
                cell = [self.tableView dequeueReusableCellWithIdentifier:@"what1"];
                    lbl = (UILabel *)[cell viewWithTag:1];
                    if ([self.what length]) {
                        lbl.text = self.what;
                    } else {
                        lbl.text = @"(Required)";
                    }
                } else {
                    cell = [self.tableView dequeueReusableCellWithIdentifier:@"what2"];
                    UIButton *btn = (UIButton *)[cell viewWithTag:2];
                    [btn addTarget:self action:@selector(whatDone) forControlEvents:UIControlEventTouchUpInside];
                    self.txtProblem = (CBTextViewPlaceHolder *)[cell viewWithTag:1];
                    self.txtProblem.placeholder = @"Briefly explain what happened...";
                    self.txtProblem.backgroundColor = [UIColor blackColor];
                    self.txtProblem.placeholderColor = [UIColor lightGrayColor];
                    self.txtProblem.textColor = [UIColor whiteColor];
                    [self.txtProblem setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
                    [self.txtProblem becomeFirstResponder];
                    
                }
                break;
            case 2:
                if (addingScreenshot) {
                    cell = [self.tableView dequeueReusableCellWithIdentifier:@"screenshot2"];
                    UIButton *btn = (UIButton *)[cell viewWithTag:2];
                    [btn addTarget:self action:@selector(screenshotDone) forControlEvents:UIControlEventTouchUpInside];
                    self.view1 = (UIView *)[cell viewWithTag:3];
                    self.view2 = (UIView *)[cell viewWithTag:4];
                    self.view3 = (UIView *)[cell viewWithTag:5];
                    [self setViews];
                } else {
                    cell = [self.tableView dequeueReusableCellWithIdentifier:@"screenshot1"];
                }
                
                break;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        return nil;
    }
}

BOOL details = NO;
BOOL addingScreenshot = NO;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableView) {
        if (indexPath.row == 0) {
            [self showWhereTable];
            details = NO;
            [self.tableView reloadData];
        } else if (indexPath.row == 1) {
            if (details) [self whatDone];
            else {
                details = YES;
                [self.tableView reloadData];
            }
        } else if (indexPath.row == 2) {
            if (addingScreenshot) {
                [self screenshotDone];
            } else {
                addingScreenshot = YES;
                [self.tableView reloadData];
            }
        }
    } else if (tableView == self.viewProblemWhere.tableProblem) {
        self.where = [self.viewProblemWhere.arrayOfProblemAreas objectAtIndex:indexPath.row];
        [self.viewProblemWhere closeView:NO];
        [self.tableView reloadData];
    }
}


-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexPath *oldIndex = [self.viewProblemWhere.tableProblem indexPathForSelectedRow];
    [self.viewProblemWhere.tableProblem cellForRowAtIndexPath:oldIndex].accessoryType = UITableViewCellAccessoryNone;
    [self.viewProblemWhere.tableProblem cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    return indexPath;
}


#pragma mark
#pragma mark - ProblemWhere Delegate
#pragma mark

-(void)problemWhereCanceled {
    self.viewProblemWhere = nil;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(CBProblemWhere *)viewProblemWhere {
    
    if (!_viewProblemWhere) {
        _viewProblemWhere = [[[NSBundle mainBundle] loadNibNamed:@"CBProblemWhere"
                                                      owner:self
                                                    options:nil]
                        objectAtIndex:0];
        _viewProblemWhere.tableProblem.delegate = self;
        _viewProblemWhere.tableProblem.dataSource = self;
        _viewProblemWhere.tableProblem.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewProblemWhere setDelegate:self];
    }
    return _viewProblemWhere;
}

-(CBProblemDescribe *)viewProblemDescribe {
    if (!_viewProblemDescribe) {
        _viewProblemDescribe = [[[NSBundle mainBundle] loadNibNamed:@"CBProblemDescribe"
                                                      owner:self
                                                    options:nil]
                        objectAtIndex:0];
    }
    return _viewProblemDescribe;
}

-(NSMutableArray *)arrayOfScreenshots {
    if (!_arrayOfScreenshots) {
        _arrayOfScreenshots = [[NSMutableArray alloc] init];
    }
    return _arrayOfScreenshots;
}

@end
