//
//  CadetsLoadingViewController.swift
//  CorpBoard
//
//  Created by Justin Moore on 5/5/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit
import AVFoundation

class CadetsLoadingViewController: UIViewController, delegateInitialAppLoad {
    
    //MARK:-
    //MARK:Properties
    var timerLoading = NSTimer()
    
    var animatedCadets = false
    var progress: Float = 0.0
    var canUseApp = true
    var arrayOfRandomProgressNumbers: [Float] = [0.05, 0.10, 0.10, 0.10, 0.10, 0.15, 0.15, 0.25]
    var player = AVAudioPlayer()
    var loadStarted = false
    var progressTimerCount = 0
    var factTimerCount = 0
    var arrayOfLoadMessages = ["This is taking longer than it's supposed to.", "If only your internet connection was as fast as The Cadets' drill.", "Internet connection is slow. What will you do with no internet?", "Do you always suffer from slow connections? You poor thing.", "It isn't supposed to take this long."]
    
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
    //MARK:Outlets
    @IBOutlet weak var viewCadets: UIView!
    @IBOutlet weak var imgArrow1: UIImageView!
    @IBOutlet weak var imgArrow2: UIImageView!
    @IBOutlet weak var imgArrow3: UIImageView!
    @IBOutlet weak var imgCadetsText: UIImageView!
    @IBOutlet weak var lblCorpsboard: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var lblFact: UILabel!
    @IBOutlet weak var imgC: UIImageView!
    @IBOutlet weak var lblLongerThanNormal: UILabel!
    
    //MARK:-
    //MARK:Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Server.sharedInstance.delegateInitial = self
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.viewCadets.backgroundColor = UIColor.clearColor()
        self.progress = 0
        self.progressBar.progress = 0
        self.progressBar.hidden = true
        self.lblFact.alpha = 0
        self.imgArrow1.alpha = 0
        self.imgArrow2.alpha = 0
        self.imgArrow3.alpha = 0
        self.imgCadetsText.alpha = 0
        self.lblCorpsboard.alpha = 0
        self.imgC.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            if !self.animatedCadets {
                self.playRockyPoint()
                Server.sharedInstance.updateFacts()
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.timerLoading.invalidate()
    }
    
    //MARK:-
    //MARK:Animations
    func animateCadets() {
        
        self.animatedCadets = true
        self.view.sendSubviewToBack(self.viewCadets)
        self.imgArrow1.frame = CGRectMake(self.imgArrow1.frame.origin.x - 20, self.imgArrow1.frame.origin.y, self.imgArrow1.frame.size.width, self.imgArrow1.frame.size.height)
        self.imgArrow2.frame = CGRectMake(self.imgArrow2.frame.origin.x - 20, self.imgArrow1.frame.origin.y, self.imgArrow1.frame.size.width, self.imgArrow1.frame.size.height)
        self.imgArrow3.frame = CGRectMake(self.imgArrow3.frame.origin.x - 20, self.imgArrow1.frame.origin.y, self.imgArrow1.frame.size.width, self.imgArrow1.frame.size.height)
        self.viewCadets.bringSubviewToFront(self.imgArrow3)
        
        UIView.animateWithDuration(2.0,
                                   delay: 1.0,
                                   options: UIViewAnimationOptions.CurveEaseInOut,
                                   animations: { 
                                    
                                    self.viewCadets.alpha = 1
                                    
        }) { (finished: Bool) in
            
        }

        
        

        UIView.animateWithDuration(0.1,
                                   delay: 0.6,
                                   options: UIViewAnimationOptions.CurveEaseInOut,
                                   animations: {
                                    
                                    self.imgArrow3.frame = CGRectMake(self.imgArrow3.frame.origin.x + 20, self.imgArrow1.frame.origin.y, self.imgArrow1.frame.size.width, self.imgArrow1.frame.size.height)
                                    self.imgArrow3.alpha = 1
                                    
        }) { (finished: Bool) in
            
        }
    
        UIView.animateWithDuration(0.1,
                                   delay: 0.8,
                                   options: UIViewAnimationOptions.CurveEaseInOut,
                                   animations: {
                                    
                                    self.imgArrow2.frame = CGRectMake(self.imgArrow2.frame.origin.x + 20, self.imgArrow1.frame.origin.y, self.imgArrow1.frame.size.width, self.imgArrow1.frame.size.height)
                                    self.imgArrow2.alpha = 1
                                    
        }) { (finished: Bool) in
            
        }
        
        UIView.animateWithDuration(0.1,
                                   delay: 1.0,
                                   options: UIViewAnimationOptions.CurveEaseInOut,
                                   animations: {
                                    
                                    self.imgArrow1.frame = CGRectMake(self.imgArrow1.frame.origin.x + 20, self.imgArrow1.frame.origin.y, self.imgArrow1.frame.size.width, self.imgArrow1.frame.size.height)
                                    self.imgArrow1.alpha = 1
                                    self.imgCadetsText.alpha = 1
                                    
        }) { (finished: Bool) in
            self.progressBar.hidden = false
            Server.sharedInstance.updateAppStatus()
            Server.sharedInstance.signInAndSyncOrAllowAnonymousUser()
            Server.sharedInstance.updateUserLocation()
            Server.sharedInstance.updateAppSettings()
            //Server.data.updateNews() This is called from updateAppSettings because we need the URL for the news
            Server.sharedInstance.updateShows()
            Server.sharedInstance.updateCorps()
            Server.sharedInstance.updateBanners()
        }

        UIView.animateWithDuration(0.1,
                                   delay: 1.0,
                                   options: UIViewAnimationOptions.CurveEaseInOut,
                                   animations: {
                                    
                                    self.imgCadetsText.alpha = 1
                                    self.lblCorpsboard.alpha = 1
        }) { (finished: Bool) in
            
        }
        
        self.doMaskAnimation()
    }
    
    //MARK: -
    //MARK:delegateInitialAppLoad
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
    
    func testProgress() {
        self.progressTimerCount += 1
        self.factTimerCount += 1
        print("Timer: '\(self.factTimerCount)")
        if self.progressTimerCount == 10 {
            let randomIndex = Int(arc4random_uniform(UInt32(self.arrayOfLoadMessages.count)))
            self.lblLongerThanNormal.text = self.arrayOfLoadMessages[randomIndex]
            self.lblLongerThanNormal.alpha = 0
            self.lblLongerThanNormal.hidden = false
            self.lblLongerThanNormal.frame = CGRectMake(self.lblLongerThanNormal.frame.origin.x, self.lblLongerThanNormal.frame.origin.y - 10, self.lblLongerThanNormal.frame.size.width, self.lblLongerThanNormal.frame.size.height)
            UIView.animateWithDuration(0.5,
                                       animations: { 
                                        self.lblLongerThanNormal.alpha = 1
                                        self.lblLongerThanNormal.frame = CGRectMake(self.lblLongerThanNormal.frame.origin.x, self.lblLongerThanNormal.frame.origin.y + 10, self.lblLongerThanNormal.frame.size.width, self.lblLongerThanNormal.frame.size.height)
                                        
            })
        }
        
        //change out the facts every 10 seconds
        if self.factTimerCount >= 10 {
            self.factTimerCount = 0
            if Server.sharedInstance.arrayOfFacts.count > 0 {
                UIView.animateWithDuration(0.5, animations: {
                    self.lblFact.alpha = 0
                    self.lblFact.frame = CGRectMake(self.lblFact.frame.origin.x, self.lblFact.frame.origin.y + 10, self.lblFact.frame.size.width, self.lblFact.frame.size.height)
                    }, completion: { (finished: Bool) in
                        let randomIndex = Int(arc4random_uniform(UInt32(Server.sharedInstance.arrayOfFacts.count)))
                        let fact = Server.sharedInstance.arrayOfFacts[randomIndex]
                        self.lblFact.text = fact["fact"] as? String
                        self.lblFact.frame = CGRectMake(self.lblFact.frame.origin.x, self.lblFact.frame.origin.y - 20, self.lblFact.frame.size.width, self.lblFact.frame.size.height)
                        UIView.animateWithDuration(0.5, animations: {
                            self.lblFact.alpha = 1
                            self.lblFact.frame = CGRectMake(self.lblFact.frame.origin.x, self.lblFact.frame.origin.y + 10, self.lblFact.frame.size.width, self.lblFact.frame.size.height)
                        })
                })
            }
        }
    }
    
    func updateProgress() {
        //update progress variable and animate progress bar
        //if at 100%, segue
        if !loadStarted {
            loadStarted = true
            timerLoading = NSTimer.scheduledTimerWithTimeInterval(1.0,
                                                                  target: self,
                                                                  selector: #selector(CadetsLoadingViewController.testProgress),
                                                                  userInfo: [],
                                                                  repeats: true)
        }
        
        if self.arrayOfRandomProgressNumbers.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(self.arrayOfRandomProgressNumbers.count)))
            let progressAmount = self.arrayOfRandomProgressNumbers.removeAtIndex(randomIndex)
            self.progress += progressAmount
            print("Progress: \(self.progress)")
            self.progressBar.setProgress(self.progress, animated: true)
            if self.progress >= 1.0 {
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("menu", sender: self)
                }
            }
        } else {
            print("Tried to update progress when no progress was left.")
        }
    }
    
    func displayFact(fact: PFact) {
        self.lblFact.text = fact["fact"] as? String
        UIView.animateWithDuration(0.5) { 
            self.lblFact.alpha = 1
        }
    }
    
    //MARK:-
    //MARK:Helpers
    func playRockyPoint() {
            self.animateCadets()
            let url:NSURL = NSBundle.mainBundle().URLForResource("RockyPoint", withExtension: "mp3")!
        
            do { self.player = try AVAudioPlayer(contentsOfURL: url, fileTypeHint: nil) }
            catch let error as NSError { print(error.description) }
            self.player.play()
    }
    
    func doMaskAnimation() {

        let c: CadetsAnimation = CadetsAnimation()
        c.doMaskAnimation(self.imgC, repeat: false)
        
//        //Create a shape layer that we will use as a mask for the waretoLogoLarge image view
//        let maskLayer = CAShapeLayer()
//        let maskHeight = self.imgC.layer.bounds.size.height
//        let maskWidth = self.imgC.layer.bounds.size.width
//        let centerPoint = CGPointMake( maskWidth/2, maskHeight/2)
//    
//        //Make the radius of our arc large enough to reach into the corners of the image view.
//        let radius = sqrtf(Float(maskWidth) * Float(maskWidth) + Float(maskHeight) * Float(maskHeight))/2
//    
//        //Don't fill the path, but stroke it in black.
//        maskLayer.fillColor = UIColor.redColor().CGColor
//        maskLayer.strokeColor = UIColor.yellowColor().CGColor
//        maskLayer.lineWidth = CGFloat(radius) //Make the line thick enough to completely fill the circle we're drawing
//    
//        let arcPath = CGPathCreateMutable()
//    
//        //Move to the starting point of the arc so there is no initial line connecting to the arc
//        CGPathMoveToPoint(arcPath, nil, centerPoint.x, centerPoint.y-CGFloat(radius)/2);
//    
//        //Create an arc at 1/2 our circle radius, with a line thickess of the full circle radius
//        CGPathAddArc(arcPath,
//                     nil,
//                     centerPoint.x,
//                     centerPoint.y,
//                     CGFloat(radius)/2,
//                     3*CGFloat(M_PI)/2,
//                     CGFloat(-M_PI)/2,
//                     true)
//    
//        maskLayer.path = arcPath;
//    
//        //Start with an empty mask path (draw 0% of the arc)
//        maskLayer.strokeEnd = 0.0;
//    
//        //Install the mask layer into out image view's layer.
//        self.imgC.layer.mask = maskLayer;
//    
//        //Set our mask layer's frame to the parent layer's bounds.
//        self.imgC.layer.mask!.frame = self.imgC.layer.bounds;
//    
//        //Create an animation that increases the stroke length to 1, then reverses it back to zero.
//        let swipe = CABasicAnimation(keyPath: "stokeEnd")
//        swipe.duration = 2;
//        swipe.delegate = self;
//        swipe.setValue("theBlock", forKey: "kAnimationCompletionBlock")
//    
//        swipe.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
//        swipe.fillMode = kCAFillModeForwards
//        swipe.removedOnCompletion = false
//        swipe.autoreverses = true
//        swipe.toValue = 1.0
//        maskLayer.addAnimation(swipe, forKey: "strokeEnd")
    
    }
}
