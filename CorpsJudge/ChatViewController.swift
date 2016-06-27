//
//  ChatViewController.swift
//  CorpBoard
//
//  Created by Justin Moore on 6/17/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import RNGridMenu
import Firebase
import IQKeyboardManager
import FirebaseStorage

class ChatViewController: JSQMessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, IQAudioRecorderViewControllerDelegate, UITextFieldDelegate, delegateUserLocation {
    
    let refStorage = FIRStorage.storage().referenceForURL("gs://corpsboard-3111c.appspot.com")
    
    var profileToOpen: PUser?
    var roomInitialized = false
    
    var usersTypingQuery: FIRDatabaseQuery!
    private var localTyping = false
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            localTyping = newValue
            userIsTypingSetRef.setValue(newValue)
        }
    }
    
    // PUBLIC ROOMS/MESSAGES
    var publicRoomRef = FIRDatabaseReference()
    var publicMessagesRef = FIRDatabaseReference()
    
    // PRIVATE ROOMS/MESSAGES
    
    //CHAT/PRIVATE/RECEIVER
    //CHAT/PRIVATE/SENDER
    //CHAT/PRIVATE/RECEIVER/SENDER
    //CHAT/PRIVATE/SENDER/RECEIVER
    var privateRoomSenderRef = FIRDatabaseReference()
    var privateRoomReceiverRef = FIRDatabaseReference()
    var privateMessagesSenderRef = FIRDatabaseReference()
    var privateMessagesReceiverRef = FIRDatabaseReference()
    var userIsTypingSetRef = FIRDatabaseReference()
    var userIsTypingReadRef = FIRDatabaseReference()
    
    
    var roomId: String?
    var isPrivate = false
    var newRoomTopic: String?
    var isNewPublicRoom = false
    var privateRoomInitialized = false
    var publicRoomInitialized = false

    var viewLoading = Loading()
    var isLoading = true
    var initialLoad = true
    var ready = false
    var arrayOfDownloads = [JSQMessage]()
    var viewLocationForDelegate = LocationServicesPermission()
    var receiverId: String?
    
    //var dictOfMessages = [String: JSQMessage]()
    var arrayOfJSQMessages = [JSQMessage]()
    var arrayOfSnapKeys = [String]() // This holds objectIds of PChatMessage
                                        // When a user sends a message, add the JSQMessage to arrayOfMessages
                                        // On parse save completion, get the objectId of PChatMessage and save it to arrayOfMessageIds
                                        // When the newly saved message is returned by the live query
                                        // Check to make sure the objectId doesn't exist in arrayOfMessageIds before adding it to the datasource
                                        // This prevents duplicate messages, while adding immediate response for sending larger messages with data
    var arrayOfAvatars = [String : JSQMessagesAvatarImage]()
    var outgoingBubbleWithTail: JSQMessagesBubbleImage!
    var incomingBubbleWithTail: JSQMessagesBubbleImage!
    var outgoingBubbleWithoutTail: JSQMessagesBubbleImage!
    var incomingBubbleWithoutTail: JSQMessagesBubbleImage!
    var placeholderImageData = JSQMessagesAvatarImage(avatarImage: UIImage(named: "defaultProfilePicture"), highlightedImage: UIImage(named: "defaultProfilePicture"), placeholderImage: UIImage(named: "defaultProfilePicture"))
    
    //MARK:-
    //MARK: VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        Server.sharedInstance.delegateLocation = self
        self.automaticallyScrollsToMostRecentMessage = true
        self.senderId = PUser.currentUser()?.objectId
        self.senderDisplayName = PUser.currentUser()!.nickname
        self.collectionView.backgroundColor = UIColor.blackColor()
        self.view.backgroundColor = UIColor.blackColor()
        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeMake(50, 50)
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeMake(50, 50)
        self.collectionView.collectionViewLayout.springinessEnabled = false
        self.inputToolbar.tintColor = UISingleton.sharedInstance.gold
        self.inputToolbar.contentView.rightBarButtonItem.setTitleColor(UISingleton.sharedInstance.gold, forState: .Normal)
        let btnAttachment = UIButton(type: .Custom)
        btnAttachment.frame = CGRectMake(0, 0, 35, 45)
        btnAttachment.setImage(UIImage(named: "attachment"), forState: .Normal)
        btnAttachment.addTarget(self, action: #selector(ChatViewController.didPressAccessoryButton(_:)), forControlEvents: .TouchUpInside)
        btnAttachment.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        self.inputToolbar.contentView.leftBarButtonItem = btnAttachment
        setupBubbles()
        arrayOfJSQMessages.removeAll()
        arrayOfDownloads.removeAll()
        arrayOfSnapKeys.removeAll()
        arrayOfAvatars.removeAll()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)
        let backBtn = UISingleton.sharedInstance.getBackButton()
        backBtn.addTarget(self, action: #selector(DailyScheduleViewController.goBack), forControlEvents: .TouchUpInside)
        let backButton = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backButton
        
        if isPrivate {
            loading()
            self.title = "Private Messages"
            setReferences()
            //If sender room exists, display it
            privateRoomSenderRef.observeSingleEventOfType(.Value) { (snap: FIRDataSnapshot) in
                if snap.exists() {
                    self.startListening()
                    self.observeTyping()
                    //Reset unread messages to 0
                    self.privateRoomSenderRef.child(ChatroomFields.numberOfMessages).setValue(NSNumber(int: 0))
                }
                //else do nothing until message is sent
                self.stopLoading()
            }
        } else {
            self.title = "Live Chat"
            if isNewPublicRoom {
                publicRoomInitialized = false
                // Do nothing, we wait for first message to init the room
                stopLoading()
            } else {
                loading()
                setReferences()
                startListening()
                updateViewerCounterForRef(publicRoomRef, increment: true)
                publicRoomInitialized = true
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        ready = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        stopListening()
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        updateViewerCounterForRef(publicRoomRef, increment: false)
        PrivateMessageListener.sharedInstance.startListening()
        profileToOpen = nil
    }
    
    func goBack() {
        stopListening()
        arrayOfSnapKeys.removeAll()
        arrayOfJSQMessages.removeAll()
        arrayOfAvatars.removeAll()
        arrayOfDownloads.removeAll()
        self.collectionView.reloadData()
        self.inputToolbar.contentView.textView.resignFirstResponder()
        stopLoading()
        initialLoad = true
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK:-
    //MARK: INITS
    func loading() {
        isLoading = true
        viewLoading = NSBundle.mainBundle().loadNibNamed("Loading", owner: self, options: nil).first as! Loading
        self.navigationController!.view.addSubview(viewLoading)
        viewLoading.center = self.navigationController!.view.center
        viewLoading.animate()
    }
    
    func stopLoading() {
        viewLoading.removeFromSuperview()
        isLoading = false
    }
    
    func setReferences() {
        if isPrivate {
            PrivateMessageListener.sharedInstance.stopListening()
            privateRoomSenderRef = FIRDatabase.database().reference().child("Chat").child("PrivateRooms").child(senderId).child("\(senderId)\(receiverId! ?? "")")
            privateRoomReceiverRef = FIRDatabase.database().reference().child("Chat").child("PrivateRooms").child(receiverId! ?? "").child("\(receiverId!)\(senderId)")
            
            privateMessagesSenderRef = FIRDatabase.database().reference().child("Chat").child("PrivateMessages").child("\(senderId)\(receiverId!)")
            print(privateMessagesSenderRef)
            privateMessagesReceiverRef = FIRDatabase.database().reference().child("Chat").child("PrivateMessages").child("\(receiverId!)\(senderId)")
            
            userIsTypingSetRef = privateRoomReceiverRef.child("typing")
            userIsTypingReadRef = privateRoomSenderRef
        } else {
            assert(roomId != nil, "setReferences() called before setting roomId.")
            publicRoomRef = FIRDatabase.database().reference().child("Chat").child("PublicRooms").child(roomId!)
            publicMessagesRef = FIRDatabase.database().reference().child("Chat").child("PublicMessages").child(roomId!)
        }
    }
    
    func createPublicRoomWithTopic(topic: String, firstMessage: String) {
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        let roomRef = FIRDatabase.database().reference().child("Chat").child("PublicRooms").childByAutoId()
        let newRoom: NSDictionary = [
            ChatroomFields.topic : topic,
            ChatroomFields.createdAt : Chatroom().currentUTCTimeAsString(),
            ChatroomFields.createdByNickname : PUser.currentUser()!.nickname,
            ChatroomFields.createdByParseObjectId : PUser.currentUser()!.objectId!,
            ChatroomFields.createdByUID : uid!,
            ChatroomFields.numberOfMessages : NSNumber(int: 0),
            ChatroomFields.numberOfViewers : NSNumber(int: 1),
            ChatroomFields.updatedAt : Chatroom().currentUTCTimeAsString(),
            ChatroomFields.lastMessage : firstMessage
        ]
        roomRef.setValue(newRoom)
        roomId = roomRef.key
        
        setReferences()
        startListening()
        publicRoomInitialized = true
    }
    
    func initPrivateRoom(firstMessage: String) {

        //Is this a new message in an existing private chat for the sender
        privateRoomSenderRef.observeSingleEventOfType(.Value) { (snap: FIRDataSnapshot) in
            if !snap.exists() {
                // create the chat
                self.createNewRoomForRef(self.privateRoomSenderRef, forSender: true)
            }
        }
        
        startListening()
        roomInitialized = true
    }
    
    func createNewRoomForRef(ref: FIRDatabaseReference, forSender: Bool?) -> Bool {
        //If for sender, use senderId for key
        //else use receiverId
        //if nil, use autoId
//        var refNewRoom = FIRDatabaseReference()
//        var chattingWith: String?
//        if let forSender = forSender {
//            if forSender {
//                //refNewRoom = ref.child(senderId)
//                chattingWith = receiverId
//            } else {
//                //refNewRoom = ref.child(receiverId)
//                chattingWith = senderId
//            }
//        } else {
//            refNewRoom = ref.childByAutoId()
//            chattingWith = ""
//        }
//        
//        let uid = FIRAuth.auth()?.currentUser?.uid
//        let newRoom: NSDictionary = [
//            ChatroomFields.createdAt : Chatroom().currentUTCTimeAsString(),
//            ChatroomFields.createdByNickname : PUser.currentUser()!.nickname,
//            ChatroomFields.createdByParseObjectId : PUser.currentUser()!.objectId!,
//            ChatroomFields.createdByUID : uid!,
//            ChatroomFields.numberOfMessages : NSNumber(int: 0),
//            ChatroomFields.numberOfViewers : NSNumber(int: 0),
//            ChatroomFields.privateChatWith : chattingWith!
//            ]
//        refNewRoom.setValue(newRoom)
        return true
    }
    
    func startListening() {
        
        var ref = FIRDatabaseReference()
        
        if isPrivate {
            ref = privateMessagesSenderRef
        } else {
            ref = publicMessagesRef
        }
        
        let messagesQuery = ref.queryLimitedToLast(25)
        
        messagesQuery.observeEventType(.ChildAdded) { (snap: FIRDataSnapshot) in
            
            if !snap.exists() { self.stopLoading() }
            
            for _ in self.arrayOfJSQMessages {
                if self.arrayOfSnapKeys.contains(snap.key) {
                    return // This snap has already been added, so ignore it
                }
            }
            
            let message = ChatMessage()
            message.snapKey = snap.key
            message.message = snap.childSnapshotForPath(ChatMessageFields.message).value as? String ?? nil
            let rawCreatedAt = snap.childSnapshotForPath(ChatMessageFields.createdAt).value as? String ?? nil
            if rawCreatedAt != nil {
                message.createdAt = ChatMessage().dateFromUTCString(rawCreatedAt!) ?? nil
            }
            message.type = snap.childSnapshotForPath(ChatMessageFields.type).value as! String
            message.createdByUID = snap.childSnapshotForPath(ChatMessageFields.createdByUID).value as? String ?? nil
            message.createdByNickname = snap.childSnapshotForPath(ChatMessageFields.createdByNickname).value as? String ?? nil
            message.createdByParseObjectId = snap.childSnapshotForPath(ChatMessageFields.createdByParseObjectId).value as? String ?? nil
            message.file = snap.childSnapshotForPath(ChatMessageFields.file).value as? String ?? nil
            let lat = snap.childSnapshotForPath(ChatMessageFields.lattitude).value as? Double ?? nil
            let lon = snap.childSnapshotForPath(ChatMessageFields.longitude).value as? Double ?? nil
            if lat != nil && lon != nil {
                message.location = CLLocation(latitude: lat!, longitude: lon!)
            }
            var jMsg: JSQMessage? = nil
            
            //Sound
            if message.createdByParseObjectId != self.senderId {
                if !self.initialLoad { JSQSystemSoundPlayer.jsq_playMessageReceivedSound() }
            }
            
            switch message.type {
            case "TEXT":
                jMsg = JSQMessage(senderId: message.createdByParseObjectId,
                                  senderDisplayName: message.createdByNickname,
                                  date: message.createdAt,
                                  text: message.message)
                
            case "PICTURE":
                var image: UIImage?
                if message.file != nil {
                    let decodedData = NSData(base64EncodedString: message.file!, options:[])
                    if let decodedImage = UIImage(data: decodedData!) {
                        image = decodedImage
                    } else {
                        image = UIImage(named: "imageNotFound")
                    }
                } else {
                    image = UIImage(named: "imageNotFound")
                }
                
                let mediaItem = JSQPhotoMediaItem(image: image)
                mediaItem.appliesMediaViewMaskAsOutgoing = (message.createdByParseObjectId == self.senderId)
                jMsg = JSQMessage(senderId: message.createdByParseObjectId,
                                  senderDisplayName: message.createdByNickname!,
                                  date: message.createdAt,
                                  media: mediaItem)
                
            case "AUDIO":
                if message.file != nil {
                    let decodedData = NSData(base64EncodedString: message.file!, options:[])
                    let mediaItem = JSQAudioMediaItem(data: decodedData)
                    mediaItem.appliesMediaViewMaskAsOutgoing = (message.createdByParseObjectId == self.senderId)
                    jMsg = JSQMessage(senderId: message.createdByParseObjectId,
                                      senderDisplayName: message.createdByNickname!,
                                      date: message.createdAt,
                                      media: mediaItem)
                }
                break
                
            case "VIDEO":
                
                let mediaItem = JSQVideoMediaItem(fileURL: nil, isReadyToPlay: false)
                mediaItem.appliesMediaViewMaskAsOutgoing = (message.createdByParseObjectId == self.senderId)
                jMsg = JSQMessage(senderId: message.createdByParseObjectId,
                                  senderDisplayName: message.createdByNickname!,
                                  date: message.createdAt,
                                  media: mediaItem)
                self.downloadVideoFromFirebase(message.snapKey, jMsg: mediaItem)
                break
                
            case "LOCATION":
                let mediaItem = JSQLocationMediaItem(location: nil)
                mediaItem.setLocation(message.location, withCompletionHandler: {
                    self.collectionView.reloadData()
                })
                mediaItem.appliesMediaViewMaskAsOutgoing = (message.createdByParseObjectId == self.senderId)
                jMsg = JSQMessage(senderId: message.createdByParseObjectId,
                                  senderDisplayName: message.createdByNickname!,
                                  date: message.createdAt,
                                  media: mediaItem)
                break
                
            default:
                break
            }
            
            if jMsg != nil {
                self.arrayOfJSQMessages.append(jMsg!)
                self.arrayOfSnapKeys.append(snap.key)
            }
            
            //check to see if this author's avatar has already been added to the dictionary first
            let keyExists = self.arrayOfAvatars[(message.createdByParseObjectId!)] != nil
            if !keyExists {
                
                let query = PFQuery(className: PUser.parseClassName())
                query.whereKey("objectId", equalTo: message.createdByParseObjectId!)
                query.getFirstObjectInBackgroundWithBlock({ (user: PFObject?, err: NSError?) in
                    if let user: PUser = user as? PUser {
                        if let file = user.thumbnail {
                            file.getDataInBackgroundWithBlock({ (data: NSData?, err: NSError?) in
                                if err == nil {
                                    let picture = UIImage(data: data!)
                                    let circleAvatar = JSQMessagesAvatarImageFactory.circularAvatarImage(picture, withDiameter: 30)
                                    let circlePlaceholder = JSQMessagesAvatarImageFactory.circularAvatarImage(UIImage(named: "defaultProfilePicture"), withDiameter: 30)
                                    
                                    let avatar = JSQMessagesAvatarImage(avatarImage: circleAvatar, highlightedImage: circleAvatar, placeholderImage: circlePlaceholder)
                                    
                                    self.arrayOfAvatars[(user.objectId)!] = avatar
                                    self.finishReceivingMessageAnimated(true)
                                } else {
                                    // there was an error getting thumbnail data, so finish up
                                    self.finishReceivingMessageAnimated(true)
                                }
                            })
                        } else {
                            // no thumbnail, so finish up
                            self.finishReceivingMessageAnimated(true)
                        }
                    }
                })
            } else {
                //Avatar already existed, so just finish up
                self.finishReceivingMessageAnimated(true)
            }
            
            if self.initialLoad {
                self.stopLoading()
                self.collectionView.reloadData()
                self.initialLoad = false
            }
        }
    }
    
    func stopListening() {
        publicMessagesRef.removeAllObservers()
        publicRoomRef.removeAllObservers()
        privateRoomReceiverRef.removeAllObservers()
        privateRoomSenderRef.removeAllObservers()
        privateMessagesSenderRef.removeAllObservers()
        privateMessagesSenderRef.removeAllObservers()
    }
    
    private func setupBubbles() {
        let tailBubbleFactory = JSQMessagesBubbleImageFactory()
        outgoingBubbleWithTail = tailBubbleFactory.outgoingMessagesBubbleImageWithColor(UISingleton.sharedInstance.gold)
        incomingBubbleWithTail = tailBubbleFactory.incomingMessagesBubbleImageWithColor(UISingleton.sharedInstance.maroon)
        
        let tailLessBubbleFactory = JSQMessagesBubbleImageFactory(bubbleImage: UIImage.jsq_bubbleRegularTaillessImage(), capInsets: UIEdgeInsetsZero)
        incomingBubbleWithoutTail = tailLessBubbleFactory.incomingMessagesBubbleImageWithColor(UISingleton.sharedInstance.maroon)
        outgoingBubbleWithoutTail = tailLessBubbleFactory.outgoingMessagesBubbleImageWithColor(UISingleton.sharedInstance.gold)
    }
    
    func updateViewerCounterForRef(ref: FIRDatabaseReference, increment: Bool) {
        ref.runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
            if var room = currentData.value as? [String : AnyObject] {
                
                var count = room[ChatroomFields.numberOfViewers] as? Int ?? 0
                if increment {
                    count += 1
                } else {
                    count -= 1
                }
                if count < 0 { count = 0 }
                room[ChatroomFields.numberOfViewers] = count
                currentData.value = room
                return FIRTransactionResult.successWithValue(currentData)
            }
            return FIRTransactionResult.successWithValue(currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func incrementMessageCounterForRoomRef(ref: FIRDatabaseReference) {

        print(ref)
        ref.runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
            if var room = currentData.value as? [String : AnyObject] {

                var count = room[ChatroomFields.numberOfMessages] as? Int ?? 0
                count += 1
                room[ChatroomFields.numberOfMessages] = count
                
                currentData.value = room
                
                return FIRTransactionResult.successWithValue(currentData)
            }
            return FIRTransactionResult.successWithValue(currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func isUserCurrentUser(userToCheck: PUser) -> Bool {
        if userToCheck.objectId == PUser.currentUser()?.objectId {
            return true
        } else {
            return false
        }
    }
    
    //MARK:-
    //MARK: JSQMESSAGE DATASOURCE
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return arrayOfJSQMessages[indexPath.item]
    }
    
    override func collectionView(collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        print(arrayOfJSQMessages.count)
        return arrayOfJSQMessages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {

        let message = arrayOfJSQMessages[indexPath.item]
        var incoming: Bool
        if message.senderId == senderId {
            incoming = false
        } else {
            incoming = true
        }
        
        //if the same user has sent the previous message, tailless bubble
        let prevIndex = indexPath.item - 1
        if prevIndex > 0 && prevIndex <= arrayOfJSQMessages.count {
            //make sure we're not out of bounds
            let prevMessage = arrayOfJSQMessages[indexPath.item - 1]
            if message.senderId == prevMessage.senderId {
                if incoming { return incomingBubbleWithoutTail }
                else { return outgoingBubbleWithoutTail }
            }
        }
        
        //other wise, show the tail
        if incoming { return incomingBubbleWithTail }
        else { return outgoingBubbleWithTail }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        let message = arrayOfJSQMessages[indexPath.item]
        let cell = self.collectionView.cellForItemAtIndexPath(indexPath) as? JSQMessagesCollectionViewCell
        
        // Are we going to show the avatar or no?
        
        if message.isMediaMessage {
            
            // Always show for media messages
            if cell != nil {
                cell!.avatarImageView.layer.borderColor = UIColor.whiteColor().CGColor
                cell!.avatarImageView.layer.borderWidth = 1
                cell!.avatarImageView.layer.cornerRadius = cell!.avatarImageView.image!.size.height / 2
            }
            return showAvatarForSenderId(message.senderId)
        } else {
            // Assuming previous was from the same user
            // If this is text, and previous was media, show it
            // If this is text, and previous was not media, hide it
            
            let prevIndex = indexPath.item - 1
            if prevIndex > 0 && prevIndex <= arrayOfJSQMessages.count {
                // Make sure we're not out of bounds
                let prevMessage = arrayOfJSQMessages[indexPath.item - 1]
                if message.senderId != prevMessage.senderId {
                    // Not from the same user, show it
                    if cell != nil {
                        cell!.avatarImageView.layer.borderColor = UIColor.whiteColor().CGColor
                        cell!.avatarImageView.layer.borderWidth = 1
                        cell!.avatarImageView.layer.cornerRadius = cell!.avatarImageView.image!.size.height / 2
                    }
                    return showAvatarForSenderId(message.senderId)
                } else {
                    // From the same user, hide it
                    if cell != nil {
                        cell!.avatarImageView.layer.borderWidth = 0
                    }
                    return nil
                }
            }
        }
        if cell != nil {
            cell!.avatarImageView.layer.borderColor = UIColor.whiteColor().CGColor
            cell!.avatarImageView.layer.borderWidth = 1
            cell!.avatarImageView.layer.cornerRadius = cell!.avatarImageView.image!.size.height / 2
        }
        return showAvatarForSenderId(message.senderId)
    }
    
    func showAvatarForSenderId(id: String) -> JSQMessagesAvatarImage {
        //other wise, show it
        if let avatar = arrayOfAvatars[id] {
            return avatar
        } else {
            let circlePlaceholder = JSQMessagesAvatarImageFactory.circularAvatarImage(UIImage(named: "defaultProfilePicture"), withDiameter: 30)
            let avatar = JSQMessagesAvatarImage(avatarImage: circlePlaceholder, highlightedImage: circlePlaceholder, placeholderImage: circlePlaceholder)
            return avatar
        }
    }
    
    override func collectionView(collectionView: UICollectionView,
                                 cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
            as! JSQMessagesCollectionViewCell
        let message = arrayOfJSQMessages[indexPath.item]
        if !message.isMediaMessage {
            if message.senderId == senderId {
                cell.textView!.textColor = UIColor.whiteColor()
            } else {
                cell.textView!.textColor = UIColor.whiteColor()
            }
        }
        cell.clipsToBounds = false
        return cell
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        if indexPath.item % 3 == 0 {
            let message = arrayOfJSQMessages[indexPath.item]
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
        } else {
            return nil
        }
    }
    
//    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
//        //WHAT IS THIS
//    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        } else {
            return 0
        }
    }
    
    //MARK:-
    //MARK: JSQMESSAGE DELEGATES
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapAvatarImageView avatarImageView: UIImageView!, atIndexPath indexPath: NSIndexPath!) {
        let message = arrayOfJSQMessages[indexPath.item]
        let query = PFQuery(className: PUser.parseClassName())
        query.whereKey("objectId", equalTo: message.senderId)
        query.limit = 1
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, err: NSError?) in
            if let user = objects?.first as? PUser {
                self.profileToOpen = user
                self.performSegueWithIdentifier("profile", sender: self)
            }
        }
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!,
                                     senderDisplayName: String!, date: NSDate!) {
        
        sendMessage(text, videoFilePath: nil, picture: nil, audioFilePath: nil)
        isTyping = false
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        showMenu()
    }
    
    //MARK:
    //MARK: UIIMAGECONTROLLER DELEGATES
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var vid: NSURL?
        var pic: UIImage?
        if let video = info[UIImagePickerControllerMediaURL] as? NSURL {
            vid = video
        }
        if let picture = info[UIImagePickerControllerEditedImage] as? UIImage {
            pic = picture
        }
        sendMessage(nil, videoFilePath: vid, picture: pic, audioFilePath: nil)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK:-
    //MARK: UITEXTVIEW DELEGATES
    override func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        //FIXME: return false where needed
        if isLoading { return true }
        else { return true }
    }
    
    override func textViewDidChange(textView: UITextView) {
        super.textViewDidChange(textView)
        // If the text is not empty, the user is typing
        isTyping = textView.text != ""
    }
    
    //MARK:-
    //MARK: IQAUDIORECORDER DELEGATES
    func audioRecorderController(controller: IQAudioRecorderViewController, didFinishWithAudioAtPath filePath: String) {
        controller.dismissViewControllerAnimated(true) {
            self.sendMessage(nil, videoFilePath: nil, picture: nil, audioFilePath: filePath)
        }
    }
    
    //MARK:-
    //MARK: SEND ALL MESSAGES
    func sendMessage(text: String?, videoFilePath: NSURL?, picture: UIImage?, audioFilePath: String?) {
        
        if isPrivate {
            // Check the paths for sender and receiver, create rooms if necessary
            privateRoomSenderRef.observeSingleEventOfType(.Value) { (snap: FIRDataSnapshot) in
                if !snap.exists() {
                    if self.createNewRoomForRef(self.privateRoomSenderRef, forSender: true) {
                        self.startListening()
                        self.observeTyping()
                        self.proceedWithMessage(text, videoFilePath: videoFilePath, picture: picture, audioFilePath: audioFilePath, forSender: true)
                    }
                } else {
                    self.proceedWithMessage(text, videoFilePath: videoFilePath, picture: picture, audioFilePath: audioFilePath, forSender: true)
                }
            }
            privateRoomReceiverRef.observeSingleEventOfType(.Value) { (snap: FIRDataSnapshot) in
                if !snap.exists() {
                    if self.createNewRoomForRef(self.privateRoomReceiverRef, forSender: false) {
                        self.proceedWithMessage(text, videoFilePath: videoFilePath, picture: picture, audioFilePath: audioFilePath, forSender: false)
                    }
                } else {
                    self.proceedWithMessage(text, videoFilePath: videoFilePath, picture: picture, audioFilePath: audioFilePath, forSender: false)
                }
            }
    
    //Public Message
        } else {
            if !publicRoomInitialized {
                createPublicRoomWithTopic(newRoomTopic ?? "[Unknown Room Topic]", firstMessage: text ?? "[Unknown Message Type]")
                proceedWithMessage(text, videoFilePath: videoFilePath, picture: picture, audioFilePath: audioFilePath, forSender: nil)
            } else {
                proceedWithMessage(text, videoFilePath: videoFilePath, picture: picture, audioFilePath: audioFilePath, forSender: nil)
            }
        }
    }
    
    func proceedWithMessage(text: String?, videoFilePath: NSURL?, picture: UIImage?, audioFilePath: String?, forSender: Bool?) {
        if text != nil { sendTextMessage(text!, forSender: forSender) }
        if picture != nil { sendPictureMessage(picture!, forSender: forSender) }
        if audioFilePath != nil { sendAudioMessage(audioFilePath!, forSender: forSender) }
        if videoFilePath != nil { sendVideoMessage(videoFilePath!, forSender: forSender) }
        if text == nil && videoFilePath == nil && picture == nil && audioFilePath == nil {
            forSenderLocation = forSender
            sendLocationMessage()
        }
    }
    
    //MARK:-
    //MARK: TEXT MESSAGE
    func sendTextMessage(text: String?, forSender: Bool?) {
        if let text = text {
            if isPrivate {
                if forSender == true { sendTextMessageForRef(privateMessagesSenderRef, text: text) }
                else if forSender == false { sendTextMessageForRef(privateMessagesReceiverRef, text: text) }
            } else {
                sendTextMessageForRef(publicMessagesRef, text: text)
            }
            self.finishSendingMessage()
            if isPrivate { JSQSystemSoundPlayer.jsq_playMessageSentSound() }
        }
    }
    func sendTextMessageForRef(ref: FIRDatabaseReference, text: String) {
        let message = blankMessage()
        message.message = text
        message.type = "TEXT"
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        let itemRef = ref.childByAutoId()
        let newMessage: NSDictionary = [
            ChatMessageFields.message : message.message!,
            ChatMessageFields.createdAt : ChatMessage().currentUTCTimeAsString(),
            ChatMessageFields.createdByNickname : PUser.currentUser()!.nickname,
            ChatMessageFields.createdByParseObjectId : PUser.currentUser()!.objectId!,
            ChatMessageFields.createdByUID : uid!,
            ChatMessageFields.type : message.type
        ]
        itemRef.setValue(newMessage)
        
        if isPrivate {
            
            privateRoomSenderRef.child(ChatroomFields.lastMessage).setValue(text)
            privateRoomSenderRef.child(ChatroomFields.updatedAt).setValue(ChatMessage().currentUTCTimeAsString())
    
            privateRoomReceiverRef.child(ChatroomFields.lastMessage).setValue(text)
            privateRoomReceiverRef.child(ChatroomFields.updatedAt).setValue(ChatMessage().currentUTCTimeAsString())
            
            privateRoomReceiverRef.child(ChatroomFields.privateChatWith).setValue(senderId)
            privateRoomSenderRef.child(ChatroomFields.privateChatWith).setValue(receiverId!)
            
            privateRoomSenderRef.child(ChatroomFields.numberOfMessages).setValue(NSNumber(int: 1))
            privateRoomReceiverRef.child(ChatroomFields.numberOfMessages).setValue(NSNumber(int: 1))
        } else {
            publicRoomRef.child(ChatroomFields.lastMessage).setValue(text)
            publicRoomRef.child(ChatroomFields.updatedAt).setValue(ChatMessage().currentUTCTimeAsString())
            incrementMessageCounterForRoomRef(publicRoomRef)
        }
    }
    
    //MARK:-
    //MARK: PICTURE MESSAGE
    func sendPictureMessage(picture: UIImage?, forSender: Bool?) {
        if let picture = picture {
            if isPrivate {
                if forSender == true { sendPictureMessageForRef(privateMessagesSenderRef, picture: picture) }
                else if forSender == false { sendPictureMessageForRef(privateMessagesReceiverRef, picture: picture) }
            } else {
                sendPictureMessageForRef(publicMessagesRef, picture: picture)
            }
            self.finishSendingMessage()
            if isPrivate { JSQSystemSoundPlayer.jsq_playMessageSentSound() }
        }
    }
    
    func sendPictureMessageForRef(ref: FIRDatabaseReference, picture: UIImage) {
        let message = blankMessage()
        message.message = "[Picture Message]"
        message.type = "PICTURE"
        
        var base64String: NSString!
        let imageData: NSData = UIImagePNGRepresentation(picture)!
        base64String = imageData.base64EncodedStringWithOptions([])
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        let itemRef = ref.childByAutoId()
        let newMessage: NSDictionary = [
            ChatMessageFields.message : message.message!,
            ChatMessageFields.createdAt : ChatMessage().currentUTCTimeAsString(),
            ChatMessageFields.createdByNickname : PUser.currentUser()!.nickname,
            ChatMessageFields.createdByParseObjectId : PUser.currentUser()!.objectId!,
            ChatMessageFields.createdByUID : uid!,
            ChatMessageFields.type : message.type,
            ChatMessageFields.file : base64String
        ]
        itemRef.setValue(newMessage)
        
        if isPrivate {
            privateRoomReceiverRef.child(ChatroomFields.lastMessage).setValue(message.message)
            privateRoomReceiverRef.child(ChatroomFields.updatedAt).setValue(ChatMessage().currentUTCTimeAsString())
            
            privateRoomSenderRef.child(ChatroomFields.lastMessage).setValue(message.message)
            privateRoomSenderRef.child(ChatroomFields.updatedAt).setValue(ChatMessage().currentUTCTimeAsString())
            
            privateRoomReceiverRef.child(ChatroomFields.privateChatWith).setValue(senderId)
            privateRoomSenderRef.child(ChatroomFields.privateChatWith).setValue(receiverId!)
            
            privateRoomSenderRef.child(ChatroomFields.numberOfMessages).setValue(NSNumber(int: 1))
            privateRoomReceiverRef.child(ChatroomFields.numberOfMessages).setValue(NSNumber(int: 1))
        } else {
            publicRoomRef.child(ChatroomFields.lastMessage).setValue(message.message)
            publicRoomRef.child(ChatroomFields.updatedAt).setValue(ChatMessage().currentUTCTimeAsString())
            incrementMessageCounterForRoomRef(publicRoomRef)
        }
    }
    
    //MARK:-
    //MARK: VIDEO MESSAGE
    
    func sendVideoMessage(videoFilePath: NSURL, forSender: Bool?) {
//        // Upload the video
//        let data = NSData(contentsOfURL: videoFilePath)
//        uploadVideoToFirebase(data!)
    }
    
    func uploadVideoToFirebase(data: NSData, forSender: Bool?) {
//        let key = NSUUID().UUIDString
//        
//        let refImage = refStorage.child("messages/videos/\(key)")
//        let uploadTask = refImage.putData(data, metadata: nil) { metadata, error in
//            if (error != nil) {
//                print("FIREBASE ERROR: File upload failed - \(error)")
//            } else {
//                print("FIREBASE: File upload successful.")
//                
//                let message = self.blankMessage()
//                message.message = "[Video Message]"
//                message.type = "VIDEO"
//                
//                // Save the message
//                let uid = FIRAuth.auth()?.currentUser?.uid
//                let itemRef = self.refMessages.child(key)
//                let newMessage: NSDictionary = [
//                    ChatMessageFields.message : message.message!,
//                    ChatMessageFields.createdAt : ChatMessage().currentUTCTimeAsString(),
//                    ChatMessageFields.createdByNickname : PUser.currentUser()!.nickname,
//                    ChatMessageFields.createdByParseObjectId : PUser.currentUser()!.objectId!,
//                    ChatMessageFields.createdByUID : uid!,
//                    ChatMessageFields.type : message.type
//                ]
//                itemRef.setValue(newMessage)
//                self.refChatRoom.child(ChatroomFields.lastMessage).setValue(message.message)
//                self.incrementMessagesOnChatRoom()
//                self.refChatRoom.child(ChatroomFields.updatedAt).setValue(ChatMessage().currentUTCTimeAsString())
//                self.finishSendingMessage()
//                if isPrivate { JSQSystemSoundPlayer.jsq_playMessageSentSound() }
//            }
//        }
//        
//        let _ = uploadTask.observeStatus(.Progress) { snapshot in
//            print("PROGRESS: \(snapshot.progress)")
//            //let percentComplete = 100.0 * (snapshot.progress?.completedUnitCount)! / (snapshot.progress?.totalUnitCount)!
//        }
    }
    
    func downloadVideoFromFirebase(key: String, jMsg: JSQVideoMediaItem) {
//        
//        let refImage = refStorage.child("messages/videos/\(key)")
//        let localURL: NSURL! = NSURL(string: "file:///local/corpsboard/\(key)")
//        let downloadTask = refImage.writeToFile(localURL) { (URL, error) -> Void in
//            if (error != nil) {
//                print("FIREBASE ERROR: File download failed - \(error)")
//            } else {
//                print("FIREBASE: File download successful.")
//                self.videoDownloadComplete(localURL, jMsg: jMsg)
//            }
//        }
//        
//        let _ = downloadTask.observeStatus(.Progress) { (snapshot) -> Void in
//            print("PROGRESS: \(snapshot.progress)")
//            //let percentComplete = 100.0 * (snapshot.progress?.completedUnitCount)! / (snapshot.progress?.totalUnitCount)!
//        }
    }
    
    func videoDownloadComplete(url: NSURL, jMsg: JSQVideoMediaItem) {
//        jMsg.fileURL = url
//        jMsg.isReadyToPlay = true
//        self.collectionView.reloadData()
    }
    
    //MARK:-
    //MARK: AUDIO MESSAGE
    func sendAudioMessage(filePath: String?, forSender: Bool?) {
        if let filePath = filePath {
            if isPrivate {
                if forSender == true { sendAudioMessageForRef(privateMessagesSenderRef, filePath: filePath) }
                else if forSender == false { sendAudioMessageForRef(privateMessagesReceiverRef, filePath: filePath) }
            } else {
                sendAudioMessageForRef(publicMessagesRef, filePath: filePath)
            }
            self.finishSendingMessage()
            if isPrivate { JSQSystemSoundPlayer.jsq_playMessageSentSound() }
        }
    }
    
    func sendAudioMessageForRef(ref: FIRDatabaseReference, filePath: String) {
        let message = blankMessage()
        message.message = "[Audio Message]"
        message.type = "AUDIO"
        
        let url = NSURL(fileURLWithPath: filePath)
        let data = NSData(contentsOfURL: url)
        let str = data?.base64EncodedStringWithOptions([])
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        let itemRef = ref.childByAutoId()
        let newMessage: NSDictionary = [
            ChatMessageFields.message : message.message!,
            ChatMessageFields.createdAt : ChatMessage().currentUTCTimeAsString(),
            ChatMessageFields.createdByNickname : PUser.currentUser()!.nickname,
            ChatMessageFields.createdByParseObjectId : PUser.currentUser()!.objectId!,
            ChatMessageFields.createdByUID : uid!,
            ChatMessageFields.type : message.type,
            ChatMessageFields.file : str!
        ]
        itemRef.setValue(newMessage)
        
        if isPrivate {
            privateRoomReceiverRef.child(ChatroomFields.lastMessage).setValue(message.message)
            privateRoomReceiverRef.child(ChatroomFields.updatedAt).setValue(ChatMessage().currentUTCTimeAsString())
            
            privateRoomSenderRef.child(ChatroomFields.lastMessage).setValue(message.message)
            privateRoomSenderRef.child(ChatroomFields.updatedAt).setValue(ChatMessage().currentUTCTimeAsString())
            
            incrementMessageCounterForRoomRef(privateRoomSenderRef)
            incrementMessageCounterForRoomRef(privateRoomReceiverRef)

            privateRoomSenderRef.child(ChatroomFields.numberOfMessages).setValue(NSNumber(int: 1))
            privateRoomReceiverRef.child(ChatroomFields.numberOfMessages).setValue(NSNumber(int: 1))
        } else {
            publicRoomRef.child(ChatroomFields.lastMessage).setValue(message.message)
            publicRoomRef.child(ChatroomFields.updatedAt).setValue(ChatMessage().currentUTCTimeAsString())
            incrementMessageCounterForRoomRef(publicRoomRef)
        }
    }
    
    //MARK:-
    //MARK: LOCATION MESSAGE
    func sendLocationMessage() {
        // Make sure location is enabled
        // If not, prompt, then try again
        // If so, location reloaded and delegate fires off location JSQMessage
        doesUserHaveLocationServicesEnabled()
    }
    
    
    var forSenderLocation: Bool?
    // deleateUserLocation in Server.swift
    // called from updateUserLocation()
    func userLocationUpdated(location: CLLocation?) {
        viewLocationForDelegate.dismissView()
        if let location = location {
            if isPrivate {
                if forSenderLocation == true { sendLocationForRef(privateMessagesReceiverRef, location: location) }
                else if forSenderLocation == false { sendLocationForRef(privateMessagesSenderRef, location: location) }
            } else {
                sendLocationForRef(publicMessagesRef, location: location)
            }
            self.finishSendingMessage()
            if isPrivate { JSQSystemSoundPlayer.jsq_playMessageSentSound() }
        }
        forSenderLocation = nil
    }
    
    func sendLocationForRef(ref: FIRDatabaseReference, location: CLLocation) {
        
        let message = blankMessage()
        message.type = "LOCATION"
        message.message = "[Location Message]"
        
        let lat = Double(location.coordinate.latitude)
        let lon = Double(location.coordinate.longitude)
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        let itemRef = ref.childByAutoId()
        let newMessage: NSDictionary = [
            ChatMessageFields.message : message.message!,
            ChatMessageFields.createdAt : ChatMessage().currentUTCTimeAsString(),
            ChatMessageFields.createdByNickname : PUser.currentUser()!.nickname,
            ChatMessageFields.createdByParseObjectId : PUser.currentUser()!.objectId!,
            ChatMessageFields.createdByUID : uid!,
            ChatMessageFields.type : message.type,
            ChatMessageFields.lattitude : NSNumber(double: lat),
            ChatMessageFields.longitude : NSNumber(double: lon)
        ]
        itemRef.setValue(newMessage)
        
        if isPrivate {
            privateRoomReceiverRef.child(ChatroomFields.lastMessage).setValue(message.message)
            privateRoomReceiverRef.child(ChatroomFields.updatedAt).setValue(ChatMessage().currentUTCTimeAsString())
            
            privateRoomSenderRef.child(ChatroomFields.lastMessage).setValue(message.message)
            privateRoomSenderRef.child(ChatroomFields.updatedAt).setValue(ChatMessage().currentUTCTimeAsString())
            
            incrementMessageCounterForRoomRef(privateRoomSenderRef)
            incrementMessageCounterForRoomRef(privateRoomReceiverRef)
            
            privateRoomSenderRef.child(ChatroomFields.numberOfMessages).setValue(NSNumber(int: 1))
            privateRoomReceiverRef.child(ChatroomFields.numberOfMessages).setValue(NSNumber(int: 1))
        } else {
            publicRoomRef.child(ChatroomFields.lastMessage).setValue(message.message)
            publicRoomRef.child(ChatroomFields.updatedAt).setValue(ChatMessage().currentUTCTimeAsString())
            
            incrementMessageCounterForRoomRef(publicRoomRef)
        }
    }
    
    // Checks to see if user has allowed location services
    // If so, returns true
    // If not, prompts user
    // Before this is called, call doesUserNeedAccountOrNickname(), because we need an account to write geo to --- We have to have an account at this point to be chatting
    func doesUserHaveLocationServicesEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .AuthorizedAlways:
                Server.sharedInstance.updateUserLocation()
                return true
            case .AuthorizedWhenInUse:
                Server.sharedInstance.updateUserLocation()
                return true
            case .Denied:
                self.tellUserToEnableLocationForView()
                return false
            case .NotDetermined:
                self.askForLocationPermissionForView()
                return false
            case .Restricted:
                self.tellUserToEnableLocationForView()
                return false
            }
        } else {
            return false
        }
    }
    
    func askForLocationPermissionForView() {
        if let viewLoc = NSBundle.mainBundle().loadNibNamed("LocationServicesPermission", owner: self, options: nil).first as? LocationServicesPermission {
            viewLoc.showInParent(self.navigationController)
            viewLoc.setDelegate(self)
            viewLocationForDelegate = viewLoc
        }
    }
    
    func tellUserToEnableLocationForView() {
        if let viewLocation = NSBundle.mainBundle().loadNibNamed("LocationServicesDisabled", owner: self, options: nil).first as? LocationServicesDisabled {
            viewLocation.showInParent(self.navigationController)
        }
    }
    
    // deleateUserLocation in Server.swift
    // called from updateUserLocation()
    func userLocationError() {
        viewLocationForDelegate.dismissView()
        let alert = UIAlertController(title: "Location Services", message: "Corpsboard could not update your location.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK:-
    //MARK: HELPERS
    
    func blankMessage() -> ChatMessage {
        let message = ChatMessage()
        message.createdByParseObjectId = PUser.currentUser()?.objectId!
        message.createdByNickname = PUser.currentUser()?.nickname
        message.createdByUID = FIRAuth.auth()?.currentUser?.uid
        message.createdAt = NSDate()
        return message
    }
    
    func showMenu() {
        if isLoading { return }
        self.inputToolbar.contentView.textView.resignFirstResponder()
        var menuItems = [RNGridMenuItem]()
        menuItems.append(RNGridMenuItem(image: UIImage(named: "chat_camera"), title: "Camera", action: {
            self.presentMultiCamera()
        }))
        menuItems.append(RNGridMenuItem(image: UIImage(named: "chat_audio"), title: "Audio", action: {
            self.presentAudioRecorder()
        }))
        menuItems.append(RNGridMenuItem(image: UIImage(named: "chat_pictures"), title: "Pictures", action: {
            self.presentPhotoLibrary()
        }))
        //        menuItems.append(RNGridMenuItem(image: UIImage(named: "chat_videos"), title: "Videos", action: {
        //            self.presentVideoLibrary()
        //        }))
        var found = false
        for item in arrayOfJSQMessages {
            if item.isKindOfClass(JSQLocationMediaItem) {
                found = true
                break
            }
        }
        if !found {
            menuItems.append(RNGridMenuItem(image: UIImage(named: "chat_location"), title: "Location", action: {
                self.sendMessage(nil, videoFilePath: nil, picture: nil, audioFilePath: nil)
            }))
        }
        //        menuItems.append(RNGridMenuItem(image: UIImage(named: "chat_stickers"), title: "Stickers", action: {
        //            print("Tapped stickers")
        //        }))
        
        let gridMenu = RNGridMenu(items: menuItems)
        gridMenu.backgroundColor = UIColor(colorLiteralRed: 97/255.0, green: 22/255.0, blue: 26/255.0, alpha: 0.7)
        gridMenu.highlightColor = UISingleton.sharedInstance.gold
        gridMenu.showInViewController(self, center: CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2))
    }
    
    func presentMultiCamera() {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            return
        }
        
        let type1 = kUTTypeImage as String
        //let type2 = kUTTypeMovie as String
        let imagePicker = UIImagePickerController()
        imagePicker.mediaTypes = [type1]
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.videoMaximumDuration = 5
        imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.Rear
        imagePicker.allowsEditing = true
        imagePicker.showsCameraControls = true
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func presentPhotoLibrary() {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            return
        }
        
        let type = kUTTypeImage as String
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.mediaTypes = [type]
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func presentVideoLibrary() {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            return
        }
        
        let type = kUTTypeVideo as String
        let type2 = kUTTypeMovie as String
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.mediaTypes = [type, type2]
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func presentAudioRecorder() {
        let controller = IQAudioRecorderViewController()
        controller.delegate = self
        controller.title = "Record Audio"
        controller.allowCropping = true
        controller.barStyle = UIBarStyle.BlackTranslucent
        self.presentBlurredAudioRecorderViewControllerAnimated(controller)
    }
    
    private func observeTyping() {
        
        userIsTypingSetRef.onDisconnectRemoveValue()
        usersTypingQuery = userIsTypingReadRef.queryOrderedByValue().queryEqualToValue(true)
        usersTypingQuery.observeEventType(.Value) { (snap: FIRDataSnapshot) in
            print(snap)
            if let typing = snap.childSnapshotForPath("typing").value as? Int {
                if typing == 1 {
                    self.showTypingIndicator = true
                    self.scrollToBottomAnimated(true)
                } else {
                    self.showTypingIndicator = false
                }
            } else {
                self.showTypingIndicator = false
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "profile" {
            let vc = segue.destinationViewController as! ProfileTableViewController
            vc.userProfile = profileToOpen
        }
    }
}
