//
//  YeaLoadingViewController.swift
//  CorpBoard
//
//  Created by Justin Moore on 5/6/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit
import AVFoundation

class YeaLoadingViewController: UIViewController {

    //MARK:-
    //MARK: Properties
    var player = AVAudioPlayer()
    
    //MARK:-
    //MARK: Outlets
    @IBOutlet weak var imgYea: UIImageView!
    
    //MARK:-
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.imgYea.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.playYea()
        self.imgYea.transform = CGAffineTransformMakeScale(0.4, 0.4);
        
        //make yea expand as it fades on and off screen
        UIView.animateWithDuration(0.4, delay: 0.5, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.imgYea.transform = CGAffineTransformIdentity
            self.imgYea.alpha = 1
            }, completion: { (finished: Bool) in
                
        })
        
        
            //wait a second
            let delayTime2 = dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime2, dispatch_get_main_queue()) {
                
                //fade yea off screen
                UIView.animateWithDuration(2.0, animations: {
                    self.imgYea.alpha = 0
                }) { (finished: Bool) in
                    self.performSegueWithIdentifier("cadets", sender: self)
                }
            }
        
    }
    
    //MARK:-
    //MARK: Helpers
    func playYea() {

        let url:NSURL = NSBundle.mainBundle().URLForResource("Yea", withExtension: "mp3")!
        
        do { self.player = try AVAudioPlayer(contentsOfURL: url, fileTypeHint: nil) }
        catch let error as NSError { print(error.description) }
        self.player.volume = 0.3
        self.player.play()
    }
}
