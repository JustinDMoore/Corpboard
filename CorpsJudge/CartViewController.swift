//
//  CartViewController.swift
//  CorpBoard
//
//  Created by Peggy Moore on 5/26/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit
import ParseUI
import PassKit

class CartViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, delegateEditCartItem {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var btnCheckout: UIButton!
    @IBOutlet weak var viewCheckout: UIView!
    @IBOutlet weak var btnApplePay: UIButton!
    @IBOutlet weak var divider: UIView!
    @IBOutlet weak var viewApplePayButton: UIView!
    @IBOutlet weak var viewCheckoutButton: UIView!
    
    var arrayOfPrices = [Double]()
    var indexPathOfEdit = NSIndexPath()
    var viewBlock = CBHoleView()
    var viewEdit = CartEditItem()
    var collectionFooter = CBCollectionFooter?()
    var final = 0.00
    
    let reuseIdentifier = "Item"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        viewEdit = NSBundle.mainBundle().loadNibNamed("CBCartEditItem", owner: self, options: nil).first as! CartEditItem
        viewEdit.delegate = self
        viewEdit.alpha = 0
        arrayOfPrices = []
        initUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.titleView = Store.sharedInstance.getStoreTitleView()
        
        self.navigationController!.navigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)
        let backBtn = UISingleton.sharedInstance.getBackButton()
        backBtn.addTarget(self, action: #selector(CartViewController.goBack), forControlEvents: .TouchUpInside)
        let backButton = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func initUI() {
        lblTotal.text = "$0"
//        viewApplePayButton.hidden = Payment.sharedInstance.applePayAccepted()
//        viewCheckoutButton.hidden = !Payment.sharedInstance.applePayAccepted()
        //FIXME: Fix this
        viewApplePayButton.hidden = false
        viewCheckoutButton.hidden = true

        if !Store.sharedInstance.arrayOfItemsInCart.isEmpty {
           calculateTotal()
            btnCheckout.layer.borderWidth = 1
            btnCheckout.layer.borderColor = UIColor.blackColor().CGColor
            viewCheckout.hidden = false
        } else {
            let lblMessage = UILabel()
            lblMessage.font = UIFont.systemFontOfSize(12)
            lblMessage.numberOfLines = 0
            lblMessage.text = "Your cart is empty. \n\n And lonely."
            lblMessage.textColor = UIColor.whiteColor()
            lblMessage.sizeToFit()
            lblMessage.textAlignment = .Center
            view.addSubview(lblMessage)
            lblMessage.center = view.center
            view.bringSubviewToFront(lblMessage)
            viewCheckout.hidden = true
        }
    }
    
    func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK
    //MARK-UICollectionView Delegates & Datasource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if Store.sharedInstance.arrayOfItemsInCart.isEmpty {
            return 0
        } else {
            return 1
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if Store.sharedInstance.arrayOfItemsInCart.isEmpty {
            return 0
        } else {
            return Store.sharedInstance.arrayOfItemsInCart.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identifier = "item"
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
        
        detailsForCell(cell, indexPath: indexPath)
        if indexPathOfEdit != indexPath {
            cell.addSubview(viewBlock)
            viewBlock.frame = cell.frame
            viewBlock.alpha = 0
        } else {
            for v in cell.subviews {
                if v.tag == 111 {
                    v.removeFromSuperview()
                }
            }
        }
        
        return cell
    }
    
    func detailsForCell(cell: UICollectionViewCell, indexPath: NSIndexPath) {

//        let viewFooter = cell.viewWithTag(10)! as UIView
//        viewFooter.backgroundColor = UIColor(colorLiteralRed: 255/2, green: 255/2, blue: 255/2, alpha: 0.5)
        
        
        if let item = Store.sharedInstance.arrayOfItemsInCart[indexPath.row] as? POrder {
        item.item.fetchIfNeededInBackgroundWithBlock({ (object: PFObject?, err: NSError?) in
            if let obj = object as? PStoreItem {
                if let imgItem = cell.viewWithTag(1) as? PFImageView {
                    if let imgfile: PFFile = obj.itemImage {
                        imgItem.file = imgfile
                        imgItem.loadInBackground()
                    } else {
                        imgItem.image = UIImage(named: "StoreError")
                    }
                }
                
                if let lblColor = cell.viewWithTag(4) as? UILabel {
                    if let color = item.color {
                        lblColor.text = "Color: \(color)"
                    } else { lblColor.text = "" }
                }
                
                if let lblSize = cell.viewWithTag(3) as? UILabel {
                    if let size = item.size {
                        lblSize.text = "Size: \(size)"
                    } else { lblSize.text = "" }
                }
                
                if let lblQty = cell.viewWithTag(2) as? UILabel {
                    lblQty.text = "Qty: \(item.quantity)"
                }
                
                //originally, these were doubles
                //not NSDecimalNumbers
//                let salePrice = itemPointer?.itemSalePrice
//                let price = itemPointer?.itemPrice
//                let qty = item?.quantity
                var total = 0.00
                if item.item.itemSalePrice.doubleValue > 0.00 {
                    total = Double(item.quantity) * item.item.itemSalePrice.doubleValue
                } else {
                    total = Double(item.quantity) * item.item.itemPrice.doubleValue
                }
                
                let str = item.size
                let x = str?.componentsSeparatedByString("$")
                if x?.count > 1 {
                    var extraCharge = Double((x?.last)!)
                    extraCharge = Double(item.quantity) * extraCharge!
                    total += extraCharge!
                }
                
                if let lblPrice = cell.viewWithTag(5) as? UILabel {
                    lblPrice.text = self.stringFromDouble(total)
                }
            }
        })
        }
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row > Store.sharedInstance.arrayOfItemsInCart.count - 1{
            return
        }
        
        if viewEdit.alpha < 1 {
            btnCheckout.userInteractionEnabled = false
            indexPathOfEdit = indexPath
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            let itemsPerRow = 2
            let column = indexPath.item % itemsPerRow
            
            let startRect = collectionView.convertRect(cell!.frame, toView: self.view)
            var endCell = UICollectionViewCell()
            var endRect: CGRect = CGRectZero
            
            if column == 0 { //since previous cell does not exist (we're ON the first cell in the row), calculate where it would be
                let eRect = CGRectMake(collectionView.frame.size.width - cell!.frame.size.width - 5, cell!.frame.origin.y, cell!.frame.size.width, cell!.frame.size.height)
                endRect = collectionView.convertRect(eRect, toView: self.view)
            } else if column == 1 { //just use the previous cell as endRect since previous cell exists
                endCell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: indexPath.row - 1, inSection: 0))!
                endRect = collectionView.convertRect(endCell.frame, toView: self.view)
            }

            let item = Store.sharedInstance.arrayOfItemsInCart[indexPath.row]
            
            self.view.bringSubviewToFront(viewEdit)
            mask(true, forRect: startRect)
            self.view.addSubview(viewEdit)
            viewEdit.showAtRect(startRect, endAtRect: endRect, withQty: item.quantity)
        } else {
            viewEdit.closeView()
            mask(false, forRect: CGRectZero)
        }
        self.view.bringSubviewToFront(viewCheckout)
    }

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        viewEdit.closeView()
        mask(false, forRect: CGRectZero)
    }
    
    func mask(yes: Bool, forRect maskRect: CGRect) {

        if yes {
            let transparentRects = NSArray.init(objects: NSValue(CGRect: maskRect))
            viewBlock = CBHoleView(frame: CGRectMake(0, 0, 200, 400), backgroundColor: UIColor.blackColor(), andTransparentRects: transparentRects as [AnyObject])
            self.view.addSubview(viewBlock)
            viewBlock.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
            viewBlock.alpha = 0.7
            self.view .bringSubviewToFront(viewCheckout)
        } else {
            viewBlock.removeFromSuperview()
        }
    }

    @IBAction func beginCheckout(sender: AnyObject) {
        
    }
    
    func newQuantity(newQty: Int) {
        let item = Store.sharedInstance.arrayOfItemsInCart[indexPathOfEdit.row]
        item.quantity = newQty
        item.saveEventually()
        let cell = collectionView.cellForItemAtIndexPath(indexPathOfEdit)
        detailsForCell(cell!, indexPath: indexPathOfEdit)
        calculateTotal()
    }

    func calculateTotal() {
        arrayOfPrices = []
        for (_, item) in Store.sharedInstance.arrayOfItemsInCart.enumerate() {
            let base = item.item
            base.fetchIfNeededInBackgroundWithBlock({ (obj: PFObject?, err: NSError?) in
                if err === nil {
                    let salePrice = Double(base.itemSalePrice)
                    let price = Double(base.itemPrice)
                    let qty = Double(item.quantity)
                    var total = 0.00
                    if salePrice > 0.00 {
                        total = qty * salePrice
                    } else {
                        total = qty * price
                    }
                    
                    let myString = item.size
                    if let myArray = myString?.componentsSeparatedByString("$") {
                        if !(myArray.isEmpty) { //extra charge
                            var extraCharge = Double((myArray.last)!)
                            if extraCharge > 0.00 {
                                extraCharge = extraCharge! * qty
                                total += extraCharge!
                            }
                        }
                    }
                    self.arrayOfPrices.append(total)
                    self.checkForTotal()
                }
            })
        }
    }

    func checkForTotal() {
        if arrayOfPrices.count == Store.sharedInstance.arrayOfItemsInCart.count {
            var total = 0.00
            let tax = 0.00
            let shipping = 5.00
            let savings = 0.00
            for (_, price) in arrayOfPrices.enumerate() {
                total += price
            }
        
            if let view = collectionFooter {
                //collectionView.reloadData()
                view.lblPriceMerch.text = stringFromDouble(total)
                view.lblPriceShipping.text = stringFromDouble(shipping)
                view.lblPriceTax.text = stringFromDouble(tax)
                view.lblPriceSavings.text = stringFromDouble(savings)
            }
            
            let final = total + shipping + tax
            lblTotal.text = stringFromDouble(final)
        }
    }

    func stringFromDouble(price: Double) -> String {
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .CurrencyStyle
        if let strPrice = numberFormatter.stringFromNumber(NSNumber(double: price)) {
            return strPrice
        }
        return ""
    }

    func itemRemoved() {
        //delete item
        //display a message
        //animate it
        
        self.viewEdit.closeView()
        let itemToDelete = Store.sharedInstance.arrayOfItemsInCart[self.indexPathOfEdit.row]
        
        collectionView.performBatchUpdates({

            
            if Store.sharedInstance.arrayOfItemsInCart.count > 1 {
            
                Store.sharedInstance.arrayOfItemsInCart.removeAtIndex(Store.sharedInstance.arrayOfItemsInCart.indexOf(itemToDelete)!)
                //self.collectionView.reloadData()
                self.collectionView.deleteItemsAtIndexPaths([self.indexPathOfEdit])
                
            }
            else if Store.sharedInstance.arrayOfItemsInCart.count == 1 {
                
                Store.sharedInstance.arrayOfItemsInCart.removeAll()
                let set = NSIndexSet(index: self.indexPathOfEdit.section)
                self.collectionView.deleteSections(set)
                
            }
            itemToDelete.deleteEventually()
        }) { (finished: Bool) in
            self.initUI()
        }
    }
    
    func itemCancelAnimationComplete() {
        
    }
    
    func itemCancelAnimationWillStart() {
        collectionView.userInteractionEnabled = true
        btnCheckout.userInteractionEnabled = true
        mask(false, forRect: CGRectZero)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionFooter {
            if (collectionFooter == nil) {
                collectionFooter = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer", forIndexPath: indexPath) as? CBCollectionFooter
            }
            
            if let view = collectionFooter {
                if view.enteringPromo {
                    collectionFooter?.imgPromo.highlighted = false
                    collectionFooter?.lblPromo.hidden = false
                    collectionFooter?.txtPromo.hidden = true
                    collectionFooter?.btnPromo.hidden = true
                } else {
                    collectionFooter?.imgPromo.hidden = false
                    collectionFooter?.lblPromo.hidden = false
                    collectionFooter?.txtPromo.hidden = true
                    collectionFooter?.btnPromo.hidden = true
                }
            }
        }
        
        return collectionFooter!
    }
}
