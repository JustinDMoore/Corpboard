//
//  LocationServicesDisabled.swift
//  Corpboard
//
//  Created by Justin Moore on 5/9/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit

class LocationServicesDisabled: UIView {

    //MARK:-
    //MARK:Properties
    var viewBlur: UIVisualEffectView!
    var parentNav = UINavigationController()
    
    //MARK:-
    //MARK:Outlets
    @IBOutlet var btnOK: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    
    //MARK:-
    //MARK:Lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func show() {
        self.viewContainer.backgroundColor = UIColor.clearColor()
        self.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        self.backgroundColor = UIColor.clearColor()
        self.btnOK.layer.borderColor = UIColor.whiteColor().CGColor
        self.btnOK.layer.borderWidth = 1
        self.btnOK.layer.cornerRadius = 5
        let blurEffect: UIVisualEffect = UIBlurEffect(style: .Dark)
        self.viewBlur = UIVisualEffectView(effect: blurEffect)
        self.viewBlur.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        self.parentNav.view.addSubview(self.viewBlur)
        self.parentNav.view.bringSubviewToFront(self.viewBlur)
        self.viewBlur.addSubview(self)
        self.parentNav.view.bringSubviewToFront(self)
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
    
    func dismissView() {
        UIView.animateWithDuration(0.25,
                                   delay: 0.09,
                                   usingSpringWithDamping: 1,
                                   initialSpringVelocity: 0.7,
                                   options: [],
                                   animations: {
                                    self.viewBlur.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, self.frame.size.width, self.frame.size.height)
        }) { (finished: Bool) in
            self.viewBlur.removeFromSuperview()
        }
    }
    
    @IBAction func btnOK(sender: AnyObject) {
        self.dismissView()
    }
}
