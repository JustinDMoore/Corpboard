//
//  CartEditItem.swift
//  CorpBoard
//
//  Created by Isaias Favela on 6/2/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit

protocol delegateEditCartItem: class {
    func newQuantity(newQty: Int)
    func itemRemoved()
    func itemCancelAnimationWillStart()
    func itemCancelAnimationComplete()
}

class CartEditItem: UIView {
    
    @IBOutlet weak var lblQty: UILabel?
    
    var quantity = 0
    
    weak var delegate: delegateEditCartItem?
    var isShowing = false
    var startRect = CGRectZero
    var endRect = CGRectZero
    let moveSpace = 165
    
    func showAtRect(sRect: CGRect, endAtRect: CGRect, withQty: Int) {
        
        quantity = withQty
        lblQty!.text = "\(quantity)"
        startRect = sRect
        endRect = endAtRect
        isShowing = true
        self.alpha = 0
        self.frame = sRect
        UIView.animateWithDuration(0.75,
                                   delay: 0.0,
                                   usingSpringWithDamping: 0.6,
                                   initialSpringVelocity: 1,
                                   options: UIViewAnimationOptions.CurveEaseOut, animations: {
                                    self.alpha = 1
                                    self.frame = self.endRect
                                    
        }) { (finished: Bool) in
            
        }
    }

    func closeView() {
        isShowing = false
        delegate?.itemCancelAnimationWillStart()
        UIView.animateWithDuration(1,
                                   delay: 0.0,
                                   usingSpringWithDamping: 0.6,
                                   initialSpringVelocity: 1,
                                   options: UIViewAnimationOptions.CurveEaseOut, animations: {
                                    self.frame = self.startRect
                                    self.alpha = 0
                                    
        }) { (finished: Bool) in
            if !self.isShowing {
                self.removeFromSuperview()
                self.delegate?.itemCancelAnimationComplete()
            }
        }
    }
    
    @IBAction func decrementQty(sender: UIButton) {
        quantity -= 1
        if quantity < 1 { quantity = 1 }
        else if quantity > 9 { quantity = 9 }
        lblQty!.text = "\(quantity)"
        delegate?.newQuantity(quantity)
    }
    
    @IBAction func incrementQty(sender: UIButton) {
        quantity += 1
        if quantity < 1 { quantity = 1 }
        else if quantity > 9 { quantity = 9 }
        lblQty!.text = "\(quantity)"
        delegate?.newQuantity(quantity)
    }
    
    @IBAction func removeItem(sender: UIButton) {
        delegate?.itemRemoved()
    }
    
    @IBAction func cancel(sender: UIButton) {
        closeView()
    }
}
