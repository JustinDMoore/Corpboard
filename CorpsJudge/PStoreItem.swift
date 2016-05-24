//
//  PStore.swift
//  CorpBoard
//
//  Created by Peggy Moore on 5/24/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit

class PStoreItem: PFObject, PFSubclassing {

    @NSManaged var itemName: String
    @NSManaged var itemDescription: String?
    @NSManaged var itemPrice: NSDecimalNumber
    @NSManaged var itemSalePrice: NSDecimalNumber?
    @NSManaged var itemAvailable: Bool
    @NSManaged var itemSizes: [String]?
    @NSManaged var itemColors: [String]?
    @NSManaged var itemCategory: String
    @NSManaged var itemSubCategory: String
    @NSManaged var itemImage: PFFile?
    @NSManaged var itemPurchaseCount: Int
    @NSManaged var itemShipable: Bool
    @NSManaged var itemNotes: String?
    @NSManaged var school: [String]?
    @NSManaged var year: Int
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Store"
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
