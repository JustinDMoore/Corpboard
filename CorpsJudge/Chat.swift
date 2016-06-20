//
//  Chat.swift
//  CorpBoard
//
//  Created by Justin Moore on 6/20/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit



class Chat: NSObject {

    override init() {
        super.init()
    }
    
    func currentUTCTimeAsString() -> String {
        
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.stringFromDate(date)
    }
    
    func dateFromUTCString(UTC: String) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let x = dateFormatter.dateFromString(UTC)
        return x
        
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm"
//        let x = formatter.dateFromString(UTC) ?? nil
//        return x
    }
}
