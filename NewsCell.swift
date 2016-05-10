//
//  NewsCell.swift
//  Corpboard
//
//  Created by Justin Moore on 5/9/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit

class NewsCell: UICollectionViewCell {
    
    //MARK:-
    //MARK:Properties
    var link = ""
    var colorNumber = 0
    
    //MARK:-
    //MARK:Outlets
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgLogo: UIImageView!

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let arrayOfViews = NSBundle.mainBundle().loadNibNamed("NewsCell", owner: self, options: nil)
        if arrayOfViews.count < 1 {
            
        }
    }
}
