//
//  CBPickFavorite.h
//  Corpboard
//
//  Created by Justin Moore on 5/26/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CBShowPickFavoriteProtocol <NSObject>
@required
-(void)favoritePicked;
@end

@interface CBPickFavorite : UIView {
    id delegate;
}

@property (nonatomic, strong) IBOutlet UILabel *lblHeader;
@property (nonatomic, strong) IBOutlet UITableView *tableCorps;

-(void)setDelegate:(id)newDelegate;
-(void)showInParent:(NSString *)header;

@end
