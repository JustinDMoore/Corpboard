//
//  CBStoreModel.h
//  Corpboard
//
//  Created by Justin Moore on 8/16/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@protocol storeProtocol <NSObject>
@required
-(void)storeDidLoad;
@end

@interface CBStoreModel : NSObject {
    id delegate;
}

@property (nonatomic) BOOL storeLoaded;
@property (nonatomic, strong) NSMutableArray *arrayOfBannerImages;
@property (nonatomic, strong) NSMutableArray *arrayOfBannerObjects;
@property (nonatomic) BOOL updatedBanners;
@property (nonatomic) BOOL updatedStoreObjects;
@property (nonatomic, strong) NSMutableArray *arrayOfStoreObjects;
@property (nonatomic, strong) NSMutableArray *arrayOfNewItems;

+(id)storeModel;
-(void)loadStore;
-(void)setDelegate:(id)newDelegate;

@end
