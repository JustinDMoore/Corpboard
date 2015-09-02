//
//  CBPaymentController.h
//  Corpboard
//
//  Created by Justin Moore on 8/26/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stripe.h"

@interface CBPaymentController : UIViewController <STPPaymentCardTextFieldDelegate>
@property(nonatomic) STPPaymentCardTextField *paymentTextField;
@end
