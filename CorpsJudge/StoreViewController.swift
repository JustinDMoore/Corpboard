//
//  StoreViewController.swift
//  CorpBoard
//
//  Created by Justin Moore on 9/3/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

import UIKit

class StoreViewController: UIViewController, StoreProtocol, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var scrollMain: UIScrollView!
    @IBOutlet weak var scrollBanners: UIScrollView!
    
    let pageOneDoc = UIImageView()
    let pageTwoDoc = UIImageView()
    let pageThreeDoc = UIImageView()
    var itemSelected = StoreItem()
    let btnBanner1 = UIButton(frame: CGRectMake(0, 0, 320, 135))
    let btnBanner2 = UIButton(frame: CGRectMake(320, 0, 320, 135))
    let btnBanner3 = UIButton(frame: CGRectMake(640, 0, 320, 135))
    var timerBanners = NSTimer()
    let CELL_ITEM_IDENTIFIER = "CBStoreItemCell"
    let CELL_CATEGORY_IDENTIFIER = "CBStoreCategoryCell"
    
    var numOfNewItems = 6
    var newItemScrollWidth = 0
    var newItemContentWidth = 0
    var counter = 0
    var prevIndex = 0, currIndex = 0, nextIndex = 0
    
    // New Items
    
    @IBOutlet weak var btnSeeAllItems: UIButton!
    @IBOutlet weak var collectionNewItems: UICollectionView!
    @IBOutlet weak var viewNewItems: ClipView!
    
    // Categories
    @IBOutlet weak var viewCategories: ClipView!
    @IBOutlet weak var collectionCategories: UICollectionView!
    
    // Popular Items
    @IBOutlet weak var viewPopularItems: ClipView!
    @IBOutlet weak var btnSeeAllPopularItems: UIButton!
    @IBOutlet weak var collectionPopularItems: UICollectionView!
    
    var store: Store {
        let _store = Store.model()
        _store.delegate = self
        return _store
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let backButton = UIButton()
        let imgBack = UIImage(named: "storeBack")
        backButton.setBackgroundImage(imgBack, forState: UIControlState.Normal)
        backButton.addTarget(self, action: "goBack", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.frame = CGRectMake(0, 0, 30, 30)
        let backButtonBarItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonBarItem
        updateCart()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = store.getStoreTitleView()
        updateCart()
        viewMain.hidden = true
        self.view.backgroundColor = UIColor.blackColor()
        scrollMain.frame = CGRectMake(0, 0, scrollMain.frame.size.width, scrollMain.frame.size.height)
        scrollMain.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, scrollBanners.frame.size.height + viewNewItems.frame.size.height + viewCategories.frame.size.height + viewPopularItems.frame.size.height)
        
        // Register cell classes
        collectionNewItems.registerClass(CBStoreItemCell.self, forCellWithReuseIdentifier: CELL_ITEM_IDENTIFIER)
        collectionCategories.registerClass(CBStoreCategoryCell.self, forCellWithReuseIdentifier: CELL_CATEGORY_IDENTIFIER)
        collectionPopularItems.registerClass(CBStoreItemCell.self, forCellWithReuseIdentifier: CELL_ITEM_IDENTIFIER)
        
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            KVNProgress.setConfiguration(Configuration.standardProgressConfig())
            KVNProgress.show()
        }
        
        let seeAllItemsArrowImage = UIImageView(image: UIImage(named: "disclosure"))
        seeAllItemsArrowImage.frame = CGRectMake(0, 0, 20, 20)
        let seeAllItemsArrow = UITableViewCell()
        btnSeeAllItems.addSubview(seeAllItemsArrow)
        seeAllItemsArrowImage.frame = CGRectMake(24, 0, btnSeeAllItems.frame.size.width, btnSeeAllItems.frame.size.height)
        seeAllItemsArrow.userInteractionEnabled = false
        seeAllItemsArrow.accessoryView = seeAllItemsArrowImage
        collectionNewItems.backgroundColor = UIColor.blackColor()
        scrollMain.backgroundColor = UIColor.blackColor()
        self.view.backgroundColor = UIColor.blackColor()
        viewNewItems.backgroundColor = UIColor.blackColor()
        collectionCategories.backgroundColor = UIColor.blackColor()
        viewMain.backgroundColor = UIColor.blackColor()
        collectionPopularItems.backgroundColor = UIColor.blackColor()
        
        // banners
        btnBanner1.addTarget(self, action: "bannerTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        btnBanner2.addTarget(self, action: "bannerTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        btnBanner3.addTarget(self, action: "bannerTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        if !store.storeLoaded {
            store.loadStore()
        } else {
            initUI()
        }
    }
    
    func goBack() {
        timerBanners.invalidate()
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            KVNProgress.dismiss()
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
    func storeDidLoad() {
        initUI()
        updateCart()
    }
    
    func storeDidFail() {
        viewMain.hidden = true
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            let config = Configuration.errorProgressConfig()
            config.minimumErrorDisplayTime = 100
            config.tapBlock = {
                progressView in
                dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                    KVNProgress.dismiss()
                }
                self.goBack()
            }
            config.fullScreen = false
            KVNProgress.setConfiguration(config)
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                KVNProgress.showErrorWithStatus("There was a problem connecting to the 34Store", onView: self.view)
            }
        }
    }
    
    func initUI() {
        loadPageWithId(store.arrayOfBannerObjects.count - 1, page: 0)
        loadPageWithId(0, page: 1)
        loadPageWithId(1, page: 2)
        scrollBanners.addSubview(btnBanner1)
        scrollBanners.addSubview(btnBanner2)
        scrollBanners.addSubview(btnBanner3)
        scrollBanners.contentSize = CGSizeMake(960, 135)
        scrollBanners.scrollRectToVisible(CGRectMake(320, 0, 320, 135), animated: false)
        startTimerForBannerRotation()
        self.automaticallyAdjustsScrollViewInsets = false
        for view in self.view.subviews as! [UIView] {
            view.setTranslatesAutoresizingMaskIntoConstraints(false)
        }
        scrollMain.canCancelContentTouches = true
        scrollMain.delaysContentTouches = true
        scrollMain.userInteractionEnabled = true
        scrollMain.exclusiveTouch = true
        initItems()
        scrollMain.frame = CGRectMake(0, 0, scrollMain.frame.size.width, scrollMain.frame.size.height)
        scrollMain.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, scrollBanners.frame.size.height + viewNewItems.frame.size.height + viewCategories.frame.size.height + viewPopularItems.frame.size.height + viewPopularItems.frame.size.height + 1000)
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            KVNProgress.dismiss()
        }
        viewMain.hidden = false
    }
    
    func initItems() {
        collectionNewItems.reloadData()
        collectionCategories.reloadData()
        collectionPopularItems.reloadData()
    }
    
    func loadPageWithId(index: Int, page: Int) {
        var btnForBanner = UIButton()
        if store.arrayOfBannerObjects.count > 0 {
            switch page {
            case 0: btnForBanner = btnBanner1
            case 1: btnForBanner = btnBanner2
            case 2: btnForBanner = btnBanner3
            default: print("default")
            }
        }
        let objBanner = store.arrayOfBannerObjects[index]
        objBanner["image"]?.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
            if (error == nil) {
                let imgBanner = UIImage(data: data!)
                btnForBanner.setBackgroundImage(imgBanner, forState: UIControlState.Normal)
                btnForBanner.tag = index
            }
        })
    }
    
    func startTimerForBannerRotation() {
        timerBanners = NSTimer(timeInterval: 1, target: self, selector: "scrollToNextBanner", userInfo: nil, repeats: true)
    }
    
    func scrollToNextBanner() {
        counter++
        if counter == 5 {
            counter = 0
            scrollBanners.scrollRectToVisible(CGRectMake(640, 0, 320, 416), animated: true)
        }
    }
    
    func updateCart() {
        let cartButton = UIButton()
        var num = store.numberOfItemsInCart()
        if num > 20 { num = 21 }
        let imgCart = UIImage(named: "cart\(num)")
        cartButton.setBackgroundImage(imgCart, forState: UIControlState.Normal)
        cartButton.addTarget(self, action: "openCart", forControlEvents: UIControlEvents.TouchUpInside)
        cartButton.frame = CGRectMake(0, 0, 30, 30)
        let cartBarButtonItem = UIBarButtonItem(customView: cartButton)
        navigationItem.rightBarButtonItem = cartBarButtonItem
        if store.storeLoaded {
            navigationItem.rightBarButtonItem?.enabled = true
        } else {
            navigationItem.rightBarButtonItem?.enabled = false
        }
    }
    
    func openCart() {
        self.performSegueWithIdentifier("cart", sender: self)
    }
    
    func bannerTapped(sender: UIButton) {
        let bannerObj = store.arrayOfBannerObjects[sender.tag]
        if let link: String = (bannerObj["link"] as? String) {
            
        }
    }
    // MARK:
    // MARK: UIScrollViewDelegate
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        //we are moving forward. Load the current doc data on the first page
        loadPageWithId(currIndex, page: 0)
        //add one to the currentIndex or reset to 0 if we have reached the end
        if currIndex >= store.arrayOfBannerObjects.count - 1 {
            currIndex = 0
        } else {
            currIndex += 1
        }
        loadPageWithId(currIndex, page: 1)
        //load the content on the last page. This is either from the next item int he array
        //or the first if we have reached the end
        if currIndex >= store.arrayOfBannerObjects.count - 1 {
            nextIndex = 0
        } else {
            nextIndex = currIndex + 1
        }
        loadPageWithId(nextIndex, page: 2)
        //Reset offset back to middle page
        scrollBanners.scrollRectToVisible(CGRectMake(320, 0, 320, 416), animated: false)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == scrollMain {
            if scrollView.contentOffset.y < -128 {
                scrollView.contentOffset = CGPointMake(0, -128)
            }
        }
        if scrollView == scrollBanners {
            // the user scrolled manually, so reset the counter
            self.counter = 0
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView == scrollBanners {
            // All data for the documents are stored in an array (documentTitles).
            // We keep track of the index that we are scrolling to so that we
            // know what data to load for each page.
            if(scrollView.contentOffset.x > scrollView.frame.size.width) {
                // We are moving forward. Load the current doc data on the first page.
                loadPageWithId(currIndex, page: 0)
                // Add one to the currentIndex or reset to 0 if we have reached the end.
                if currIndex >= store.arrayOfBannerObjects.count - 1 {
                    currIndex = 0
                } else {
                    currIndex += 1
                }
                loadPageWithId(currIndex, page: 1)
                // Load content on the last page. This is either from the next item in the array
                // or the first if we have reached the end.
                if currIndex >= store.arrayOfBannerObjects.count - 1 {
                    nextIndex = 0
                } else {
                    nextIndex = currIndex + 1
                }
                loadPageWithId(nextIndex, page: 2)
            }
        }
        if scrollView.contentOffset.x < scrollView.frame.size.width {
            // We are moving backward. Load the current doc data on the last page.
            loadPageWithId(currIndex, page: 2)
            // Subtract one from the currentIndex or go to the end if we have reached the beginning.
            if currIndex == 0 {
                currIndex = store.arrayOfBannerObjects.count - 1
            } else {
                currIndex -= 1
            }
            loadPageWithId(currIndex, page: 1)
            // Load content on the first page. This is either from the prev item in the array
            // or the last if we have reached the beginning.
            if currIndex == 0 {
                prevIndex = store.arrayOfBannerObjects.count - 1
            } else {
                prevIndex = currIndex - 1
            }
            loadPageWithId(prevIndex, page: 0)
        }
        //Reset offset back to middle page
        scrollView.scrollRectToVisible(CGRectMake(320, 0, 320, 416), animated: false)
    }
    
    //MARK:
    //MARK: UICollectionView Delegates
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionNewItems {
            if store.arrayOfNewItems.count > 10 { return 10 }
            else { return store.arrayOfNewItems.count }
        } else if collectionView == collectionCategories {
            if store.arrayOfCategoryObjects.count > 0 { return store.arrayOfCategoryObjects.count }
            else { return 0 }
        } else if collectionView == collectionPopularItems {
            if store.arrayOfPopularItems.count > 10 { return 10 }
            else { return store.arrayOfPopularItems.count }
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        if collectionView == collectionNewItems {
            let cellIdentifier = "CBStoreItemCell"
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
            let item = store.arrayOfNewItems[indexPath.row]
            let imgItem = cell.viewWithTag(1) as! PFImageView
            if let imgFile = item.itemImage {
                imgItem.file = imgFile
                imgItem.loadInBackground()
            } else {
                imgItem.image = UIImage(named: "StoreError")
            }
            let view = cell.viewWithTag(6)!
            view.layer.cornerRadius = 10
            view.layer.borderColor = UIColor.blackColor().CGColor
            view.layer.borderWidth = 0
            view.clipsToBounds = true
            
            let lblItem = cell.viewWithTag(2) as! UILabel
            lblItem.text = item.itemName
            
            let lblCategory = cell.viewWithTag(3) as! UILabel
            lblCategory.text = item.itemCategory
            
            let lblItemPrice = cell.viewWithTag(4) as! UILabel
            let lblItemSalePrice = cell.viewWithTag(5) as! UILabel
            
            if item.itemSalePrice?.compare(NSDecimalNumber(double: 0.00)) == NSComparisonResult.OrderedSame { //no sale
                lblItemPrice.text = item.priceString
                lblItemSalePrice.hidden = true
            } else { // there is a sale going on here
                lblItemSalePrice.hidden = false
                let attributedString = NSMutableAttributedString(string: item.priceString)
                attributedString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributedString.length))
                lblItemPrice.attributedText = attributedString
                lblItemSalePrice.text = item.priceString
            }
            
            cell.clipsToBounds = true
            return cell
        } else if collectionView == collectionCategories {
            let cellIdentifier = "CBStoreCategoryCell"
            let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
            let imgCategory = cell.viewWithTag(1) as! UIImageView
            let objCategory = store.arrayOfCategoryObjects[indexPath.row]
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
        } else if collectionView == collectionPopularItems {
            let cellIdentifier = "CBStoreItemCell"
            let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
            let item = store.arrayOfPopularItems[indexPath.row]
            let imgItem = cell.viewWithTag(1) as! PFImageView
            if let imgFile = item.itemImage {
                imgItem.file = imgFile
                imgItem.loadInBackground()
            } else {
                imgItem.image = UIImage(named: "StoreError")
            }
            let view = cell.viewWithTag(6)!
            view.layer.cornerRadius = 10
            view.layer.borderColor = UIColor.blackColor().CGColor
            view.layer.borderWidth = 0
            view.clipsToBounds = true
            
            let lblItem = cell.viewWithTag(2) as! UILabel
            lblItem.text = item.itemName
            
            let lblCategory = cell.viewWithTag(3) as! UILabel
            lblCategory.text = item.itemCategory
            
            let lblItemPrice = cell.viewWithTag(4) as! UILabel
            let lblItemSalePrice = cell.viewWithTag(5) as! UILabel
            
            if item.itemSalePrice?.compare(NSDecimalNumber(double: 0.00)) == NSComparisonResult.OrderedSame { //no sale
                lblItemPrice.text = item.priceString
                lblItemSalePrice.hidden = true
            } else { // there is a sale going on here
                lblItemSalePrice.hidden = false
                let attributedString = NSMutableAttributedString(string: item.priceString)
                attributedString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributedString.length))
                lblItemPrice.attributedText = attributedString
                lblItemSalePrice.text = item.priceString
            }
            
            cell.clipsToBounds = true
            return cell
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == collectionNewItems {
            itemSelected = store.arrayOfNewItems[indexPath.row]
            self.performSegueWithIdentifier("item", sender: self)
        } else if collectionView == collectionPopularItems {
            itemSelected = store.arrayOfPopularItems[indexPath.row]
            self.performSegueWithIdentifier("item", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "item" {
            var vc = segue.destinationViewController as! StoreItemTableViewController
            vc.item = itemSelected
        }
    }
}



































