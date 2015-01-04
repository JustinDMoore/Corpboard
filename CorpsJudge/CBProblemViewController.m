//
//  CBProblemViewController.m
//  CorpBoard
//
//  Created by Justin Moore on 11/8/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBProblemViewController.h"
#import "CBTextViewPlaceHolder.h"

#import "CBProblemWhere.h"
#import "CBProblemDescribe.h"

@interface CBProblemViewController ()
@property (nonatomic, strong) CBProblemWhere *viewProblemWhere;
@property (nonatomic, strong) CBProblemDescribe *viewProblemDescribe;
@property (nonatomic, strong) NSMutableArray *arrayOfSubviews;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollProblem;

@end

@implementation CBProblemViewController

-(void)viewWillAppear:(BOOL)animated {
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addView:self.viewProblemWhere andScroll:NO];
    [self addView:self.viewProblemDescribe andScroll:NO];
}

-(void)addView:(UIView *)viewToAdd andScroll:(BOOL)scroll {
    
    viewToAdd.frame = CGRectMake(viewToAdd.frame.origin.x, 0, self.scrollProblem.frame.size.width, self.scrollProblem.frame.size.height);
    
    
    if ([self.arrayOfSubviews count]) {
        UIView *view = [self.arrayOfSubviews lastObject];
        viewToAdd.frame = CGRectMake(view.frame.origin.x + view.frame.size.width, 0, self.scrollProblem.frame.size.width, self.scrollProblem.frame.size.height);
        self.scrollProblem.contentSize = CGSizeMake(self.scrollProblem.contentSize.width + self.scrollProblem.frame.size.width, self.scrollProblem.frame.size.height);
    } else {
        viewToAdd.frame = CGRectMake(self.scrollProblem.frame.size.width, 0, self.scrollProblem.frame.size.width, self.scrollProblem.frame.size.height);
        self.scrollProblem.contentSize = CGSizeMake(self.scrollProblem.frame.size.width * 2, self.scrollProblem.frame.size.height);
    }
    
    [self.scrollProblem addSubview:viewToAdd];
    [self.scrollProblem scrollRectToVisible:viewToAdd.frame animated:scroll];
    
    
    [self.arrayOfSubviews addObject:viewToAdd];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.viewProblemWhere.arrayOfProblemAreas count];
}

bool isProblemOpen = NO;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = [self.viewProblemWhere.arrayOfProblemAreas objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

}


-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexPath *oldIndex = [self.viewProblemWhere.tableProblem indexPathForSelectedRow];
    [self.viewProblemWhere.tableProblem cellForRowAtIndexPath:oldIndex].accessoryType = UITableViewCellAccessoryNone;
    [self.viewProblemWhere.tableProblem cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    return indexPath;
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
@end
