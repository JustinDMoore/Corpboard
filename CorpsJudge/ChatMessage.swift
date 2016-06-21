//
//  ChatMessage.swift
//  CorpBoard
//
//  Created by Justin Moore on 6/20/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit

struct ChatMessageFields {
    static let message = "message"
    static let type = "messageType"
    static let createdAt = "createdAt"
    static let createdByParseObjectId = "createdByParseObjectId"
    static let createdByNickname = "createdByNickname"
    static let createdByUID = "createdByUID"
    static let file = "file"
}

class ChatMessage: Chat {
    
    var message: String?
    var type = "NOT SET"
    var createdAt: NSDate?
    var createdByParseObjectId: String?
    var createdByNickname: String?
    var createdByUID: String?
    var file: String?

    var snapKey = String()
    
    override init() {
        
    }
    
    func parseDuration(timeString:String) -> NSTimeInterval {
        guard !timeString.isEmpty else {
            return 0
        }
        
        var interval:Double = 0
        
        let parts = timeString.componentsSeparatedByString(":")
        for (index, part) in parts.reverse().enumerate() {
            interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
        }
        
        return interval
    }
}