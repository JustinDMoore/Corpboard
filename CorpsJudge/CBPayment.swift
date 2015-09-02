//
//  CBPayment.swift
//  Corpboard
//
//  Created by Justin Moore on 8/31/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

import Foundation
import UIKit
import PassKit

@objc class Payment: NSObject, PKPaymentAuthorizationViewControllerDelegate {
    
    let SUPPORTED_PAYMENT_NETWORKS = [PKPaymentNetworkVisa, PKPaymentNetworkMasterCard, PKPaymentNetworkAmex]
    let MERCHANT_ID = "merchant.com.yea"
    var arrayOfCartItemsToPurchase = [PFObject]()
    var arrayOfPrices = [Double]()
    var senderViewController: UIViewController?
    let paymentPane = PKPaymentAuthorizationViewController()
    var discountAmount = 0.00
    var orderCanShip = false
    var totalPrice = NSDecimalNumber(double: 0.00)
    
    override init () {
        
        
    }
    
    func applePayAccepted() -> Bool {
        return PKPaymentAuthorizationViewController.canMakePayments()
    }
    
    func purchaseItemsWithApplePay(arrayOfCartItems: [PFObject], discount: Double, fromViewController: UIViewController) {
        if (self.applePayAccepted()) {
            senderViewController = fromViewController
            discountAmount = discount
            arrayOfCartItemsToPurchase.removeAll()
            arrayOfCartItemsToPurchase = arrayOfCartItems
            self.calculateTotalForItems()
        } else {
            print("Apple Pay Not Accepted")
        }
    }
    
    func calculateTotalForItems() {
        self.arrayOfPrices.removeAll()
        for (index, item) in enumerate(arrayOfCartItemsToPurchase) {
            let base = item["item"] as! PFObject
            base.fetchIfNeededInBackgroundWithBlock {(result, error) in
                if base == base {
                    //var shipable: Bool?
                    if let shipable: Bool = base["shipable"] as? Bool {
                        self.orderCanShip = true
                    }
                    
                    let price = base["price"] as! Double
                    let qty = item["quantity"] as! Int
                    var total: Double = 0.00
                    if let salePrice = base["salePrice"] as? Double {
                        total = Double(qty) * salePrice
                    } else {
                        total = Double(qty) * price
                    }
                    
                    if let myString: String = item["size"] as? String {
                        let myArray = myString.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "$"))
                        if myArray.count > 1 { //extra charge
                            let extraChargeString: NSString = myArray.last!
                            var extraCharge = (extraChargeString as NSString).doubleValue
                            if extraCharge > 0 {
                                extraCharge = extraCharge * Double(qty)
                                total = total + extraCharge
                            }
                        }
                    }
                    
                    self.arrayOfPrices.append(total)
                    self.checkForTotal()
                }
            }
        }
    }
    
    func checkForTotal() {
        if self.arrayOfPrices.count == self.arrayOfCartItemsToPurchase.count {
            var total: Double = 0.00
            var tax: Double = 0.00
            var shipping: Double = 5.00
            for (index, price) in enumerate(self.arrayOfPrices) {
                let p: Double = Double(price)
                total = total + p
            }
            self.beginApplePayTransaction(subTotal: total, tax: tax, shipping: shipping, discount: discountAmount)
        }
    }
    
    func beginApplePayTransaction(#subTotal: Double, tax: Double, shipping: Double, discount: Double) {
        let request = PKPaymentRequest()
        let applePayController: PKPaymentAuthorizationViewController
        //applePayController.delegate = self;
        request.merchantIdentifier = MERCHANT_ID
        request.supportedNetworks = SUPPORTED_PAYMENT_NETWORKS
        request.merchantCapabilities = PKMerchantCapability.Capability3DS
        request.currencyCode = "USD"
        request.countryCode = "US"
        
        var _subTotal = NSDecimalNumber(double: subTotal)
        var _tax: NSDecimalNumber
        var _shipping: NSDecimalNumber
        var _discount: NSDecimalNumber
        
        var taxItem: PKPaymentSummaryItem
        var shippingItem: PKPaymentSummaryItem
        var discountItem: PKPaymentSummaryItem
        var subTotalItem = PKPaymentSummaryItem(label: "Subtotal", amount: _subTotal)
        
        var arrayOfSummaryItems = [PKPaymentSummaryItem]()
        arrayOfSummaryItems.append(subTotalItem)
        if tax > 0 {
            _tax = NSDecimalNumber(double: tax)
            taxItem = PKPaymentSummaryItem(label: "Tax", amount: _tax)
            arrayOfSummaryItems.append(taxItem)
        }
        if shipping > 0 {
            _shipping = NSDecimalNumber(double: shipping)
            shippingItem = PKPaymentSummaryItem(label: "Shipping", amount: _shipping)
            arrayOfSummaryItems.append(shippingItem)
        }
        if discount != 0 {
            _discount = NSDecimalNumber(double: discount)
            discountItem = PKPaymentSummaryItem(label: "Discount", amount: _discount)
            arrayOfSummaryItems.append(discountItem)
        }
        self.totalPrice = NSDecimalNumber(double: subTotal + tax + shipping + discount)
        let _total = self.totalPrice
        let totalItem = PKPaymentSummaryItem(label: "Yea!", amount: _total)
        arrayOfSummaryItems.append(totalItem)
        
        request.paymentSummaryItems = arrayOfSummaryItems
        
        if self.orderCanShip {
            request.requiredShippingAddressFields = PKAddressField.All
        } else {
            request.requiredShippingAddressFields = PKAddressField.Name | PKAddressField.Phone
        }
    
        applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
        applePayController.delegate = self
        self.senderViewController?.presentViewController(applePayController, animated: true, completion: nil)
    }

    func createShippingAddressFromRef(address: ABRecord!) -> Address {
        var shippingAddress: Address = Address()
        
        shippingAddress.FirstName = ABRecordCopyValue(address, kABPersonFirstNameProperty)?.takeRetainedValue() as? String
        shippingAddress.LastName = ABRecordCopyValue(address, kABPersonLastNameProperty)?.takeRetainedValue() as? String
        
        let addressProperty : ABMultiValueRef = ABRecordCopyValue(address, kABPersonAddressProperty).takeUnretainedValue() as ABMultiValueRef
        if let dict : NSDictionary = ABMultiValueCopyValueAtIndex(addressProperty, 0).takeUnretainedValue() as? NSDictionary {
            shippingAddress.Street = dict[String(kABPersonAddressStreetKey)] as? String
            shippingAddress.City = dict[String(kABPersonAddressCityKey)] as? String
            shippingAddress.State = dict[String(kABPersonAddressStateKey)] as? String
            shippingAddress.Zip = dict[String(kABPersonAddressZIPKey)] as? String
        }
        
        return shippingAddress
    }

}


extension Payment: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController!, didAuthorizePayment payment: PKPayment!, completion: ((PKPaymentAuthorizationStatus) -> Void)!) {
        // 1
        let shippingAddress = self.createShippingAddressFromRef(payment.shippingAddress)
        
        // 2
        Stripe.setDefaultPublishableKey("pk_test_UJ1Jcj6gdlBK5ASXmKWeR7Vf")  // Replace With Your Own Key!
        
        // 3
        STPAPIClient.sharedClient().createTokenWithPayment(payment) {
            (token, error) -> Void in
            
            if (error != nil) {
                println(error)
                completion(PKPaymentAuthorizationStatus.Failure)
                return
            }
            
            // 4
            let shippingAddress = self.createShippingAddressFromRef(payment.shippingAddress)
            
            // 5
            let url = NSURL(string: "http://10.0.1.28:5000/pay")  // Replace with computers local IP Address!
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            // 6
            let body = ["stripeToken": token!.tokenId,
                "amount": self.totalPrice.decimalNumberByMultiplyingBy(NSDecimalNumber(string: "100")),
                "description": "Purchase",
                "shipping": [
                    "city": shippingAddress.City!,
                    "state": shippingAddress.State!,
                    "zip": shippingAddress.Zip!,
                    "firstName": shippingAddress.FirstName!,
                    "lastName": shippingAddress.LastName!]
            ]
            
            var error: NSError?
            request.HTTPBody = NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions(), error: &error)
            
            // 7
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
                if (error != nil) {
                    completion(PKPaymentAuthorizationStatus.Failure)
                } else {
                    completion(PKPaymentAuthorizationStatus.Success)
                }
            }
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(controller: PKPaymentAuthorizationViewController!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController!, didSelectShippingAddress address: ABRecord!, completion: ((PKPaymentAuthorizationStatus, [AnyObject]!, [AnyObject]!) -> Void)!) {
        let shippingAddress = createShippingAddressFromRef(address)
        
        switch (shippingAddress.State, shippingAddress.City, shippingAddress.Zip) {
        case (.Some(let state), .Some(let city), .Some(let zip)):
            completion(PKPaymentAuthorizationStatus.Success, nil, nil)
        default:
            completion(PKPaymentAuthorizationStatus.InvalidShippingPostalAddress, nil, nil)
        }
    }
}