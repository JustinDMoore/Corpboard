//
//  UISingleton.swift
//  CorpBoard
//
//  Created by Justin Moore on 5/11/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import Foundation
import UIKit

@objc class UISingleton: NSObject {
    
    static let sharedInstance = UISingleton()

    let maroon = UIColor(colorLiteralRed: 97/255.0, green: 22/255.0, blue: 26/255.0, alpha: 1)
    let gold = UIColor(colorLiteralRed: 199/255.0, green: 143/255.0, blue: 48/255.0, alpha: 1)
    let appTint = UIColor(colorLiteralRed: 0/255.0, green: 174/255.0, blue: 237/255.0, alpha: 1)
    //let appTint = UIColor.redColor()
    
    func getBackButton() -> UIButton {
        let backBtn = UIButton(type: .Custom)
        let backBtnImage = UIImage(named: "arrowLeft")
        backBtn.setBackgroundImage(backBtnImage, forState: .Normal)
        backBtn.frame = CGRectMake(0, 0, 30, 30)
        backBtn.tintColor = self.appTint
        return backBtn
    }
}