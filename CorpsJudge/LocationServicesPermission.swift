//
//  LocationServicesPermission.swift
//  Corpboard
//
//  Created by Justin Moore on 5/9/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit

protocol delegateLocationServices: class {
    func locationGranted()
    func locationDenied()
}
class LocationServicesPermission: UIView {

    //MARK:-
    //MARK:Properties
    weak var delegateLocation: delegateLocationServices?
    var viewBlur: UIVisualEffectView!
    var parentNav: UINavigationController?
    
    //MARK:-
    //MARK:Outlets
    @IBOutlet var btnAllowLocation: UIButton!
    
    //MARK:-
    //MARK:Lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func show() {
        self.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        self.backgroundColor = UIColor.clearColor()
        self.btnAllowLocation.layer.borderColor = UIColor.whiteColor().CGColor
        self.btnAllowLocation.layer.borderWidth = 1
        self.btnAllowLocation.layer.cornerRadius = 5
        let blurEffect: UIVisualEffect = UIBlurEffect(style: .Dark)
        self.viewBlur = UIVisualEffectView(effect: blurEffect)
        self.viewBlur.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        self.parentNav!.view.addSubview(self.viewBlur)
        self.parentNav!.view.bringSubviewToFront(self.viewBlur)
        self.viewBlur.addSubview(self)
        self.parentNav!.view.bringSubviewToFront(self)
        UIView.animateWithDuration(0.25,
                                   delay: 0,
                                   usingSpringWithDamping: 0.9,
                                   initialSpringVelocity: 0.7,
                                   options: [],
                                   animations: { 
                                    self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                                    self.center = self.viewBlur.center
        }) { (finished: Bool) in
            
        }
    }
    
    func dismissView(allow: Bool) {
        UIView.animateWithDuration(0.25,
                                   delay: 0.09,
                                   usingSpringWithDamping: 1,
                                   initialSpringVelocity: 0.7,
                                   options: [],
                                   animations: { 
                                    self.viewBlur.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, self.frame.size.width, self.frame.size.height)
        }) { (finished: Bool) in
            self.viewBlur.removeFromSuperview()
            if allow {
                self.delegateLocation?.locationGranted()
            } else {
                self.delegateLocation?.locationDenied()
            }
        }
    }
    
    @IBAction func btnAllowLocation(sender: AnyObject) {
        self.dismissView(true)
    }
    
    @IBAction func btnDenyLocation(sender: AnyObject) {
        self.dismissView(false)
    }
}
