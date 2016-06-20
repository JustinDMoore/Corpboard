//
//  Chatroom.swift
//  CorpBoard
//
//  Created by Justin Moore on 6/20/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit

struct ChatroomFields {
    static let topic = "topic"
    static let createdAt = "createdAt"
    static let createdByParseObjectId = "createdByParseObjectId"
    static let createdByNickname = "createdByNickname"
    static let createdByUID = "createdByUID"
    static let numberOfMessages = "numberOfMessages"
    static let numberOfViewers = "numberOfViewers"
    static let updatedAt = "updatedAt"
//    static let updatedByNickname = "updatedByNickname"
//    static let updatedByParseObjectId = "updatedByParseObjectId"
//    static let updatedByUID = "updatedbyUID"
    static let lastMessage = "lastMessage"

}

class Chatroom: Chat {
    
    var topic: String?
    var lastMessage: String?
    var numberOfMessages: Int = 0
    var numberOfViewers: Int = 0
    
    var createdAt: NSDate?
    var createdByParseObjectId: String?
    var createdByNickname: String?
    var createdByUID: String?
    
    var updatedAt: NSDate?
//    var updatedByParseObjectId: String?
//    var updatedByNickname: String?
//    var updatedByUID: String?
    
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
