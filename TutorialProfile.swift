//
//  Tutorial.swift
//  CorpBoard
//
//  Created by Justin Moore on 7/6/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit

class TutorialProfile: UIView {

    @IBOutlet weak var btnGotIt: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewDialog: UIView!
    @IBOutlet weak var btnIcon: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    
    func showInParent(parentNav: UINavigationController) {

        clipsToBounds = true
        layer.cornerRadius = 8
        
        parentNav.view.addSubview(self)
        viewContainer.backgroundColor = UIColor.clearColor()
        
        //DIALOG VIEW TOP ROUNDED CORNERS
        let shapePath2 = UIBezierPath(roundedRect: viewDialog.bounds, byRoundingCorners: [.TopLeft, .TopRight], cornerRadii: CGSizeMake(10, 10))
        
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.frame = viewDialog.bounds
        shapeLayer2.path = shapePath2.CGPath
        shapeLayer2.strokeColor = UIColor.whiteColor().CGColor
        shapeLayer2.fillColor = UISingleton.sharedInstance.maroon.CGColor
        viewDialog.layer.insertSublayer(shapeLayer2, below: lblMessage.layer)
        
        //BUTTON BOTTOM CORNERS ROUND
        let shapePath = UIBezierPath(roundedRect: btnGotIt.bounds, byRoundingCorners: [.BottomLeft, .BottomRight], cornerRadii: CGSizeMake(10, 10))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = btnGotIt.bounds
        shapeLayer.path = shapePath.CGPath
        shapeLayer.fillColor = UISingleton.sharedInstance.gold.CGColor
        shapeLayer.strokeColor = UISingleton.sharedInstance.gold.CGColor
        shapeLayer.lineWidth = 1
        btnGotIt.layer.insertSublayer(shapeLayer, below: btnGotIt.layer)
        
        //set image and button tint colors to match app
        btnIcon.tintColor = UISingleton.sharedInstance.gold
        btnGotIt.tintColor = UISingleton.sharedInstance.maroon
        btnGotIt.backgroundColor = UIColor.clearColor()
        
        //add top border line on button
        let lineView = UIView(frame: CGRectMake(0, 0, btnGotIt.frame.size.width, 1))
        lineView.backgroundColor = UIColor.whiteColor()
        btnGotIt.addSubview(lineView)
        
        self.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        
        backgroundColor = UIColor.clearColor()
        viewContainer.alpha = 0
        btnGotIt.alpha = 0
        frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
        //alpha = 0
        
        //1
        UIView.animateWithDuration(0.25, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.7, options: .CurveLinear, animations: {
            
            self.viewContainer.transform = CGAffineTransformScale(self.viewDialog.transform, 0.8, 0.8)
            
        }) { (done: Bool) in
            
            //2
            UIView.animateWithDuration(0.25, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: .CurveLinear, animations: {
                self.alpha = 1
                self.viewContainer.alpha = 1
                self.viewContainer.transform = CGAffineTransformIdentity
            }) { (done: Bool) in
                
                
                //set up button for showing
                self.btnGotIt.frame = CGRectMake(self.btnGotIt.frame.origin.x, self.btnGotIt.frame.origin.y - self.btnGotIt.frame.size.height, self.btnGotIt.frame.size.width, self.btnGotIt.frame.size.height)
                self.showButton()
            }//end 2
            
        }//end 1
    }
    
    func showButton() {
        UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseIn, animations: {
            
            self.btnGotIt.alpha = 1
            self.btnGotIt.frame = CGRectMake(self.btnGotIt.frame.origin.x, self.btnGotIt.frame.origin.y + self.btnGotIt.frame.size.height, self.btnGotIt.frame.size.width, self.btnGotIt.frame.size.height)
            
            }, completion: { (done: Bool) in
                print("done: \(self.btnGotIt)")
        })
    }
    
    @IBAction func btnGotItDidTouch(sender: UIButton) {
        closeView()
    }
    
    func closeView() {
        UIView.animateWithDuration(0.25,
                                   delay: 0.09,
                                   usingSpringWithDamping: 1,
                                   initialSpringVelocity: 0.7,
                                   options: UIViewAnimationOptions.CurveLinear,
                                   animations: {
                                    self.viewContainer.transform = CGAffineTransformScale(self.viewContainer.transform, 0.0, 0.0)
        }) { (done: Bool) in
            self.removeFromSuperview()
        }
    }
}