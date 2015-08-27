//
//  CBCollectionFooter.h
//  Corpboard
//
//  Created by Justin Moore on 8/26/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBCollectionFooter : UICollectionReusableView
@property (nonatomic, strong) IBOutlet UILabel *lblPriceMerch;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceShipping;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceTax;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceSavings;
@property (weak, nonatomic) IBOutlet UILabel *lblPromo;
@property (weak, nonatomic) IBOutlet UITextField *txtPromo;
@property (weak, nonatomic) IBOutlet UIImageView *imgPromo;
@property (weak, nonatomic) IBOutlet UIButton *btnPromo;
@property (nonatomic) BOOL enteringPromo;
- (IBAction)enterPromoCode:(id)sender;

@end
