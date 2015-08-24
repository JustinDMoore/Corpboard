//
//  CBCartCollectionViewController.m
//  Corpboard
//
//  Created by Isaias Favela on 8/21/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBCartCollectionViewController.h"
#import "CBStoreModel.h"
#import "CBHoleView.h"
#import "UICollectionView+ScrollDelegateBlock.h"

CBStoreModel *store;
NSIndexPath *indexPathOfEdit;
CBHoleView *viewBlock;

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
    self.btnCheckout.layer.borderWidth = 1;
    self.btnCheckout.layer.borderColor = [UIColor blackColor].CGColor;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    viewBlock = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    viewBlock.backgroundColor = [UIColor blackColor];
    viewBlock.alpha = .5;
}

-(void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma mark - UICollectionView Delegates & Datasource
#pragma mark
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [store.arrayOfItemsInCart count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CBCartItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    [self detailsForCell:cell atIndexPath:indexPath];
    if (indexPathOfEdit != indexPath) {
        [cell addSubview:viewBlock];
        viewBlock.frame = cell.frame;
    } else {
        for (UIView *v in [cell subviews]) {
            if (v.tag == 111) [v removeFromSuperview];
        }
    }
    return cell;
}

-(void)detailsForCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    PFImageView *imgItem = (PFImageView *)[cell viewWithTag:1];
    UILabel *lblQty = (UILabel *)[cell viewWithTag:2];
    UILabel *lblSize = (UILabel *)[cell viewWithTag:3];
    UILabel *lblColor = (UILabel *)[cell viewWithTag:4];
    UILabel *lblPrice = (UILabel *)[cell viewWithTag:5];
    UIView *viewFooter = (UIView *)[cell viewWithTag:10];
    viewFooter.backgroundColor = [UIColor colorWithRed:255/2 green:255/2 blue:255/2 alpha:0.5];
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

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView scrollToItemAtIndexPath:indexPath
                           atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                   animated:YES];
    
    BOOL isScrolling = (collectionView.isDragging || collectionView.isDecelerating);
    
    
    if (self.viewEdit.alpha == 0 && !isScrolling) {
        
//        self.collectionView.userInteractionEnabled = NO;
//        self.btnCheckout.userInteractionEnabled = NO;
//        
//        indexPathOfEdit = indexPath;
//        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//        
//        [self.view addSubview:self.viewEdit];
//        NSInteger itemsPerRow = 2;
//        NSInteger column = indexPath.item % itemsPerRow;
//        
//        CGRect startRect = [collectionView convertRect:cell.frame toView:self.view];
//        UICollectionViewCell *endCell;
//        if (column == 0) {
//            endCell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row + 1 inSection:0]];
//        } else {
//            endCell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row - 1 inSection:0]];
//        }
//        CGRect endRect = [collectionView convertRect:endCell.frame toView:self.view];
//        PFObject *item = store.arrayOfItemsInCart[indexPath.row];
//        [self.viewEdit showAtRect:startRect endAtRect:endRect withQty:[item[@"quantity"] intValue]];
//        [self mask:YES forRect:startRect];
//        [self.view bringSubviewToFront:self.viewEdit];
        
    }
}

-(void)mask:(BOOL)yes forRect:(CGRect)maskRect {
    if (yes) {
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        NSArray *transparentRects = [[NSArray alloc] initWithObjects:[NSValue valueWithCGRect:maskRect],  nil];
        viewBlock = [[CBHoleView alloc] initWithFrame:CGRectMake(0,0,200,400) backgroundColor:[UIColor blackColor] andTransparentRects:transparentRects];
        [self.view addSubview:viewBlock];
        viewBlock.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        viewBlock.alpha = .7;
    } else {
        [viewBlock removeFromSuperview];
    }
}

#pragma mark
#pragma mark - Actions
#pragma mark
- (IBAction)beginCheckout:(id)sender {
}

#pragma mark
#pragma mark - Edit Item Protocol
#pragma mark
-(void)newQuantity:(int)newQty {
    PFObject *item = store.arrayOfItemsInCart[indexPathOfEdit.row];
    item[@"quantity"] = [NSNumber numberWithInt:newQty];
    [item saveEventually];
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPathOfEdit];
    [self detailsForCell:cell atIndexPath:indexPathOfEdit];
}

-(void)itemRemoved {
    //delete item
    //display a message
    //animate it
}

-(void)itemCancelAnimationComplete {
   
}

-(void)itemCancelAnimationWillStart {
    self.collectionView.userInteractionEnabled = YES;
    self.btnCheckout.userInteractionEnabled = YES;
    [self mask:NO forRect:CGRectZero];
}

-(CBCartEditItem *)viewEdit {
    if (!_viewEdit) {
        _viewEdit = [[[NSBundle mainBundle] loadNibNamed:@"CBCartEditItem"
                                                       owner:self
                                                     options:nil]
                         objectAtIndex:0];
        [_viewEdit setDelegate:self];
        _viewEdit.alpha = 0;
    }
    return _viewEdit;
}
@end
