//
//  CBCartCollectionViewController.m
//  Corpboard
//
//  Created by Isaias Favela on 8/21/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBCartCollectionViewController.h"
#import "CBStoreModel.h"


CBStoreModel *store;
BOOL editing;
@interface CBCartCollectionViewController ()
@property (nonatomic, strong) CBCartEditItem *viewEdit;
@end

@implementation CBCartCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    store = [CBStoreModel storeModel];
    [store setDelegate:self];
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
    store = [CBStoreModel storeModel];
    editing = NO;
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

-(void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [store.arrayOfItemsInCart count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CBCartItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    
    PFImageView *imgItem = (PFImageView *)[cell viewWithTag:1];
    UILabel *lblQty = (UILabel *)[cell viewWithTag:2];
    UILabel *lblSize = (UILabel *)[cell viewWithTag:3];
    UILabel *lblColor = (UILabel *)[cell viewWithTag:4];
    UILabel *lblPrice = (UILabel *)[cell viewWithTag:5];
    
    PFObject *item = store.arrayOfItemsInCart[indexPath.row];
    PFObject *itemPointer = item[@"item"];
    [itemPointer fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
    
        if (object) {
            PFFile *imgFile = object[@"image"];
            if (imgFile) {
                [imgItem setFile:imgFile];
                [imgItem loadInBackground];
            } else {
                [imgItem setImage:[UIImage imageNamed:@"StoreError"]];
            }
            NSString *color = item[@"color"];
            NSString *size = item[@"size"];
            NSString *qty = [NSString stringWithFormat:@"%i", [item[@"quantity"] intValue]];
            if ([color length]) lblColor.text = [NSString stringWithFormat:@"Color: %@", color];
            else lblColor.text = @"";
            
            if ([size length]) lblSize.text = [NSString stringWithFormat:@"Size: %@", size];
            else lblSize.text = @"";
            
            if ([qty length]) lblQty.text = [NSString stringWithFormat:@"Qty: %@", qty];
            else lblQty.text = @"";
            
            //calculate price x quantity for item
            
            double itemSalePrice = [itemPointer[@"salePrice"] doubleValue];
            double itemPrice = [itemPointer[@"price"] doubleValue];
            double total = 0;
            if (itemSalePrice > 0) {
                total = itemSalePrice * [item[@"quantity"] intValue];
            } else {
                total = itemPrice * [item[@"quantity"] intValue];
            }
            // we have price x qty.. now check for price increase for size
            NSString *myString = size;
            NSArray *myArray = [myString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"$"]];
            if ([myArray count]) { // charge extra
                double extraCharge = [[myArray lastObject] doubleValue];
                total = total + (extraCharge * [item[@"quantity"] intValue]);
            }
            
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
            NSString *strPrice = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:total]];
            lblPrice.text = strPrice;
        }
    }];

    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!editing) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        CGRect frame = [collectionView convertRect:cell.frame toView:self.view];
        [self.view addSubview:self.viewEdit];
        [self.view bringSubviewToFront:self.viewEdit];
        NSInteger itemsPerRow = 2;
        NSInteger column = indexPath.item % itemsPerRow;
        BOOL right;
        if (column == 0) right = YES;
        else right = NO;
        [self.viewEdit showAtRect:frame animateRight:right];
        editing = YES;
    }
//    PFObject *item = store.arrayOfItemsInCart[indexPath.row];
//    self.viewEdit.lblQty.text = item[@"quantity"];

}

#pragma mark
#pragma mark - Edit Item Protocol
#pragma mark
-(void)incrementQty {
    //increment and update price on item and total
}

-(void)decrementQty {
    //decrement and update price on item and total
}

-(void)itemRemoved {
    //delete item
    //display a message
    //animate it
}

-(void)itemCancelAnimationComplete {
    self.viewEdit = nil;
    editing = NO;
}

-(void)itemCancelAnimationWillStart {
    
}

-(CBCartEditItem *)viewEdit {
    if (!_viewEdit) {
        _viewEdit = [[[NSBundle mainBundle] loadNibNamed:@"CBCartEditItem"
                                                       owner:self
                                                     options:nil]
                         objectAtIndex:0];
        [_viewEdit setDelegate:self];
    }
    return _viewEdit;
}
@end
