//
//  Loading.swift
//  CorpBoard
//
//  Created by Justin Moore on 5/19/16.
//  Copyright © 1016 Justin Moore. All rights reserved.
//

import UIKit

class Loading: UIView {

    var timerLoading = NSTimer()
    
    @IBOutlet weak var viewCadets: UIView!
    @IBOutlet weak var imgArrow1: UIImageView!
    @IBOutlet weak var imgArrow2: UIImageView!
    @IBOutlet weak var imgArrow3: UIImageView!
    @IBOutlet weak var imgC: UIImageView!
    
    func animate() {
        self.backgroundColor = UIColor.clearColor()
        self.doMaskAnimation()
        
        //self.view.sendSubviewToBack(self.viewCadets)
        self.imgArrow1.frame = CGRectMake(self.imgArrow1.frame.origin.x - 10, self.imgArrow1.frame.origin.y, self.imgArrow1.frame.size.width, self.imgArrow1.frame.size.height)
        self.imgArrow2.frame = CGRectMake(self.imgArrow2.frame.origin.x - 10, self.imgArrow1.frame.origin.y, self.imgArrow1.frame.size.width, self.imgArrow1.frame.size.height)
        self.imgArrow3.frame = CGRectMake(self.imgArrow3.frame.origin.x - 10, self.imgArrow1.frame.origin.y, self.imgArrow1.frame.size.width, self.imgArrow1.frame.size.height)
        self.viewCadets.bringSubviewToFront(self.imgArrow3)
        
        self.imgArrow3.alpha = 0
        self.imgArrow2.alpha = 0
        self.imgArrow1.alpha = 0
        
        UIView.animateWithDuration(2.0,
                                   delay: 1.0,
                                   options: UIViewAnimationOptions.CurveEaseInOut,
                                   animations: {
                                    
                                    self.viewCadets.alpha = 1
                                    
        }) { (finished: Bool) in
            
        }
        
        
        
        
        UIView.animateWithDuration(0.5,
                                   delay: 0.6,
                                   options: UIViewAnimationOptions.CurveEaseInOut,
                                   animations: {
                                    
                                    self.imgArrow3.frame = CGRectMake(self.imgArrow3.frame.origin.x + 10, self.imgArrow1.frame.origin.y, self.imgArrow1.frame.size.width, self.imgArrow1.frame.size.height)
                                    self.imgArrow3.alpha = 1
                                    
        }) { (finished: Bool) in
            
            UIView.animateWithDuration(0.5,
                                       delay: 0.0,
                                       options: [],
                                       animations: {
                                        
                                        self.imgArrow3.alpha = 0
                                        
            }) { (finished: Bool) in

            }
            
        }
        
        UIView.animateWithDuration(0.5,
                                   delay: 0.7,
                                   options: UIViewAnimationOptions.CurveEaseInOut,
                                   animations: {
                                    
                                    self.imgArrow2.frame = CGRectMake(self.imgArrow2.frame.origin.x + 10, self.imgArrow1.frame.origin.y, self.imgArrow1.frame.size.width, self.imgArrow1.frame.size.height)
                                    self.imgArrow2.alpha = 1
                                    
        }) { (finished: Bool) in
            
            UIView.animateWithDuration(0.5,
                                       delay: 0,
                                       options: [],
                                       animations: {
                                        
                                        self.imgArrow2.alpha = 0
                                        
            }) { (finished: Bool) in

            }
        }
        
        UIView.animateWithDuration(0.5,
                                   delay: 0.8,
                                   options: UIViewAnimationOptions.CurveEaseInOut,
                                   animations: {
                                    
                                    self.imgArrow1.frame = CGRectMake(self.imgArrow1.frame.origin.x + 10, self.imgArrow1.frame.origin.y, self.imgArrow1.frame.size.width, self.imgArrow1.frame.size.height)
                                    self.imgArrow1.alpha = 1
                                    
                                    
        }) { (finished: Bool) in
            
      
            
            UIView.animateWithDuration(0.5,
                                       delay: 0,
                                       options: [],
                                       animations: {
                                        
                                        self.imgArrow1.alpha = 0
                                        
            }) { (finished: Bool) in
                UIView.animateWithDuration(1.0, animations: {
                    
                    }, completion: { (finished: Bool) in
                        self.animate()
                })
               
            }
        }

        self.doMaskAnimation()
    }
    
    func doMaskAnimation() {
        
        let c: CadetsAnimation = CadetsAnimation()
        c.doMaskAnimation(self.imgC, repeat: true)
        
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
