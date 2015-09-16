//
//  CBStoreItemTableViewController.swift
//  CorpBoard
//
//  Created by Justin Moore on 9/3/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

import UIKit

class StoreItemTableViewController: UITableViewController, StoreItemSelectorProtocol, StoreProtocol {

    enum errorForItem {
        case NONE
        case SIZE
        case COLOR
    }
    
    let GOLD = UIColor(red:0.78, green:0.56, blue:0.2, alpha:1.0)
    let MAROON = UIColor(red:0.47, green:0.13, blue:0.15, alpha:1.0)
    var store: Store {
        let _store = Store.model()
        _store.delegate = self
        return _store
    }
    let buttonBorderWidth: CGFloat = 1
    let buttonCornerRadius: CGFloat = 8
    let buttonBorderColor = UIColor.blackColor()
    let buttonBackgroundColor = UIColor.clearColor()
    let buttonTitleColor = UIColor.blackColor()
    
    var viewSelector: StoreItemSelector {
        var tViewSelector = StoreItemSelector()
        //tViewSelector = NSBundle.mainBundle().loadNibNamed("CBStoreItemSelector", owner: self, options: nil)
        tViewSelector = NSBundle.mainBundle().loadNibNamed("StoreItemSelector", owner: nil, options: nil)[0] as! StoreItemSelector
        tViewSelector.tableSelector.delegate = self
        tViewSelector.tableSelector.dataSource = self
        tViewSelector.tableSelector.tableFooterView = UIView(frame: CGRectZero)
        return tViewSelector
    }
    
    var colors = false
    var sizes = false
    var item: StoreItem! = nil
    var numOfItemsInCart = 0
    var itemError = errorForItem.NONE
    var indexOfQuantity = 0
    var indexOfColor = -1
    var indexOfSize = -1
    var btnCart: UIButton?
    var imgVToAnimate = PFImageView()
    var imgOriginal = PFImageView()
    var viewFade: UIView?
    var payment = Payment()
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        store.delegate = self
        numOfItemsInCart = store.numberOfItemsInCart() - 1
        self.updateCart()
        self.navigationItem.titleView = store.getStoreTitleView()
        let backButton = UIButton()
        let imgBack = UIImage(named: "storeBack")
        backButton.setBackgroundImage(imgBack, forState: UIControlState.Normal)
        backButton.addTarget(self, action: "goBack", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.frame = CGRectMake(0, 0, 30, 30)
        let backButtonBarItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backButtonBarItem
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.clearsSelectionOnViewWillAppear = true
        if item?.itemSizes != nil { sizes = true }
        if item?.itemColors != nil { colors = true }
        
    }

    func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
        //self.viewSelector.closeView()
    }
    
    func updateCart() {
        btnCart = UIButton()
        numOfItemsInCart = numOfItemsInCart + 1
        var num = numOfItemsInCart
        if num > 20 { num = 21 }
        let imgCart = UIImage(named: "cart\(num)")
        btnCart?.addTarget(self, action: "openCart", forControlEvents: UIControlEvents.TouchUpInside)
        btnCart?.setBackgroundImage(imgCart, forState: UIControlState.Normal)
        btnCart?.frame = CGRectMake(0, 0, 30, 30)
        let cartBarButtonItem = UIBarButtonItem(customView: btnCart!)
        self.navigationItem.rightBarButtonItem = cartBarButtonItem
    }
    
    func openCart() {
        self.performSegueWithIdentifier("cart", sender: self)
    }
    
    
    //MARK:
    //MARK: UITableView Delegates
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView === self.tableView {
            if indexPath.row == 0 { return 300 }
            else if indexPath.row == 1 { return 52 }
            else if indexPath.row == 4 { return 100 }
            else { return 48 }
        } else {
            return 44
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView === self.tableView {
            if let _ = item.itemDescription {
                return 5
            } else { return 4 }
        } else {
            switch viewSelector.selectorType {
            case .SIZE: return item.itemSizes!.count
            case .COLOR: return item.itemColors!.count
            case .QUANTITY: return 9 //1-9
            case .NOTSET: return 0
            }
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if tableView == self.tableView {
            switch indexPath.row {
            case 0: return self.imageCellForTableView(tableView, cellForRowAtIndexPath: indexPath)
            case 1: return self.descriptionCellForTableView(tableView, cellForRowAtIndexPath: indexPath)
            case 2: return self.buttonsCellForTableView(tableView, cellForRowAtIndexPath: indexPath)
            //case 3: return self.cartCellForTableView(tableView, cellForRowAtIndexPath: indexPath)
            case 4: return self.detailsCellForTableView(tableView, cellForRowAtIndexPath: indexPath)
            default: print("Error", terminator: "")
            }
        } else if tableView == self.viewSelector.tableSelector {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
            switch self.viewSelector.selectorType {
            case .SIZE:
                cell.textLabel?.text = item.itemSizes?[indexPath.row]
                if indexOfSize == indexPath.row {
                    cell.backgroundColor = UIColor.blackColor()
                    cell.textLabel?.textColor = UIColor.whiteColor()
                } else {
                    cell.backgroundColor = UIColor.clearColor()
                    cell.textLabel?.textColor = UIColor.blackColor()
                }
            case .COLOR:
                cell.textLabel?.text = item.itemColors?[indexPath.row]
                if indexOfColor == indexPath.row {
                    cell.backgroundColor = UIColor.blackColor()
                    cell.textLabel?.textColor = UIColor.whiteColor()
                } else {
                    cell.backgroundColor = UIColor.clearColor()
                    cell.textLabel?.textColor = UIColor.blackColor()
                }
            case .QUANTITY:
                cell.textLabel?.text = "\(indexPath.row + 1)"
                if indexOfQuantity == indexPath.row {
                    cell.backgroundColor = UIColor.blackColor()
                    cell.textLabel?.textColor = UIColor.whiteColor()
                } else {
                    cell.backgroundColor = UIColor.clearColor()
                    cell.textLabel?.textColor = UIColor.blackColor()
                }
            case .NOTSET: print("Not set", terminator: "")
            }
            cell.textLabel?.textAlignment = NSTextAlignment.Center
            cell.textLabel?.font = UIFont(name: cell.textLabel!.font.fontName, size: 10)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == viewSelector.tableSelector {
            switch viewSelector.selectorType {
            case .SIZE: indexOfSize = indexPath.row
            case .COLOR: indexOfColor = indexPath.row
            case .QUANTITY: indexOfQuantity = indexPath.row
            case .NOTSET: print("not set", terminator: "")
            }
            viewSelector.tableSelector.reloadData()
            viewSelector.closeView()
            itemError = .NONE
            self.tableView.reloadData()
        }
    }
    
    func descriptionCellForTableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("description", forIndexPath: indexPath) 
        let lblItemName = cell.viewWithTag(5) as! UILabel
        let lblItemPrice = cell.viewWithTag(6) as! UILabel
        let lblItemSalePrice = cell.viewWithTag(7) as! UILabel
        let lblError = cell.viewWithTag(10) as! UILabel
        if itemError == .COLOR {
            lblError.hidden = false
            lblError.text = "Please select an available color."
        } else if itemError == .SIZE {
            lblError.hidden = false
            lblError.text = "Please select an available size."
        } else {
            lblError.hidden = true
        }
        lblItemName.text = item.itemName
        if item.itemSalePrice != nil {
            let attributedString = NSMutableAttributedString(string: item.priceString)
            attributedString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributedString.length))
            lblItemPrice.attributedText = attributedString
            lblItemSalePrice.text = item.salePriceString
        } else {
            lblItemPrice.text = item.priceString
            lblItemSalePrice.hidden = true
        }
        return cell
    }

    func imageCellForTableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("image", forIndexPath: indexPath) 
        let imgItem = cell.viewWithTag(1) as! PFImageView
        if let imgFile: PFFile = item.itemImage {
            imgItem.file = imgFile
            imgItem.loadInBackground({ (image: UIImage?, error: NSError?) -> Void in
                self.imgVToAnimate = PFImageView(frame: imgItem.convertRect(imgItem.frame, toView: self.navigationController?.view))
                self.imgVToAnimate.file = imgFile
                self.imgVToAnimate.loadInBackground()
            })
        } else {
            imgItem.image = UIImage(named: "StoreError")
            imgVToAnimate = PFImageView(frame: imgItem.convertRect(imgItem.frame, toView: self.navigationController?.view))
            imgVToAnimate.image = UIImage(named: "StoreError")
        }
        imgVToAnimate.frame = imgItem .convertRect(imgItem.frame, toView: self.navigationController?.view)
        imgVToAnimate.contentMode = UIViewContentMode.ScaleAspectFit
        imgOriginal = imgItem
        return cell
    }
    
    func buttonsCellForTableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if (!colors && !sizes) {
            cell = tableView.dequeueReusableCellWithIdentifier("quantity", forIndexPath: indexPath) 
        } else if (sizes && !colors) {
            cell = tableView.dequeueReusableCellWithIdentifier("sizequantity", forIndexPath: indexPath) 
        } else if (sizes && colors) {
            cell = tableView.dequeueReusableCellWithIdentifier("sizecolorquantity", forIndexPath: indexPath) 
        }
        
        var btnPickASize = UIButton()
        var btnPickAColor = UIButton()
        var btnPickQuantity = UIButton()
        
        if sizes {
            btnPickASize = cell.viewWithTag(1) as! UIButton
            btnPickASize.layer.borderWidth = buttonBorderWidth
            btnPickASize.backgroundColor = buttonBackgroundColor
            btnPickASize.setTitleColor(buttonTitleColor, forState: UIControlState.Normal)
            btnPickASize.addTarget(self, action: "showSelector:", forControlEvents: UIControlEvents.TouchUpInside)
            if (indexOfSize > -1) {
                btnPickASize.setTitle("Size: \(item.itemSizes?[indexOfSize])", forState: UIControlState.Normal)
            } else {
                btnPickASize.setTitle("PICK A SIZE", forState: UIControlState.Normal)
            }
        }
        
        if colors {
            btnPickAColor = cell.viewWithTag(2) as! UIButton
            btnPickAColor.layer.borderWidth = buttonBorderWidth
            btnPickAColor.backgroundColor = buttonBackgroundColor
            btnPickAColor.setTitleColor(buttonTitleColor, forState: UIControlState.Normal)
            btnPickAColor.addTarget(self, action: "showSelector:", forControlEvents: UIControlEvents.TouchUpInside)
            if (indexOfColor > -1) {
                btnPickAColor.setTitle("Color: \(item.itemColors?[indexOfColor])", forState: UIControlState.Normal)
            } else {
                btnPickAColor.setTitle("PICK A COLOR", forState: UIControlState.Normal)
            }
        }
        
        // we will always need a quantity
        btnPickQuantity = cell.viewWithTag(3) as! UIButton
        btnPickQuantity.layer.borderWidth = buttonBorderWidth
        btnPickQuantity.layer.borderColor = buttonBorderColor.CGColor
        btnPickQuantity.backgroundColor = buttonBackgroundColor
        btnPickQuantity.setTitleColor(buttonTitleColor, forState: UIControlState.Normal)
        btnPickQuantity.addTarget(self, action: "showSelector:", forControlEvents: UIControlEvents.TouchUpInside)
        btnPickQuantity.setTitle("QTY: \(indexOfQuantity + 1)", forState: UIControlState.Normal)
        
        if (self.itemError == .SIZE) {
            if sizes { btnPickASize.layer.borderColor = UIColor.redColor().CGColor }
        } else if (self.itemError == .COLOR) {
            if colors { btnPickAColor.layer.borderColor = UIColor.redColor().CGColor }
        } else {
            if sizes { btnPickASize.layer.borderColor = buttonBorderColor.CGColor }
            if colors { btnPickAColor.layer.borderColor = buttonBorderColor.CGColor }
        }

        return cell
    }
    
    func cartCellForTableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("isaias", forIndexPath: indexPath) as! cartTableViewCell
        let btnAddToCart = cell.viewWithTag(4) as! UIButton
        btnAddToCart.layer.borderColor = buttonBorderColor.CGColor
        btnAddToCart.layer.borderWidth = buttonBorderWidth
        btnAddToCart.setTitleColor(GOLD, forState: UIControlState.Normal)
        btnAddToCart.backgroundColor = MAROON
        btnAddToCart.addTarget(self, action: "addItemToCartAndBuy:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let btnApplePay = cell.viewWithTag(40) as! UIButton
        btnApplePay.addTarget(self, action: "applePay", forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }
    
    func detailsCellForTableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("details", forIndexPath: indexPath) 
        let lblDesc = cell.viewWithTag(1) as! UILabel
        lblDesc.font = UIFont(name: lblDesc.font.fontName, size: 12)
        lblDesc.text = item.itemDescription
        return cell
    }
    
    func showSelector(sender: UIButton) {
        switch sender.tag {
        case 1: viewSelector.selectorType = .SIZE
        case 2: viewSelector.selectorType = .COLOR
        case 3: viewSelector.selectorType = .QUANTITY
        default: print("error", terminator: "")
        }
        self.setFade(true)
        self.navigationController!.view.addSubview(viewSelector)
        viewSelector.showInParent()
        //viewSelector
    }
    
    func setFade(on: Bool) {
        if viewFade == nil {
            viewFade = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
            viewFade?.backgroundColor = UIColor.blackColor()
            viewFade?.alpha = 0.6
        }
        if on {
            self.navigationController!.view.addSubview(viewFade!)
        } else {
            viewFade?.removeFromSuperview()
        }
    }
    
    func addItemToCartAndBuy(buyNow: Bool) {
        //make sure size, color exists
        if item.itemSizes?.count != nil {
            if indexOfSize < 0 {
                itemError = .SIZE
                self.tableView.reloadData()
                return
            }
        } else { itemError = .NONE }
        if item.itemColors?.count != nil {
            if indexOfColor < 0 {
                itemError = .COLOR
                self.tableView.reloadData()
                return
            }
        }
        
        let cartItem = PFObject(className: "Orders")
        cartItem["status"] = "CART"
        cartItem["user"] = PFUser.currentUser()
        cartItem["item"] = item
        cartItem["quantity"] = NSNumber(int: indexOfQuantity + 1)
        if item.itemSizes?.count != nil {
            cartItem["size"] = item.itemSizes?[indexOfSize]
        }
        if item.itemColors?.count != nil {
            cartItem["color"] = item.itemColors?[indexOfColor]
        }
        store.arrayOfItemsInCart.append(cartItem)
        if (!buyNow) {
            cartItem.saveEventually()
            var intv = 0.0
            for var i = indexOfQuantity + 1; i > 0; i-- {
                NSTimer.scheduledTimerWithTimeInterval(intv, target: self, selector: "animateItemToCart", userInfo: nil, repeats: false)
                intv = intv + 0.6
            }
        } else {
            cartItem.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                self.payment = Payment()
                var arrayOfItems = [PFObject]()
                arrayOfItems.append(cartItem)
                self.payment.purchaseItemsWithApplePay(arrayOfItems, discount: 0.00, fromViewController: self)
            })
        }
    }
    
    func animateItemToCart() {
        imgVToAnimate.alpha = 1.0
        let viewAnimate = PFImageView(frame: imgVToAnimate.frame)
        viewAnimate.image = imgVToAnimate.image
        viewAnimate.contentMode = UIViewContentMode.ScaleAspectFit
        viewAnimate.alpha = 1.0
        
        let imageFrame = viewAnimate.frame
        var viewOrigin = viewAnimate.frame.origin
        viewOrigin.y = viewOrigin.y + imageFrame.size.height / 2.0;
        viewOrigin.x = viewOrigin.x + imageFrame.size.width / 2.0;
        
        viewAnimate.frame = imageFrame;
        viewAnimate.layer.position = viewOrigin;
        self.navigationController!.view.addSubview(viewAnimate)
        
        let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadeOutAnimation.setValue(0.3, forKey: "opacity")
        fadeOutAnimation.fillMode = kCAFillModeForwards
        fadeOutAnimation.removedOnCompletion = false
        
        let resizeAnimation = CABasicAnimation(keyPath: "bounds.size")
        resizeAnimation.setValue(0.0, forKey: "bounds.size")
        //resizeAnimation.setValue(CGSizeMake(0.0, 0.0), forKey: "bounds.size")
        resizeAnimation.fillMode = kCAFillModeForwards
        resizeAnimation.removedOnCompletion = false
        
        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.calculationMode = kCAAnimationPaced
        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.removedOnCompletion = false
        
        let endP = CGPointMake(UIScreen.mainScreen().bounds.size.width - 30, 45)
        
        let curvedPath = CGPathCreateMutable()
        CGPathMoveToPoint(curvedPath, nil, viewOrigin.x, viewOrigin.y)
        CGPathAddCurveToPoint(curvedPath, nil, endP.x, viewOrigin.y, endP.x, viewOrigin.y, endP.x, endP.y)
        pathAnimation.path = curvedPath
    
        let group = CAAnimationGroup()
        group.fillMode = kCAFillModeForwards
        group.removedOnCompletion = false
        group.animations = [fadeOutAnimation, pathAnimation, resizeAnimation]
        group.duration = 0.6
        group.delegate = self
        group.setValue(viewAnimate, forKey: "imageViewBeingAnimated")
        
        viewAnimate.layer.addAnimation(group, forKey: "savingAnimation")
     
        NSTimer.scheduledTimerWithTimeInterval(0.6, target: self, selector: "updateCart", userInfo: nil, repeats: false)
        
        imgOriginal.alpha = 0
        imgOriginal.transform = CGAffineTransformScale(imgOriginal.transform, 0.8, 0.8)
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.imgOriginal.alpha = 1
            self.imgOriginal.transform = CGAffineTransformIdentity
            }) { ( completed: Bool ) -> Void in
                self.tableView.reloadData()
        }
    }
    
    func indexSelected() {
        
    }
    
    func selectorDidClose() {
        
    }
    
    func selectorWillClose() {
        self.setFade(false)
    }
    
    func selectorClosedWithSelectedIndex(selectedIndex: Int) {
        //self.viewSelector = nil
    }
    
    func storeDidLoad() {
        
    }
    
    func storeDidFail() {
        
    }
}
























