//
//  Store.swift
//  Corpboard
//
//  Created by Justin Moore on 9/2/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

import Foundation

protocol StoreProtocol {
    func storeDidLoad()
    func storeDidFail()
}

@objc class Store: NSObject  {
    
    static let _model = Store()
    
    var delegate: StoreProtocol?
    var storeLoaded = false
    var updatedBanners = false
    var updatedStoreObjects = false
    var updatedCategories = false
    var updatedItemsInCart = false
    var arrayOfCategoryObjects = [PFObject]()
    var arrayOfBannerObjects = [PFObject]()
    var arrayOfStoreObjects = [StoreItem]()
    var arrayOfNewItems = [StoreItem]()
    var arrayOfPopularItems = [StoreItem]()
    var arrayOfItemsInCart = [PFObject]()
    var task = 0
    
    @objc enum Status: Int {
        case NOTSET
        case INCART
        case ORDERED
    }
    
    class func string(status: Status) -> String {
        switch status {
        case .NOTSET: return "NOT SET"
        case .INCART: return "IN CART"
        case .ORDERED: return "ORDERED"
        }
    }
    
    private override init() {
        storeLoaded = false
        updatedBanners = false
        updatedStoreObjects = false
        updatedCategories = false
        updatedItemsInCart = false
        delegate = nil
    }
    
    class func model() -> Store {
        return Store._model
    }
    
    func getStoreTitleView() -> UIView {
        let bgTitleView = UIView(frame: CGRectMake(0, 0, 120, 35))
        let storeImage = UIImageView(image: UIImage(named: "34storeLogo"))
        bgTitleView.addSubview(storeImage)
        storeImage.frame = CGRectMake(0, 0, bgTitleView.frame.size.width, bgTitleView.frame.size.height)
        return bgTitleView
    }
    
    func loadStore() {
        self.getStoreCategories()
        self.getBannerObjects()
        self.getStoreObjects()
        self.getCartObjects()
    }
    
    func numberOfItemsInCart() -> Int {
        if arrayOfItemsInCart.count > 0 {
            var qty = 0
            for (index, itemInCart) in enumerate(arrayOfItemsInCart) {
                if let q = itemInCart["quantity"] as? Int {
                    qty = qty + q
                }
            }
            return qty
        } else {
            return 0
        }
    }

    func didWeFinish() {
        if updatedBanners && updatedStoreObjects && updatedCategories && updatedItemsInCart {
            self.getNewestItems()
            self.getPopularItems()
            self.storeLoaded = true
            if let del = self.delegate {
                del.storeDidLoad()
            }
        } else {
            if (task >= 4) {
                 if let del = self.delegate {
                    del.storeDidFail()
                }
            }
        }
    }
    
    func getPopularItems() {
        if arrayOfStoreObjects.count > 0 {
            arrayOfStoreObjects.sort({ $0.itemPurchaseCount > $1.itemPurchaseCount })
            var max = 10
            if max > arrayOfStoreObjects.count {
                max = arrayOfStoreObjects.count
            }
            for var x = 0; x < max; x++ {
                var item = arrayOfStoreObjects[x] as StoreItem
                arrayOfPopularItems.append(item)
            }
        }
    }

    func getNewestItems() {
        if arrayOfStoreObjects.count > 0 {
            arrayOfStoreObjects.sort({ $0.createdAt!.compare($1.createdAt!) == NSComparisonResult.OrderedAscending })
            var max = 10
            if max > arrayOfStoreObjects.count {
                max = arrayOfStoreObjects.count
            }
            for var x = 0; x < max; x++ {
                var newItem = arrayOfStoreObjects[x] as StoreItem
                arrayOfNewItems.append(newItem)
            }
        }
    }
    
    func getStoreCategories() {
        PFCloud.callFunctionInBackground("getStoreCategories", withParameters: nil) { (results: NSArray?, error: NSError?) -> Void in
            
        }
        PFCloud.callFunctionInBackground("getStoreCategories", withParameters: nil, target: self, selector: Selector("blockCategories:error:"))
        func blockCategories(results: NSArray!, error: NSError!) {
            if (error === nil) {
                if let swiftResults = results as NSArray as? [PFObject] {
                    if !swiftResults.isEmpty {
                        arrayOfCategoryObjects += swiftResults
                        updatedCategories = true
                    }
                    task++
                    self.didWeFinish()
                }
            }
            else if (error != nil) {
                NSLog("Error: \(error.userInfo)")
            }
        }
    }
    
    func getStoreObjects() {
        PFCloud.callFunctionInBackground("getStoreObjects", withParameters: nil, target: self, selector: Selector("blockStore:error:"))
        func blockStore(results: NSArray!, error: NSError!) {
            if (error === nil) {
                if let swiftResults = results as NSArray as? [PFObject] {
                    if !swiftResults.isEmpty {
                        for (index, item) in enumerate(results) {
                            var storeItem = StoreItem()
                            arrayOfStoreObjects.append(storeItem)
                        }
                        updatedStoreObjects = true
                    }
                    task++
                    self.didWeFinish()
                }
            }
            else if (error != nil) {
                NSLog("Error: \(error.userInfo)")
            }
        }
    }
    
    func getBannerObjects() {
        PFCloud.callFunctionInBackground("getStoreBanners", withParameters: nil, target: self, selector: Selector("blockBanners:error:"))
        func blockBanners(results: NSArray!, error: NSError!) {
            if (error === nil) {
                if let swiftResults = results as NSArray as? [PFObject] {
                    if !swiftResults.isEmpty {
                        arrayOfBannerObjects += swiftResults
                        updatedBanners = true
                    }
                    task++
                    self.didWeFinish()
                }
            }
            else if (error != nil) {
                NSLog("Error: \(error.userInfo)")
            }
        }
    }
    
    
    func getCartObjects() {
        PFCloud.callFunctionInBackground("getItemsInCart", withParameters: nil, target: self, selector: Selector("blockCart:error:"))
        func blockCart(results: NSArray!, error: NSError!) {
            if (error === nil) {
                if let swiftResults = results as NSArray as? [PFObject] {
                    if !swiftResults.isEmpty {
                        arrayOfItemsInCart += swiftResults
                        updatedItemsInCart = true
                    }
                    task++
                    self.didWeFinish()
                }
            }
            else if (error != nil) {
                NSLog("Error: \(error.userInfo)")
            }
        }
    }
}