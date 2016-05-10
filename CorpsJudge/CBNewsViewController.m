//
//  CBNewsViewController.m
//  CorpBoard
//
//  Created by Justin Moore on 11/14/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBNewsViewController.h"
#import "CBNewsSingleton.h"
#import "CBNewsItem.h"
#import "NSDate+Utilities.h"
#import "JSQMessagesTimestampFormatter.h"
#import "CBWebViewController.h"
#import "DTCoreText.h"
#import "Corpsboard-Swift.h"

News *news;

@interface CBNewsViewController ()

@end

@implementation CBNewsViewController

MWFeedItem *itemForWeb;

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
    self.title = @"News";
    
}

- (void)goback {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    news = [[News alloc] init];
    
    self.tableView.estimatedRowHeight = 65.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.clearsSelectionOnViewWillAppear = YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - UITableview delegates
#pragma mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [news.arrayOfNewsItemsToDisplay count];
}

- (NSString *)trimWhitespace:(NSString *)str {
    NSMutableString *mStr = [str mutableCopy];
    CFStringTrimWhitespace((CFMutableStringRef)mStr);
    
    NSString *result = [mStr copy];
    
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"news" forIndexPath:indexPath];
    
    UILabel *title = (UILabel *)[cell viewWithTag:1];
    UILabel *desc = (UILabel *)[cell viewWithTag:2];
    UILabel *by = (UILabel *)[cell viewWithTag:3];
    
    MWFeedItem *item = [news.arrayOfNewsItemsToDisplay objectAtIndex:indexPath.row];
    
    NSData *data = [item.summary dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithHTMLData:data documentAttributes:NULL];
    
    //NSLog(@"%@", attrString.string);
    
    title.text = item.title;
    
    NSString *x = [self trimWhitespace:attrString.string];
    
    if ([item.title isEqualToString:@"Corps news and announcements"]) {
        desc.text = @"The latest news and notes from Drum Corps International's World and Open Class corps";
    } else {
        desc.text = x;
    }

   // by.text = [NSString stringWithFormat:@"by Drum Corps International - %@", [news.sharedInstance dateForNews(item.date)]];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    itemForWeb = [news.arrayOfNewsItemsToDisplay objectAtIndex:indexPath.row];
    
    NSString * storyboardName = @"Main";
    NSString * viewControllerID = @"web";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    CBWebViewController * web = (CBWebViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    web.webURL = itemForWeb.link;
    web.websiteTitle = @"Drum Corps International";
    web.websiteSubTitle = itemForWeb.title;
    
    [self presentViewController:web animated:YES completion:nil];
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

@end
