//
//  CBStoreModel.m
//  Corpboard
//
//  Created by Justin Moore on 8/16/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBStoreModel.h"


@implementation CBStoreModel

//int task = 0;
//
//+(id)storeModel {
//    static CBStoreModel *storeModel = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        storeModel = [[self alloc] init];
//    });
//    return storeModel;
//}
//
//-(id)init {
//    self = [super init];
//    if (self) {
//        self.arrayOfBannerObjects = [[NSArray alloc] init];
//        self.arrayOfCategoryObjects = [[NSMutableArray alloc] init];
//        self.arrayOfNewItems = [[NSMutableArray alloc] init];
//        self.arrayOfStoreObjects = [[NSMutableArray alloc] init];
//        self.arrayOfPopularItems = [[NSMutableArray alloc] init];
//        self.arrayOfItemsInCart = [[NSMutableArray alloc] init];
//        self.updatedItemsInCart = NO;
//        self.updatedStoreObjects = NO;
//        self.updatedBanners = NO;
//        self.storeLoaded = NO;
//        self.updatedCategories = NO;
//        task = 0;
//    }
//    return self;
//}
//
//-(void)setDelegate:(id)newDelegate{
//    delegate = newDelegate;
//}
//
//-(void)loadStore {
//    [self getStoreCategories];
//    [self getBannerObjects];
//    [self getStoreObjects];
//    [self getCartObjects];
////    [self change];
//}
//
////-(void)change {
////    PFQuery *query = [PFQuery queryWithClassName:@"Store"];
////    [query setLimit:1000];
////    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
////        
////        for (PFObject *item in objects) {
////            //item[@"itemName"] = item[@"item"];
////            
////            //NSString *str = item[@"description"];
////            //[item setObject:str forKey:@"itemDescription"];
//////            item[@"itemPrice"] = item[@"price"];
//////            item[@"itemSalePrice"] = item[@"salePrice"];
//////            item[@"itemAvailable"] = item[@"available"];
//////            item[@"itemSizes"] = item[@"sizes"];
//////            item[@"itemColors"] = item[@"colors"];
//////            item[@"itemCategory"] = item[@"category"];
//////            item[@"itemSubCategory"] = item[@"subCategory"];
//////            item[@"itemImage"] = item[@"image"];
////            NSNumber *purchase = item[@"purchaseCount"];
////            if (purchase) {
////                [item setObject:item[@"purchaseCount"] forKey:@"itemPurchaseCount"];
////            }
////            [item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
////                NSLog(@"saved %lu", [objects indexOfObject:item]);
////            }];
////            //if ([item saveInBackground]) NSLog(@"saved %li", [objects indexOfObject:item]);
////        }
////    }];
////}
//
//-(void)getCartObjects {
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    [dict setObject:[PFUser currentUser].objectId forKey:@"user"];
//    [PFCloud callFunctionInBackground:@"getItemsInCart"
//                       withParameters:dict
//                                block:^(NSArray *results, NSError *error) {
//                                    task++;
//                                    if (!error) {
//                                        if ([results count]) {
//                                            [self.arrayOfItemsInCart addObjectsFromArray:results];
//                                        }
//                                        self.updatedItemsInCart = YES;
//                                        [self didWeFinish];
//                                    }
//                                }];
//}
//
//-(void)getBannerObjects {
//    [PFCloud callFunctionInBackground:@"getStoreBanners"
//                       withParameters:nil
//                                block:^(NSArray *results, NSError *error) {
//                                    task++;
//                                    if (!error) {
//                                        if ([results count]) {
//                                            self.arrayOfBannerObjects = results;
//                                            self.updatedBanners = YES;
//                                        }
//                                        [self didWeFinish];
//                                    }
//                                }];
//}
//
//-(void)getStoreObjects {
//    [PFCloud callFunctionInBackground:@"getStoreObjects"
//                       withParameters:nil
//                                block:^(NSArray *results, NSError *error) {
//                                    task++;
//                                    if (!error) {
//                                        if ([results count]) {
//                                            for (PFObject *object in results) {
//                                                StoreItem *item = [[StoreItem alloc] init];
//                                                item = (PFObject *)object;
//                                                [self.arrayOfStoreObjects addObject:item];
//                                            }
//                                            //[self.arrayOfStoreObjects addObjectsFromArray:results];
//                                            self.updatedStoreObjects = YES;
//                                        }
//                                        [self didWeFinish];
//                                    }
//                                }];
//}
//
//-(void)getStoreCategories {
//    [PFCloud callFunctionInBackground:@"getStoreCategories"
//                       withParameters:nil
//                                block:^(NSArray *results, NSError *error) {
//                                    task++;
//                                    if (!error) {
//                                        if ([results count]) {
//                                            [self.arrayOfCategoryObjects addObjectsFromArray:results];
//                                            self.updatedCategories = YES;
//                                        }
//                                        [self didWeFinish];
//                                    }
//                                }];
//}
//
//
//
//
//
//
//
////below done
//
//-(void)getNewestItems {
//    NSSortDescriptor *sortNewest = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
//    NSArray *sortedNewItems = [NSArray arrayWithObject: sortNewest];
//    
//    if ([self.arrayOfStoreObjects count]) [self.arrayOfStoreObjects sortUsingDescriptors:sortedNewItems];
//    
//    int max = 10;
//    if (max > [self.arrayOfStoreObjects count])
//        max = (int)[self.arrayOfStoreObjects count];
//    
//    for (int x = 0; x < max; x++) {
//        PFObject *newItem = self.arrayOfStoreObjects[x];
//        [self.arrayOfNewItems addObject:newItem];
//    }
//}
//
//-(void)getPopularItems {
//    NSSortDescriptor *sortPopular = [[NSSortDescriptor alloc] initWithKey:@"itemPurchaseCount" ascending:NO];
//    NSArray *sortedPopularItems = [NSArray arrayWithObject: sortPopular];
//    
//    if ([self.arrayOfStoreObjects count]) [self.arrayOfStoreObjects sortUsingDescriptors:sortedPopularItems];
//    
//    int max = 10;
//    if (max > [self.arrayOfStoreObjects count])
//        max = (int)[self.arrayOfStoreObjects count];
//    
//    for (int x = 0; x < max; x++) {
//        PFObject *popularItem = self.arrayOfStoreObjects[x];
//        [self.arrayOfPopularItems addObject:popularItem];
//    }
//}
//
//-(void)didWeFinish {
//    if ((self.updatedBanners) && (self.updatedStoreObjects) && (self.updatedCategories) && (self.updatedItemsInCart)) {
//        [self getNewestItems];
//        [self getPopularItems];
//        self.storeLoaded = YES;
//        if ([delegate respondsToSelector:@selector(storeDidLoad)]) {
//            [delegate storeDidLoad];
//        }
//    } else {
//        if (task >= 4) {
//            if ([delegate respondsToSelector:@selector(storeDidFail)]) {
//                [delegate storeDidFail];
//            }
//        }
//    }
//}
//
//-(UIView *)getStoreTitleView {
//    UIView *bgTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 35)];
//    UIImageView *storeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"34storeLogo"]];
//    [bgTitleView addSubview:storeImage];
//    storeImage.frame = CGRectMake(0, 0, bgTitleView.frame.size.width, bgTitleView.frame.size.height);
//    return bgTitleView;
//}
//
//-(int)numberOfItemsInCart {
//    if (![self.arrayOfItemsInCart count]) return 0;
//    else {
//        int qty = 0;
//        for (PFObject *itemInCart in self.arrayOfItemsInCart) {
//            qty = qty + [itemInCart[@"quantity"] intValue];
//        }
//        return qty;
//    }
//}
//
//
//-(NSString *)stringFromItemStatus:(itmStatus)status {
//    switch ((int)status) {
//        case INCART: return @"CART";
//            break;
//        case ORDERED: return @"ORDERED";
//            break;
//    }
//    return @"ERROR";
//}

@end
