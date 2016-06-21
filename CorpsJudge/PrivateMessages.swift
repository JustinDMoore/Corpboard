//
//  PrivateMessages.swift
//  CorpBoard
//
//  Created by Justin Moore on 6/21/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

//TODO: Remove @objc
@objc class PrivateMessages: NSObject {
    
    //MARK:-
    //MARK:SINGLETON DECLARATION
    static let sharedInstance = PrivateMessages()
    
    var refPrivateChatRooms = FIRDatabase.database().reference().child("privateChatRooms")
    
    func listenForPrivateMessages() {
        
    }

}