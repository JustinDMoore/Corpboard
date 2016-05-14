//
//  StoreItemCell.swift
//  Corpboard
//
//  Created by Justin Moore on 9/9/15.
//  Copyright © 2015 Justin Moore. All rights reserved.
//

import UIKit
import ParseUI

class StoreItemCell: UICollectionViewCell {


    @IBOutlet weak var imgItem: PFImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblSalePrice: UILabel!

    override func awakeFromNib() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
