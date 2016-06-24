//
//  ProfileTableViewController.swift
//  CorpBoard
//
//  Created by Justin Moore on 6/9/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit
import IQKeyboardManager
import ParseUI
import PulsingHalo

class ProfileTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, delegateSelectPhoto, CBUserCategoriesProtocol, delegateCorpsExperience, delegateEditDescription {

    enum BadgeType : String {
        case Alumni = "Alumni",
        Volunteer = "Volunteer",
        Staff = "Staff",
        FormerStaff = "Former Staff",
        FamilyOfMember = "Family of Member",
        Percussionist = "Percussionist",
        BrassPlayer = "Brass Player",
        ColorGuard = "Color Guard",
        ActiveMember = "Active Member",
        Fan = "Fan",
        NewUser = "New User"
    }
    
    enum buttonType {
        case picture, edit
    }
    
//    //MARK:-
//    //MARK:Outlets
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var imgUser: PFImageView!
    @IBOutlet weak var imgCoverPhoto: PFImageView!
    @IBOutlet weak var viewOnline: UIView!
    @IBOutlet weak var imgOnline: UIImageView!
    @IBOutlet weak var lblOnline: UILabel!
    @IBOutlet weak var lblUserNickname: UILabel!
    @IBOutlet weak var lblUserLocation: UILabel!
    @IBOutlet weak var lblViews: UILabel!
    @IBOutlet weak var lblUserBackground: UILabel!
    @IBOutlet weak var lblBadges: UILabel!
    @IBOutlet weak var lblExperience: UILabel!
    @IBOutlet weak var viewEditCoverPicture: UIView!
    @IBOutlet weak var viewEditProfilePicture: UIView!
    @IBOutlet weak var viewEditBadges: UIView!
    @IBOutlet weak var viewEditPriorExperience: UIView!
    @IBOutlet weak var viewEditBackground: UIView!
    @IBOutlet weak var lblAboutMe: UILabel!
    
//    //MARK:-
//    //MARK:Variables
    var userProfile: PUser?
    var userId: String?
    var btnEditProfile = UIBarButtonItem()
    var profileLoaded = false
    var fromPrivate = false
    var editingProfile = false
    var fetchedExperience = false
    var fetchedProfile = false
    var viewLoading = Loading()
    var arrayOfCorpsExperience = [PCorpsExperience]()
    var userCat = CBUserCategories()
    var userExp = CBCorpExperienceList()
    var userDesc = CBEditDescription()
    
//    //MARK:-
//    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        self.tableView.separatorStyle = .None
        self.tableView.tableFooterView = UIView()
        imgCoverPhoto.image = UIImage()
        viewOnline.backgroundColor = UIColor.clearColor()
        viewOnline.clipsToBounds = false
        loading()
        getUserCorpExperience()
        getUserProfile()
    }

    func initUI() {
        if fetchedExperience && fetchedProfile {

            editingProfile = false
            imgUser.layer.cornerRadius = imgUser.frame.size.width / 2
            imgUser.layer.masksToBounds = true
            imgUser.layer.borderColor = UIColor.whiteColor().CGColor
            imgUser.layer.borderWidth = 2
            
            // User Profile Picture
            if let imgFile = userProfile!.picture {
                self.imgUser.file = imgFile
                self.imgUser.loadInBackground()
            } else {
                self.imgUser.image = UIImage(named: "defaultProfilePicture")
            }
            
            // User Cover Picture
            if let coverFile = userProfile!.coverImage {
                imgCoverPhoto.file = coverFile
                imgCoverPhoto.loadInBackground()
            } else {
                if let coverPointer = userProfile!.coverPointer {
                    coverPointer.fetchInBackgroundWithBlock { (object: PFObject?, err: NSError?) in
                        if err == nil {
                            self.imgCoverPhoto.file = coverPointer.photo
                            self.imgCoverPhoto.loadInBackground()
                        }
                    }
                } else {
                    imgCoverPhoto.image = UIImage(named: "defaultCoverPicture")
                }
            }
            
            // Online Now?
            if userOnlineNow() && !usersOwnProfile() {
                viewOnline.hidden = false
                let halo = PulsingHaloLayer()
                halo.position = imgOnline.center
                halo.radius = 10
                halo.animationDuration = 2
                halo.backgroundColor = UIColor.whiteColor().CGColor
                viewOnline.layer.addSublayer(halo)
                imgOnline.layer.cornerRadius = imgOnline.frame.size.height / 2
                imgOnline.layer.borderWidth = 2
                imgOnline.layer.borderColor = UIColor.whiteColor().CGColor
                viewOnline.sendSubviewToBack(imgOnline)
            } else {
                viewOnline.hidden = true
            }
            
            // Name
            lblUserNickname.text = userProfile!.nickname
            
            // Location
            if userProfile!.location != nil {
                lblUserLocation.text = userProfile!.location
            } else {
                lblUserLocation.text = ""
            }
            
            // Get joined date
            let formatter = NSDateFormatter()
            formatter.timeStyle = .NoStyle
            formatter.dateStyle = .ShortStyle
            let dateString = formatter.stringFromDate(userProfile!.createdAt!)
            
            // Get profile views
            var viewsString = ""
            if userProfile!.profileViews == 1 {
                viewsString = "1 Profile View"
            } else {
                viewsString = "\(userProfile!.profileViews) Profile Views"
            }
            
            // Get show reviews
            var reviewsString = ""
            if userProfile!.showReviews == 1 {
                reviewsString = "1 Show Review"
            } else {
                reviewsString = "\(userProfile!.showReviews) Show Reviews"
            }
            
            // Add all 3 up
            lblViews.text = "Joined \(dateString)  |  \(viewsString)  |  \(reviewsString)"
            
            if !usersOwnProfile() {
                viewEditBadges.hidden = true
                viewEditBackground.hidden = true
                viewEditProfilePicture.hidden = true
                viewEditCoverPicture.hidden = true
                viewEditPriorExperience.hidden = true
            }
            
            profileLoaded = true
            tableView.reloadData()
            stopLoading()
            editProfile()
        }
    }
    
    func editProfile() {
        if usersOwnProfile() {
            viewOnline.hidden = true
            btnChat.enabled = false
            btnReport.enabled = false
            
            // Edit Buttons
            let width: CGFloat = 1
            let radius: CGFloat = 8
            let color = UIColor.whiteColor().CGColor
            let backColor = UIColor.blackColor()
            
            // Cover Picture
            viewEditCoverPicture.layer.borderWidth = width
            viewEditCoverPicture.layer.cornerRadius = radius
            viewEditCoverPicture.layer.borderColor = color
            viewEditCoverPicture.backgroundColor = backColor
            
            // Profile Picture
            viewEditProfilePicture.layer.borderWidth = width
            viewEditProfilePicture.layer.cornerRadius = radius
            viewEditProfilePicture.layer.borderColor = color
            viewEditProfilePicture.backgroundColor = backColor
            viewEditProfilePicture.frame = CGRectMake(viewOnline.frame.origin.x, viewOnline.frame.origin
                .y, viewEditProfilePicture.frame.size.width, viewEditProfilePicture.frame.size.height)
            
            // Badges
            viewEditBadges.layer.borderWidth = width
            viewEditBadges.layer.cornerRadius = radius
            viewEditBadges.layer.borderColor = color
            viewEditBadges.backgroundColor = backColor
            
            // Prior Experiences
            viewEditPriorExperience.layer.borderWidth = width
            viewEditPriorExperience.layer.cornerRadius = radius
            viewEditPriorExperience.layer.borderColor = color
            viewEditPriorExperience.backgroundColor = backColor
            
            // Background
            viewEditBackground.layer.borderWidth = width
            viewEditBackground.layer.cornerRadius = radius
            viewEditBackground.layer.borderColor = color
            viewEditBackground.backgroundColor = backColor
        }
    }
    
    @IBAction func editCoverPicture(sender: UIButton) {
        self.performSegueWithIdentifier("coverPhotos", sender: self)
    }

    @IBAction func editProfilePicture(sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = .PhotoLibrary
        picker.delegate = self
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    
    @IBAction func editBadges(sender: UIButton) {
        
        if let userCat = NSBundle.mainBundle().loadNibNamed("CBUserCategories", owner: self, options: nil).first as? CBUserCategories {
            userCat.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
            userCat.setDelegate(self)
            userCat.setCategories(userProfile!.arrayOfBadges)
            userCat.showInParent(self.navigationController!)
        }
    }
    
    @IBAction func editPriorExperience(sender: UIButton) {
        if let userExp = NSBundle.mainBundle().loadNibNamed("CorpsExperienceList", owner: self, options: nil).first as? CorpsExperienceList {
            userExp.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
            userExp.delegate = self
            userExp.showInParent(self.navigationController!, experienceList: arrayOfCorpsExperience)
        }
    }
    
    @IBAction func editBackground(sender: UIButton) {
        if let userDesc = NSBundle.mainBundle().loadNibNamed("CBEditDescription", owner: self, options: nil).first as? CBEditDescription {
            userDesc.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
            userDesc.setDelegate(self)
            userDesc.showInParent(self.navigationController!)
        }
    }
    
    
    func userOnlineNow() -> Bool {
       let dateLastLogin = userProfile!.lastLogin
        let diff = dateLastLogin.minutesBeforeDate(NSDate())
        if diff <= 10 { // Online now (within last 10 minutes)
            return true
        } else {
            return false
        }
    }
    
    func getUserCorpExperience() {
        arrayOfCorpsExperience = [PCorpsExperience]()
        let query = PFQuery(className: PCorpsExperience.parseClassName())
        query.whereKey("user", equalTo: userProfile!)
        query.includeKey("corps")
        query.orderByDescending("year")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, err: NSError?) in
            if err == nil {
                self.fetchedExperience = true
                if objects != nil {
                    for (_, object) in (objects?.enumerate())! {
                        self.arrayOfCorpsExperience.append(object as! PCorpsExperience)
                    }
                    self.initUI()
                }
            } else { // Could not get experience
                
            }
        }
    }
    
    func getUserProfile() {
        if userProfile != nil {
            userProfile!.fetchInBackgroundWithBlock { (object: PFObject?, err: NSError?) in
                if err == nil {
                    self.fetchedProfile = true
                    self.initUI()
                } else { // Could not load profile
                    
                }
            }
        } else {
            let query = PFQuery(className: PUser.parseClassName())
            query.whereKey("objectId", equalTo: userId!)
            query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, err: NSError?) in
                if err == nil {
                    let user = objects?.first as! PUser
                    self.userProfile = user
                    self.fetchedProfile = true
                    self.initUI()
                }
            })
        }
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
    }

    func loading() {
        viewLoading = NSBundle.mainBundle().loadNibNamed("Loading", owner: self, options: nil).first as! Loading
        self.navigationController!.view.addSubview(viewLoading)
        viewLoading.center = self.view.center
        viewLoading.animate()
    }

    func stopLoading() {
        viewLoading.removeFromSuperview()
    }
    
    func incrementProfileViews() {
        if !usersOwnProfile() {
            var numViews = userProfile!.profileViews
            numViews += 1
            userProfile!.profileViews = numViews
            userProfile!.saveEventually()
        }
    }
    
    func usersOwnProfile() -> Bool {
        if userProfile!.objectId == PFUser.currentUser()?.objectId {
            return true
        }
        return false
    }
    
    func goBack() {
        stopLoading()
        userCat.removeFromSuperview()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
//    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === self.tableView {
            if !profileLoaded { return 0 }
            else { return super.tableView(tableView, numberOfRowsInSection: section) }
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 2 { //chat and report, hide if own profile
            if usersOwnProfile() { return 0 }
            else { return super.tableView(tableView, heightForRowAtIndexPath: indexPath) }
        } else if indexPath.row == 3 { // dynamic height for badges
            if userProfile!.arrayOfBadges != nil {
                var num = max(userProfile!.arrayOfBadges!.count, 1)
                num += 1
                let result = (num * 35) + 8
                return CGFloat(result)
            } else {
                return (35 * 2) + 8
            }
        } else if indexPath.row == 4 { // dynamic height for experience
            if !arrayOfCorpsExperience.isEmpty {
                var num = max(arrayOfCorpsExperience.count, 1)
                num += 1
                let result = (num * 35) + 8
                return CGFloat(result)
            } else {
                return (35 * 2) + 8
            }
        } else if indexPath.row == 5 { // dynamic height for background
            if lblUserBackground.hidden { return super.tableView(tableView, heightForRowAtIndexPath: indexPath) }
            else { return UITableViewAutomaticDimension }
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 3 {
            return badgeCellForRowAtIndexPath(tableView, cellForRowAtIndexPath: indexPath)
        } else if indexPath.row == 4 {
            return experienceCellForRowAtIndexPath(tableView, cellForRowAtIndexPath: indexPath)
        } else if indexPath.row == 5 {
            updateBackground()
            return backgroundCell(indexPath)
        } else {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    func backgroundCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        // Remove old experience, if any
        for v in cell.subviews {
            if v.tag == 100 {
                v.removeFromSuperview()
            }
        }
        
        if lblUserBackground.hidden {
            let frame = CGRectMake(lblAboutMe.frame.origin.x + 8, lblAboutMe.frame.origin.y + 28, 200, 50)
                // There is no experience, so create the default
                let type = BadgeType.NewUser
                let colorAndImageView = badgeColorAndImageViewForType(type)
                let btn = UIButton(frame: frame)
                //btn.layer.borderWidth = 1
                btn.titleLabel?.font = UIFont.systemFontOfSize(14)
                btn.setTitle("         All About Nothing  ", forState: .Normal)
                btn.sizeToFit()
                //btn.layer.borderColor = colorAndImageView.color.CGColor
                btn.titleLabel?.textColor = UIColor.blueColor()
                btn.addSubview(colorAndImageView.imageView)
                cell.addSubview(btn)
                cell.bringSubviewToFront(btn)
                btn.tag = 100
        }
        return cell
    }
    
    func updateBackground() {
        if userProfile!.background != nil {
            if userProfile!.background == "" {
                lblUserBackground.hidden = true
            } else {
                lblUserBackground.hidden = false
                lblUserBackground.numberOfLines = 0
                lblUserBackground.text = userProfile!.background
                lblUserBackground.sizeToFit()
            }
        } else {
            lblUserBackground.hidden = true
        }
    }
    
    func userCatCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        cell.textLabel!.text = userCat.arrayOfCategories[indexPath.row] as? String
        cell.selectionStyle = .None
        cell.textLabel?.font = UIFont.systemFontOfSize(14)
        let str = userCat.dict.objectForKey((cell.textLabel?.text)!)
        if str === "YES" {
            selectCell(cell, atIndexPath: indexPath, isOn: true, fromMethod: false)
        } else {
            selectCell(cell, atIndexPath: indexPath, isOn: false, fromMethod: false)
        }
        return cell
    }
    
    func experienceCellForRowAtIndexPath(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        // Remove old experience, if any
        for v in cell.subviews {
            if v.tag == 100 {
                v.removeFromSuperview()
            }
        }
        
        var frame = CGRectMake(lblExperience.frame.origin.x + 8, lblExperience.frame.origin.y + 28, 200, 50)
        if arrayOfCorpsExperience.count < 1 {
            // There is no experience, so create the default
            let type = BadgeType.NewUser
            let colorAndImageView = badgeColorAndImageViewForType(type)
            let btn = UIButton(frame: frame)
            //btn.layer.borderWidth = 1
            btn.titleLabel?.font = UIFont.systemFontOfSize(14)
            btn.setTitle("         No Prior Experience Listed  ", forState: .Normal)
            btn.sizeToFit()
            //btn.layer.borderColor = colorAndImageView.color.CGColor
            btn.titleLabel?.textColor = UIColor.blueColor()
            btn.addSubview(colorAndImageView.imageView)
            cell.addSubview(btn)
            btn.tag = 100
        } else {
            // Show the badges
            for experience in arrayOfCorpsExperience {
                let imgV = PFImageView(frame: CGRectMake(0, 0, 27, 27))
                if let corps = experience.corps {
                    let imgLogo = corps.logo
                    imgV.file = imgLogo
                    imgV.loadInBackground()
                    imgV.contentMode = .ScaleAspectFit
                }
                let str = "\(experience.corpsName), \(experience.year) - \(experience.position)"
                let btn = UIButton(frame: frame)
                btn.titleLabel?.font = UIFont.systemFontOfSize(14)
                btn.setTitle("         \(str)  ", forState: .Normal)
                btn.sizeToFit()
                btn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
                btn.addSubview(imgV)
                cell.addSubview(btn)
                btn.tag = 100
                frame = CGRectMake(frame.origin.x, frame.origin.y + 35, frame.size.width, frame.size.height)
            }
        }

        return cell
    }
    
    func badgeCellForRowAtIndexPath(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        // Remove all the old badges first, if any
        for v in cell.subviews {
            if v.tag == 100 {
                v.removeFromSuperview()
            }
        }
        
        var frame = CGRectMake(lblBadges.frame.origin.x + 8, lblBadges.frame.origin.y + 28, 200, 50)
        if userProfile!.arrayOfBadges?.count < 1 {
            // There are no badges, so create the default "new user badge"
            let type = BadgeType.NewUser
            let colorAndImageView = badgeColorAndImageViewForType(type)
            let btn = UIButton(frame: frame)
            //btn.layer.borderWidth = 1
            btn.titleLabel?.font = UIFont.systemFontOfSize(14)
            btn.setTitle("         No Badges Set  ", forState: .Normal)
            btn.sizeToFit()
            //btn.layer.borderColor = colorAndImageView.color.CGColor
            btn.titleLabel?.textColor = UIColor.blueColor()
            btn.addSubview(colorAndImageView.imageView)
            cell.addSubview(btn)
            btn.tag = 100
        } else {
            // Show the badges
            for badge in userProfile!.arrayOfBadges! {
                if let type = BadgeType(rawValue: badge) {
                    let colorAndImageView = badgeColorAndImageViewForType(type)
                    let btn = UIButton(frame: frame)
                    btn.layer.borderWidth = 1
                    btn.titleLabel?.font = UIFont.systemFontOfSize(14)
                    btn.setTitle("         \(type.rawValue)  ", forState: .Normal)
                    btn.sizeToFit()
                    btn.layer.borderColor = colorAndImageView.color.CGColor
                    btn.setTitleColor(colorAndImageView.color, forState: .Normal)
                    btn.addSubview(colorAndImageView.imageView)
                    cell.addSubview(btn)
                    btn.tag = 100
                    frame = CGRectMake(frame.origin.x, frame.origin.y + 35, frame.size.width, frame.size.height)
                }
            }
        }
        return cell
    }
    
    func badgeColorAndImageViewForType(type: BadgeType) -> (color: UIColor, imageView: UIImageView) {
        let imgV = UIImageView(frame: CGRectMake(-2, -5, 40, 40))
        switch type {
        case .Alumni:
            imgV.image = UIImage(named: "badgeAlumni")
            return (colorFromHexString("f5542c"), imgV)
        case .Volunteer:
            imgV.image = UIImage(named: "badgeVolunteer")
            return (colorFromHexString("9a5fad"), imgV)
        case .Staff:
            imgV.image = UIImage(named: "badgeStaff")
            return (colorFromHexString("3ac251"), imgV)
        case .FormerStaff:
            imgV.image = UIImage(named: "badgeStaff")
            return (colorFromHexString("3ac251"), imgV)
        case .FamilyOfMember:
            imgV.image = UIImage(named: "badgeFamily")
            return (colorFromHexString("02abde"), imgV)
        case .Percussionist:
            imgV.image = UIImage(named: "badgePercussionist")
            return (colorFromHexString("f7c82d"), imgV)
        case .BrassPlayer:
            imgV.image = UIImage(named: "badgeBrassPlayer")
            return (colorFromHexString("C0C0C0"), imgV)
        case .ColorGuard:
            imgV.image = UIImage(named: "badgeColorGuard")
            return (colorFromHexString("c3de7e"), imgV)
        case .ActiveMember:
            imgV.image = UIImage(named: "badgeActiveMember")
            imgV.frame = CGRectMake(15, 3, 10, 22)
            return (colorFromHexString("85a6ab"), imgV)
        case .Fan:
            imgV.image = UIImage(named: "badgeFan")
            return (colorFromHexString("B83535"), imgV)
        case .NewUser:
            imgV.image = UIImage(named: "badgeNewUser")
            return (UIColor.blueColor(), imgV)
        }
    }
    
//    //MARK:-
//    //MARK:Helpers
    func colorFromHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    //MARK:-
    //MARK: UIImagePickerController Delegates
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        saveProfileImage(image)
    }
    
    func saveProfileImage(image: UIImage?) {
        loading()
        var photo = image!
        //Have the image draw itself in the correct orientation if necessary
        if !(photo.imageOrientation == .Up || photo.imageOrientation == .UpMirrored) {
            let imgsize = photo.size
            UIGraphicsBeginImageContext(imgsize)
            photo.drawInRect(CGRectMake(0, 0, imgsize.width, imgsize.height))
            photo = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        if let imageData = UIImagePNGRepresentation(photo) {
            let size = imageData.length
            if size < 20971520 { //20MB
                if let imageFile = PFFile(name: "picture.png", data: imageData) {
                    
                    imgUser.image = image
                    userProfile!.setObject(imageFile, forKey: userProfile!.pictureString)
                    userProfile!.saveInBackground()
                    stopLoading()
                    
                } else {
                    let alert = UIAlertController(title: "Update Profile", message: "An error occurred updating your picture.", preferredStyle: .Alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(defaultAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                    self.stopLoading()
                }
            } else {
                let alert = UIAlertController(title: "Image Too Large", message: "Image must be less than 20MB.", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(defaultAction)
                self.presentViewController(alert, animated: true, completion: nil)
                stopLoading()
            }
        }
    }
    
    //MARK:-
    //MARK: Cover Photo Protocol

    func coverSubmitForApproval(image: UIImage) {
        submitPhotoForReview(image)
    }
    
    func coverPhotoObject(photoObject: PPhoto) {
        //either a default cover photo or user submitted cover photo
        //just set the pointer and clear the profile cover photo
        loading()
        
        userProfile!.removeObjectForKey(userProfile!.coverImageString)
        userProfile!.setObject(photoObject, forKey: userProfile!.coverPointerString)
        imgCoverPhoto.file = photoObject.photo
        imgCoverPhoto.loadInBackground()
        userProfile!.saveInBackground()
        stopLoading()
    }

    func coverImage(image: UIImage) {
        loading()
        //new cover image from camera roll
        //clear the cover pointer and set the image
        
        if let imageData = UIImagePNGRepresentation(image) {
            let size = imageData.length
            if size < 20971520 { //20MB
                if let imageFile = PFFile(name: "cover.png", data: imageData) {
                    
                    imgCoverPhoto.image = image
                    userProfile!.setObject(imageFile, forKey: userProfile!.coverImageString)
                    userProfile!.saveInBackground()
                    stopLoading()
                    
                } else {
                    let alert = UIAlertController(title: "Update Profile", message: "An error occurred updating your cover picture.", preferredStyle: .Alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(defaultAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                    self.stopLoading()
                }
            } else {
                let alert = UIAlertController(title: "Image Too Large", message: "Image must be less than 20MB.", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(defaultAction)
                self.presentViewController(alert, animated: true, completion: nil)
                stopLoading()
            }
        }
        
    }
    
    func submitPhotoForReview(image: UIImage) {
        loading()
        if let imageData = UIImagePNGRepresentation(image) {
            let size = imageData.length
            if size < 20971520 { //20MB
                if let imageFile = PFFile(name: "picture.png", data: imageData) {
                    let photoForReview = PPhoto()
                    photoForReview.type = PPhoto.typeOfPhoto.Cover.rawValue
                    photoForReview.user = PUser.currentUser()
                    photoForReview.userSubmitted = true
                    photoForReview.approved = false
                    photoForReview.photo = imageFile
                    photoForReview.isPublic = true
                    stopLoading()
                    photoForReview.saveInBackgroundWithBlock({ (success: Bool, err: NSError?) in
                        if !success {
                            let alert = UIAlertController(title: "Update Profile", message: "An error occurred updating your cover picture.", preferredStyle: .Alert)
                            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            alert.addAction(defaultAction)
                            self.presentViewController(alert, animated: true, completion: nil)
                            self.stopLoading()
                        }
                    })
                }
            } else {
                let alert = UIAlertController(title: "Image Too Large", message: "Image must be less than 20MB.", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(defaultAction)
                self.presentViewController(alert, animated: true, completion: nil)
                stopLoading()
            }
        } else {
            let alert = UIAlertController(title: "Update Profile", message: "An error occurred updating your cover picture.", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(defaultAction)
            self.presentViewController(alert, animated: true, completion: nil)
            self.stopLoading()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "coverPhotos" {
            if let vc = segue.destinationViewController as? SelectPhotoViewController {
                vc.delegate = self
            }
        } else if segue.identifier == "chat" {
            let vc = segue.destinationViewController as! ChatViewController
            vc.isPrivate = true
            vc.receiverId = (userProfile?.objectId)!
        }
    }
    
    // Badges Protocol
    func categoriesClosed() {
       
    }
    
    func savedCategories() {
        self.tableView.reloadData()
    }
    
    func selectCell(cell: UITableViewCell, atIndexPath: NSIndexPath, isOn: Bool, fromMethod: Bool) {
        
    }
    
    func changedCorpsExperience(experience: [PCorpsExperience]) {
        arrayOfCorpsExperience = [PCorpsExperience]()
        arrayOfCorpsExperience = experience
        tableView.reloadData()
    }

    func decriptionUpdated() {
        updateBackground()
        self.tableView.reloadData()
    }
    
    
    @IBAction func btnChat_didTap(sender: UIButton) {
        self.performSegueWithIdentifier("chat", sender: self)
    }
    
}





