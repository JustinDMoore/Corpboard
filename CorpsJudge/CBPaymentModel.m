////
////  CBPaymentModel.m
////  Corpboard
////
////  Created by Justin Moore on 8/27/15.
////  Copyright (c) 2015 Justin Moore. All rights reserved.
////
//
//#import "CBPaymentModel.h"
//
//NSString *const MERCHANT_ID = @"merchant.com.yea";
//NSMutableArray *arrayOfCartItemsToPurchase;
//NSMutableArray *arrayOfPrices;
//UIViewController *senderViewController;
//PKPaymentAuthorizationViewController *paymentPane;
//BOOL orderCanShip;
//
//
//
//double discountAmount;
//@implementation CBPaymentModel
//
////+(id)paymentModel {
////    static CBPaymentModel *paymentModel = nil;
////    static dispatch_once_t onceToken;
////    dispatch_once(&onceToken, ^{
////        paymentModel = [[self alloc] init];
////    });
////    return paymentModel;
////}
////
////-(id)init {
////    self = [super init];
////    if (self) {
////        arrayOfCartItemsToPurchase = [[NSMutableArray alloc] init];
////        arrayOfPrices = [[NSMutableArray alloc] init];
////    }
////    return self;
////}
////
////-(BOOL)applePayAccepted {
////    return [PKPaymentAuthorizationViewController canMakePayments];
////}
////
////
////
//////1. Must add to cart before processing
//////2. Array of PFObjects need to be cart objects, not raw items
////-(void)purchaseItemsWithApplePay:(NSMutableArray *)arrayOfCartItems withDiscount:(double)discount fromViewController:(UIViewController *)senderController {
////    if ([self applePayAccepted]) {
////        senderViewController = senderController;
////        discountAmount = discount;
////        [arrayOfCartItemsToPurchase removeAllObjects];
////        arrayOfCartItemsToPurchase = arrayOfCartItems;
////        [self calculateTotalForItems];
////    } else {
////        NSLog(@"APPLE PAY NOT SUPPORTED");
////    }
////}
////
////
//////double final;
////-(void)calculateTotalForItems {
////    
////    //calculates total price for all items
////    
////    //also checks to see if any item is shipable, which requires a shipping address
////    
////    [arrayOfPrices removeAllObjects];
////    for (PFObject *item in arrayOfCartItemsToPurchase) {
////        PFObject *base = item[@"item"];
////        [base fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
////            BOOL shipable = [base[@"shipable"] boolValue];
////            if (shipable) orderCanShip = YES;
////            double salePrice = [base[@"salePrice"] doubleValue];
////            double price = [base[@"price"] doubleValue];
////            int qty = [item[@"quantity"] intValue];
////            double total = 0;
////            if (salePrice > 0) {
////                total = qty * salePrice;
////            } else {
////                total = qty * price;
////            }
////            
////            
////            NSString *myString = item[@"size"];
////            NSArray *myArray = [myString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"$"]];
////            if ([myArray count] > 1) { // charge extra
////                double extraCharge = [[myArray lastObject] doubleValue];
////                if (extraCharge > 0) {
////                    extraCharge = extraCharge * qty;
////                    total = total + extraCharge;
////                }
////            }
////            
////            [arrayOfPrices addObject:[NSNumber numberWithDouble:total]];
////            [self checkForTotal];
////        }];
////    }
////}
////
////-(void)checkForTotal {
////    if ([arrayOfPrices count] == [arrayOfCartItemsToPurchase count]) {
////        double total = 0.00;
////        double tax = 0.00;
////        double shipping = 5.00;
////        for (NSNumber *price in arrayOfPrices) {
////            double p = [price doubleValue];
////            total += p;
////        }
////        [self beginApplePayTransactionWithSubTotal:total
////                                               tax:tax
////                                          shipping:shipping
////                                          discount:discountAmount];
////    }
////}
////
////-(void)beginApplePayTransactionWithSubTotal:(double)subTotal tax:(double)tax shipping:(double)shipping discount:(double)discount {
////    PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
////    request.countryCode = @"US";
////    request.currencyCode = @"USD";
////    request.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
////    request.merchantCapabilities = PKMerchantCapability3DS;
////    request.merchantIdentifier = MERCHANT_ID;
////    
////    NSDecimalNumber *_subTotal = [[NSDecimalNumber alloc] initWithDouble:subTotal];
////    
////    NSDecimalNumber *_tax;
////    PKPaymentSummaryItem *taxItem;
////    
////    NSDecimalNumber *_shipping;
////    PKPaymentSummaryItem *shippingItem;
////    
////    NSDecimalNumber *_discount;
////    PKPaymentSummaryItem *discountItem;
////    
////    PKPaymentSummaryItem *subTotalItem = [PKPaymentSummaryItem summaryItemWithLabel:@"Subtotal" amount:_subTotal];
////    
////    NSMutableArray *arrayOfSummaryItems = [[NSMutableArray alloc] init];
////    
////    [arrayOfSummaryItems addObject:subTotalItem];
////    
////    if (tax) {
////        _tax = [[NSDecimalNumber alloc] initWithDouble:tax];
////        taxItem = [PKPaymentSummaryItem summaryItemWithLabel:@"Tax" amount:_tax];
////        [arrayOfSummaryItems addObject:taxItem];
////    }
////    
////    if (shipping) {
////        _shipping = [[NSDecimalNumber alloc] initWithDouble:shipping];
////        shippingItem = [PKPaymentSummaryItem summaryItemWithLabel:@"Shipping" amount:_shipping];
////        [arrayOfSummaryItems addObject:shippingItem];
////    }
////    
////    if (discount != 0) {
////        _discount = [[NSDecimalNumber alloc] initWithDouble:discount];
////        discountItem = [PKPaymentSummaryItem summaryItemWithLabel:@"Discount" amount:_discount];
////        [arrayOfSummaryItems addObject:discountItem];
////    }
////    
////    double final = subTotal + tax + shipping + discount;
////    NSDecimalNumber *_total = [[NSDecimalNumber alloc] initWithDouble:final];
////    PKPaymentSummaryItem *totalItem = [PKPaymentSummaryItem summaryItemWithLabel:@"Yea!" amount:_total];
////    [arrayOfSummaryItems addObject:totalItem];
////    
////    request.paymentSummaryItems = arrayOfSummaryItems;
////    
////    if (orderCanShip) {
////        request.requiredShippingAddressFields = PKAddressFieldAll;
////    } else {
////        request.requiredShippingAddressFields = PKAddressFieldName | PKAddressFieldPhone;
////    }
////    
////    paymentPane = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
////    paymentPane.delegate = self;
////    [senderViewController presentViewController:paymentPane animated:TRUE completion:nil];
////}
////
////-(void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
////    [paymentPane dismissViewControllerAnimated:YES
////                                    completion:nil];
////}
////
////-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion {
//////    NSError *error;
//////    ABMultiValueRef addressMultiValue = ABRecordCopyValue(payment.billingAddress, kABPersonAddressProperty);
//////    NSDictionary *addressDictionary = (__bridge_transfer NSDictionary *) ABMultiValueCopyValueAtIndex(addressMultiValue, 0);
//////    NSData *json = [NSJSONSerialization dataWithJSONObject:addressDictionary options:NSJSONWritingPrettyPrinted error: &error];
//////    
//////    // ... Send payment token, shipping and billing address, and order information to your server ...
//////    
//////    PKPaymentAuthorizationStatus status;  // From your server
//////    completion(status);
////}
////
////-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectShippingAddress:(ABRecordRef)address completion:(void (^)(PKPaymentAuthorizationStatus, NSArray *, NSArray *))completion {
////    //self.selectedShippingAddress = address;
////    //[self updateShippingCost];
////    //NSArray *shippingMethods = [self shippingMethodsForAddress:address];
////    //completion(PKPaymentAuthorizationStatusSuccess, shippingMethods, self.summaryItems);
////    
////}
////
////-(CBAddress *)createShippingAddressFromRef:(ABRecordRef *)address {
////    CBAddress *shippingAddress = [[CBAddress alloc] init];
////    //shippingAddress.firstName = ABRecordCopyValue(address, address.f)
////}
////
//////func createShippingAddressFromRef(address: ABRecord!) -> Address {
//////    var shippingAddress: Address = Address()
//////    
//////    shippingAddress.FirstName = ABRecordCopyValue(address, kABPersonFirstNameProperty)?.takeRetainedValue() as? String
//////    shippingAddress.LastName = ABRecordCopyValue(address, kABPersonLastNameProperty)?.takeRetainedValue() as? String
//////    
//////    let addressProperty : ABMultiValueRef = ABRecordCopyValue(address, kABPersonAddressProperty).takeUnretainedValue() as ABMultiValueRef
//////    if let dict : NSDictionary = ABMultiValueCopyValueAtIndex(addressProperty, 0).takeUnretainedValue() as? NSDictionary {
//////        shippingAddress.Street = dict[String(kABPersonAddressStreetKey)] as? String
//////        shippingAddress.City = dict[String(kABPersonAddressCityKey)] as? String
//////        shippingAddress.State = dict[String(kABPersonAddressStateKey)] as? String
//////        shippingAddress.Zip = dict[String(kABPersonAddressZIPKey)] as? String
//////    }
//////    
//////    return shippingAddress
//////}
//@end
