//
//  CBCartItemCell.h
//  Corpboard
//
//  Created by Isaias Favela on 8/21/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface CBCartItemCell : UICollectionViewCell
@property (nonatomic, strong) IBOutlet PFImageView *imgItem;
@property (nonatomic, strong) IBOutlet UILabel *lblQty;
@property (nonatomic, strong) IBOutlet UILabel *lblSize;
@property (nonatomic, strong) IBOutlet UILabel *lblColor;
@property (nonatomic, strong) IBOutlet UILabel *lblPrice; //needs to include extras like 2X+$10.00
@property (nonatomic, strong) IBOutlet UILabel *lblSalePrice;
@end
