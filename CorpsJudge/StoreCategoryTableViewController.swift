//
//  StoreCategoryTableViewController.swift
//  CorpBoard
//
//  Created by Isaias Favela on 6/1/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit
import ParseUI

class StoreCategoryTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let CELL_ITEM_IDENTIFIER = "StoreItemCell"
    
    var category: PBanner! = nil
    var viewLoading = Loading()
    var arrayOfArrayOfSubCategories = [[PStoreItem]]()
    var arrayOfCategoryItems = [PStoreItem]()
    var arrayOfSubCategories = [String]()
    var itemSelected = PStoreItem()
    var categoryBannerFile: PFFile? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = UIColor.blackColor()
        
        viewLoading = NSBundle.mainBundle().loadNibNamed("Loading", owner: self, options: nil).first as! Loading
        self.view.addSubview(viewLoading)
        viewLoading.center = self.view.center
        viewLoading.animate()
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        fetchItems()
        
        // Register cell classes
//        self.collectionView!.registerNib(UINib(nibName: CELL_ITEM_IDENTIFIER, bundle: nil), forCellWithReuseIdentifier: CELL_ITEM_IDENTIFIER)
//        collectionView?.backgroundColor = UIColor.blackColor()
    }

    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController!.navigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)
        let backBtn = UISingleton.sharedInstance.getBackButton()
        backBtn.addTarget(self, action: #selector(StoreCategoryTableViewController.goBack), forControlEvents: .TouchUpInside)
        let backButton = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backButton
        
        updateCart()
    }
    
    func fetchItems() {
        
        arrayOfCategoryItems = []
        arrayOfSubCategories = []
        arrayOfArrayOfSubCategories = []
        
        var done = false
        
        let query = PFQuery(className: PStoreItem.parseClassName())
        query.limit = 1000
        query.whereKey("itemCategory", equalTo: category.desc)
        query.orderByDescending("year")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, err: NSError?) in
            if err === nil {
                if let objs = objects as? [PStoreItem] {
                    for (_, obj) in objs.enumerate() {
                        self.arrayOfCategoryItems.append(obj)
                        let sub = obj.itemSubCategory
                        if !self.arrayOfSubCategories.contains(sub) {
                            self.arrayOfSubCategories.append(sub)
                        }
                    }
                    
                    for (_, cat) in self.arrayOfSubCategories.enumerate() {
                        var newArray = [PStoreItem]()
                        for (_, item) in objs.enumerate() {
                            if item.itemSubCategory == cat {
                                newArray.append(item)
                            }
                        }
                        self.arrayOfArrayOfSubCategories.append(newArray)
                    }
                    
                    if (done) {
                        self.reload()
                    } else {
                        done = true
                    }
                }
            } else {
                self.reload()
            }
        }
        
        //category banner
        let query1 = PFQuery(className: PBanner.parseClassName())
        query1.whereKey("type", equalTo: "CATEGORYBANNER")
        query1.whereKey("desc", equalTo: category.desc)
        query1.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, err: NSError?) in
            if err === nil {
                if let objs = objects as? [PBanner] {
                    if let banner = objs.first {
                        self.categoryBannerFile = banner.image
                    }
                    if (done) {
                        self.reload()
                    } else {
                        done = true
                    }
                }
            } else {
                self.reload()
            }
        }
    }
    
    func reload() {
        viewLoading.removeFromSuperview()
        tableView.reloadData()
    }
    
    func updateCart() {
        
        let cartButton = Store.sharedInstance.cartButton()
        cartButton.addTarget(self, action: #selector(StoreCategoryTableViewController.openCart), forControlEvents: UIControlEvents.TouchUpInside)
        let cartBarButtonItem = UIBarButtonItem(customView: cartButton)
        navigationItem.rightBarButtonItem = cartBarButtonItem
        if Store.sharedInstance.storeLoaded {
            navigationItem.rightBarButtonItem?.enabled = true
        } else {
            navigationItem.rightBarButtonItem?.enabled = false
        }
    }
    
    func openCart() {
        
        self.performSegueWithIdentifier("cart", sender: self)
    }
    
    func goBack() {
        
        viewLoading.removeFromSuperview()
        navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayOfArrayOfSubCategories.count + 1
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 { return 100 }
        else { return 159 }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if indexPath.row == 0 {
            cell = self.tableView.dequeueReusableCellWithIdentifier("banner")!
            if let imgBanner = cell.viewWithTag(3) as? PFImageView {
                imgBanner.file = categoryBannerFile
                imgBanner.loadInBackground()
            }
        } else {
            cell = self.tableView.dequeueReusableCellWithIdentifier("category")!
            if let lblCategory = cell.viewWithTag(1) as? UILabel {
                let array = arrayOfArrayOfSubCategories[indexPath.row - 1]
                if let item = array.first {
                    lblCategory.text = item.itemSubCategory
                    lblCategory.backgroundColor = UIColor.blackColor()
                }
            }
            
            let collection = cell.viewWithTag(2) as! UICollectionView
            collection.registerNib(UINib(nibName: CELL_ITEM_IDENTIFIER, bundle: nil), forCellWithReuseIdentifier: CELL_ITEM_IDENTIFIER)
            
            
            
            collection.delegate = self
            collection.dataSource = self
        }

        return cell
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let location = collectionView.superview?.convertPoint(collectionView.center, toView: self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(location!)
        let array = self.arrayOfArrayOfSubCategories[indexPath!.row - 1]
        return array.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let location = collectionView.superview?.convertPoint(collectionView.center, toView: self.tableView)
        let path = self.tableView.indexPathForRowAtPoint(location!)
        let array = self.arrayOfArrayOfSubCategories[path!.row - 1]
        let item = array[indexPath.row]
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            CELL_ITEM_IDENTIFIER, forIndexPath: indexPath) as! StoreItemCell
        
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let location = collectionView.superview?.convertPoint(collectionView.center, toView: tableView)
        let path = tableView.indexPathForRowAtPoint(location!)
        let array = arrayOfArrayOfSubCategories[path!.row - 1]
        itemSelected = array[indexPath.row]
        self.performSegueWithIdentifier("item", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "item" {
            let vc = segue.destinationViewController as! StoreItemTableViewController
            vc.item = itemSelected
        }
    }
}
