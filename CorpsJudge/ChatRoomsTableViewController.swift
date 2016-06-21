//
//  ChatRoomsTableViewController.swift
//  CorpBoard
//
//  Created by Justin Moore on 6/16/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import ParseUI
import AFDateHelper
import Firebase

class ChatRoomsTableViewController: UITableViewController, delegateNewChatRoom {

    
    let chatroomsRef = FIRDatabase.database().reference().child("publicChatRooms")
    

    var isPrivate = false
    var chatrooms = [Chatroom]()
    var roomIdToOpen = ""
    //var viewNewChatRoom = NewChatRoom()
    var viewLoading = Loading()
    var initialLoad = true
    
    func loading() {
        viewLoading = NSBundle.mainBundle().loadNibNamed("Loading", owner: self, options: nil).first as! Loading
        self.navigationController?.view.addSubview(viewLoading)
        viewLoading.center = self.view.center
        viewLoading.animate()
    }
    
    func stopLoading() {
        viewLoading.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loading()
        self.tableView.tableFooterView = UIView()
        if isPrivate {
            self.title = "Private Messages"
        } else {
            self.title = "Chat Rooms"
        }
    }
    
    func startListening() {
        chatroomsRef.observeEventType(.ChildAdded) { (snap: FIRDataSnapshot) in
            
            let room = Chatroom()
            room.snapKey = snap.key
            room.topic = snap.childSnapshotForPath(ChatroomFields.topic).value as? String ?? nil
            let rawCreatedAt = snap.childSnapshotForPath(ChatroomFields.createdAt).value as? String ?? nil
            if rawCreatedAt != nil {
                room.createdAt = Chatroom().dateFromUTCString(rawCreatedAt!) ?? nil
            }
            
            let rawUpdatedAt = snap.childSnapshotForPath(ChatroomFields.updatedAt).value as? String ?? nil
            if rawUpdatedAt != nil {
                room.updatedAt = Chatroom().dateFromUTCString(rawUpdatedAt!) ?? nil
            }
            
            room.createdByUID = snap.childSnapshotForPath(ChatroomFields.createdByUID).value as? String ?? nil
            room.createdByParseObjectId = snap.childSnapshotForPath(ChatroomFields.createdByParseObjectId).value as? String ?? nil
            room.createdByNickname = snap.childSnapshotForPath(ChatroomFields.createdByNickname).value as? String ?? nil
            
            room.numberOfViewers = snap.childSnapshotForPath(ChatroomFields.numberOfViewers).value as? Int ?? 0
            room.numberOfMessages = snap.childSnapshotForPath(ChatroomFields.numberOfMessages).value as? Int ?? 0
            
            room.lastMessage = snap.childSnapshotForPath(ChatroomFields.lastMessage).value as? String ?? nil
            
            self.chatrooms.insert(room, atIndex: 0)
            
            if self.initialLoad {
                self.stopLoading()
                self.tableView.reloadData()
            }
        }
        
        chatroomsRef.observeEventType(.Value) { (snap: FIRDataSnapshot) in
            
            if !self.initialLoad {
                self.chatrooms.removeAll()
                
                for snapRoom in snap.children {
                    let room = Chatroom()
                    room.snapKey = snapRoom.key
                    room.topic = snapRoom.childSnapshotForPath(ChatroomFields.topic).value as? String ?? nil
                    let rawCreatedAt = snapRoom.childSnapshotForPath(ChatroomFields.createdAt).value as? String ?? nil
                    if rawCreatedAt != nil {
                        room.createdAt = Chatroom().dateFromUTCString(rawCreatedAt!) ?? nil
                    }
                    
                    let rawUpdatedAt = snapRoom.childSnapshotForPath(ChatroomFields.updatedAt).value as? String ?? nil
                    if rawUpdatedAt != nil {
                        room.updatedAt = Chatroom().dateFromUTCString(rawUpdatedAt!) ?? nil
                    }
                    
                    room.createdByUID =           snapRoom.childSnapshotForPath(ChatroomFields.createdByUID).value           as? String ?? nil
                    room.createdByParseObjectId = snapRoom.childSnapshotForPath(ChatroomFields.createdByParseObjectId).value as? String ?? nil
                    room.createdByNickname =      snapRoom.childSnapshotForPath(ChatroomFields.createdByNickname).value      as? String ?? nil
                    
                    room.numberOfViewers =  snapRoom.childSnapshotForPath(ChatroomFields.numberOfViewers).value  as? Int    ?? 0
                    room.numberOfMessages = snapRoom.childSnapshotForPath(ChatroomFields.numberOfMessages).value as? Int    ?? 0
                    room.lastMessage =      snapRoom.childSnapshotForPath(ChatroomFields.lastMessage).value      as? String ?? nil
                    
                    self.chatrooms.insert(room, atIndex: 0)
                }
            }
            
            self.tableView.reloadData()
            self.stopLoading()
            self.initialLoad = false
        }
    }
    
    func stopListening() {
        chatroomsRef.removeAllObservers()
        chatrooms = [Chatroom]()
    }
    
    override func viewWillAppear(animated: Bool) {
        
       startListening()
        
        self.navigationController!.navigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)
        let backBtn = UISingleton.sharedInstance.getBackButton()
        backBtn.addTarget(self, action: #selector(ChatRoomsTableViewController.goBack), forControlEvents: .TouchUpInside)
        let backButton = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backButton
        
        let btnNewChatRoom = UIButton()
        let imgNewChatRoom = UIImage(named: "Add")
        btnNewChatRoom.addTarget(self, action: #selector(ChatRoomsTableViewController.addNewChatRoomView), forControlEvents: UIControlEvents.TouchUpInside)
        btnNewChatRoom.setBackgroundImage(imgNewChatRoom, forState: UIControlState.Normal)
        btnNewChatRoom.frame = CGRectMake(0, 0, 30, 30)
        let newChatBarButton = UIBarButtonItem(customView: btnNewChatRoom)
        self.navigationItem.rightBarButtonItem = newChatBarButton
        
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(index, animated: true)
        }
    }
    
    func addNewChatRoomView() {
        if let viewNewChatRoom = NSBundle.mainBundle().loadNibNamed("NewChatRoom", owner: self, options: nil).first as? NewChatRoom {
            viewNewChatRoom.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
            viewNewChatRoom.delegate = self
            viewNewChatRoom.showInParent(self.navigationController!)
        }
    }
    
    func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        stopListening()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatrooms.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! LiveChatCell
        setCellColor(UISingleton.sharedInstance.goldFade, cell: cell)
        
    }
    
    override func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! LiveChatCell
        setCellColor(UIColor.blackColor(), cell: cell)
    }
    
    func setCellColor(color: UIColor, cell: UITableViewCell) {
        //cell.contentView.backgroundColor = color
        cell.backgroundColor = color
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if isPrivate {
            return privateTableView(tableView, cellForRowAtIndexPath: indexPath)
        } else {
            return publicTableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    func privateTableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("privateCell")
        if cell == nil {
            let topLevelObjects = NSBundle.mainBundle().loadNibNamed("PrivateMessageCell", owner: self, options: nil)
            cell = topLevelObjects.first as! PrivateMessageCell
        }
        
        let imgNew = cell?.viewWithTag(2) as! UIImageView
        let lblUser = cell?.viewWithTag(3) as! UILabel
        let lblLastMessageHidden = cell?.viewWithTag(5) as! UILabel
        lblLastMessageHidden.hidden = true
        
        let chatRoom = chatrooms[indexPath.row]
        let topic = chatRoom.topic

        var userChattingWith: PUser?
        var numberOfUnreadMessages = 0
//        if chatRoom.createdBy == PUser.currentUser() {
//            numberOfUnreadMessages = chatRoom.createdByCounter
//            if let user = chatRoom.toUser {
//                userChattingWith = user
//            }
//        } else {
//            numberOfUnreadMessages = chatRoom.toUserCounter
//            userChattingWith = chatRoom.createdBy
//        }
        
        if numberOfUnreadMessages > 0 {
            imgNew.hidden = false
        } else {
            imgNew.hidden = true
        }
        
        if userChattingWith != nil {
            lblUser.text = userChattingWith!.nickname
        } else {
            lblUser.text = "Unknown User"
        }
        lblUser.sizeToFit()
        
        //clears the old message label
        for view in (cell?.subviews)! {
            if view.tag == 10 { view.removeFromSuperview() }
        }
        
        let lblLastMessage = UILabel(frame: CGRectMake(30, 45, 282, 41))
        lblLastMessage.tag = 10
        //lblLastMessage.text = chatRoom.lastMessage
        lblLastMessage.textColor = UIColor.lightGrayColor()
        lblLastMessage.font = UIFont.systemFontOfSize(14)
        lblLastMessage.numberOfLines = 2
        lblLastMessage.sizeToFit()
        cell?.addSubview(lblLastMessage)
        
        if cell != nil { return cell! }
        else {
            print("Error creating UITableViewCell")
            return UITableViewCell()
        }
    }
    
    func publicTableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("LiveChatCell")
        if cell == nil {
            let topLevelObjects = NSBundle.mainBundle().loadNibNamed("LiveChatCell", owner: self, options: nil)
            cell = topLevelObjects.first as! LiveChatCell
        }
        
        let room = chatrooms[indexPath.row]
        
        let updated = room.updatedAt ?? NSDate()
        let diff = updated.minutesBeforeDate(NSDate())
        var timeDiff = ""
        if diff < 3 {
            timeDiff = "Just Now"
        } else if diff <= 50 {
            timeDiff = "\(diff) min ago"
        } else if diff > 50 && diff < 65 {
            timeDiff = "An hour ago"
        } else {
            if updated.isYesterday() {
                timeDiff = "Yesterday"
            } else if updated.daysBeforeDate(NSDate()) == 2 {
                timeDiff = "2 days ago"
            } else if updated.isToday() {
                timeDiff = JSQMessagesTimestampFormatter().timeForDate(room.updatedAt)
            } else {
                let format = NSDateFormatter()
                format.dateFormat = "MMMM d"
                timeDiff = format.stringFromDate(updated)
            }
        }

        let lblTopic = cell?.viewWithTag(1) as! UILabel
        let lblLastMessage = cell?.viewWithTag(2) as! UILabel
        let lblHowLongAgo = cell?.viewWithTag(3) as! UILabel
        let lblNumberOfViewers = cell?.viewWithTag(4) as! UILabel
        let lblNumberOfMessages = cell?.viewWithTag(5) as! UILabel
        
        lblTopic.text = room.topic
        lblHowLongAgo.text = "\(timeDiff)"
        lblLastMessage.text = room.lastMessage ?? "No messages yet"
        
        var viewers = ""
        if room.numberOfViewers == 1 {
            viewers = " 1 Live Viewer"
        } else {
            viewers = " \(room.numberOfViewers) Live Viewers"
        }
        
        let btnNumberOfViewers = cell?.viewWithTag(11) as! UIButton
        if room.numberOfViewers > 0 {
            btnNumberOfViewers.tintColor = UISingleton.sharedInstance.gold
            let attributedString = NSMutableAttributedString(string: viewers as String, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12)])
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UISingleton.sharedInstance.gold, range: NSRange(location:0,length:viewers.characters.count))
            lblNumberOfViewers.attributedText = attributedString
        } else {
            btnNumberOfViewers.tintColor = UIColor.lightGrayColor()
            lblNumberOfViewers.text = viewers
            lblNumberOfViewers.textColor = UIColor.lightGrayColor()
        }
        
        if room.numberOfMessages == 1 {
            lblNumberOfMessages.text = "1 Message"
        } else {
            lblNumberOfMessages.text = "\(room.numberOfMessages) Messages"
        }
        
        return cell!
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let room = chatrooms[indexPath.row]
        roomIdToOpen = room.snapKey
        performSegueWithIdentifier("chat", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "chat" {
            let vc = segue.destinationViewController as? ChatViewController
            vc?.roomId = roomIdToOpen
            vc?.isPrivate = isPrivate
        }
    }
    
    func newChatRoomCreated(topic: String) {
        let uid = FIRAuth.auth()?.currentUser?.uid
        let roomRef = chatroomsRef.childByAutoId()
        let newRoom: NSDictionary = [
            ChatroomFields.topic : topic,
            ChatroomFields.createdAt : Chatroom().currentUTCTimeAsString(),
            ChatroomFields.createdByNickname : PUser.currentUser()!.nickname,
            ChatroomFields.createdByParseObjectId : PUser.currentUser()!.objectId!,
            ChatroomFields.createdByUID : uid!,
            ChatroomFields.numberOfMessages : NSNumber(int: 0),
            ChatroomFields.numberOfViewers : NSNumber(int: 0),
            ChatroomFields.updatedAt : Chatroom().currentUTCTimeAsString(),
            //ChatroomFields.updatedByUID : uid!,
            //ChatroomFields.updatedByNickname : PUser.currentUser()!.nickname,
            //ChatroomFields.updatedByParseObjectId : PUser.currentUser()!.objectId!,
        ]
        roomRef.setValue(newRoom) // 3
    }
}
