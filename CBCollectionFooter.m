//
//  CBCollectionFooter.m
//  Corpboard
//
//  Created by Justin Moore on 8/26/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBCollectionFooter.h"

@implementation CBCollectionFooter

- (IBAction)enterPromoCode:(id)sender {
    self.enteringPromo = YES;
    self.imgPromo.hidden = YES;
    self.lblPromo.hidden = YES;
    self.txtPromo.hidden = NO;
    self.btnPromo.hidden = NO;
}
@end
