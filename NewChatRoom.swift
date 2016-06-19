//
//  NewChatRoom.swift
//  CorpBoard
//
//  Created by Justin Moore on 6/17/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit

protocol delegateNewChatRoom: class {
    func newChatRoomCreated(topic: String)
}

class NewChatRoom: UIView {

    weak var delegate: delegateNewChatRoom?
    var toolBar = UIToolbar()
    
    @IBOutlet weak var txtTopic: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewDialog: UIView!
    @IBOutlet weak var btnIcon: UIButton!
    @IBOutlet weak var lblMessage: UILabel!

    func showInParent(parentNav: UINavigationController) {
        
        toolBar.barStyle = UIBarStyle.BlackTranslucent
        toolBar.translucent = false
        toolBar.tintColor = UISingleton.sharedInstance.gold
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done   ", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(NewChatRoom.hideKeyboard))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        txtTopic.inputAccessoryView = toolBar

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
        let shapePath = UIBezierPath(roundedRect: btnSave.bounds, byRoundingCorners: [.BottomLeft, .BottomRight], cornerRadii: CGSizeMake(10, 10))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = btnSave.bounds
        shapeLayer.path = shapePath.CGPath
        shapeLayer.fillColor = UISingleton.sharedInstance.gold.CGColor
        shapeLayer.strokeColor = UISingleton.sharedInstance.gold.CGColor
        shapeLayer.lineWidth = 1
        btnSave.layer.insertSublayer(shapeLayer, below: btnSave.layer)
        
        //set image and button tint colors to match app
        btnIcon.tintColor = UISingleton.sharedInstance.gold
        btnSave.tintColor = UISingleton.sharedInstance.maroon
        btnSave.backgroundColor = UIColor.clearColor()
        
        //add top border line on button
        let lineView = UIView(frame: CGRectMake(0, 0, btnSave.frame.size.width, 1))
        lineView.backgroundColor = UIColor.whiteColor()
        btnSave.addSubview(lineView)
        
        self.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        
        backgroundColor = UIColor.clearColor()
        viewContainer.alpha = 0
        btnSave.alpha = 0
        frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
        //alpha = 0
        
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
                
                
                //set up button for showing
                self.btnSave.frame = CGRectMake(self.btnSave.frame.origin.x, self.btnSave.frame.origin.y - self.btnSave.frame.size.height, self.btnSave.frame.size.width, self.btnSave.frame.size.height)
                self.showButton()
            }//end 2
            
        }//end 1
    }
    
    func showButton() {
        UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseIn, animations: {
            
            self.btnSave.alpha = 1
            self.btnSave.frame = CGRectMake(self.btnSave.frame.origin.x, self.btnSave.frame.origin.y + self.btnSave.frame.size.height, self.btnSave.frame.size.width, self.btnSave.frame.size.height)
            
            }, completion: { (done: Bool) in
                print("done: \(self.btnSave)")
        })
    }
    
    func hideKeyboard() {
        txtTopic.resignFirstResponder()
    }
    
    @IBAction func btnCloseDidTouch(sender: UIButton) {
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
    
    @IBAction func btnSaveDidTouch(sender: UIButton) {
        if txtTopic.text != nil {
             delegate?.newChatRoomCreated(txtTopic.text!)
            closeView()
        } else {
             shake()
        }
    }
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.04
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(viewContainer.center.x - 10, viewContainer.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(viewContainer.center.x + 10, viewContainer.center.y))
        viewContainer.layer.addAnimation(animation, forKey: "position")
    }
}
