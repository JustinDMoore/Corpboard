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

class ProfileTableViewController: UITableViewController {

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
    
//    //MARK:-
//    //MARK:Outlets
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var imgUser: PFImageView!
    @IBOutlet weak var imgCoverPhoto: PFImageView!
    @IBOutlet weak var viewOnline: UIView!
    @IBOutlet weak var imgOnline: UIImageView!
    @IBOutlet weak var lblUserNickname: UILabel!
    @IBOutlet weak var lblUserLocation: UILabel!
    @IBOutlet weak var lblViews: UILabel!
    @IBOutlet weak var lblUserBackground: UILabel!
//
//    //MARK:-
//    //MARK:Variables
    var userProfile = PUser()
    var btnEditProfile = UIBarButtonItem()
    var profileLoaded = false
    var fromPrivate = false
    var editingProfile = false
    var fetchedExperience = false
    var fetchedProfile = false
    var viewLoading = Loading()
    var arrayOfCorpsExperience = [PCorpsExperience]()
//
//    //MARK:-
//    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.hidden = true
        
        self.tableView.tableFooterView = UIView()
        
        loading()
        getUserCorpExperience()
        getUserProfile()
    }

    func initUI() {
        if fetchedExperience && fetchedProfile {
            
            for test in userProfile.arrayOfBadges! {
                print("heeeey: \(test)")
            }
            
            editingProfile = false
            imgUser.layer.cornerRadius = imgUser.frame.size.width / 2
            imgUser.layer.masksToBounds = true
            imgUser.layer.borderColor = UIColor.whiteColor().CGColor
            imgUser.layer.borderWidth = 2
            
            // User Profile Picture
            if let imgFile = userProfile.picture {
                self.imgUser.file = imgFile
                self.imgUser.loadInBackground()
            } else {
                self.imgUser.image = UIImage(named: "defaultProfilePicture")
            }
            
            // User Cover Picture
            if let coverFile = userProfile.coverImage {
                imgCoverPhoto.file = coverFile
                imgCoverPhoto.loadInBackground()
            } else {
                if let coverPointer = userProfile.coverPointer {
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
            if userOnlineNow() {
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
            lblUserNickname.text = userProfile.nickname
            
            // Location
            if userProfile.location != nil {
                lblUserLocation.text = userProfile.location
            } else {
                lblUserLocation.text = ""
            }
            
            // Get joined date
            let formatter = NSDateFormatter()
            formatter.timeStyle = .NoStyle
            formatter.dateStyle = .ShortStyle
            let dateString = formatter.stringFromDate(userProfile.createdAt!)
            
            // Get profile views
            var viewsString = ""
            if userProfile.profileViews == 1 {
                viewsString = "1 View"
            } else {
                viewsString = "\(userProfile.profileViews) Views"
            }
            
            // Get show reviews
            var reviewsString = ""
            if userProfile.showReviews == 1 {
                reviewsString = "1 Show Review"
            } else {
                reviewsString = "\(userProfile.showReviews) Show Reviews"
            }
            
            // Add all 3 up
            lblViews.text = "Joined \(dateString)  |  \(viewsString)  |  \(reviewsString)"
            
            // User background
            if userProfile.background != nil {
                lblUserBackground.text = userProfile.background
                lblUserBackground.sizeToFit()
            } else {
                lblUserBackground.text = "No background listed."
            }
            
            tableView.reloadData()
            stopLoading()
            tableView.hidden = false
        }
    }
    
    func userOnlineNow() -> Bool {
       let dateLastLogin = userProfile.lastLogin
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
        query.whereKey("user", equalTo: userProfile)
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
        userProfile.fetchInBackgroundWithBlock { (object: PFObject?, err: NSError?) in
            if err == nil {
                self.fetchedProfile = true
                self.initUI()
            } else { // Could not load profile
                
            }
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
    
    func showEditButtons() {
        if usersOwnProfile() { //show the edit buttons
            let configBtn = UIButton(type: .Custom)
            let configBtnImage = UIImage(named: "Config")
            configBtn.setImage(configBtnImage, forState: .Normal)
            configBtn.addTarget(self, action: #selector(ProfileTableViewController.configProfile), forControlEvents: .TouchUpInside)
            configBtn.frame = CGRectMake(0, 0, 30, 30)
            btnEditProfile = UIBarButtonItem(customView: configBtn)
            navigationItem.rightBarButtonItem = btnEditProfile
            if profileLoaded {
                btnEditProfile.enabled = true
            } else {
                btnEditProfile.enabled = false
            }
            btnReport.enabled = false
            btnChat.enabled = !fromPrivate //prevents a loop when opening a profile from private chats, then allowing user to start another private chat
        }
    }
    
    func incrementProfileViews() {
        if !usersOwnProfile() {
            var numViews = userProfile.profileViews
            numViews += 1
            userProfile.profileViews = numViews
            userProfile.saveEventually()
        }
    }
    
    func usersOwnProfile() -> Bool {
        if userProfile.objectId == PFUser.currentUser()?.objectId {
            return true
        }
        return false
    }
    
    func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func configProfile() {
        
    }
    
//    // MARK: - Table view data source
//
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 3 { // dynamic height for badges
            if userProfile.arrayOfBadges != nil {
                var num = max(userProfile.arrayOfBadges!.count, 1)
                num += 1
                let result = (num * 35) + 8
                return CGFloat(result)
            } else {
                return (35 * 2) + 8
            }
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 3 {
            return badgeCellForRowAtIndexPath(tableView, cellForRowAtIndexPath: indexPath)
        } else {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }

    func badgeCellForRowAtIndexPath(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        var frame = CGRectMake(0, 0, 200, 50)
            if userProfile.arrayOfBadges?.count < 1 {
                if indexPath.row == 0 {
                    // There are no badges, so create the default "new user badge"
                    let type = BadgeType.NewUser
                    let colorAndImageView = badgeColorAndImageViewForType(type)
                    let btn = UIButton(frame: frame)
                    btn.layer.borderWidth = 1
                    btn.titleLabel?.font = UIFont.systemFontOfSize(14)
                    btn.setTitle("         \(type.rawValue)  ", forState: .Normal)
                    btn.sizeToFit()
                    btn.layer.borderColor = colorAndImageView.color.CGColor
                    btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    btn.addSubview(colorAndImageView.imageView)
                    cell.addSubview(btn)
                }
            } else {
                // Show the badges
                for badge in userProfile.arrayOfBadges! {
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
                        frame = CGRectMake(frame.origin.x, frame.origin.y + 30, frame.size.width, frame.size.height)
                    }
                }
            }
            return cell

    }

    func badgeColorAndImageViewForType(type: BadgeType) -> (color: UIColor, imageView: UIImageView) {
        let imgV = UIImageView(frame: CGRectMake(0, -5, 40, 40))
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
            imgV.frame = CGRectMake(13, 2, 13, 20)
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
}
