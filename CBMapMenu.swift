//
//  CBMapMenu.swift
//  CorpBoard
//
//  Created by Justin Moore on 6/27/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit

class CBMapMenu: UIView {

    @IBOutlet weak var tableCorps: UITableView!
    

    @IBOutlet weak var btnFilter1: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewDialog: UIView!
    @IBOutlet weak var lblMessage1: UILabel!

    
    func showInParent(parentNav: UINavigationController) {
        
        clipsToBounds = true
        
        parentNav.view.addSubview(self)
        viewContainer.backgroundColor = UIColor.clearColor()
        
        //DIALOG VIEW TOP ROUNDED CORNERS
        let shapePath2 = UIBezierPath(roundedRect: viewDialog.bounds, byRoundingCorners: [.TopLeft, .TopRight], cornerRadii: CGSizeMake(10, 10))
        
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.frame = viewDialog.bounds
        shapeLayer2.path = shapePath2.CGPath
        shapeLayer2.strokeColor = UIColor.whiteColor().CGColor
        shapeLayer2.fillColor = UISingleton.sharedInstance.maroon.CGColor
        viewDialog.layer.insertSublayer(shapeLayer2, below: tableCorps.layer)

        
        //set image and button tint colors to match app
        btnFilter1.tintColor = UISingleton.sharedInstance.gold
        
        self.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        
        backgroundColor = UIColor.clearColor()
        viewContainer.alpha = 0
        frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
        //alpha = 0
        
        tableCorps.reloadData()
        
        //1
        UIView.animateWithDuration(0.50, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.7, options: .CurveLinear, animations: {
            
            self.viewContainer.transform = CGAffineTransformScale(self.viewDialog.transform, 0.8, 0.8)
            
        }) { (done: Bool) in
            
            //2
            UIView.animateWithDuration(0.25, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: .CurveLinear, animations: {
                self.alpha = 1
                self.viewContainer.alpha = 1
                self.viewContainer.transform = CGAffineTransformIdentity
            }) { (done: Bool) in
            }//end 2
            
        }//end 1
    }
    
    func closeView() {
        UIView.animateWithDuration(0.25,
                                   delay: 0.0,
                                   usingSpringWithDamping: 1,
                                   initialSpringVelocity: 0.7,
                                   options: UIViewAnimationOptions.CurveLinear,
                                   animations: {
                                    self.viewContainer.transform = CGAffineTransformScale(self.viewContainer.transform, 0.0, 0.0)
        }) { (done: Bool) in
            self.removeFromSuperview()
        }
    }
    
    @IBAction func btnClose_didtap(sender: UIButton) {
        closeView()
    }
    
    
}
