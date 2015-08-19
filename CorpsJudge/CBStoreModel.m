//
//  CBStoreModel.m
//  Corpboard
//
//  Created by Justin Moore on 8/16/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBStoreModel.h"

@implementation CBStoreModel

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
        self.arrayOfBannerImages = [[NSMutableArray alloc] init];
        self.arrayOfBannerObjects = [[NSMutableArray alloc] init];
        self.arrayOfNewItems = [[NSMutableArray alloc] init];
        self.arrayOfStoreObjects = [[NSMutableArray alloc] init];
        self.updatedStoreObjects = NO;
        self.updatedBanners = NO;
        self.storeLoaded = NO;
    }
    return self;
}

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

-(void)loadStore {
    [self getBannerObjects];
    [self getStoreObjects];
}

-(void)getBannerObjects {
    PFQuery *query = [PFQuery queryWithClassName:@"banners"];
    [query whereKey:@"hidden" equalTo:[NSNumber numberWithBool:NO]];
    [query whereKey:@"type" equalTo:@"STORE"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *obj in objects) {
                PFFile *imageFile = [obj objectForKey:@"image"];
                [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error) {
                        UIImage *image = [UIImage imageWithData:data];
                        [self.arrayOfBannerImages addObject:image];
                        [self.arrayOfBannerObjects addObject:obj];
                        if ([self.arrayOfBannerImages count] == [objects count]) {
                            
                            self.updatedBanners = YES;
                            [self didWeFinish];
                        }
                    }
                }];
            }
        }
    }];
}

-(void)getStoreObjects {
    
    [PFCloud callFunctionInBackground:@"getStoreItems"
                       withParameters:nil
                                block:^(NSArray *results, NSError *error) {
                                    if (!error) {
                                        [self.arrayOfStoreObjects addObjectsFromArray:results];
                                        self.updatedStoreObjects = YES;
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

-(void)didWeFinish {
    if ((self.updatedBanners) && (self.updatedStoreObjects)) {
        [self getNewestItems];
        self.storeLoaded = YES;
        if ([delegate respondsToSelector:@selector(storeDidLoad)]) {

            [delegate storeDidLoad];
        }
    }
}

@end
