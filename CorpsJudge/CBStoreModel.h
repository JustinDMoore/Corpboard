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
-(void)storeDidFail;
@end

@interface CBStoreModel : NSObject {
    id delegate;
}
typedef enum {
    INCART,
    ORDERED
} itmStatus;
@property (nonatomic) BOOL storeLoaded;
@property (nonatomic) BOOL updatedBanners;
@property (nonatomic) BOOL updatedStoreObjects;
@property (nonatomic) BOOL updatedCategories;
@property (nonatomic) BOOL updatedItemsInCart;
@property (nonatomic, strong) NSMutableArray *arrayOfCategoryObjects;
@property (nonatomic, strong) NSArray *arrayOfBannerObjects;
@property (nonatomic, strong) NSMutableArray *arrayOfStoreObjects;
@property (nonatomic, strong) NSMutableArray *arrayOfNewItems;
@property (nonatomic, strong) NSMutableArray *arrayOfPopularItems;
@property (nonatomic, strong) NSMutableArray *arrayOfItemsInCart;
+(id)storeModel;
-(void)loadStore;
-(void)setDelegate:(id)newDelegate;
-(int)numberOfItemsInCart;
-(UIView *)getStoreTitleView;
-(NSString *)stringFromItemStatus:(itmStatus)status;
@end
