//
//  StoreItem.swift
//  CorpBoard
//
//  Created by Justin Moore on 9/2/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

import Foundation

@objc class StoreItem : PFObject, PFSubclassing {
    
    
    @NSManaged var itemName: String
    @NSManaged var itemDescription: String?
    @NSManaged var itemPrice: NSDecimalNumber
    @NSManaged var itemSalePrice: NSDecimalNumber?
    @NSManaged var itemAvailable: Boolean
    @NSManaged var itemSizes: [String]?
    @NSManaged var itemColors: [String]?
    @NSManaged var itemCategory: String
    @NSManaged var itemSubCategory: String
    @NSManaged var itemImage: PFFile?
    @NSManaged var itemPurchaseCount: Int
    @NSManaged var itemShipable: Bool
    @NSManaged var itemCreated: NSDate

    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "StoreItem"
    }
    
    var priceString: String {
        let dollarFormatter: NSNumberFormatter = NSNumberFormatter()
        dollarFormatter.minimumFractionDigits = 2;
        dollarFormatter.maximumFractionDigits = 2;
        return dollarFormatter.stringFromNumber(itemPrice)!
    }
    
    var salePriceString: String {
        let dollarFormatter: NSNumberFormatter = NSNumberFormatter()
        dollarFormatter.minimumFractionDigits = 2;
        dollarFormatter.maximumFractionDigits = 2;
        return dollarFormatter.stringFromNumber(itemSalePrice!)!
    }
}