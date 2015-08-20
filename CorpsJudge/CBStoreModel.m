//
//  CBStoreModel.m
//  Corpboard
//
//  Created by Justin Moore on 8/16/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBStoreModel.h"

@implementation CBStoreModel

int task = 0;

+(id)storeModel {
    static CBStoreModel *storeModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storeModel = [[self alloc] init];
    });
    return storeModel;
}

-(id)init {
    self = [super init];
    if (self) {
        self.arrayOfBannerObjects = [[NSArray alloc] init];
        self.arrayOfCategoryObjects = [[NSMutableArray alloc] init];
        self.arrayOfNewItems = [[NSMutableArray alloc] init];
        self.arrayOfStoreObjects = [[NSMutableArray alloc] init];
        self.arrayOfPopularItems = [[NSMutableArray alloc] init];
        self.updatedStoreObjects = NO;
        self.updatedBanners = NO;
        self.storeLoaded = NO;
        self.updatedCategories = NO;
        task = 0;
    }
    return self;
}

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

-(void)loadStore {
    [self getStoreCategories];
    [self getBannerObjects];
    [self getStoreObjects];
}

-(void)getBannerObjects {
    [PFCloud callFunctionInBackground:@"getStoreBanners"
                       withParameters:nil
                                block:^(NSArray *results, NSError *error) {
                                    task++;
                                    if (!error) {
                                        if ([results count]) {
                                            self.arrayOfBannerObjects = results;
                                            self.updatedBanners = YES;
                                        }
                                        [self didWeFinish];
                                    }
                                }];
}

-(void)getStoreObjects {
    [PFCloud callFunctionInBackground:@"getStoreObjects"
                       withParameters:nil
                                block:^(NSArray *results, NSError *error) {
                                    task++;
                                    if (!error) {
                                        if ([results count]) {
                                            [self.arrayOfStoreObjects addObjectsFromArray:results];
                                            self.updatedStoreObjects = YES;
                                        }
                                        [self didWeFinish];
                                    }
                                }];
}

-(void)getStoreCategories {
    [PFCloud callFunctionInBackground:@"getStoreCategories"
                       withParameters:nil
                                block:^(NSArray *results, NSError *error) {
                                    task++;
                                    if (!error) {
                                        if ([results count]) {
                                            [self.arrayOfCategoryObjects addObjectsFromArray:results];
                                            self.updatedCategories = YES;
                                        }
                                        [self didWeFinish];
                                    }
                                }];
}

-(void)getNewestItems {
    NSSortDescriptor *sortNewest = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
    NSArray *sortedNewItems = [NSArray arrayWithObject: sortNewest];
    
    if ([self.arrayOfStoreObjects count]) [self.arrayOfStoreObjects sortUsingDescriptors:sortedNewItems];
    
    int max = 10;
    if (max > [self.arrayOfStoreObjects count])
        max = (int)[self.arrayOfStoreObjects count];
    
    for (int x = 0; x < max; x++) {
        PFObject *newItem = self.arrayOfStoreObjects[x];
        [self.arrayOfNewItems addObject:newItem];
    }
}

-(void)getPopularItems {
    NSSortDescriptor *sortPopular = [[NSSortDescriptor alloc] initWithKey:@"purchaseCount" ascending:NO];
    NSArray *sortedPopularItems = [NSArray arrayWithObject: sortPopular];
    
    if ([self.arrayOfStoreObjects count]) [self.arrayOfStoreObjects sortUsingDescriptors:sortedPopularItems];
    
    int max = 10;
    if (max > [self.arrayOfStoreObjects count])
        max = (int)[self.arrayOfStoreObjects count];
    
    for (int x = 0; x < max; x++) {
        PFObject *popularItem = self.arrayOfStoreObjects[x];
        [self.arrayOfPopularItems addObject:popularItem];
    }
}

-(void)didWeFinish {
    if ((self.updatedBanners) && (self.updatedStoreObjects) && (self.updatedCategories)) {
        [self getNewestItems];
        [self getPopularItems];
        self.storeLoaded = YES;
        if ([delegate respondsToSelector:@selector(storeDidLoad)]) {
            [delegate storeDidLoad];
        }
    } else {
        if (task >= 3) {
            if ([delegate respondsToSelector:@selector(storeDidFail)]) {
                [delegate storeDidFail];
            }
        }
    }
}

@end
