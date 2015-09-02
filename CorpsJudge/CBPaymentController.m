//
//  CBPaymentController.m
//  Corpboard
//
//  Created by Justin Moore on 8/26/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBPaymentController.h"

@interface CBPaymentController ()

@end

@implementation CBPaymentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.paymentTextField = [[STPPaymentCardTextField alloc] initWithFrame:CGRectMake(15, 15, CGRectGetWidth(self.view.frame) - 30, 44)];;
    self.paymentTextField.delegate = self;
    [self.view addSubview:self.paymentTextField];
}

- (void)paymentCardTextFieldDidChange:(STPPaymentCardTextField *)textField {
    
        // Toggle navigation, for example
        
    }

@end
