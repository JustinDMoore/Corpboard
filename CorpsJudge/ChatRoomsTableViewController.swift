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
import PulsingHalo

protocol delegateNearMeFromPrivateMessages: class {
    func nearMeFromPrivateMessages()
}

class ChatRoomsTableViewController: UITableViewController, delegateNewChatRoom {

    
    @IBOutlet weak var stackNoMessages: UIStackView!
    
    let publicChatRoomsRef = FIRDatabase.database().reference().child("Chat").child("PublicRooms")
    var privateChatRoomsRef = FIRDatabaseReference()
    var privateMessagesSenderRef = FIRDatabaseReference()
    
    var isPrivate = false
    var arrayOfChatRooms = [Chatroom]() // could be public or private
    var roomIdToOpen = ""
    //var viewNewChatRoom = NewChatRoom()
    var viewLoading = Loading()
    var initialLoad = true
    var creatingNewRoom = false
    var newRoomTopic: String?
    var receiverId: String?
    var viewEmptyChat = EmptyChat()
    
    weak var delegate: delegateNearMeFromPrivateMessages?
    
    //MARK:-
    //MARK: VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let viewEmptyChat = NSBundle.mainBundle().loadNibNamed("EmptyChat", owner: self, options: nil).first as? EmptyChat {
            self.tableView.backgroundView = viewEmptyChat
            self.tableView.backgroundView?.hidden = true
            if let btnNearMe = viewEmptyChat.viewWithTag(5) as? UIButton {
                btnNearMe.addTarget(self, action: #selector(ChatRoomsTableViewController.nearMe), forControlEvents: .TouchUpInside)
            }
        }
        
        self.tableView.backgroundColor = UIColor.blackColor()
        arrayOfChatRooms.removeAll()
        self.reload()
        loading()
        self.tableView.tableFooterView = UIView()
        if isPrivate {
            PrivateMessageListener.sharedInstance.stopListening()
            PFCloud.callFunctionInBackground("userTap", withParameters: ["tapped": "messages"])
            self.title = "Private Messages"
        } else {
            PFCloud.callFunctionInBackground("userTap", withParameters: ["tapped": "liveChat"])
            self.title = "Live Chat"
        }
    }
    
    override func viewWillAppear(animated: Bool) {

        
        if isPrivate {
            //Disable receiving notifications for private chats... because you're in private chats
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.showPushView = false
            
            privateChatRoomsRef = FIRDatabase.database().reference().child("Chat").child("PrivateRooms").child((PUser.currentUser()?.objectId!)!)
            startListeningForRef(privateChatRoomsRef)
        } else {
            startListeningForRef(publicChatRoomsRef)
        }
        
        self.navigationController!.navigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)
        let backBtn = UISingleton.sharedInstance.getBackButton()
        backBtn.addTarget(self, action: #selector(ChatRoomsTableViewController.goBack), forControlEvents: .TouchUpInside)
        let backButton = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backButton
        
        if !isPrivate {
            let btnNewChatRoom = UIButton()
            let imgNewChatRoom = UIImage(named: "Add")
            btnNewChatRoom.addTarget(self, action: #selector(ChatRoomsTableViewController.addNewChatRoomView), forControlEvents: UIControlEvents.TouchUpInside)
            btnNewChatRoom.setBackgroundImage(imgNewChatRoom, forState: UIControlState.Normal)
            btnNewChatRoom.frame = CGRectMake(0, 0, 30, 30)
            let newChatBarButton = UIBarButtonItem(customView: btnNewChatRoom)
            self.navigationItem.rightBarButtonItem = newChatBarButton
        }
        
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(index, animated: true)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.showPushView = true
        super.viewWillDisappear(animated)
        PrivateMessageListener.sharedInstance.startListening()
    }
    
    func loading() {
        viewLoading = NSBundle.mainBundle().loadNibNamed("Loading", owner: self, options: nil).first as! Loading
        self.navigationController?.view.addSubview(viewLoading)
        viewLoading.center = self.navigationController!.view.center
        viewLoading.animate()
    }
    
    func stopLoading() {
        viewLoading.removeFromSuperview()
        if self.arrayOfChatRooms.isEmpty { self.tableView.backgroundView?.hidden = false }
    }
    
    func newPrivateRoomCreated() {
        self.reload()
    }
    
    func startListeningForRef(ref: FIRDatabaseReference) {
        
        let roomsQuery = ref.queryOrderedByChild(ChatroomFields.updatedAt)
        
        roomsQuery.observeEventType(.ChildAdded) { (snap: FIRDataSnapshot) in
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
            room.privateChatWith = snap.childSnapshotForPath(ChatroomFields.privateChatWith).value as? String ?? nil
            
            self.arrayOfChatRooms.insert(room, atIndex: 0)
            
            if self.initialLoad {
                self.stopLoading()
                self.reload()
            }
        }
        
        ref.observeEventType(.Value) { (snap: FIRDataSnapshot) in
            
            if !self.initialLoad {
                self.arrayOfChatRooms.removeAll()
                
                for snapRoom in snap.children {
                    let room = Chatroom()
                    room.snapKey = snapRoom.key
                    room.topic = snapRoom.childSnapshotForPath(ChatroomFields.topic).value as? String ?? nil
                    let rawCreatedAt = snapRoom.childSnapshotForPath(ChatroomFields.createdAt).value as? String ?? nil
                    if rawCreatedAt != nil {
                        room.createdAt = Chatroom().dateFromUTCString(rawCreatedAt!) ?? NSDate()
                    } else {
                        room.createdAt = NSDate()
                    }
                    
                    let rawUpdatedAt = snapRoom.childSnapshotForPath(ChatroomFields.updatedAt).value as? String ?? nil
                    if rawUpdatedAt != nil {
                        room.updatedAt = Chatroom().dateFromUTCString(rawUpdatedAt!) ?? NSDate()
                    } else {
                        room.updatedAt = NSDate()
                    }
                    
                    room.createdByUID =           snapRoom.childSnapshotForPath(ChatroomFields.createdByUID).value           as? String ?? nil
                    room.createdByParseObjectId = snapRoom.childSnapshotForPath(ChatroomFields.createdByParseObjectId).value as? String ?? nil
                    room.createdByNickname =      snapRoom.childSnapshotForPath(ChatroomFields.createdByNickname).value      as? String ?? nil
                    
                    room.numberOfViewers =  snapRoom.childSnapshotForPath(ChatroomFields.numberOfViewers).value  as? Int    ?? 0
                    room.numberOfMessages = snapRoom.childSnapshotForPath(ChatroomFields.numberOfMessages).value as? Int    ?? 0
                    room.lastMessage =      snapRoom.childSnapshotForPath(ChatroomFields.lastMessage).value      as? String ?? nil
                    room.privateChatWith = snapRoom.childSnapshotForPath(ChatroomFields.privateChatWith).value      as? String ?? nil
                    
                    self.arrayOfChatRooms.insert(room, atIndex: 0)
                }
            }

            
            self.reload()
            self.stopLoading()
            self.initialLoad = false
        }
    }
    
    func reload() {
        if !arrayOfChatRooms.isEmpty {
            self.arrayOfChatRooms.sortInPlace({ $0.updatedAt!.compare($1.updatedAt!) == NSComparisonResult.OrderedDescending })
        }
        tableView.reloadData()
    }
    
    func stopListening() {
        privateChatRoomsRef.removeAllObservers()
        publicChatRoomsRef
        arrayOfChatRooms = [Chatroom]()
    }
    
    func addNewChatRoomView() {
        if let viewNewChatRoom = NSBundle.mainBundle().loadNibNamed("NewChatRoom", owner: self, options: nil).first as? NewChatRoom {
            viewNewChatRoom.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
            viewNewChatRoom.delegate = self
            viewNewChatRoom.showInParent(self.navigationController!)
        }
    }
    
    func goBack() {
        stopLoading()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if arrayOfChatRooms.isEmpty {
            return 0
        } else {
            tableView.backgroundView?.hidden = true
            return arrayOfChatRooms.count
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if arrayOfChatRooms.isEmpty {
            return self.view.frame.size.height
        } else {
            if isPrivate {
                return 125
            } else {
                return 100
            }
        }
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        if arrayOfChatRooms.isEmpty { return }
        var cell: UITableViewCell
        if isPrivate {
            cell = tableView.cellForRowAtIndexPath(indexPath) as! PrivateMessageCell
        } else {
            cell = tableView.cellForRowAtIndexPath(indexPath) as! LiveChatCell
        }
        setCellColor(UISingleton.sharedInstance.goldFade, cell: cell)
    }
    
    override func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        if arrayOfChatRooms.isEmpty { return }
        var cell: UITableViewCell
        if isPrivate {
            cell = tableView.cellForRowAtIndexPath(indexPath) as! PrivateMessageCell
        } else {
            cell = tableView.cellForRowAtIndexPath(indexPath) as! LiveChatCell
        }
        setCellColor(UIColor.blackColor(), cell: cell)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if isPrivate && !arrayOfChatRooms.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if isPrivate {
                
                let room = arrayOfChatRooms[indexPath.row]
                receiverId = room.privateChatWith
                
                var sendId = ""
                if PUser.currentUser()?.objectId != nil {
                    sendId = (PUser.currentUser()?.objectId)!
                }
                
                var recId = ""
                if room.privateChatWith != nil {
                    recId = room.privateChatWith!
                }

                //Delete the selected room
                let refToDelete = privateChatRoomsRef.child("\(sendId)\(recId)")
                refToDelete.removeValue()
                
                //Delete messages
                privateMessagesSenderRef = FIRDatabase.database().reference().child("Chat").child("PrivateMessages").child("\(sendId)\(recId)")
                privateMessagesSenderRef.removeValue()
            }
        }
    }
    
    func setCellColor(color: UIColor, cell: UITableViewCell) {
        //cell.contentView.backgroundColor = color
        cell.backgroundColor = color
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if arrayOfChatRooms.isEmpty {
            if let cell = tableView.dequeueReusableCellWithIdentifier("noMessages") {
                let btnNearMe = cell.viewWithTag(5) as! UIButton
                btnNearMe.addTarget(self, action: #selector(ChatRoomsTableViewController.nearMe), forControlEvents: .TouchUpInside)
                return cell
            }
        } else {
            if isPrivate {
                return privateTableView(tableView, cellForRowAtIndexPath: indexPath)
            } else {
                return publicTableView(tableView, cellForRowAtIndexPath: indexPath)
            }
        }
        return UITableViewCell()
    }
    
    func privateTableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Create the cell
        var cell = tableView.dequeueReusableCellWithIdentifier("privateCell")
        if cell == nil {
            let topLevelObjects = NSBundle.mainBundle().loadNibNamed("PrivateMessageCell", owner: self, options: nil)
            cell = topLevelObjects.first as! PrivateMessageCell
        }
        
        // Chatroom reference
        let chatRoom = arrayOfChatRooms[indexPath.row]
        
        // New message indicator
        let btnNew = cell?.viewWithTag(1) as! UIButton
        btnNew.tintColor = UISingleton.sharedInstance.gold
        if chatRoom.numberOfMessages > 0 {
            btnNew.setImage(UIImage(named: "newMessage"), forState: .Normal)
        } else {
            btnNew.setImage(nil, forState: .Normal)
        }
        
        // Sender nickname and image
        let imgUser = cell?.viewWithTag(2) as! PFImageView
        imgUser.frame = CGRectMake(imgUser.frame.origin.x, imgUser.frame.origin.y, 100, 100)
        imgUser.layer.cornerRadius = imgUser.frame.size.height / 2
        imgUser.layer.borderWidth = 2
        imgUser.layer.borderColor = UIColor.whiteColor().CGColor
        imgUser.clipsToBounds = true
        
        let lblUser = cell?.viewWithTag(3) as! UILabel
        let query = PFQuery(className: PUser.parseClassName())
        if let id = chatRoom.privateChatWith {
            query.whereKey("objectId", equalTo: id)
            query.limit = 1
            query.findObjectsInBackgroundWithBlock { (users: [PFObject]?, err: NSError?) in
                if err == nil {
                    if let user = users?.first as? PUser {
                        lblUser.text = " \(user.nickname)"
                        lblUser.sizeToFit()
                        if user.picture != nil {
                            imgUser.file = user.picture
                            imgUser.loadInBackground()
                        }
                        
                        var array = [PulsingHaloLayer]()
                        for layer: CALayer in cell!.layer.sublayers! {
                            if layer.isKindOfClass(PulsingHaloLayer) {
                                array.append(layer as! PulsingHaloLayer)
                            }
                        }
                        
                        for layer in array {
                            layer.removeFromSuperlayer()
                        }
                        
                        // Online Now?
                        if self.userOnlineNow(user) {
                            imgUser.layer.borderWidth = 3;
                            imgUser.layer.borderColor = UIColor(colorLiteralRed: 0.188, green: 0.549, blue: 0.149, alpha: 1).CGColor
                            let halo = PulsingHaloLayer()
                            halo.radius = 75
                            halo.animationDuration = 3
                            halo.haloLayerNumber = 8
                            halo.backgroundColor = UIColor.greenColor().CGColor
                            imgUser.superview!.layer.insertSublayer(halo, atIndex: 0)
                            halo.position = imgUser.center
                            halo.start()
                        }
                    } else {
                        lblUser.text = "Unknown User"
                    }
                } else {
                    lblUser.text = "Unknown User"
                }
            }
        }
        
        // Last message received
        let lblLastMessage = cell?.viewWithTag(4) as! UILabel
        if let message = chatRoom.lastMessage {
            lblLastMessage.text = message
        } else {
            lblLastMessage.text = ""
        }
        
        // How long ago
        let lblHowLongAgo = cell?.viewWithTag(5) as! UILabel
        let updated = chatRoom.updatedAt ?? NSDate()
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
                timeDiff = JSQMessagesTimestampFormatter().timeForDate(chatRoom.updatedAt)
            } else {
                let format = NSDateFormatter()
                format.dateFormat = "MMMM d"
                timeDiff = format.stringFromDate(updated)
            }
        }
        lblHowLongAgo.text = "\(timeDiff)"
        
        // Return the cell
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
        
        let room = arrayOfChatRooms[indexPath.row]
        
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
        if arrayOfChatRooms.isEmpty { return }
        var room: Chatroom
        room = arrayOfChatRooms[indexPath.row]
        roomIdToOpen = room.snapKey
        receiverId = room.privateChatWith
        performSegueWithIdentifier("chat", sender: self)
    }
    
    func newChatRoomCreated(topic: String) {
        creatingNewRoom = true
        newRoomTopic = topic
        self.performSegueWithIdentifier("chat", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "chat" {
            let vc = segue.destinationViewController as? ChatViewController
            vc?.roomId = roomIdToOpen
            vc?.isPrivate = isPrivate
            vc?.isNewPublicRoom = creatingNewRoom
            vc?.newRoomTopic = newRoomTopic
            vc?.receiverId = receiverId ?? nil
            creatingNewRoom = false
        }
    }
    
    func blankMessage() -> ChatMessage {
        let message = ChatMessage()
        message.createdByParseObjectId = PUser.currentUser()?.objectId!
        message.createdByNickname = PUser.currentUser()?.nickname
        message.createdByUID = FIRAuth.auth()?.currentUser?.uid
        message.createdAt = NSDate()
        return message
    }
    
    func userOnlineNow(user: PUser) -> Bool {
        let dateLastLogin = user.lastLogin
        let diff = dateLastLogin.minutesBeforeDate(NSDate())
        if diff <= 10 { // Online now (within last 10 minutes)
            return true
        } else {
            return false
        }
    }
    
    func nearMe() {
        goBack()
        delegate?.nearMeFromPrivateMessages()
    }
}
