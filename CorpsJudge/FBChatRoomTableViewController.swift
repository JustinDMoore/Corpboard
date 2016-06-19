////
////  FBChatRoomTableViewController.swift
////  CorpBoard
////
////  Created by Justin Moore on 6/17/16.
////  Copyright © 2016 Justin Moore. All rights reserved.
////
//
//import UIKit
//import FirebaseDatabase
//import JSQMessagesViewController
//import FirebaseAuth
//
//class FBChatRoomTableViewController: UITableViewController, delegateNewChatRoom {
//
//    
//    let ref = FIRDatabase.database().reference()
//    var chatroomRef = FIRDatabaseReference()
//    var viewNewChatRoom = NewChatRoom()
//    var arrayOfChatRooms = [FIRDataSnapshot]()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
//        self.tableView.tableFooterView = UIView()
//        chatroomRef = ref.child("chatrooms")
//        observeChatRooms()
//    }
//    
//    override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(animated)
//        chatroomRef.removeAllObservers()
//    }
//    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        self.navigationController!.navigationBarHidden = false
//        self.navigationItem.setHidesBackButton(false, animated: false)
//        let backBtn = UISingleton.sharedInstance.getBackButton()
//        backBtn.addTarget(self, action: #selector(FBChatRoomTableViewController.goBack), forControlEvents: .TouchUpInside)
//        let backButton = UIBarButtonItem(customView: backBtn)
//        self.navigationItem.leftBarButtonItem = backButton
//        
//        let btnNewChatRoom = UIButton()
//        let imgNewChatRoom = UIImage(named: "Add")
//        btnNewChatRoom.addTarget(self, action: #selector(FBChatRoomTableViewController.addNewChatRoomView), forControlEvents: UIControlEvents.TouchUpInside)
//        btnNewChatRoom.setBackgroundImage(imgNewChatRoom, forState: UIControlState.Normal)
//        btnNewChatRoom.frame = CGRectMake(0, 0, 30, 30)
//        let newChatBarButton = UIBarButtonItem(customView: btnNewChatRoom)
//        self.navigationItem.rightBarButtonItem = newChatBarButton
//    }
//    
//    func goBack() {
//        self.navigationController?.popViewControllerAnimated(true)
//    }
//    
//    func addNewChatRoomView() {
//        if let viewNewChatRoom = NSBundle.mainBundle().loadNibNamed("NewChatRoom", owner: self, options: nil).first as? NewChatRoom {
//            viewNewChatRoom.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
//            viewNewChatRoom.delegate = self
//            viewNewChatRoom.showInParent(self.navigationController!)
//        }
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arrayOfChatRooms.count
//    }
//    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 104
//    }
//    
//    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 104
//    }
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//
//        var cell = tableView.dequeueReusableCellWithIdentifier("LiveChatCell")
//        if cell == nil {
//            let topLevelObjects = NSBundle.mainBundle().loadNibNamed("LiveChatCell", owner: self, options: nil)
//            cell = topLevelObjects.first as! LiveChatCell
//        }
//        
////        let d = JSQMessagesTimestampFormatter().timeForDate(room.updatedAt)
////        //let updated = room.lastMessageDate as NSDate
////        let updated = room.updatedAt ?? NSDate()
////        let diff = updated.minutesBeforeDate(NSDate())
////        //let diff = 5
////        var timeDiff = ""
////        if diff < 3 {
////            timeDiff = "Just Now"
////        } else if diff <= 50 {
////            timeDiff = "\(diff) min ago"
////        } else if diff > 50 && diff < 65 {
////            timeDiff = "An hour ago"
////        } else {
////            if updated.isYesterday() {
////                timeDiff = "Yesterday"
////            } else if updated.daysBeforeDate(NSDate()) == 2 {
////                timeDiff = "2 days ago"
////            } else if updated.isToday() {
////                timeDiff = d
////            } else {
////                let format = NSDateFormatter()
////                format.dateFormat = "MMMM d"
////                timeDiff = format.stringFromDate(updated)
////            }
////        }
////        
////        let lblLastUserHowLongAgo = cell?.viewWithTag(6) as! UILabel
////        let imgLastUser = cell?.viewWithTag(4) as! PFImageView
////        let lblLastUser = cell?.viewWithTag(5) as! UILabel
////        let lblStartedByUserAndWhen = cell?.viewWithTag(2) as! UILabel
////        let lblNumberOfMessagesAndViews = cell?.viewWithTag(3) as! UILabel
//        let lblChatName = cell?.viewWithTag(1) as! UILabel
////
////        lblLastUserHowLongAgo.text = timeDiff
////        
////        let imgfile = room.lastUserThumbnail
////        imgLastUser.file = imgfile as? PFFile
////        imgLastUser.loadInBackground()
////        
////        lblLastUser.text = room.lastUserNickname
////        imgLastUser.layer.cornerRadius = imgLastUser.frame.size.width / 2
////        imgLastUser.layer.borderColor = UIColor.whiteColor().CGColor
////        imgLastUser.layer.borderWidth = 1
////        
////        lblStartedByUserAndWhen.text = "\(room.createdByUserNickname)"
////        
////        var m = ""
////        if room.numberOfMessages == 1 {
////            m = "message"
////        } else {
////            m = "messages"
////        }
////        
////        var v = ""
////        if room.numberOfViews == 1 {
////            v = "view"
////        } else {
////            v = "views"
////        }
////        
////        lblNumberOfMessagesAndViews.text = "\(room.numberOfViews) \(v) - \(room.numberOfMessages) \(m)"
////        lblChatName.text = room.name
////        lblChatName.numberOfLines = 3
////        lblChatName.sizeToFit()
//        
//        
//        ////
//        let room = arrayOfChatRooms[indexPath.row]
//
//            lblChatName.text = room.childSnapshotForPath("topic").value as? String
//        
////        if let topic = room.childSnapshotForPath("lastMessage").value as? String {
////            cell.detailTextLabel?.text = topic
////            cell.textLabel?.textColor = UIColor.blackColor()
////        }
//        return cell!
//    }
//
//    private func observeChatRooms() {
//        let chatRoomsQuery = chatroomRef.queryLimitedToLast(50)
//        chatRoomsQuery.observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
//            self.arrayOfChatRooms.insert(snapshot, atIndex: 0)
//            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
//        })
//    }
//    
//    func newChatRoomCreated(topic: String) {
//        let itemRef = chatroomRef.childByAutoId()
//        let chatRoomItem = [
//            "topic": topic,
//            "lastMessage": "No messages yet.",
//        ]
//        itemRef.setValue(chatRoomItem)
//        //then segue to new room with room data
//    }
//}
