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
    func cartUpdated()
}

@objc class Store: NSObject  {
    
    static let _model = Store()
    
    var delegate: StoreProtocol?
    var storeLoaded = false
    var updatedBanners = false
    var updatedStoreObjects = false
    var updatedCategories = false
    var updatedItemsInCart = false
    var arrayOfCategoryObjects = [PBanner]()
    var arrayOfBannerObjects = [PFObject]()
    var arrayOfBannerImages = [UIImage]()
    var arrayOfStoreObjects = [PStoreItem]()
    var arrayOfNewItems = [PStoreItem]()
    var arrayOfPopularItems = [PStoreItem]()
    var arrayOfItemsInCart = [POrder]()
    var task = 0
    
    enum OrderStatus: String {
        case NOTSET = "NOT SET"
        case INCART = "IN CART"
        case ORDERED = "ORDERED"
    }
    
    private override init() {
        storeLoaded = false
        updatedBanners = false
        updatedStoreObjects = false
        updatedCategories = false
        updatedItemsInCart = false
        delegate = nil
    }
    
    static let sharedInstance = Store()
    
    func getStoreTitleView() -> UIView {
        let bgTitleView = UIView(frame: CGRectMake(0, 0, 120, 35))
        let storeImage = UIImageView(image: UIImage(named: "34storeLogo"))
        bgTitleView.addSubview(storeImage)
        storeImage.frame = CGRectMake(0, 0, bgTitleView.frame.size.width, bgTitleView.frame.size.height)
        return bgTitleView
    }
    
    func loadStore() {
        task = 0
        self.getStoreCategories()
        self.getBannerObjects()
        self.getStoreObjects()
        self.getCartObjects()
    }
    
    func numberOfItemsInCart() -> Int {
        if arrayOfItemsInCart.count > 0 {
            var qty = 0
            for (_, itemInCart) in arrayOfItemsInCart.enumerate() {
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
            delegate?.storeDidLoad()
        } else {
            if (task >= 4) {
            delegate?.storeDidFail()
            }
        }
    }
    
    func getPopularItems() {
        if arrayOfStoreObjects.count > 0 {
            arrayOfStoreObjects.sortInPlace({ $0.itemPurchaseCount > $1.itemPurchaseCount })
            var max = 10
            if max > arrayOfStoreObjects.count {
                max = arrayOfStoreObjects.count
            }
            for x in 1...10 {
                let item = arrayOfStoreObjects[x] as PStoreItem
                arrayOfPopularItems.append(item)
            }
        }
    }

    func getNewestItems() {
        if arrayOfStoreObjects.count > 0 {
            arrayOfStoreObjects.sortInPlace({ $0.createdAt!.compare($1.createdAt!) == NSComparisonResult.OrderedAscending })
            var max = 10
            if max > arrayOfStoreObjects.count {
                max = arrayOfStoreObjects.count
            }
            for x in 1...10 {
                let newItem = arrayOfStoreObjects[x] as PStoreItem
                arrayOfNewItems.append(newItem)
            }
        }
    }
    
    func getStoreCategories() {
        arrayOfCategoryObjects = []
        let query = PFQuery(className: PBanner.parseClassName())
        query.whereKey("type", equalTo: "STORECATEGORY")
        query.whereKey("hidden", equalTo: false)
        query.orderByAscending("order")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, err: NSError?) in
            if (err === nil) {
                if let objects = objects as? [PBanner] {
                    if !objects.isEmpty {
                        self.arrayOfCategoryObjects += objects
                        self.updatedCategories = true
                    }
                    self.task += 1
                    self.didWeFinish()
                }
            } else if (err != nil) {
                NSLog("Error: \(err!.userInfo)")
            }
        }
    }
    
    func getStoreObjects() {
        
        arrayOfStoreObjects = []
        let query = PFQuery(className: PStoreItem.parseClassName())
        query.limit = 1000
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, err: NSError?) in
            if (err === nil) {
                if let objects = objects as? [PStoreItem] {
                    if !objects.isEmpty {
                        self.arrayOfStoreObjects += objects
                        self.updatedStoreObjects = true
                    }
                    self.task += 1
                    self.didWeFinish()
                }
            } else if (err != nil) {
                NSLog("Error: \(err!.userInfo)")
            }
        }
    }
    
    func getBannerObjects() {
        
        arrayOfBannerImages = []
        arrayOfBannerObjects = []
        
        let query = PFQuery(className: PBanner.parseClassName())
        query.whereKey("type", equalTo: "STORE")
        query.whereKey("hidden", equalTo: false)
        query.orderByAscending("order")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, err: NSError?) in
            
            if (err === nil) {
                if let objects = objects as? [PBanner] {
                    for (_, banner) in objects.enumerate() {
                        let imageFile = banner.image
                        imageFile.getDataInBackgroundWithBlock({ (data: NSData?, err: NSError?) in
                            if (err === nil) {
                                let image = UIImage(data: data!)
                                self.arrayOfBannerImages.append(image!)
                                self.arrayOfBannerObjects.append(banner)
                                if self.arrayOfBannerImages.count == objects.count {
                                    self.updatedBanners = true
                                    self.task += 1
                                    self.didWeFinish()
                                }
                            }
                        })
                    }
                }
            } else if (err != nil) {
                NSLog("Error: \(err!.userInfo)")
            }
        }
    }
    
    
    func getCartObjects() {
        
        let query = PFQuery(className: POrder.parseClassName())
        query.whereKey("status", equalTo: "\(OrderStatus.INCART)")
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, err: NSError?) in
            if (err === nil) {
                if let results = objects as? [POrder] {
                    if !results.isEmpty {
                        self.arrayOfItemsInCart += results
                    }
                    self.delegate?.cartUpdated()
                    self.task += 1
                    self.updatedItemsInCart = true
                    self.didWeFinish()
                }
            } else if (err != nil) {
                NSLog("Error: \(err!.userInfo)")
            }
        }
    }
    
    func cartButton() -> UIButton {
        let cartButton = UIButton()
        var num = numberOfItemsInCart()
        if num > 20 { num = 21 }
        let imgCart = UIImage(named: "cart\(num)")
        cartButton.setBackgroundImage(imgCart, forState: UIControlState.Normal)
        cartButton.frame = CGRectMake(0, 0, 30, 30)
        return cartButton
    }
}