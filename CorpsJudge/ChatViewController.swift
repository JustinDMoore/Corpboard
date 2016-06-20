//
//  ChatViewController.swift
//  CorpBoard
//
//  Created by Justin Moore on 6/17/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import ParseLiveQuery
import RNGridMenu

let liveQueryClient = ParseLiveQuery.Client()

class ChatViewController: JSQMessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, IQAudioRecorderViewControllerDelegate {

    var roomToConnect = PRoom()
    var isPrivate = false
    var dictOfMessages = [String: JSQMessage]()
    var arrayOfOrderedMessageIds = [String]() // This holds objectIds of PChatMessage
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
    var connected: Bool { return currentChatRoom != nil }
    
    private var currentChatRoom: PRoom?
    private var subscription: Subscription<PChatMessage>?
    var messagesQuery: PFQuery {
        return (PChatMessage.query()?
            .whereKey("room", equalTo: roomToConnect.objectId!)
            .orderByAscending("createdAt"))!
    }
    
    func connectToChatRoom(room: PRoom) {
        if connected {
            disconnectFromChatRoom()
        }
        
        PRoom.query()?.whereKey("objectId", equalTo: room.objectId!).getFirstObjectInBackground().continueWithBlock { task in
            self.currentChatRoom = task.result as? PRoom
            print("Connected to room \(self.currentChatRoom?.name ?? "null")")
            self.loadMessages()
            self.subscribeToUpdates()
            return nil
        }
    }
    
    func disconnectFromChatRoom() {
        liveQueryClient.unsubscribe(messagesQuery, handler: subscription!)
    }
    
    func loadMessages() {
        self.automaticallyScrollsToMostRecentMessage = true
        messagesQuery.findObjectsInBackground().continueWithBlock() { task in
            (task.result as? [PChatMessage])?.forEach(self.printMessage)
            return nil
        }
    }
    
    func addMessageToDataSource(parseMessage: PChatMessage, jsqMsg: JSQMessage) {
        //check to see if it already exists
        let msgExists = dictOfMessages[(parseMessage.objectId!)] != nil
        if !msgExists {
            dictOfMessages[parseMessage.objectId!] = jsqMsg
            arrayOfOrderedMessageIds.append(parseMessage.objectId!)
        }
    }
    
    private func printMessage(msg: PChatMessage) {
        
        msg.fetchIfNeededInBackgroundWithBlock { (loadedMsg: PFObject?, err: NSError?) in
            print(msg)
            print(loadedMsg)
        }
        let createdAt = msg.createdAt ?? NSDate()
        print("\(createdAt) \(msg.authorName ?? "unknown"): \(msg.message ?? "")")
        
        switch msg.messageType {
        case "TEXT":
            let message = JSQMessage(senderId: msg.authorId,
                                     senderDisplayName: msg.authorName,
                                     date: createdAt,
                                     text: msg.message)
            addMessageToDataSource(msg, jsqMsg: message)
            
        case "PICTURE":
            let mediaItem = JSQPhotoMediaItem(image: nil)
            mediaItem.appliesMediaViewMaskAsOutgoing = (msg.authorId == self.senderId)
            let message = JSQMessage(senderId: msg.authorId,
                                     senderDisplayName: msg.authorName,
                                     date: createdAt,
                                     media: mediaItem)
            addMessageToDataSource(msg, jsqMsg: message)
            let filePicture = msg.file! as PFFile
            filePicture.getDataInBackgroundWithBlock({ (data: NSData?, err: NSError?) in
                if err == nil {
                    mediaItem.image = UIImage(data: data!)
                    self.collectionView.reloadData()
                }
            })
            
        case "AUDIO":
            break
            
        case "VIDEO":
            break
            
        case "LOCATION":
            break
            
        default:
            break
        }
        
        //check to see if this author's avatar has already been added to the dictionary first
        let keyExists = arrayOfAvatars[(msg.authorId)] != nil
        if !keyExists {

            let query = PFQuery(className: PUser.parseClassName())
            query.whereKey("objectId", equalTo: msg.authorId)
            query.getFirstObjectInBackgroundWithBlock({ (user: PFObject?, err: NSError?) in
                if let user: PUser = user as? PUser {
                    if let file = user.thumbnail {
                        file.getDataInBackgroundWithBlock({ (data: NSData?, err: NSError?) in
                            if err == nil {
                                let avatar = JSQMessagesAvatarImage(avatarImage: UIImage(data: data!), highlightedImage: UIImage(data: data!), placeholderImage: UIImage(data: data!))
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
            finishReceivingMessageAnimated(true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isPrivate {
            self.title = "Private Chat"
        } else {
            self.title = "Live Chat"
        }
        self.senderId = PUser.currentUser()?.objectId
        self.senderDisplayName = PUser.currentUser()!.nickname
        self.collectionView.backgroundColor = UIColor.blackColor()
        self.view.backgroundColor = UIColor.blackColor()
        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeMake(50, 50)
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeMake(50, 50)
        self.collectionView.collectionViewLayout.springinessEnabled = false
        
        
        // Add custom attachment button for chat
        
        
        
        //
        
        setupBubbles()
        connectToChatRoom(roomToConnect)
    }

    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController!.navigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)
        let backBtn = UISingleton.sharedInstance.getBackButton()
        backBtn.addTarget(self, action: #selector(DailyScheduleViewController.goBack), forControlEvents: .TouchUpInside)
        let backButton = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        disconnectFromChatRoom()
    }

    private func setupBubbles() {
        let tailBubbleFactory = JSQMessagesBubbleImageFactory()
        outgoingBubbleWithTail = tailBubbleFactory.outgoingMessagesBubbleImageWithColor(UISingleton.sharedInstance.gold)
        incomingBubbleWithTail = tailBubbleFactory.incomingMessagesBubbleImageWithColor(UISingleton.sharedInstance.maroon)
        
        let tailLessBubbleFactory = JSQMessagesBubbleImageFactory(bubbleImage: UIImage.jsq_bubbleRegularTaillessImage(), capInsets: UIEdgeInsetsZero)
        incomingBubbleWithoutTail = tailLessBubbleFactory.incomingMessagesBubbleImageWithColor(UISingleton.sharedInstance.maroon)
        outgoingBubbleWithoutTail = tailLessBubbleFactory.outgoingMessagesBubbleImageWithColor(UISingleton.sharedInstance.gold)
    }

    func subscribeToUpdates() {
        subscription = liveQueryClient
            .subscribe(messagesQuery)
            .handle(Event.Created) { _, message in
                self.printMessage(message)
        }
    }
    
//    func addMessage(message: PChatMessage) {
//        let author = message.author
//        if let attachment = message.attachment {
//            let mediaItem = JSQPhotoMediaItem(image: nil)
//            mediaItem.appliesMediaViewMaskAsOutgoing = isUserCurrentUser(author)
//            let JMessage = JSQMessage(senderId: author.objectId, senderDisplayName: author.nickname, date: message.createdAt, media: mediaItem)
//            arrayOfMessages.append(JMessage)
//            let filePicture = attachment
//            filePicture.getDataInBackgroundWithBlock({ (data: NSData?, err: NSError?) in
//                if err == nil {
//                    mediaItem.image = UIImage(data: data!)
//                    self.collectionView.reloadData()
//                }
//            })
//        } else {
//            let JMessage = JSQMessage(senderId: author.objectId, senderDisplayName: author.nickname, date: message.createdAt, text: message.message)
//            arrayOfMessages.append(JMessage)
//        }
//        finishReceivingMessage()
//    }
    
    func isUserCurrentUser(userToCheck: PUser) -> Bool {
        if userToCheck.objectId == PUser.currentUser()?.objectId {
            return true
        } else {
            return false
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        let messageId = arrayOfOrderedMessageIds[indexPath.item]
        return dictOfMessages[messageId]
    }
    
    override func collectionView(collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return dictOfMessages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let messageId = arrayOfOrderedMessageIds[indexPath.item]
        let message = dictOfMessages[messageId]
        var incoming: Bool
        if message!.senderId == senderId {
            incoming = false
        } else {
            incoming = true
        }
        
        //if the same user has sent the previous message, tailless bubble
        let prevIndex = indexPath.item - 1
        if prevIndex > 0 && prevIndex <= arrayOfOrderedMessageIds.count {
            //make sure we're not out of bounds
            let prevMessageId = arrayOfOrderedMessageIds[indexPath.item - 1]
            let prevMessage = dictOfMessages[prevMessageId]
            if message!.senderId == prevMessage!.senderId {
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
        let messageId = arrayOfOrderedMessageIds[indexPath.item]
        let message = dictOfMessages[messageId]
        
        //if the same user has sent the previous message, empty avatar
        let prevIndex = indexPath.item - 1
        if prevIndex > 0 && prevIndex <= arrayOfOrderedMessageIds.count {
            //make sure we're not out of bounds
            let prevMessageId = arrayOfOrderedMessageIds[indexPath.item - 1]
            let prevMessage = dictOfMessages[prevMessageId]
            if message!.senderId == prevMessage!.senderId {
                return nil
            }
        }
        
        //other wise, show it
        if let avatar = arrayOfAvatars[message!.senderId] {
            return avatar
        } else {
            return JSQMessagesAvatarImage(avatarImage: UIImage(named: "defaultProfilePicture"), highlightedImage: UIImage(named: "defaultProfilePicture"), placeholderImage: UIImage(named: "defaultProfilePicture"))
        }
    }
    
    override func collectionView(collectionView: UICollectionView,
                                 cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
            as! JSQMessagesCollectionViewCell
        
        let messageId = arrayOfOrderedMessageIds[indexPath.item]
        let message = dictOfMessages[messageId]
        if !message!.isMediaMessage {
            if message!.senderId == senderId {
                cell.textView!.textColor = UIColor.whiteColor()
            } else {
                cell.textView!.textColor = UIColor.whiteColor()
            }
        }
        
        return cell
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        if indexPath.item % 3 == 0 {
            let messageId = arrayOfOrderedMessageIds[indexPath.item]
            let message = dictOfMessages[messageId]
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message!.date)
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
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapAvatarImageView avatarImageView: UIImageView!, atIndexPath indexPath: NSIndexPath!) {
        
        let messageId = arrayOfOrderedMessageIds[indexPath.item]
        let message = dictOfMessages[messageId]
        let userId = message!.senderId
        let profileView = ProfileTableViewController()
        profileView.userId = userId
        self.navigationController?.pushViewController(profileView, animated: true)
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!,
                                     senderDisplayName: String!, date: NSDate!) {
        
        sendMessage(text, video: nil, picture: nil, audio: nil)

    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
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
//            PresentVideoLibrary(self, true)
//        }))
//        menuItems.append(RNGridMenuItem(image: UIImage(named: "chat_location"), title: "Location", action: {
//            print("Tapped location")
//        }))
//        menuItems.append(RNGridMenuItem(image: UIImage(named: "chat_stickers"), title: "Stickers", action: {
//            print("Tapped stickers")
//        }))

        let gridMenu = RNGridMenu(items: menuItems)
        gridMenu.backgroundColor = UIColor(colorLiteralRed: 97/255.0, green: 22/255.0, blue: 26/255.0, alpha: 0.7)
        gridMenu.highlightColor = UISingleton.sharedInstance.gold
        gridMenu.showInViewController(self, center: CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2))
    }
    
    //MARK:
    //MARK: UIImagePickerController Delegates
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
        sendMessage(nil, video: vid, picture: pic, audio: nil)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK:
    //MARK: Sending & Receiving Messages
//    func messageSend(text: String?, video: NSURL?, picture: UIImage?, audio: String?) {
//        let outgoing = Outgoing(currentChatRoom?.objectId, view: self.navigationController!.view)
//        outgoing.send(text, video: video, picture: picture, audio: audio)
//        JSQSystemSoundPlayer.jsq_playMessageSentSound()
//        finishSendingMessage()
//    }
    
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
    
    func presentAudioRecorder() {
        let controller = IQAudioRecorderViewController()
        controller.delegate = self
        controller.title = "Record Audio"
        controller.allowCropping = true
        controller.barStyle = UIBarStyle.BlackTranslucent
        self.presentBlurredAudioRecorderViewControllerAnimated(controller)
    }

    func audioRecorderController(controller: IQAudioRecorderViewController, didFinishWithAudioAtPath filePath: String) {
        
    }
    
    func sendMessage(text: String?, video: NSURL?, picture: UIImage?, audio: String?) {
        
        if text != nil { sendTextMessage(text!) }
        if picture != nil { sendPictureMessage(picture!) }
    }
    
    func sendTextMessage(text: String) {
        let message = blankMessage()
        message.message = text
        message.messageType = "TEXT"
        message.saveInBackgroundWithBlock { (done: Bool, err: NSError?) in
            if err == nil {
                
                // add new message to data source
                let msg = JSQMessage(senderId: message.authorId,
                    senderDisplayName: message.authorName,
                    date: NSDate(),
                    text: message.message)
      
                self.addMessageToDataSource(message, jsqMsg: msg)
                self.finishSendingMessage()
                JSQSystemSoundPlayer.jsq_playMessageSentSound()
            } else { print("Couldn't save text message to Parse") }
        }
    }
    
    func sendPictureMessage(picture: UIImage) {
        let message = blankMessage()
        message.message = "[Picture Message]"
        message.messageType = "PICTURE"
        //show loading perhaps
        if let dataPicture = UIImageJPEGRepresentation(picture, 0.6) {
            let file = PFFile(name: "picture.jpg", data: dataPicture)
            message.file = file
        }
        message.saveInBackgroundWithBlock { (done: Bool, err: NSError?) in
            if err == nil {
                
                // add new message to data source
                let mediaItem = JSQPhotoMediaItem(image: nil)
                mediaItem.appliesMediaViewMaskAsOutgoing = (message.authorId == self.senderId)
                let msg = JSQMessage(senderId: message.authorId,
                    senderDisplayName: message.authorName,
                    date: NSDate(),
                    media: mediaItem)

                let filePicture = message.file
                filePicture?.getDataInBackgroundWithBlock({ (data: NSData?, err: NSError?) in
                    if err == nil {
                        mediaItem.image = UIImage(data: data!)
                        self.collectionView.reloadData()
                    }
                })
                
                self.addMessageToDataSource(message, jsqMsg: msg)
                JSQSystemSoundPlayer.jsq_playMessageSentSound()
                self.finishSendingMessage()

            } else { print("Couldn't save picture to Parse") }
        }
    }
    
    func sendVideoMessage() {
//        let message = blankMessage()
//        message.message = "[Video Message]"
//        message.messageType = "VIDEO"
//        //show loading perhaps
//        if let dataPicture = UIImageJPEGRepresentation(picture, 0.6) {
//            let file = PFFile(name: "picture.jpg", data: dataPicture)
//            message.file = file
//        }
//        message.saveInBackground()
//        JSQSystemSoundPlayer.jsq_playMessageSentSound()
//        finishSendingMessage()
    }
    
    func sendAudioMessage() {
        let message = blankMessage()
        message.messageType = "AUDIO"
        message.message = "[Audio Message]"
    }
    
    func sendLocationMessage() {
        let message = blankMessage()
        message.messageType = "LOCATION"
        message.message = "[Location Message]"
    }
    
    func blankMessage() -> PChatMessage {
        let message = PChatMessage()
        message.author = PUser.currentUser()!
        message.authorName = message.author.nickname
        message.room = (currentChatRoom?.objectId)!
        message.roomName = (currentChatRoom?.name)!
        message.authorId = (PUser.currentUser()?.objectId)!
        return message
    }
        //    - (void)send:(NSString *)text Video:(NSURL *)video Picture:(UIImage *)picture Audio:(NSString *)audio
//    //-------------------------------------------------------------------------------------------------------------------------------------------------
//    {
//    NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
//    //---------------------------------------------------------------------------------------------------------------------------------------------
//    item[@"userId"] = [PFUser currentId];
//    item[@"name"] = [PFUser currentName];
//    item[@"date"] = Date2String([NSDate date]);
//    item[@"status"] = TEXT_DELIVERED;
//    //---------------------------------------------------------------------------------------------------------------------------------------------
//    item[@"video"] = item[@"thumbnail"] = item[@"picture"] = item[@"audio"] = item[@"latitude"] = item[@"longitude"] = @"";
//    item[@"video_duration"] = item[@"audio_duration"] = @0;
//    item[@"picture_width"] = item[@"picture_height"] = @0;
//    //---------------------------------------------------------------------------------------------------------------------------------------------
//    if (text != nil) [self sendTextMessage:item Text:text];
//    else if (video != nil) [self sendVideoMessage:item Video:video];
//    else if (picture != nil) [self sendPictureMessage:item Picture:picture];
//    else if (audio != nil) [self sendAudioMessage:item Audio:audio];
//    else [self sendLoactionMessage:item];

}
