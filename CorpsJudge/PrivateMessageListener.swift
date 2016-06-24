//
//  PrivateMessageListener.swift
//  CorpBoard
//
//  Created by Justin Moore on 6/21/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

protocol delegatePrivateMessageListener: class {
    func newMessageReceived()
}

class PrivateMessageListener: NSObject {
    
    //MARK:-
    //MARK:SINGLETON DECLARATION
    static let sharedInstance = PrivateMessageListener()
    weak var delegate: delegatePrivateMessageListener?
    var refPrivateChatRooms = FIRDatabase.database().reference().child("Chat").child("privateChatRooms")
    var initialLoad = false
    var numberOfUnreadMessages = 0
    
    func listenForPrivateMessages() {
        if PUser.currentUser() != nil { //Make sure we have a user signed up and logged in
        let receivingUserId = PUser.currentUser()?.objectId
        refPrivateChatRooms = refPrivateChatRooms.child(receivingUserId!) //For all incoming chats from any user/thread specifically to current user
            
        startListening()
            
        } else {
            print("Private Message Listener: No user to listen for.")
        }
    }
    
    func stopListening() {
        refPrivateChatRooms.removeAllObservers()
    }
    
    func startListening() {
//    
//        
//        
//        // I THINK ALL WE NEED TO DO HERE IS NOTIFY THE USER OF AN INCOMING MESSAGE
//        // IF THE USER IS IN PRIVATE CHAT ROOM OR PRIVATE CHAT MESSAGE, THIS NEEDS TO BE DEACTIVATED
//        // BECAUSE THEY WILL SEE THE INCOMING MESSAGE THERE
//        
//        refPrivateChatRooms.observeEventType(.ChildAdded) { (snap: FIRDataSnapshot) in
//            
//            print("NEW MESSAGE")
//            
////            let room = Chatroom()
////            room.snapKey = snap.key
////            room.topic = snap.childSnapshotForPath(ChatroomFields.topic).value as? String ?? nil
////            let rawCreatedAt = snap.childSnapshotForPath(ChatroomFields.createdAt).value as? String ?? nil
////            if rawCreatedAt != nil {
////                room.createdAt = Chatroom().dateFromUTCString(rawCreatedAt!) ?? nil
////            }
////            
////            let rawUpdatedAt = snap.childSnapshotForPath(ChatroomFields.updatedAt).value as? String ?? nil
////            if rawUpdatedAt != nil {
////                room.updatedAt = Chatroom().dateFromUTCString(rawUpdatedAt!) ?? nil
////            }
////            
////            room.createdByUID = snap.childSnapshotForPath(ChatroomFields.createdByUID).value as? String ?? nil
////            room.createdByParseObjectId = snap.childSnapshotForPath(ChatroomFields.createdByParseObjectId).value as? String ?? nil
////            room.createdByNickname = snap.childSnapshotForPath(ChatroomFields.createdByNickname).value as? String ?? nil
////            
////            room.numberOfViewers = snap.childSnapshotForPath(ChatroomFields.numberOfViewers).value as? Int ?? 0
////            room.numberOfMessages = snap.childSnapshotForPath(ChatroomFields.numberOfMessages).value as? Int ?? 0
////            
////            room.lastMessage = snap.childSnapshotForPath(ChatroomFields.lastMessage).value as? String ?? nil
////            room.unreadMessagesForReceiver = snap.childSnapshotForPath(ChatroomFields.unreadMessagesForReceiver).value as? Bool ?? nil
////            
////            self.arrayOfPrivateChatRooms.insert(room, atIndex: 0)
////            
//            if self.initialLoad {
//                self.delegate?.newMessageReceived()
//            }
//        }
//        
//        refPrivateChatRooms.observeEventType(.Value) { (snap: FIRDataSnapshot) in
//            
//            print("NEW MESSAGE")
//            
////            if !self.initialLoad {
////                self.arrayOfPrivateChatRooms.removeAll()
////                
////                for snapRoom in snap.children {
////                    let room = Chatroom()
////                    room.snapKey = snapRoom.key
////                    room.topic = snapRoom.childSnapshotForPath(ChatroomFields.topic).value as? String ?? nil
////                    let rawCreatedAt = snapRoom.childSnapshotForPath(ChatroomFields.createdAt).value as? String ?? nil
////                    if rawCreatedAt != nil {
////                        room.createdAt = Chatroom().dateFromUTCString(rawCreatedAt!) ?? nil
////                    }
////                    
////                    let rawUpdatedAt = snapRoom.childSnapshotForPath(ChatroomFields.updatedAt).value as? String ?? nil
////                    if rawUpdatedAt != nil {
////                        room.updatedAt = Chatroom().dateFromUTCString(rawUpdatedAt!) ?? nil
////                    }
////                    
////                    room.createdByUID =           snapRoom.childSnapshotForPath(ChatroomFields.createdByUID).value           as? String ?? nil
////                    room.createdByParseObjectId = snapRoom.childSnapshotForPath(ChatroomFields.createdByParseObjectId).value as? String ?? nil
////                    room.createdByNickname =      snapRoom.childSnapshotForPath(ChatroomFields.createdByNickname).value      as? String ?? nil
////                    
////                    room.numberOfViewers =  snapRoom.childSnapshotForPath(ChatroomFields.numberOfViewers).value  as? Int    ?? 0
////                    room.numberOfMessages = snapRoom.childSnapshotForPath(ChatroomFields.numberOfMessages).value as? Int    ?? 0
////                    room.lastMessage =      snapRoom.childSnapshotForPath(ChatroomFields.lastMessage).value      as? String ?? nil
////                    room.unreadMessagesForReceiver = snap.childSnapshotForPath(ChatroomFields.unreadMessagesForReceiver).value as? Bool ?? nil
////                    
////                    self.arrayOfPrivateChatRooms.insert(room, atIndex: 0)
////                }
////            }
//
//            self.initialLoad = false
//        }
    }
}