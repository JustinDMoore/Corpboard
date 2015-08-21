//
//  CBStoreItemTableViewController.m
//  Corpboard
//
//  Created by Justin Moore on 8/20/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBStoreItemTableViewController.h"
#import "CBStoreModel.h"

CBStoreModel *store;
NSString *const _GOLD = @"c78e34";
NSString *const _MAROON = @"782025";

@interface CBStoreItemTableViewController ()
@property (nonatomic, strong) CBStoreItemSelector *viewSelector;
@end

@implementation CBStoreItemTableViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    store = [CBStoreModel storeModel];
    [store setDelegate:self];
    [self updateCart];
    self.navigationItem.titleView = [store getStoreTitleView];
    UIButton *backButton = [[UIButton alloc] init];
    UIImage *imgBack = [UIImage imageNamed:@"storeBack"];
    [backButton setBackgroundImage:imgBack forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButtonBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonBarItem;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0;
    self.clearsSelectionOnViewWillAppear = YES;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateCart {
    // cart button
    UIButton *cartButton = [[UIButton alloc] init];
    UIImage *imgCart = [UIImage imageNamed:[NSString stringWithFormat:@"cart%i", + [store numberOfItemsInCart]]];
    [cartButton setBackgroundImage:imgCart forState:UIControlStateNormal];
    [cartButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    cartButton.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *cartBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cartButton];
    self.navigationItem.rightBarButtonItem = cartBarButtonItem;
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: return 300;
            break;
        case 1: return 164;
            break;
        case 2: return 100;
        default: return 44;
            break;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *desc = self.item[@"description"];
    if ([desc length]) return 3;
    else return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    switch (indexPath.row) {
        {case 0: //image
             cell = [tableView dequeueReusableCellWithIdentifier:@"image" forIndexPath:indexPath];
            PFImageView *imgItem = (PFImageView *)[cell viewWithTag:1];
            PFFile *imgFile = self.item[@"image"];
            
            if (imgFile) {
                [imgItem setFile:imgFile];
                [imgItem loadInBackground];
            } else {
                [imgItem setImage:[UIImage imageNamed:@"StoreError"]];
            }
            break;}
        {case 1: //buy
            cell = [tableView dequeueReusableCellWithIdentifier:@"buy" forIndexPath:indexPath];
            UIButton *btnPickASize = (UIButton *)[cell viewWithTag:1];
            UIButton *btnPickAColor = (UIButton *)[cell viewWithTag:2];
            UIButton *btnPickQuantity = (UIButton *)[cell viewWithTag:3];
            UIButton *btnAddToCart = (UIButton *)[cell viewWithTag:4];
            UILabel *lblItemDescription = (UILabel *)[cell viewWithTag:5];
            UILabel *lblItemPrice = (UILabel *)[cell viewWithTag:6];
            UILabel *lblItemSalePrice = (UILabel *)[cell viewWithTag:7];
            
            btnPickASize.layer.borderWidth = 1;
            btnPickAColor.layer.borderWidth = 1;
            btnPickQuantity.layer.borderWidth = 1;
            btnAddToCart.layer.borderWidth = 1;
            
            btnPickASize.layer.borderColor = [UIColor blackColor].CGColor;
            btnPickAColor.layer.borderColor = [UIColor blackColor].CGColor;
            btnPickQuantity.layer.borderColor = [UIColor blackColor].CGColor;
            btnAddToCart.layer.borderColor = [UIColor blackColor].CGColor;
            
            [btnPickASize setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btnPickAColor setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btnPickQuantity setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btnAddToCart setTitleColor:[self colorFromHexString:_GOLD] forState:UIControlStateNormal];
            
            [btnPickASize setBackgroundColor:[UIColor clearColor]];
            [btnPickAColor setBackgroundColor:[UIColor clearColor]];
            [btnPickQuantity setBackgroundColor: [UIColor clearColor]];
            [btnAddToCart setBackgroundColor:[self colorFromHexString:_MAROON]];
            
            [btnPickASize addTarget:self action:@selector(showSelector) forControlEvents:UIControlEventTouchUpInside];
            
            lblItemDescription.text = self.item[@"item"];
            
            double itemPrice = [self.item[@"price"] doubleValue];
            double itemSalePrice = [self.item[@"salePrice"] doubleValue];
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
            NSString *strPrice = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:itemPrice]];
            NSString *strSalePrice = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:itemSalePrice]];
            if (itemSalePrice > 0) {
                NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:strPrice];
                [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                        value:@2
                                        range:NSMakeRange(0, [attributeString length])];
                lblItemPrice.attributedText = attributeString;
                lblItemSalePrice.text = strSalePrice;
            } else {
                lblItemPrice.text = strPrice;
                lblItemSalePrice.hidden = YES;
            }
        
            NSArray *arrayOfColorChoices = self.item[@"colors"];
            if ([arrayOfColorChoices count]) {
                btnPickAColor.hidden = NO;
            } else {
                btnPickAColor.hidden = YES;
            }
            
            
        break;}
        {case 2: //details
            cell = [tableView dequeueReusableCellWithIdentifier:@"details" forIndexPath:indexPath];
            UILabel *lblDesc = (UILabel *)[cell viewWithTag:1];
            lblDesc.text = self.item[@"description"];
            break;}
        default:
            break;
    }

    return cell;
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
-(UIColor*)colorFromHexString:(NSString*)hex {
    
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

-(void)showSelector {
    [self.navigationController.view addSubview:self.viewSelector];
    [self.viewSelector showInParent:self.view.frame];
}

-(CBStoreItemSelector *)viewSelector {
    if (!_viewSelector) {
        _viewSelector = [[[NSBundle mainBundle] loadNibNamed:@"CBStoreItemSelector"
                                                             owner:self
                                                           options:nil]
                               objectAtIndex:0];
        [_viewSelector setDelegate:self];
    }
    return _viewSelector;
}
@end
