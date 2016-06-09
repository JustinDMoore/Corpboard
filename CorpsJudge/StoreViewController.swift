//
//  StoreViewController.swift
//  CorpBoard
//
//  Created by Justin Moore on 9/3/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

import UIKit
import KVNProgress
import ImageSlideshow

class StoreViewController: UIViewController, StoreProtocol, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var scrollMain: UIScrollView!
    
    let pageOneDoc = UIImageView()
    let pageTwoDoc = UIImageView()
    let pageThreeDoc = UIImageView()
    var itemSelected = PStoreItem()
    var categorySelected = PBanner()
    let CELL_ITEM_IDENTIFIER = "StoreItemCell"
    let CELL_CATEGORY_IDENTIFIER = "CBStoreCategoryCell"
    
    var numOfNewItems = 6
    var newItemScrollWidth = 0
    var newItemContentWidth = 0
    var counter = 0
    var prevIndex = 0, currIndex = 0, nextIndex = 0
    var viewLoading = Loading()
    
    
    @IBOutlet weak var slideBanners: ImageSlideshow!
    // New Items
    @IBOutlet weak var collectionNewItems: UICollectionView!
    @IBOutlet weak var viewNewItems: ClipView!
    
    // Categories
    @IBOutlet weak var viewCategories: ClipView!
    @IBOutlet weak var collectionCategories: UICollectionView!
    
    // Popular Items
    @IBOutlet weak var viewPopularItems: ClipView!
    @IBOutlet weak var collectionPopularItems: UICollectionView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController!.navigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)
        let backBtn = UISingleton.sharedInstance.getBackButton()
        backBtn.addTarget(self, action: #selector(StoreViewController.goBack), forControlEvents: .TouchUpInside)
        let backButton = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backButton
        
        updateCart()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //NAV BAR BACKGROUND
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(named: "stone"), forBarMetrics: .Default)
            navigationBar.shadowImage = UIImage()
            navigationBar.translucent = true
            navigationController?.view.backgroundColor = .blackColor()
            //navigationItem.titleView = Store.sharedInstance.getStoreTitleView()
        }
        
        viewMain.hidden = true
        self.view.backgroundColor = UIColor.blackColor()
        scrollMain.frame = CGRectMake(0, 0, scrollMain.frame.size.width, scrollMain.frame.size.height)
        
        // Register cell classes
        collectionNewItems.registerNib(UINib(nibName: CELL_ITEM_IDENTIFIER, bundle: nil), forCellWithReuseIdentifier: CELL_ITEM_IDENTIFIER)
        collectionPopularItems.registerNib(UINib(nibName: CELL_ITEM_IDENTIFIER, bundle: nil), forCellWithReuseIdentifier: CELL_ITEM_IDENTIFIER)

        
        //collectionNewItems.registerClass(StoreItemCell.self, forCellWithReuseIdentifier: CELL_ITEM_IDENTIFIER)
        collectionCategories.registerClass(CBStoreCategoryCell.self, forCellWithReuseIdentifier: CELL_CATEGORY_IDENTIFIER)
        //collectionPopularItems.registerClass(StoreItemCell.self, forCellWithReuseIdentifier: CELL_ITEM_IDENTIFIER)

        viewLoading = NSBundle.mainBundle().loadNibNamed("Loading", owner: self, options: nil).first as! Loading
        self.view.addSubview(viewLoading)
        viewLoading.center = self.view.center
        viewLoading.animate()
        
        collectionNewItems.backgroundColor = UIColor.blackColor()
        scrollMain.backgroundColor = UIColor.blackColor()
        self.view.backgroundColor = UIColor.blackColor()
        viewNewItems.backgroundColor = UIColor.blackColor()
        collectionCategories.backgroundColor = UIColor.blackColor()
        viewMain.backgroundColor = UIColor.blackColor()
        collectionPopularItems.backgroundColor = UIColor.blackColor()
        
        // banners

        Store.sharedInstance.delegate = self
        
        if !Store.sharedInstance.storeLoaded {
            Store.sharedInstance.loadStore()
        } else {
            initUI()
        }
    }
    
    func goBack() {
        
        viewLoading.removeFromSuperview()
        navigationController?.popViewControllerAnimated(true)
    }
    
    func storeDidLoad() {
        initUI()
    }
    
    func storeDidFail() {
        viewMain.hidden = true
        viewLoading.removeFromSuperview()
        //TODO: add message for error
    }
    
    func initUI() {
        self.automaticallyAdjustsScrollViewInsets = false
        for view in self.view.subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        //banners
        slideBanners.backgroundColor = UIColor.whiteColor()
        slideBanners.slideshowInterval = 5.0
        slideBanners.pageControlPosition = .Hidden
        slideBanners.pageControl.currentPageIndicatorTintColor = UIColor.lightGrayColor();
        slideBanners.pageControl.pageIndicatorTintColor = UIColor.blackColor();
        slideBanners.contentScaleMode = .ScaleToFill
        slideBanners.setImageInputs(Store.sharedInstance.arrayOfBannerImages!)
        
        scrollMain.canCancelContentTouches = true
        scrollMain.delaysContentTouches = true
        scrollMain.userInteractionEnabled = true
        scrollMain.exclusiveTouch = true
        initItems()
        scrollMain.frame = CGRectMake(0, 0, scrollMain.frame.size.width, scrollMain.frame.size.height)
        //scrollMain.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, scrollBanners.frame.size.height + viewNewItems.frame.size.height + viewCategories.frame.size.height + viewPopularItems.frame.size.height + viewPopularItems.frame.size.height + 1000)
        viewLoading.removeFromSuperview()
        viewMain.hidden = false
        
        let reduce = UIScreen.mainScreen().bounds.size.width / 36.6
        
        collectionNewItems.frame = CGRectMake(collectionNewItems.frame.origin.x, collectionNewItems.frame.origin.y, UIScreen.mainScreen().bounds.size.width - reduce, collectionNewItems.frame.size.height)
        
        collectionPopularItems.frame = CGRectMake(collectionPopularItems.frame.origin.x, collectionPopularItems.frame.origin.y, UIScreen.mainScreen().bounds.size.width - reduce, collectionPopularItems.frame.size.height)
        viewMain.frame = CGRectMake(0, 0, viewMain.frame.size.width, viewMain.frame.size.height)
    }
    
    func initItems() {
        collectionNewItems.reloadData()
        collectionCategories.reloadData()
        collectionPopularItems.reloadData()
    }
    
    func updateCart() {
        let cartButton = Store.sharedInstance.cartButton()
        cartButton.addTarget(self, action: #selector(StoreViewController.openCart), forControlEvents: UIControlEvents.TouchUpInside)
        let cartBarButtonItem = UIBarButtonItem(customView: cartButton)
        navigationItem.rightBarButtonItem = cartBarButtonItem
//        if Store.sharedInstance.storeLoaded {
//            navigationItem.rightBarButtonItem?.enabled = true
//        } else {
//            navigationItem.rightBarButtonItem?.enabled = false
//        }
    }
    
    func openCart() {
        self.performSegueWithIdentifier("cart", sender: self)
    }
    
//    func bannerTapped(sender: UIButton) {
//        let bannerObj = Store.sharedInstance.arrayOfBannerObjects[sender.tag]
//        if let link: String = (bannerObj["link"] as? String) {
//            
//        }
//    }
    
    // MARK:
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == scrollMain {
            if scrollView.contentOffset.y < -128 {
                scrollView.contentOffset = CGPointMake(0, -128)
            }
        }
    }
    
    //MARK:
    //MARK: UICollectionView Delegates
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionNewItems {
            if Store.sharedInstance.arrayOfNewItems.count > 10 { return 10 }
            else { return Store.sharedInstance.arrayOfNewItems.count }
        } else if collectionView == collectionCategories {
            if Store.sharedInstance.arrayOfCategoryObjects.count > 0 { return Store.sharedInstance.arrayOfCategoryObjects.count }
            else { return 0 }
        } else if collectionView == collectionPopularItems {
            if Store.sharedInstance.arrayOfPopularItems.count > 10 { return 10 }
            else { return Store.sharedInstance.arrayOfPopularItems.count }
        } else {
            return 0
        }
    }
    
    func getStoreItemCell(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            CELL_ITEM_IDENTIFIER, forIndexPath: indexPath) as! StoreItemCell
        
        let item: PStoreItem
        if collectionView == collectionNewItems {
            item = Store.sharedInstance.arrayOfNewItems[indexPath.row]
        } else {
            item = Store.sharedInstance.arrayOfPopularItems[indexPath.row]
        }

        if let imgFile = item.itemImage {
            cell.imgItem.file = imgFile
            cell.imgItem.loadInBackground()
        } else {
            cell.imgItem.image = UIImage(named: "StoreError")
        }
        let view = cell.viewWithTag(6)!
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.blackColor().CGColor
        view.layer.borderWidth = 0
        view.clipsToBounds = true

        if item.itemSalePrice == 0.00 || item.itemSalePrice.compare(NSDecimalNumber.zero()) == NSComparisonResult.OrderedSame { //no sale
                cell.lblPrice.text = "$\(item.priceString)"
                cell.lblSalePrice.hidden = true
        } else { // there is a sale going on here
            cell.lblSalePrice.hidden = false
            let attributedString = NSMutableAttributedString(string: "$\(item.priceString)")
            attributedString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributedString.length))
            cell.lblPrice.attributedText = attributedString
            cell.lblSalePrice.text = "$\(item.salePriceString)"
        }
        
        cell.clipsToBounds = true
        return cell
    }
    
    
    func getCategoryCellForCollectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = "CBStoreCategoryCell"
        let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
        let imgCategory = cell.viewWithTag(1) as! UIImageView
        let objCategory = Store.sharedInstance.arrayOfCategoryObjects[indexPath.row]
        if let fileCategory = objCategory["image"] as? PFFile {
            fileCategory.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                if error == nil {
                    let image = UIImage(data: data!)
                    imgCategory.image = image
                }
            })
        }
        cell.backgroundColor = UIColor.redColor()
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionNewItems {
            
            return self.getStoreItemCell(collectionView, cellForItemAtIndexPath: indexPath)
            
        } else if collectionView == collectionCategories {
            
            return self.getCategoryCellForCollectionView(collectionView, cellForItemAtIndexPath: indexPath)
            
        } else if collectionView == collectionPopularItems {
            
            return self.getStoreItemCell(collectionView, cellForItemAtIndexPath: indexPath)
            
        }
        let cell = UICollectionViewCell()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if collectionView == collectionNewItems {
            itemSelected = Store.sharedInstance.arrayOfNewItems[indexPath.row]
            self.performSegueWithIdentifier("item", sender: self)
        } else if collectionView == collectionPopularItems {
            itemSelected = Store.sharedInstance.arrayOfPopularItems[indexPath.row]
            self.performSegueWithIdentifier("item", sender: self)
        } else if collectionView == collectionCategories {
            categorySelected = Store.sharedInstance.arrayOfCategoryObjects[indexPath.row]
            self.performSegueWithIdentifier("category", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "item" {
            let vc = segue.destinationViewController as! StoreItemTableViewController
            vc.item = self.itemSelected
            
        } else if segue.identifier == "category" {
            let vc1 = segue.destinationViewController as! StoreCategoryTableViewController
            vc1.category = categorySelected
        }
    }
    
    func cartUpdated() {
        updateCart()
    }
}



































