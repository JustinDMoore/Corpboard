//
//  StoreItemSelector.swift
//  CorpBoard
//
//  Created by Justin Moore on 9/3/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

import UIKit

protocol StoreItemSelectorProtocol {
    func indexSelected()
    func selectorClosedWithSelectedIndex(selectedIndex: Int)
    func selectorDidClose()
    func selectorWillClose()
}

class StoreItemSelector: UIView {

    enum selectType {
        case SIZE, COLOR, QUANTITY, NOTSET
    }
    
    var delegate: StoreItemSelectorProtocol?
    var selectorType: selectType = selectType.NOTSET
    
    @IBOutlet weak var tableSelector: UITableView!
    @IBOutlet weak var title: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func showInParent() {
        switch selectorType {
        case .NOTSET: title.text = "ERROR"
        case .SIZE: title.text = "PICK A SIZE"
        case .COLOR: title.text = "PICK A COLOR"
        case .QUANTITY: title.text = "PICK A QUANTITY"
        }
        
        self.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height / 2)
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10.0, options: UIViewAnimationOptions.allZeros, animations: ({
            self.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height - (UIScreen.mainScreen().bounds.size.height / 2), UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height / 2)
        }), completion: nil)
    }
    
    func closeView() {
         if let del = self.delegate {
            del.selectorWillClose()
        }
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10.0, options: UIViewAnimationOptions.allZeros, animations: ({
            
        }), completion: { finisehd in
            self.removeFromSuperview()
             if let del = self.delegate {
                del.selectorDidClose()
            }
        })
    }
    
    @IBAction func close(sender: UIButton) {
        self.closeView()
    }
}
