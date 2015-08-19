//
//  CBStoreController.m
//  Corpboard
//
//  Created by Justin Moore on 8/16/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBStoreController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "KVNProgress.h"
#import "Configuration.h"
#import "ClipView.h"
#import "CBStoreItemCell.h"
#import "CBStoreCategoryCell.h"

CBStoreModel *store;
UIButton *sbtnBanner1, *sbtnBanner2, *sbtnBanner3;
NSTimer *stimerBanners;

@interface CBStoreController()

@property (nonatomic, strong) IBOutlet UIScrollView *scrollMain;
@property (nonatomic, strong) IBOutlet UIView *contentMainView;

@property (nonatomic, retain) UIImageView *spageOneDoc;
@property (nonatomic, retain) UIImageView *spageTwoDoc;
@property (nonatomic, retain) UIImageView *spageThreeDoc;
@property (nonatomic, strong) IBOutlet UIScrollView *sscrollBanners;
@property (nonatomic) int sprevIndex;
@property (nonatomic) int scurrIndex;
@property (nonatomic) int snextIndex;

#pragma mark
#pragma mark - New Items
#pragma mark
@property (weak, nonatomic) IBOutlet UIButton *btnSeeAllItems;
@property (weak, nonatomic) IBOutlet ClipView *viewNewItems;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionNewItems;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionCategories;
@property (nonatomic, strong) NSMutableArray *arrayOfCategoryImages;
@end

@implementation CBStoreController

static NSString * const CELL_ITEM_IDENTIFIER = @"CBStoreItemCell";
static NSString * const CELL_CATEGORY_IDENTIFIER = @"CBStoreCategoryCell";

-(void)viewWillAppear:(BOOL)animated {
    // title view
    UIView *bgTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110, 25)];
    UIImageView *storeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"storeLogo"]];
    [bgTitleView addSubview:storeImage];
    storeImage.frame = CGRectMake(0, 0, bgTitleView.frame.size.width, bgTitleView.frame.size.height);
    self.navigationItem.titleView = bgTitleView;
    
    // back button
    UIButton *backButton = [[UIButton alloc] init];
    UIImage *imgBack = [UIImage imageNamed:@"arrowLeftMaroon"];
    [backButton setBackgroundImage:imgBack forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButtonBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonBarItem;
    
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayOfCategoryImages = [[NSMutableArray alloc] init];
    [self.arrayOfCategoryImages addObject:[UIImage imageNamed:@"Apparel5"]];
    [self.arrayOfCategoryImages addObject:[UIImage imageNamed:@"Media5"]];
    [self.arrayOfCategoryImages addObject:[UIImage imageNamed:@"Gifts5"]];
    [self.arrayOfCategoryImages addObject:[UIImage imageNamed:@"Instruments5"]];
    [self.arrayOfCategoryImages addObject:[UIImage imageNamed:@"Tickets5"]];
    [self.arrayOfCategoryImages addObject:[UIImage imageNamed:@"More5"]];
    
    // Register cell classes
    [self.collectionNewItems registerClass:[CBStoreItemCell class] forCellWithReuseIdentifier:CELL_ITEM_IDENTIFIER];
    [self.collectionCategories registerClass:[CBStoreCategoryCell class] forCellWithReuseIdentifier:CELL_CATEGORY_IDENTIFIER];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress setConfiguration:[Configuration standardProgressConfig]];
        [KVNProgress show];
    });
    
    store = [CBStoreModel storeModel];
    
    if (!store.storeLoaded) {
        [store loadStore];
    } else {
        [self initUI];
    }
}

-(void)storeDidLoad {
    [self initUI];
}

-(void)initUI {
    
    // new items
    
    UIImageView *seeAllItemsArrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"disclosure"]];
    seeAllItemsArrowImage.frame = CGRectMake(0, 0, 20, 20);
    UITableViewCell *seeAllItemsArrow = [[UITableViewCell alloc] init];
    [self.btnSeeAllItems addSubview:seeAllItemsArrow];
    seeAllItemsArrowImage.frame = CGRectMake(24, 0, self.btnSeeAllItems.frame.size.width, self.btnSeeAllItems.frame.size.height);
    //newsArrow.frame = self.btnSeeAllNews.bounds;
    //newsArrow.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    seeAllItemsArrow.userInteractionEnabled = NO;
    seeAllItemsArrow.accessoryView = seeAllItemsArrowImage;
    self.collectionNewItems.backgroundColor = [UIColor blackColor];
    self.scrollMain.backgroundColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor blackColor];
    self.viewNewItems.backgroundColor = [UIColor blackColor];
    self.collectionCategories.backgroundColor = [UIColor blackColor];
    //banners
    sbtnBanner1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 135)];
    sbtnBanner2 = [[UIButton alloc] initWithFrame:CGRectMake(320, 0, 320, 135)];
    sbtnBanner3 = [[UIButton alloc] initWithFrame:CGRectMake(640, 0, 320, 135)];
    
    [sbtnBanner1 addTarget:self
                   action:@selector(bannerTapped:)
         forControlEvents:UIControlEventTouchUpInside];
    [sbtnBanner2 addTarget:self
                   action:@selector(bannerTapped:)
         forControlEvents:UIControlEventTouchUpInside];
    [sbtnBanner3 addTarget:self
                   action:@selector(bannerTapped:)
         forControlEvents:UIControlEventTouchUpInside];
    
    [self loadPageWithId:(int)[store.arrayOfBannerImages count] - 1 onPage:0];
    [self loadPageWithId:0 onPage:1];
    [self loadPageWithId:1 onPage:2];
    
    [self.sscrollBanners addSubview:sbtnBanner1];
    [self.sscrollBanners addSubview:sbtnBanner2];
    [self.sscrollBanners addSubview:sbtnBanner3];
    
    self.sscrollBanners.contentSize = CGSizeMake(960, 135);
    [self.sscrollBanners scrollRectToVisible:CGRectMake(320,0,320,135) animated:NO];

    [self startTimerForBannerRotation];
    
    // calculate scroll content
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentMainView.backgroundColor = [UIColor blackColor];
    
    //    // for scrollMain content size (per the docs)
    for (UIView *view in [self.contentMainView subviews]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.scrollMain.canCancelContentTouches = YES;
    self.scrollMain.delaysContentTouches = YES;
    self.scrollMain.userInteractionEnabled = YES;
    self.scrollMain.exclusiveTouch = YES;
    
    //self.scrollMain.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, self.scrollMain.contentSize.height);
    
    self.scrollMain.frame = CGRectMake(0, 0, self.scrollMain.frame.size.width, self.scrollMain.frame.size.height);
    
    
    [self initNewItems];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress dismiss];
    });
}

int numOfNewItems = 6;
int newItemScrollWidth = 0;
int newItemContentWidth = 0;

-(void)initNewItems {
    [self.collectionNewItems reloadData];
    [self.collectionCategories reloadData];
}

-(void)goBack {
    [stimerBanners invalidate];
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress dismiss];
    });
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadPageWithId:(int)index onPage:(int)page {
    
    UIButton *btnForBanner;
    
    if ([store.arrayOfBannerImages count]) {
        // load data for page
        switch (page) {
            case 0:
                btnForBanner = sbtnBanner1;
                break;
            case 1:
                btnForBanner = sbtnBanner2;
                break;
            case 2:
                btnForBanner = sbtnBanner3;
                break;
        }
        
        [btnForBanner setBackgroundImage:[store.arrayOfBannerImages objectAtIndex:index] forState:UIControlStateNormal];
        btnForBanner.tag = index;
    }
}

-(void)startTimerForBannerRotation {
    
    stimerBanners = [NSTimer scheduledTimerWithTimeInterval:1
                                                    target:self
                                                  selector:@selector(scrollToNextBanner)
                                                  userInfo:nil
                                                   repeats:YES];
}

-(void)bannerTapped:(UIButton *)sender {
    
    PFObject *bannerObj = store.arrayOfBannerObjects[sender.tag];
    
    if ([bannerObj[@"link"] length]) {
        

    }
}

int scounter = 0;
-(void)scrollToNextBanner {
    
    scounter ++;
    if (scounter == 5) {
        scounter = 0;
        [self.sscrollBanners scrollRectToVisible:CGRectMake(640,0,320,416) animated:YES];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    // We are moving forward. Load the current doc data on the first page.
    [self loadPageWithId:self.scurrIndex onPage:0];
    // Add one to the currentIndex or reset to 0 if we have reached the end.
    self.scurrIndex = (self.scurrIndex >= [store.arrayOfBannerImages count]-1) ? 0 : self.scurrIndex + 1;
    [self loadPageWithId:self.scurrIndex onPage:1];
    // Load content on the last page. This is either from the next item in the array
    // or the first if we have reached the end.
    self.snextIndex = (self.scurrIndex >= [store.arrayOfBannerImages count]-1) ? 0 : self.scurrIndex + 1;
    [self loadPageWithId:self.snextIndex onPage:2];
    
    // Reset offset back to middle page
    [self.sscrollBanners scrollRectToVisible:CGRectMake(320,0,320,416) animated:NO];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView == self.scrollMain) {
        if (scrollView.contentOffset.y < -128) {
            scrollView.contentOffset = CGPointMake(0, -128);
        }
    }
    
    if (scrollView == self.sscrollBanners) {
        // the user scrolled manually, so reset the counter
        scounter = 0;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    
    if (scrollView == self.sscrollBanners) {
        
        // All data for the documents are stored in an array (documentTitles).
        // We keep track of the index that we are scrolling to so that we
        // know what data to load for each page.
        if(scrollView.contentOffset.x > scrollView.frame.size.width) {
            // We are moving forward. Load the current doc data on the first page.
            [self loadPageWithId:self.scurrIndex onPage:0];
            // Add one to the currentIndex or reset to 0 if we have reached the end.
            self.scurrIndex = (self.scurrIndex >= [store.arrayOfBannerImages count]-1) ? 0 : self.scurrIndex + 1;
            [self loadPageWithId:self.scurrIndex onPage:1];
            // Load content on the last page. This is either from the next item in the array
            // or the first if we have reached the end.
            self.snextIndex = (self.scurrIndex >= [store.arrayOfBannerImages count]-1) ? 0 : self.scurrIndex + 1;
            [self loadPageWithId:self.snextIndex onPage:2];
        }
        if(scrollView.contentOffset.x < scrollView.frame.size.width) {
            // We are moving backward. Load the current doc data on the last page.
            [self loadPageWithId:self.scurrIndex onPage:2];
            // Subtract one from the currentIndex or go to the end if we have reached the beginning.
            self.scurrIndex = (self.scurrIndex == 0) ? (int)[store.arrayOfBannerImages count]-1 : self.scurrIndex - 1;
            [self loadPageWithId:self.scurrIndex onPage:1];
            // Load content on the first page. This is either from the prev item in the array
            // or the last if we have reached the beginning.
            self.sprevIndex = (self.scurrIndex == 0) ? (int)[store.arrayOfBannerImages count]-1 : self.scurrIndex - 1;
            [self loadPageWithId:self.sprevIndex onPage:0];
        }
        
        // Reset offset back to middle page
        [scrollView scrollRectToVisible:CGRectMake(320,0,320,416) animated:NO];
    }
}

- (IBAction)seeAllItems:(UIButton *)sender {
}

#pragma mark -
#pragma mark - UICollectionView Delegates
#pragma mark

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView == self.collectionNewItems) {
        int x = 0;
        if ([store.arrayOfNewItems count] > 10) x = 10;
        else x = (int)[store.arrayOfNewItems count];
        
        return x;
        
        if ([store.arrayOfNewItems count] > 10) return 10;
        else return [store.arrayOfNewItems count];
    } else if (collectionView == self.collectionCategories) {
        if ([self.arrayOfCategoryImages count]) return [self.arrayOfCategoryImages count];
        else return 0;
    } else {
        return 0;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.collectionNewItems) {
        
        static NSString *cellIdentifier = @"CBStoreItemCell";
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

        
        PFObject *item = [store.arrayOfNewItems objectAtIndex:indexPath.row];
        
        
        PFImageView *imgItem = (PFImageView *)[cell viewWithTag:1];
        PFFile *imgFile = item[@"image"];
        if (imgFile) {
            [imgItem setFile:imgFile];
            [imgItem loadInBackground];
        } else {
            [imgItem setImage:[UIImage imageNamed:@"StoreError"]];
        }
        UIView *view = (UIView *)[cell viewWithTag:6];
        
        view.layer.cornerRadius = 10;
        view.layer.borderColor = [UIColor blackColor].CGColor;
        view.layer.borderWidth = 0;
        view.clipsToBounds = YES;
        
        UILabel *lblItem = (UILabel *)[cell viewWithTag:2];
        lblItem.text = item[@"item"];
        
        UILabel *lblCategory = (UILabel *)[cell viewWithTag:3];
        lblCategory.text = item[@"category"];
        
        double price = [item[@"price"] doubleValue];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        NSString *priceString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:price]];
        
        UILabel *lblPrice = (UILabel *)[cell viewWithTag:4];
        lblPrice.text = priceString;
        
        cell.clipsToBounds = YES;
        
        return cell;
        
    } else if (collectionView == self.collectionCategories) {
        
        static NSString *cellIdentifier = @"CBStoreCategoryCell";
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

        
        UIImageView *imgCategory = (UIImageView *)[cell viewWithTag:1];
        [imgCategory setImage:(UIImage *)self.arrayOfCategoryImages[indexPath.row]];
        cell.backgroundColor = [UIColor redColor];
        
        cell.layer.cornerRadius = 10;
        cell.clipsToBounds = YES;
        return cell;
    } else {
        return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.collectionNewItems) {
        
        PFObject *itemSelected = [store.arrayOfNewItems objectAtIndex:indexPath.row];
        
        
        // do something with selected item
    
    
    }
}
@end
