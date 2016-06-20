//
//  ChatRoomsTableViewController.swift
//  CorpBoard
//
//  Created by Justin Moore on 6/16/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit
import ParseLiveQuery
import JSQMessagesViewController
import ParseUI
import AFDateHelper

class ChatRoomsTableViewController: UITableViewController, delegateNewChatRoom {

    var isPrivate = false
    var arrayOfChatRooms = [PRoom]()
    var chatRoomToOpen = PRoom()
    var viewNewChatRoom = NewChatRoom()
    let query = PFQuery(className: PRoom.parseClassName())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        if isPrivate {
            self.title = "Private Messages"
        } else {
            self.title = "Chat Rooms"
        }
    }

    override func viewWillAppear(animated: Bool) {
        
        getExistingRooms()
        
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
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfChatRooms.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 104
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 104
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
        
        let chatRoom = arrayOfChatRooms[indexPath.row]
        
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
        
        let room = arrayOfChatRooms[indexPath.row]
        
        let d = JSQMessagesTimestampFormatter().timeForDate(room.updatedAt)
        //let updated = room.lastMessageDate as NSDate
        let updated = room.updatedAt ?? NSDate()
        let diff = updated.minutesBeforeDate(NSDate())
        //let diff = 5
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
                timeDiff = d
            } else {
                let format = NSDateFormatter()
                format.dateFormat = "MMMM d"
                timeDiff = format.stringFromDate(updated)
            }
        }
        
        let lblChatName = cell?.viewWithTag(1) as! UILabel
        let lblCreatedByWhen = cell?.viewWithTag(2) as! UILabel
        let lblUpdatedAt = cell?.viewWithTag(3) as! UILabel
        let imgCreatedby = cell?.viewWithTag(4) as! PFImageView

        lblChatName.text = room.name
        lblCreatedByWhen.text = "by \(room.authorName) | \(JSQMessagesTimestampFormatter().timeForDate(room.createdAt))"
        lblUpdatedAt.text = "updated \(timeDiff)"
        let author = room.author
        author.fetchIfNeededInBackgroundWithBlock { (auth: PFObject?, err: NSError?) in
            if let imageFile = author.thumbnail {
                imgCreatedby.file = imageFile
                imgCreatedby.loadInBackground()
            }
        }

        
        
//        let imgfile = room.lastUserThumbnail
//        imgLastUser.file = imgfile as? PFFile
//        imgLastUser.loadInBackground()
//
//        lblLastUser.text = room.lastUserNickname
//        imgLastUser.layer.cornerRadius = imgLastUser.frame.size.width / 2
//        imgLastUser.layer.borderColor = UIColor.whiteColor().CGColor
//        imgLastUser.layer.borderWidth = 1
//
//        lblStartedByUserAndWhen.text = "\(room.createdByUserNickname)"
//
//        var m = ""
//        if room.numberOfMessages == 1 {
//            m = "message"
//        } else {
//            m = "messages"
//        }
//        
//        var v = ""
//        if room.numberOfViews == 1 {
//            v = "view"
//        } else {
//            v = "views"
//        }
//        
//        lblNumberOfMessagesAndViews.text = "\(room.numberOfViews) \(v) - \(room.numberOfMessages) \(m)"
//        lblChatName.text = room.name
//        lblChatName.numberOfLines = 3
//        lblChatName.sizeToFit()
        
        return cell!
    }
    
    func getExistingRooms() {
        arrayOfChatRooms.removeAll()
        query.whereKey("isPrivate", equalTo: false)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, err: NSError?) in
            if err == nil {
                if let chatRooms = objects as? [PRoom] {
                    for room in chatRooms {
                        self.arrayOfChatRooms.append(room)
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        chatRoomToOpen = arrayOfChatRooms[indexPath.row]
        performSegueWithIdentifier("chat", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "chat" {
            let vc = segue.destinationViewController as? ChatViewController
            vc?.roomToConnect = chatRoomToOpen
            vc?.isPrivate = isPrivate
        }
    }
    
    func newChatRoomCreated(topic: String) {
        
    }
}
