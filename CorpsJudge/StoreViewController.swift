//
//  StoreViewController.swift
//  CorpBoard
//
//  Created by Justin Moore on 9/3/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

import UIKit
import KVNProgress

class StoreViewController: UIViewController, StoreProtocol, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var scrollMain: UIScrollView!
    @IBOutlet weak var scrollBanners: UIScrollView!
    
    let pageOneDoc = UIImageView()
    let pageTwoDoc = UIImageView()
    let pageThreeDoc = UIImageView()
    var itemSelected = PStoreItem()
    var categorySelected = PBanner()
    let btnBanner1 = UIButton(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 135))
    let btnBanner2 = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.size.width, 0, UIScreen.mainScreen().bounds.size.width, 135))
    let btnBanner3 = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.size.width * 2, 0, UIScreen.mainScreen().bounds.size.width, 135))
    let CELL_ITEM_IDENTIFIER = "StoreItemCell"
    let CELL_CATEGORY_IDENTIFIER = "CBStoreCategoryCell"
    
    var timerBanners = NSTimer()
    var numOfNewItems = 6
    var newItemScrollWidth = 0
    var newItemContentWidth = 0
    var counter = 0
    var prevIndex = 0, currIndex = 0, nextIndex = 0
    var viewLoading = Loading()
    
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
        navigationItem.titleView = Store.sharedInstance.getStoreTitleView()
        viewMain.hidden = true
        self.view.backgroundColor = UIColor.blackColor()
        scrollMain.frame = CGRectMake(0, 0, scrollMain.frame.size.width, scrollMain.frame.size.height)
        scrollMain.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, scrollBanners.frame.size.height + viewNewItems.frame.size.height + viewCategories.frame.size.height + viewPopularItems.frame.size.height)
        
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
        btnBanner1.addTarget(self, action: #selector(StoreViewController.bannerTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        btnBanner2.addTarget(self, action: #selector(StoreViewController.bannerTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        btnBanner3.addTarget(self, action: #selector(StoreViewController.bannerTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        Store.sharedInstance.delegate = self
        
        if !Store.sharedInstance.storeLoaded {
            Store.sharedInstance.loadStore()
        } else {
            initUI()
        }
    }
    
    func goBack() {
        
        timerBanners.invalidate()
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
        loadPageWithId(Store.sharedInstance.arrayOfBannerObjects.count - 1, page: 0)
        loadPageWithId(0, page: 1)
        loadPageWithId(1, page: 2)
        scrollBanners.addSubview(btnBanner1)
        scrollBanners.addSubview(btnBanner2)
        scrollBanners.addSubview(btnBanner3)
        scrollBanners.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width * 3, 135)
        scrollBanners.scrollRectToVisible(CGRectMake(UIScreen.mainScreen().bounds.size.width, 0, UIScreen.mainScreen().bounds.size.width, 135), animated: false)
        startTimerForBannerRotation()
        self.automaticallyAdjustsScrollViewInsets = false
        for view in self.view.subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        scrollMain.canCancelContentTouches = true
        scrollMain.delaysContentTouches = true
        scrollMain.userInteractionEnabled = true
        scrollMain.exclusiveTouch = true
        initItems()
        scrollMain.frame = CGRectMake(0, 0, scrollMain.frame.size.width, scrollMain.frame.size.height)
        scrollMain.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, scrollBanners.frame.size.height + viewNewItems.frame.size.height + viewCategories.frame.size.height + viewPopularItems.frame.size.height + viewPopularItems.frame.size.height + 1000)
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
    
    func loadPageWithId(index: Int, page: Int) {
        var btnForBanner = UIButton()
        if Store.sharedInstance.arrayOfBannerImages.count > 0 {
            switch page {
            case 0: btnForBanner = btnBanner1
            case 1: btnForBanner = btnBanner2
            case 2: btnForBanner = btnBanner3
            default: print("default", terminator: "")
            }
            let objBanner = Store.sharedInstance.arrayOfBannerImages[index]
            btnForBanner.setBackgroundImage(objBanner, forState: UIControlState.Normal)
        }
    }
    
    func startTimerForBannerRotation() {
        timerBanners = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(StoreViewController.scrollToNextBanner), userInfo: nil, repeats: true)
        //timerBanners = NSTimer(timeInterval: 1, target: self, selector: "scrollToNextBanner", userInfo: nil, repeats: true)
    }
    
    func scrollToNextBanner() {
        counter += 1
        if counter == 5 {
            counter = 0
            scrollBanners.scrollRectToVisible(CGRectMake(640, 0, UIScreen.mainScreen().bounds.size.width, 416), animated: true)
        }
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
    
    func bannerTapped(sender: UIButton) {
        let bannerObj = Store.sharedInstance.arrayOfBannerObjects[sender.tag]
        if let link: String = (bannerObj["link"] as? String) {
            
        }
    }
    
    // MARK:
    // MARK: UIScrollViewDelegate
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        if scrollView == scrollBanners {
            //we are moving forward. Load the current doc data on the first page
            loadPageWithId(currIndex, page: 0)
            //add one to the currentIndex or reset to 0 if we have reached the end
            if currIndex >= Store.sharedInstance.arrayOfBannerObjects.count - 1 {
                currIndex = 0
            } else {
                currIndex += 1
            }
            loadPageWithId(currIndex, page: 1)
            //load the content on the last page. This is either from the next item int he array
            //or the first if we have reached the end
            if currIndex >= Store.sharedInstance.arrayOfBannerObjects.count - 1 {
                nextIndex = 0
            } else {
                nextIndex = currIndex + 1
            }
            loadPageWithId(nextIndex, page: 2)
            //Reset offset back to middle page
            scrollBanners.scrollRectToVisible(CGRectMake(UIScreen.mainScreen().bounds.size.width, 0, UIScreen.mainScreen().bounds.size.width, 416), animated: false)
        }
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
                if currIndex >= Store.sharedInstance.arrayOfBannerObjects.count - 1 {
                    currIndex = 0
                } else {
                    currIndex += 1
                }
                loadPageWithId(currIndex, page: 1)
                // Load content on the last page. This is either from the next item in the array
                // or the first if we have reached the end.
                if currIndex >= Store.sharedInstance.arrayOfBannerObjects.count - 1 {
                    nextIndex = 0
                } else {
                    nextIndex = currIndex + 1
                }
                loadPageWithId(nextIndex, page: 2)
            }
            if scrollView.contentOffset.x < scrollView.frame.size.width {
                // We are moving backward. Load the current doc data on the last page.
                loadPageWithId(currIndex, page: 2)
                // Subtract one from the currentIndex or go to the end if we have reached the beginning.
                if currIndex == 0 {
                    currIndex = Store.sharedInstance.arrayOfBannerObjects.count - 1
                } else {
                    currIndex -= 1
                }
                loadPageWithId(currIndex, page: 1)
                // Load content on the first page. This is either from the prev item in the array
                // or the last if we have reached the beginning.
                if currIndex == 0 {
                    prevIndex = Store.sharedInstance.arrayOfBannerObjects.count - 1
                } else {
                    prevIndex = currIndex - 1
                }
                loadPageWithId(prevIndex, page: 0)
            }
            //Reset offset back to middle page
            scrollView.scrollRectToVisible(CGRectMake(UIScreen.mainScreen().bounds.size.width, 0, UIScreen.mainScreen().bounds.size.width, 416), animated: false)
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



































