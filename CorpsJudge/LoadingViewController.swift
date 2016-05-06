//
//  LoadingViewController.swift
//  CorpBoard
//
//  Created by Justin Moore on 5/5/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController, delegateInitialAppLoad {
    
    //MARK:-
    //MARK: Properties
    var animatedCadets = false
    var progress: Float = 0.0
    var canUseApp = true
    var arrayOfRandomProgressNumbers: [Float] = [0.05, 0.05, 0.05, 0.10, 0.10, 0.10, 0.15, 0.15, 0.25]
    /*
     1. updateAppStatus() Check app messages, stop if can't use app
     2. signInAndSyncOrCreateAnonymousUser()
     3. updateUserLocation()
     4. updateAppSettings()
     5. Update news
     6. updateCorps()
     7. updateShows()
     8. updateBanners()
     */
    
    //MARK:-
    //MARK: Outlets
    @IBOutlet weak var viewCadets: UIView!
    @IBOutlet weak var imgArrow1: UIImageView!
    @IBOutlet weak var imgArrow2: UIImageView!
    @IBOutlet weak var imgArrow3: UIImageView!
    @IBOutlet weak var imgCadetsText: UIImageView!
    @IBOutlet weak var lblCorpsboard: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var lblFact: UILabel!
    
    //MARK:-
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Server.data.delegateInitial = self
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.viewCadets.backgroundColor = UIColor.clearColor()
        self.progress = 0
        self.progressBar.progress = 0
        self.lblFact.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !self.animatedCadets {
            self.animateCadets()
            Server.data.updateFacts()
            Server.data.updateAppStatus()
            Server.data.signInAndSyncOrAllowAnonymousUser()
            Server.data.updateUserLocation()
            Server.data.updateAppSettings()
            Server.data.updateNews()
            Server.data.updateShows()
            Server.data.updateCorps()
            Server.data.updateBanners()
        }
    }
    
    //MARK:-
    //MARK: Animations
    func animateCadets() {
        //gives the animations time to complete, then updates the last part of the progress
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(5 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.updateProgress()
        }
        
        self.animatedCadets = true
        self.view.sendSubviewToBack(self.viewCadets)
        self.imgArrow1.frame = CGRectMake(self.imgArrow1.frame.origin.x - 15, self.imgArrow1.frame.origin.y, self.imgArrow1.frame.size.width, self.imgArrow1.frame.size.height)
        self.imgArrow2.frame = self.imgArrow1.frame
        self.imgArrow3.frame = self.imgArrow1.frame
        self.viewCadets.bringSubviewToFront(self.imgArrow3)
        
        UIView.animateWithDuration(2.0,
                                   delay: 1.0,
                                   options: UIViewAnimationOptions.CurveEaseInOut,
                                   animations: { 
                                    
                                    self.viewCadets.alpha = 1
                                    
        }) { (finished: Bool) in
            
        }

        UIView.animateWithDuration(1.5,
                                   delay: 1.0,
                                   options: UIViewAnimationOptions.CurveEaseInOut,
                                   animations: {
                                    
                                    self.imgArrow3.frame = CGRectMake(self.imgArrow1.frame.origin.x + 20, self.imgArrow1.frame.origin.y, self.imgArrow1.frame.size.width, self.imgArrow1.frame.size.height)
                                    self.imgArrow3.alpha = 1
                                    
        }) { (finished: Bool) in
            
        }

        UIView.animateWithDuration(1.5,
                                   delay: 1.2,
                                   options: UIViewAnimationOptions.CurveEaseInOut,
                                   animations: {
                                    
                                    self.imgArrow2.frame = CGRectMake(self.imgArrow1.frame.origin.x + 20, self.imgArrow1.frame.origin.y, self.imgArrow1.frame.size.width, self.imgArrow1.frame.size.height)
                                    self.imgArrow2.alpha = 1
                                    
        }) { (finished: Bool) in
            
        }
        
        UIView.animateWithDuration(1.5,
                                   delay: 1.4,
                                   options: UIViewAnimationOptions.CurveEaseInOut,
                                   animations: {
                                    
                                    self.imgArrow1.frame = CGRectMake(self.imgArrow1.frame.origin.x + 20, self.imgArrow1.frame.origin.y, self.imgArrow1.frame.size.width, self.imgArrow1.frame.size.height)
                                    self.imgArrow1.alpha = 1
                                    self.imgCadetsText.alpha = 1
                                    
        }) { (finished: Bool) in
            
        }

        UIView.animateWithDuration(1.5,
                                   delay: 1.25,
                                   options: UIViewAnimationOptions.CurveEaseInOut,
                                   animations: {
                                    
                                    self.lblCorpsboard.alpha = 1
                                    
        }) { (finished: Bool) in

        }
    }
    
    //MARK: -
    //MARK: Server Delegates
    func showAppMessage(title: String?, message: String?, canUseApp: Bool) {
        if !canUseApp {
            self.canUseApp = false
        }
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func updateProgress() {
        //update progress variable and animate progress bar
        //if at 100%, segue
        if self.arrayOfRandomProgressNumbers.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(self.arrayOfRandomProgressNumbers.count)))
            let progressAmount = self.arrayOfRandomProgressNumbers.removeAtIndex(randomIndex)
            self.progress += progressAmount
            print("Progress: \(self.progress)")
            self.progressBar.setProgress(self.progress, animated: true)
            if self.progress >= 100 {
                
            }
        } else {
            print("Tried to update progress when no progress was left.")
        }
    }
    
    func displayFact(fact: PFObject) {
        self.lblFact.text = fact["fact"] as? String
        UIView.animateWithDuration(0.5) { 
            self.lblFact.alpha = 1
        }
    }
}
