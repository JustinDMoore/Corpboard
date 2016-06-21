//
//  MenuTableViewController.swift
//  CorpBoard
//
//  Created by Justin Moore on 6/6/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit
import ImageSlideshow
import JSBadgeView
import PulsingHalo
import YouTubePlayer

class MenuTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, delegateUserProfile, delegateCreateAccount, delegateUserLocation, UIGestureRecognizerDelegate {

    //MARK:-
    //MARK:Outlets
    
    //Banners
    @IBOutlet weak var slideBanners: ImageSlideshow!
    
    //Buttons
    @IBOutlet weak var btnNearMe: UIButton!
    @IBOutlet weak var lblProfile: UILabel!
    @IBOutlet weak var lblMessages: UILabel!
    @IBOutlet weak var lblLiveChat: UILabel!
    @IBOutlet weak var lblNearMe: UILabel!
    @IBOutlet weak var lblTourMap: UILabel!
    
    //Cadets Right Now
    @IBOutlet weak var btnSeeDailySchedule: UIButton!
    @IBOutlet weak var lblTaskLocation: UILabel!
    @IBOutlet weak var lblTask: UILabel!
    @IBOutlet weak var btnSeeTodaysSchedule: UIButton!
    
    //Latest Shows
    @IBOutlet weak var scrollShows: UIScrollView!
    @IBOutlet weak var tableLastShows: UITableView!
    @IBOutlet weak var tableNextShows: UITableView!
    @IBOutlet weak var lblShowsHeader: UILabel!
    @IBOutlet weak var btnSeeAllShows: UIButton!
    @IBOutlet weak var pageShows: UIPageControl!
    
    //Shop and Support
    @IBOutlet weak var viewShop: UIControl!
    @IBOutlet weak var viewSupport: UIControl!
    
    //Top 12
    @IBOutlet weak var scrollTopTwelve: UIScrollView!
    @IBOutlet weak var contentTop: UIView!
    @IBOutlet weak var tableTopFour: UITableView!
    @IBOutlet weak var tableTopEight: UITableView!
    @IBOutlet weak var tableTopTwelve: UITableView!
    @IBOutlet weak var lblTopTwelveHeader: UILabel!
    @IBOutlet weak var btnSeeAllRankings: UIButton!
    @IBOutlet weak var pageTopTwelve: UIPageControl!
    
    //News
    @IBOutlet weak var btnSeeAllNews: UIButton!
    @IBOutlet weak var collectionNews: UICollectionView!
    
    
    //Videos
    @IBOutlet weak var btnSeeAllVideos: UIButton!
    @IBOutlet weak var collectionVideos: UICollectionView!
    
    //About and Feedback
    @IBOutlet weak var viewFeedback: UIControl!
    @IBOutlet weak var viewAboutTheCorps: UIControl!
    
    //Links
    @IBOutlet weak var lblVersion: UILabel!

    //MARK:-
    //MARK:Enums
    enum scrollDir {
        case None
        case Right
        case Left
        case Up
        case Down
        case Crazy
    }
    
    enum opening {
        case None
        case Profile
        case Messages
        case LiveChat
        case NearMe
        case Map
        case Store
    }
    
    //MARK:-
    //MARK:Constants
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    let BUTTON_CORNER_RADIUS: CGFloat = 8.0
    let BUTTON_BORDER_WIDTH: CGFloat = 1.0
    let BUTTON_BORDER_COLOR = UIColor.blackColor().CGColor
    
    //MARK:-
    //MARK:Variables
    var lastShowString = ""
    var nextShowString = ""
    var arrayOfLastShows = [PShow]()
    var arrayOfShowsYesterday = [PShow]()
    var arrayOfShowsToday = [PShow]()
    var arrayOfShowsTomorrow = [PShow]()
    var arrayOfNextShows = [PShow]()
    var arrayOfShowsForTable1 = [PShow]()
    var arrayOfShowsForTable2 = [PShow]()
    var badgeMessages = JSBadgeView()
    var badgeAdmin = JSBadgeView()
    var btnAdminBarButton = UIBarButtonItem()
    var btnAdminButton = UIButton()
    var showToOpen: PShow?
    var lastContentOffSet: CGFloat = 0.0
    var isScrolling = false
    var scrollDirection = scrollDir.None
    var tryingToOpen = opening.None
    var viewLocationForDelegate = LocationServicesPermission()
    
    //MARK:-
    //MARK:View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Server.sharedInstance.getUnreadMessagesForUser()
        initVariables()
        initUI()
        setupShows()
        initNewsFeed()
        sortScores()
        checkForNewVersion()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let imageView = UIImageView(frame: CGRectMake(130, 20, 20, 54))
        imageView.image = UIImage(named: "title")
        imageView.contentMode = .ScaleAspectFit
        navigationItem.titleView = imageView

        self.edgesForExtendedLayout = .None
        
        //update the cadets current activity
        updateCurrentTask()
        
        
        // Video cells were disappearing after returning from
        // videoCollectionViewController - this should keep them visible
        collectionVideos.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        //content size for scrollShows correctly calculated by auto layout
        scrollTopTwelve.contentSize = CGSizeMake(contentTop.frame.size.width, contentTop.frame.size.height)
    }
    
    //MARK:-
    //MARK:Inits
    func initVariables() {
        Server.sharedInstance.delegateLocation = self
 
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "    ",
                                                                style: UIBarButtonItemStyle.Plain,
                                                                target: nil,
                                                                action: nil)
    }
    
    func setupShows() {
        if Server.sharedInstance.arrayOfAllShows?.count > 0 {
            prepareShowsForTable()
//            scrollViewShows.hidden = false
//            lblShowsHeader.hidden = false
//            btnSeeAllShows.hidden = false
        } else {
            print("Error: No shows to set up.")
        }
    }
    
    func loadProfile() {
        //set admin
        if Server.sharedInstance.adminMode {
            navigationController?.navigationBarHidden = false
            navigationItem.setHidesBackButton(false, animated: false)
            btnAdminButton = UIButton(type: .Custom)
            let admImage = UIImage(named: "admin_admin")
            btnAdminButton.setBackgroundImage(admImage, forState: .Normal)
            btnAdminButton.addTarget(self, action: #selector(MenuViewController.admin), forControlEvents: .TouchUpInside)
            btnAdminButton.frame = CGRectMake(0, 0, 30, 30)
            btnAdminButton.addSubview(badgeAdmin)
            btnAdminBarButton = UIBarButtonItem(customView: btnAdminButton)
            navigationItem.leftBarButtonItem = btnAdminBarButton
            setAdminBadge()
        } else {
            navigationController?.navigationBarHidden = false
            navigationItem.setHidesBackButton(true, animated: false)
        }
    }
    
    func initUI() {
        loadProfile()
        pulse()

        let textColor = UISingleton.sharedInstance.gold
        
        lblProfile.textColor = textColor
        lblMessages.textColor = textColor
        lblLiveChat.textColor = textColor
        lblNearMe.textColor = textColor
        lblTourMap.textColor = textColor
        
        automaticallyAdjustsScrollViewInsets = false
        
        // Display app version to user
        let info = NSBundle.mainBundle().infoDictionary
        let version = info!["CFBundleShortVersionString"] as! String
        lblVersion.text = version
        
        // Disclosure arrows
        let disclosure1 = UITableViewCell()
        btnSeeAllShows.addSubview(disclosure1)
        disclosure1.frame = CGRectMake(25, 1, btnSeeAllShows.bounds.size.width, btnSeeAllShows.bounds.size.height)
        disclosure1.accessoryType = .DisclosureIndicator
        disclosure1.userInteractionEnabled = false
        let img1 = UIImageView(image: UIImage(named: "disclosure"))
        img1.frame = CGRectMake(0, 0, 20, 20)
        disclosure1.accessoryView = img1
        
        let disclosure2 = UITableViewCell()
        btnSeeAllRankings.addSubview(disclosure2)
        disclosure2.frame = CGRectMake(25, 1, btnSeeAllRankings.bounds.size.width, btnSeeAllRankings.bounds.size.height)
        disclosure2.accessoryType = .DisclosureIndicator
        disclosure2.userInteractionEnabled = false
        let img2 = UIImageView(image: UIImage(named: "disclosure"))
        img2.frame = CGRectMake(0, 0, 20, 20)
        disclosure2.accessoryView = img2
        
        let disclosure3 = UITableViewCell()
        btnSeeAllNews.addSubview(disclosure3)
        disclosure3.frame = CGRectMake(25, 1, btnSeeAllNews.bounds.size.width, btnSeeAllNews.bounds.size.height)
        disclosure3.accessoryType = .DisclosureIndicator
        disclosure3.userInteractionEnabled = false
        let img3 = UIImageView(image: UIImage(named: "disclosure"))
        img3.frame = CGRectMake(0, 0, 20, 20)
        disclosure3.accessoryView = img3
        
        let disclosure4 = UITableViewCell()
        btnSeeDailySchedule.addSubview(disclosure4)
        disclosure4.frame = CGRectMake(25, 1, btnSeeDailySchedule.bounds.size.width, btnSeeDailySchedule.bounds.size.height)
        disclosure4.accessoryType = .DisclosureIndicator
        disclosure4.userInteractionEnabled = false
        let img4 = UIImageView(image: UIImage(named: "disclosure"))
        img4.frame = CGRectMake(0, 0, 20, 20)
        disclosure4.accessoryView = img4
        
        let disclosure5 = UITableViewCell()
        btnSeeAllVideos.addSubview(disclosure5)
        disclosure5.frame = CGRectMake(25, 1, btnSeeAllVideos.bounds.size.width, btnSeeAllVideos.bounds.size.height)
        disclosure5.accessoryType = .DisclosureIndicator
        disclosure5.userInteractionEnabled = false
        let img5 = UIImageView(image: UIImage(named: "disclosure"))
        img5.frame = CGRectMake(0, 0, 20, 20)
        disclosure5.accessoryView = img5
        
        let disclosure6 = UITableViewCell()
        btnSeeTodaysSchedule.addSubview(disclosure6)
        disclosure6.frame = CGRectMake(25, 1, btnSeeTodaysSchedule.bounds.size.width, btnSeeTodaysSchedule.bounds.size.height)
        disclosure6.accessoryType = .DisclosureIndicator
        disclosure6.userInteractionEnabled = false
        let img6 = UIImageView(image: UIImage(named: "disclosure"))
        img6.frame = CGRectMake(0, 0, 20, 20)
        disclosure6.accessoryView = img6
        
        
        // Top 12
        pageTopTwelve.hidden = true
        lblTopTwelveHeader.hidden = true
        btnSeeAllRankings.hidden = true
        
        // Hide empty cells
        tableLastShows.tableFooterView = UIView()
        tableNextShows.tableFooterView = UIView()
        tableTopFour.tableFooterView = UIView()
        tableTopEight.tableFooterView = UIView()
        tableTopTwelve.tableFooterView = UIView()
        
        // Banners
        slideBanners.backgroundColor = UIColor.whiteColor()
        slideBanners.slideshowInterval = 5.0
        slideBanners.pageControlPosition = .Hidden
        slideBanners.pageControl.currentPageIndicatorTintColor = UIColor.lightGrayColor();
        slideBanners.pageControl.pageIndicatorTintColor = UIColor.blackColor();
        slideBanners.contentScaleMode = .ScaleToFill
        slideBanners.setImageInputs(Server.sharedInstance.arrayOfBannerImages!)
        
        // Buttons
        viewAboutTheCorps.layer.cornerRadius = BUTTON_CORNER_RADIUS
        viewFeedback.layer.cornerRadius = BUTTON_CORNER_RADIUS
        viewShop.layer.cornerRadius = BUTTON_CORNER_RADIUS
        viewSupport.layer.cornerRadius = BUTTON_CORNER_RADIUS
        
        viewAboutTheCorps.layer.borderColor = BUTTON_BORDER_COLOR
        viewFeedback.layer.borderColor = BUTTON_BORDER_COLOR
        viewShop.layer.borderColor = BUTTON_BORDER_COLOR
        viewSupport.layer.borderColor = BUTTON_BORDER_COLOR
        
        viewAboutTheCorps.layer.borderWidth = BUTTON_BORDER_WIDTH
        viewFeedback.layer.borderWidth = BUTTON_BORDER_WIDTH
        viewShop.layer.borderWidth = BUTTON_BORDER_WIDTH
        viewSupport.layer.borderWidth = BUTTON_BORDER_WIDTH
        
        // News
        collectionNews.backgroundColor = UIColor.blackColor()
        
        // Videos
        collectionVideos.backgroundColor = UIColor.blackColor()
    }
    
    func initNewsFeed() {
        self.collectionNews.reloadData()
    }
    
    //MARK:-
    //MARK:Table view data source
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if tableView == self.tableView {
            if indexPath.row == 3 { //recent and next shows will have a varying heigh
                if !arrayOfShowsForTable1.isEmpty || !arrayOfShowsForTable2.isEmpty {
                    var num = max(arrayOfShowsForTable1.count, arrayOfShowsForTable2.count)
                    num += 1
                    let result = (num * 44) + 20 // 20 for pageControl and padding
                    return CGFloat(result)
                }
            }
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        } else if tableView == tableLastShows ||
            tableView == tableNextShows ||
            tableView == tableTopFour ||
            tableView == tableTopEight ||
            tableView == tableTopTwelve {
            return 44
        }
        return 44
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
        
        else if tableView == self.tableLastShows {
            if arrayOfShowsForTable1.count > 0 {
                return arrayOfShowsForTable1.count
            } else {
                return 0
            }
        }
            
        else if tableView == self.tableNextShows {
            if arrayOfShowsForTable2.count > 0 {
                return arrayOfShowsForTable2.count
            } else {
                return 0
            }
        }
            
        else if tableView == self.tableTopFour { return 4 }
        else if tableView == self.tableTopEight { return 4 }
        else if tableView == self.tableTopTwelve { return 4 }
    
        else { return 0 }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
            return cell
        } else if tableView == tableLastShows {
            return lastShowsTableView(cellForRowAtIndexPath: indexPath)
        } else if tableView == tableNextShows {
            return nextShowsTableView(cellForRowAtIndexPath: indexPath)
        } else if tableView == tableTopFour ||
                    tableView == tableTopEight ||
                    tableView == tableTopTwelve {
            return topTwelveTableView(tableView, cellForRowAtIndexPath: indexPath)
        }
        return UITableViewCell()
    }
    
    func topTwelveTableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if Server.sharedInstance.arrayOfWorldClass?.count > 0 {
            
            let corps: PCorps
            let lblCorpsName: UILabel
            let lblPosition: UILabel
            let lblScore: UILabel
            let lblScoreDate: UILabel
            let imgView: UIImageView
            var cell = UITableViewCell()
            
            cell = tableTopFour.dequeueReusableCellWithIdentifier("rank")!
            lblPosition = cell.viewWithTag(4) as! UILabel
            lblCorpsName = cell.viewWithTag(1) as! UILabel
            lblScore = cell.viewWithTag(2) as! UILabel
            lblScoreDate = cell.viewWithTag(3) as! UILabel
            imgView = cell.viewWithTag(5) as! UIImageView
            
            var increment = 0
            if tableView == tableTopFour { increment = 0 }
            if tableView == tableTopEight { increment = 4 }
            if tableView == tableTopTwelve { increment = 8 }
            
            corps = Server.sharedInstance.arrayOfWorldClass![indexPath.row + increment]
            lblPosition.text = "\(indexPath.row + 1 + increment)"
            lblCorpsName.text = corps.corpsName
            //get corps logo
            if corps.logo != nil {
                corps.logo!.getDataInBackgroundWithBlock({ (data: NSData?, err: NSError?) in
                    if err == nil {
                        imgView.image = UIImage(data: data!)
                    } else {
                        imgView.image = nil
                        print("Could not display logo for \(corps.corpsName)")
                    }
                })
            } else {
                imgView.image = nil
                print("Could not display logo for \(corps.corpsName)")
            }
            
            if corps.lastScoreDate.isToday() {
                lblScoreDate.text = "Today"
            } else if corps.lastScoreDate.isYesterday() {
                lblScoreDate.text = "Yesterday"
            } else {
                let days = corps.lastScoreDate.daysBeforeDate(NSDate())
                if days > 1 {
                    lblScoreDate.text = "\(days) days ago"
                } else if days <= 0 {
                    lblScoreDate.text = ""
                } else {
                    lblScoreDate.text = "\(days) day ago"
                }
            }
            
            if corps.lastScore.characters.count > 0 {
                lblScore.text = corps.lastScore
            } else {
                lblScore.text = "0"
                lblScoreDate.text = "No score"
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func nextShowsTableView(cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if self.arrayOfShowsForTable2.count > 0 {
            var cell = UITableViewCell()
            let show: PShow
            let lblShowName: UILabel
            let lblShowLocation: UILabel
            
            cell = self.tableNextShows.dequeueReusableCellWithIdentifier("show")!
            lblShowName = cell.viewWithTag(1) as! UILabel
            lblShowLocation = cell.viewWithTag(2) as! UILabel
            
            show = self.arrayOfShowsForTable2[indexPath.row]
            lblShowName.text = show.showName
            lblShowLocation.text = show.showLocation
            
            return cell
        }
        return UITableViewCell()
    }
    
    func lastShowsTableView(cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if self.arrayOfShowsForTable1.count > 0 {
            var cell = UITableViewCell()
            let show: PShow
            let lblShowName: UILabel
            let lblShowLocation: UILabel
            var btnScores = UIButton()
            
            show = self.arrayOfShowsForTable1[indexPath.row]
            if show.isShowOver {
                cell = self.tableLastShows.dequeueReusableCellWithIdentifier("scores")!
                lblShowName = cell.viewWithTag(1) as! UILabel
                lblShowLocation = cell.viewWithTag(2) as! UILabel
                btnScores = cell.viewWithTag(3) as! UIButton
                btnScores.addTarget(self, action: #selector(MenuViewController.openShow(_:)), forControlEvents: .TouchUpInside)
                lblShowName.text = show.showName
                lblShowLocation.text = show.showLocation
                btnScores.layer.borderWidth = 1.0
                btnScores.layer.borderColor = UISingleton.sharedInstance.appTint.CGColor
                btnScores.layer.cornerRadius = 4.0
                btnScores.titleLabel?.text = " Scores "
                btnScores.layer.masksToBounds = true
                btnScores.titleLabel?.font = UIFont.systemFontOfSize(12)
                btnScores.setTitleColor(UISingleton.sharedInstance.appTint, forState: .Normal)
                
                if show.exception.characters.count > 0 {
                    let lblException = UILabel(frame: CGRectMake(btnScores.frame.origin.x - 5, btnScores.frame.origin.y + 5, btnScores.frame.size.width, 20))
                    lblException.font = UIFont.systemFontOfSize(12)
                    lblException.textColor = UIColor.lightGrayColor()
                    lblException.text = show.exception
                    lblException.textAlignment = .Right
                    lblException.sizeToFit()
                    cell.addSubview(lblException)
                } else {
                    btnScores.hidden = false
                }
                
            } else {
                cell = self.tableLastShows.dequeueReusableCellWithIdentifier("show")!
                lblShowName = cell.viewWithTag(1) as! UILabel
                lblShowLocation = cell.viewWithTag(2) as! UILabel
                lblShowName.text = show.showName
                lblShowLocation.text = show.showLocation
            }
            
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == tableLastShows || tableView == tableNextShows {
            self.openShowAtIndex(indexPath, tableView: tableView)
        }
    }

    
    //MARK:-
    //MARK:UICollectionView
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == collectionNews {
            if News.sharedInstance.arrayOfNewsItemsToDisplay.count >= 6 { return 6 }
            else { return News.sharedInstance.arrayOfNewsItemsToDisplay.count }
        } else if collectionView == collectionVideos {
            if Server.sharedInstance.arrayOfVideoPlayerViews.count >= 6 { return 6 }
            else { return Server.sharedInstance.arrayOfVideoPlayerViews.count }
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView == collectionNews {
            return newsCollectionView(collectionView, cellForItemAtIndexPath: indexPath)
        } else if collectionView == collectionVideos {
            return videoCollectionView(collectionView, cellForItemAtIndexPath: indexPath)
        } else {
            return UICollectionViewCell()
        }
    }
    
    func videoCollectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = "cell\(indexPath.row)"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! VideoCell
        let viewVideo = Server.sharedInstance.arrayOfVideoPlayerViews[indexPath.row]
//        let dateLabel = UILabel(frame: CGRectMake(8, 8, 190, 21))
//        dateLabel.font = UIFont(name: "HelveticaNeue-Light", size: 12)
//        dateLabel.text = News.sharedInstance.dateForNews(item.date)
//        dateLabel.textColor = UIColor.whiteColor()
//        dateLabel.sizeToFit()
//        cell.addSubview(dateLabel)
        
//        let titleLabel = UILabel(frame: CGRectMake(8, dateLabel.frame.origin.y + dateLabel.frame.size.height + 3, 190, 60))
//        titleLabel.font = UIFont.systemFontOfSize(14)
//        titleLabel.text = item.title
//        titleLabel.textColor = UIColor.whiteColor()
//        titleLabel.numberOfLines = 3
//        titleLabel.lineBreakMode = .ByTruncatingTail
//        titleLabel.sizeToFit()
//        cell.addSubview(titleLabel)
        
//        let imgFrom = UIImageView(frame: CGRectMake(cell.frame.size.width - 30, cell.frame.size.height - 25, 30, 30))
//        imgFrom.image = UIImage(named: "DCI_LOGO_Transparent3")
//        cell.addSubview(imgFrom)
        
//        let lblFrom = UILabel(frame: CGRectMake(imgFrom.frame.origin.x + 3, cell.frame.size.height - 17, 190, 21))
//        lblFrom.font = UIFont.systemFontOfSize(10)
//        lblFrom.text = ""
//        lblFrom.textColor = UIColor.blueColor()
//        lblFrom.sizeToFit()
//        cell.addSubview(lblFrom)
        
        viewVideo.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)
        cell.addSubview(viewVideo)
        
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 8
//        cell.colorNumber = News.sharedInstance.arrayOfColors[indexPath.row]
        
        return cell
    }
    
    func newsCollectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = "cell\(indexPath.row)"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! CBNewsCell
        let item = News.sharedInstance.arrayOfNewsItemsToDisplay[indexPath.row]
        let dateLabel = UILabel(frame: CGRectMake(8, 8, 190, 21))
        dateLabel.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        dateLabel.text = News.sharedInstance.dateForNews(item.date)
        dateLabel.textColor = UIColor.whiteColor()
        dateLabel.sizeToFit()
        cell.addSubview(dateLabel)
        
        let titleLabel = UILabel(frame: CGRectMake(8, dateLabel.frame.origin.y + dateLabel.frame.size.height + 3, 190, 60))
        titleLabel.font = UIFont.systemFontOfSize(14)
        titleLabel.text = item.title
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.numberOfLines = 3
        titleLabel.lineBreakMode = .ByTruncatingTail
        titleLabel.sizeToFit()
        cell.addSubview(titleLabel)
        
        let imgFrom = UIImageView(frame: CGRectMake(cell.frame.size.width - 30, cell.frame.size.height - 25, 30, 30))
        imgFrom.image = UIImage(named: "DCI_LOGO_Transparent3")
        cell.addSubview(imgFrom)
        
        let lblFrom = UILabel(frame: CGRectMake(imgFrom.frame.origin.x + 3, cell.frame.size.height - 17, 190, 21))
        lblFrom.font = UIFont.systemFontOfSize(10)
        lblFrom.text = ""
        lblFrom.textColor = UIColor.blueColor()
        lblFrom.sizeToFit()
        cell.addSubview(lblFrom)
        
        cell.lblDate = dateLabel
        cell.lblTitle = titleLabel
        
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 8
        cell.colorNumber = News.sharedInstance.arrayOfColors[indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == collectionNews {
            let itemForWeb = News.sharedInstance.arrayOfNewsItemsToDisplay[indexPath.row]
            self.openWebViewWithLink(itemForWeb.link, title: "Drum Corps International", subTitle: itemForWeb.title)
        } else if collectionView == collectionVideos {
            //play video full screen
        }
    }
    
    //MARK:-
    //MARK:UIScrollView
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if lastContentOffSet > scrollView.contentOffset.x {
            self.scrollDirection = .Right
        } else if lastContentOffSet < scrollView.contentOffset.x {
            self.scrollDirection = .Left
        }
        
        lastContentOffSet = scrollView.contentOffset.x
        
        if scrollView === scrollShows {
            let pageWidth = scrollShows.frame.size.width
            let fractionalPage = scrollShows.contentOffset.x / pageWidth
            let page = lround(Double(fractionalPage))
            self.pageShows.currentPage = page
            if self.pageShows.currentPage == 0 {
                self.lblShowsHeader.text = self.lastShowString
            } else {
                self.lblShowsHeader.text = self.nextShowString
            }
        }
        
        if scrollView === self.scrollTopTwelve {
            let pageWidth = scrollTopTwelve.frame.size.width
            let fractionalPage = scrollTopTwelve.contentOffset.x / pageWidth
            let page = lround(Double(fractionalPage))
            self.pageTopTwelve.currentPage = page
        }
    }
    
//    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        if scrollView === self.scrollViewShows {
//            
//        }
//    }
    
    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //        if scrollView === self.collectionNews {
        //            let point = targetContentOffset
        //            let layout = self.collectionNews.collectionViewLayout as! UICollectionViewFlowLayout
        //            let visibleWidth = layout.minimumInteritemSpacing + layout.itemSize.width
        //            let indexOfItemToSnap = round(point.x / visibleWidth)
        //            if indexOfItemToSnap + 1 == self.collectionNews.numberOfItemsInSection(0) { //last item
        //                targetContentOffset = CGPointMake(self.collectionNews.contentSize.width - self.collectionNews.bounds.size.width, 0)
        //            } else {
        //                targetContentOffset = CGPointMake(indexOfItemToSnap * visibleWidth, 0)
        //            }
        //        }
    }

    //MARK:-
    //MARK:Helpers
    
    func updateCurrentTask() {
        lblTaskLocation.text = Server.sharedInstance.currentLocation
        lblTask.text = Server.sharedInstance.currentTask
    }
    
    func openWebViewWithLink(link: String, title: String, subTitle: String) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let web = storyboard.instantiateViewControllerWithIdentifier("web") as? CBWebViewController {
            web.webURL = link
            web.websiteTitle = title
            web.websiteSubTitle = subTitle
            self.presentViewController(web, animated: true, completion: nil)
        }
    }
    
    func pulse() {
        let halo = PulsingHaloLayer()
        
        halo.radius = 20
        halo.animationDuration = 2
        halo.backgroundColor = UIColor.whiteColor().CGColor
        btnNearMe.layer.addSublayer(halo)
        halo.position = CGPointMake(btnNearMe.frame.origin.x + (btnNearMe.frame.size.width / 2) - 7, btnNearMe.frame.origin.y + (btnNearMe.frame.size.height / 2) - 1)
        //viewProfile.layer.addSublayer(halo)
        //self.viewProfile.bringSubviewToFront(self.btnNearMe)
    }
    
    func openShow(sender: UIButton) {
        var parentCell = sender.superview
        while !(parentCell?.isKindOfClass(UITableViewCell))! {
            parentCell = parentCell?.superview
        }
        var parentView = parentCell?.superview
        while !(parentView?.isKindOfClass(UITableView))! {
            parentView = parentView?.superview
        }
        let tableView = parentView as! UITableView
        let buttonPosition = sender.convertPoint(CGPointZero, toView: tableView)
        let indPath = tableView.indexPathForRowAtPoint(buttonPosition)
        if tableView === self.tableLastShows {
            self.openShowAtIndex(indPath!, tableView: self.tableLastShows)
        } else if tableView === self.tableNextShows {
            self.openShowAtIndex(indPath!, tableView: self.tableNextShows)
        }
    }
    
    func sortScores() {
        if Server.sharedInstance.arrayOfWorldClass?.count > 0 {
            Server.sharedInstance.arrayOfWorldClass!.sortInPlace({ $0.lastScore > $1.lastScore })
        }
        self.pageTopTwelve.hidden = false
        self.lblTopTwelveHeader.hidden = false
        self.btnSeeAllRankings.hidden = false
        self.tableTopFour.reloadData()
        self.tableTopEight.reloadData()
        self.tableTopTwelve.reloadData()
    }
    
    func prepareShowsForTable() {
        self.getPreviousAndNextShows()
        if self.arrayOfShowsForTable2.count > 0 {
            self.tableNextShows.reloadData()
        } else {
            self.tableNextShows.hidden = true
        }
        if self.arrayOfShowsForTable1.count > 0 {
            self.tableLastShows.reloadData()
        } else {
            self.tableLastShows.hidden = true
        }
        if arrayOfShowsForTable1.isEmpty || arrayOfShowsForTable2.isEmpty {
//            self.scrollViewShows.contentSize = CGSizeMake(scrollViewShows.contentSize.width / 2, scrollViewShows.contentSize.height)
            pageShows.numberOfPages = 0
            scrollShows.scrollEnabled = false
        }
    }
    
    func getPreviousAndNextShows() {
        self.arrayOfLastShows = []
        self.arrayOfShowsYesterday = []
        self.arrayOfShowsToday = []
        self.arrayOfShowsTomorrow = []
        self.arrayOfNextShows = []
        self.arrayOfShowsForTable1 = []
        self.arrayOfShowsForTable2 = []
        
        if Server.sharedInstance.arrayOfAllShows?.count > 0 {
            Server.sharedInstance.arrayOfAllShows!.sortInPlace({ $0.showDate.compare($1.showDate) == NSComparisonResult.OrderedAscending })
        }
        
        let lastShow = Server.sharedInstance.arrayOfAllShows?.last
        let lastShowDate = (lastShow?.showDate)! as NSDate
        
        //if today is after finals, just get the last four shows
        if lastShowDate.isInPast() {
            let i = Server.sharedInstance.arrayOfAllShows?.indexOf(lastShow!)
            var x = 0
            while x < 4 {
                self.arrayOfShowsYesterday.append(Server.sharedInstance.arrayOfAllShows![i!-x])
                x += 1
            }
            self.arrayOfShowsForTable1 = self.arrayOfShowsYesterday
            lastShowString = "Latest Shows"
        } else {
            //otherwise proceed as normal
            //get shows for yesterday, today, and tomorrow
            if let shows = Server.sharedInstance.arrayOfAllShows as [PShow]! {
                for show in shows {
                    if show.showDate.isYesterday() {
                        self.arrayOfShowsYesterday.append(show)
                    }
                    if show.showDate.isToday() {
                        self.arrayOfShowsToday.append(show)
                    }
                    if show.showDate.isTomorrow() {
                        self.arrayOfShowsTomorrow.append(show)
                    }
                }
            }
            //get latests show prior to yesterday
            if self.arrayOfLastShows.count < 1 {
                var arrayForLast = [PShow]()
                if self.arrayOfShowsYesterday.count < 1 { //if yesterday is empty, use it
                    arrayForLast = self.arrayOfShowsYesterday
                } else {
                    arrayForLast = self.arrayOfLastShows
                }
                var numberOfDays = 2
                var foundLastDate = false
                repeat {
                    let days = NSDate().dateBySubtractingDays(2)
                    if let shows = Server.sharedInstance.arrayOfAllShows as [PShow]! {
                        for show in shows {
                            if show.showDate.isEqualToDateIgnoringTime(days) {
                                arrayForLast.append(show)
                                foundLastDate = true
                            }
                        }
                        numberOfDays += 1
                        if numberOfDays > 60 { break }
                    }
                    
                } while !foundLastDate
            }
        }
        
        //get the next show after tomorrow
        if self.arrayOfLastShows.count < 1 {
            var arrayForNext = [PShow]()
            if self.arrayOfShowsTomorrow.count < 1 { // if tomorrow is empty, use it
                arrayForNext = self.arrayOfShowsTomorrow
            } else { //otherwise, use next shows
                arrayForNext = self.arrayOfNextShows
            }
            
            var numberOfDays = 2
            var foundNextDate = false
            repeat {
                let days = NSDate().dateByAddingDays(numberOfDays)
                if let shows = Server.sharedInstance.arrayOfAllShows as [PShow]! {
                    for show in shows {
                        if show.showDate.isEqualToDateIgnoringTime(days) {
                            arrayForNext.append(show)
                            foundNextDate = true
                        }
                    }
                    numberOfDays += 1
                    if numberOfDays > 60 { break }
                }
            } while !foundNextDate
        }
        
        //now see what we have and assign the tables
        if self.arrayOfShowsToday.count > 0 {
            self.arrayOfShowsForTable1 = self.arrayOfShowsToday
            if self.arrayOfShowsTomorrow.count > 0 {
                self.arrayOfShowsForTable2 = self.arrayOfShowsTomorrow
            } else if self.arrayOfNextShows.count > 0 {
                self.arrayOfShowsForTable2 = self.arrayOfNextShows
            }
        } else if self.arrayOfShowsYesterday.count > 0 {
            self.arrayOfShowsForTable1 = self.arrayOfShowsYesterday
            if self.arrayOfShowsTomorrow.count > 0 {
                self.arrayOfShowsForTable2 = self.arrayOfShowsTomorrow
            } else if self.arrayOfNextShows.count > 0 {
                self.arrayOfShowsForTable2 = self.arrayOfNextShows
            }
        } else if self.arrayOfLastShows.count > 0 {
            self.arrayOfShowsForTable1 = self.arrayOfLastShows
            if self.arrayOfShowsTomorrow.count > 0 {
                self.arrayOfShowsForTable2 = self.arrayOfShowsTomorrow
            } else if self.arrayOfNextShows.count > 0 {
                self.arrayOfShowsForTable2 = self.arrayOfNextShows
            }
        } else if self.arrayOfShowsTomorrow.count > 0 {
            self.arrayOfShowsForTable1 = self.arrayOfShowsTomorrow
            if self.arrayOfNextShows.count > 0 {
                self.arrayOfShowsForTable2 = self.arrayOfNextShows
            }
        }
        
        //set the date label for table 1 shows
        if self.arrayOfShowsForTable1.count > 0 {
            if let show = self.arrayOfShowsForTable1.first {
                if show.showDate.isToday() {
                    lastShowString = "Shows Today"
                } else if show.showDate.isYesterday() {
                    lastShowString = "Shows Yesterday"
                } else if show.showDate.isTomorrow() {
                    lastShowString = "Shows Tomorrow"
                } else {
                    let formatter = NSDateFormatter()
                    formatter.dateFormat = "EEEE M/dd"
                    lastShowString = formatter.stringFromDate(show.showDate)
                }
            }
        }
        
        //set the date label for table 2 shows
        if self.arrayOfShowsForTable2.count > 0 {
            if let show = self.arrayOfShowsForTable2.first {
                if show.showDate.isToday() {
                    nextShowString = "Shows Today"
                } else if show.showDate.isTomorrow() {
                    nextShowString = "Shows Tomorrow"
                } else {
                    let formatter = NSDateFormatter()
                    formatter.dateFormat = "EEEE M/dd"
                    nextShowString = formatter.stringFromDate(show.showDate)
                }
            }
        }
        
        self.lblShowsHeader.text = lastShowString
    }
    
    //MARK:-
    //MARK: Actions
    @IBAction func feedback(sender: AnyObject) {
        if let feedbackView = NSBundle.mainBundle().loadNibNamed("CBFeedback", owner: self, options: nil).first as? CBFeedback {
            feedbackView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
            feedbackView.showViewInParent(self.navigationController)
        }
    }
    
    @IBAction func rankings(sender: AnyObject) {
        self.performSegueWithIdentifier("rankings", sender: self)
    }
    
    @IBAction func schedules(sender: AnyObject) {
        self.performSegueWithIdentifier("schedules", sender: self)
    }
    
    @IBAction func today(sender: AnyObject) {
        self.performSegueWithIdentifier("today", sender: self)
    }
    
    @IBAction func shows(sender: AnyObject) {
        self.performSegueWithIdentifier("shows", sender: self)
    }
    
    @IBAction func aboutTheCorps(sender: AnyObject) {
        self.performSegueWithIdentifier("corps", sender: self)
    }
    
    @IBAction func news(sender: AnyObject) {
        self.performSegueWithIdentifier("news", sender: self)
    }
    
    @IBAction func videos(sender: AnyObject) {
        self.performSegueWithIdentifier("videos", sender: self)
    }
    
    @IBAction func link(sender: AnyObject) {
        switch sender.tag {
        case 0:
            self.openWebViewWithLink("http://yea.org", title: "Yea!", subTitle: "Youth Education in the Arts")
        case 1:
            self.openWebViewWithLink("http://cadets.org", title: "The Cadets", subTitle: "www.cadets.org")
        case 2:
            self.openWebViewWithLink("http://yea.org/programs/cadets/cadets2", title: "Cadets 2", subTitle: "http://yea.org/programs/cadets/cadets2")
        case 3:
            self.openWebViewWithLink("http://usbands.org", title: "USBands", subTitle: "www.usbands.org")
        case 4:
            self.openWebViewWithLink("http://yea.org/programs/cadets/cadets-winter-perc" , title: "Cadets Winter Percussion", subTitle: "http://yea.org/programs/cadets/cadets-winter-perc")
        case 5:
            self.openWebViewWithLink("http://yea.org/programs/cadets/cadets-winter-guard" , title: "Cadets Winter Guard", subTitle: "http://yea.org/programs/cadets/cadets-winter-guard")
        default: break
        }
    }
    
    @IBAction func admin() {
        self.performSegueWithIdentifier("admin", sender: self)
    }
    
    @IBAction func btnProfile(sender: AnyObject) {
        self.tryingToOpen = .Profile
        if !self.doesUserNeedAccountOrNickname() {
            self.resumeOpening()
        }
    }
    
    @IBAction func btnMessages(sender: AnyObject) {
        self.tryingToOpen = .Messages
        if !self.doesUserNeedAccountOrNickname() {
            self.resumeOpening()
        }
    }
    
    @IBAction func btnChat(sender: AnyObject) {
        self.tryingToOpen = .LiveChat
        if !self.doesUserNeedAccountOrNickname() {
            self.resumeOpening()
        }
    }
    
    @IBAction func near(sender: AnyObject) {
        self.tryingToOpen = .NearMe
        if !self.doesUserNeedAccountOrNickname() {
            self.resumeOpening()
        }
    }
    
    @IBAction func btnTourMap(sender: AnyObject) {
        self.tryingToOpen = .Map
        self.resumeOpening()
    }
    
    @IBAction func shop(sender: UIControl) {
        self.tryingToOpen = .Store
        if !self.doesUserNeedAccountOrNickname() {
            self.resumeOpening()
        }
    }
    
    @IBAction func support(sender: UIControl) {
        let alert = UIAlertController(title: "Support The Cadets", message: "Coming soon.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func openStore() {
        self.performSegueWithIdentifier("store", sender: self)
    }
    
    func openProfile() {
        self.performSegueWithIdentifier("profile", sender: self)
    }
    
    func openMessages() {
        self.performSegueWithIdentifier("messages", sender: self)
    }
    
    func openChat() {
        self.performSegueWithIdentifier("chat", sender: self)
    }
    
    func openNearMe() { //one extra step compared to the other open() functions to ensure location is enabled
        if self.doesUserHaveLocationServicesEnabled() {
            self.performSegueWithIdentifier("find", sender: self)
        }
    }
    
    func openMap() {
        self.performSegueWithIdentifier("tour", sender: self)
    }
    
    //MARK:-
    //MARK: Account Functions
    
    // Checks to see if user has a profile and nickname
    // If they need either, prompts the user
    // If they don't, returns false to the caller can resumeOpening()
    func doesUserNeedAccountOrNickname() -> Bool {
        if profileActive() {
            if !doesUserNeedNickname() {
                return false
            } else {
                signUpForView("nickname")
                return true
            }
        } else {
            signUpForView("account")
            return true
        }
    }
    
    // Called by doesUserNeedAccountOrNickname()
    // Do not call directly
    func profileActive() -> Bool {
        if PFUser.currentUser() != nil {
            return true
        } else {
            return false
        }
    }
    
    // Called by doesUserNeedAccountOrNickname()
    // Do not call directly
    func doesUserNeedNickname() -> Bool {
        if let user = PFUser.currentUser() {
            if let nickname = user["nickname"] as? String {
                if nickname.characters.count < 1 {
                    return true
                } else {
                    return false
                }
            } else {
                return true
            }
        }
        return false
    }
    
    func signUpForView(view: String) {
        if let signUpView = NSBundle.mainBundle().loadNibNamed("CreateAccount", owner: self, options: nil).first as? CreateAccount {
            signUpView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
            signUpView.setDelegate(self);
            signUpView.showView(view, inParent: self.navigationController!)
        }
    }
    
    // delegateCreateAccount in CreateAccount.h
    
    func accountCreated() {
        self.resumeOpening()
    }
    
    //MARK:-
    //MARK: Location Functions
    
    // Checks to see if user has allowed location services
    // If so, returns true
    // If not, prompts user
    // Before this is called, call doesUserNeedAccountOrNickname(), because we need an account to write geo to
    func doesUserHaveLocationServicesEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .AuthorizedAlways: return true
            case .AuthorizedWhenInUse: return true
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
    func userLocationUpdated(location: CLLocation) {
        viewLocationForDelegate.dismissView()
        self.resumeOpening()
    }
    
    // deleateUserLocation in Server.swift
    // called from updateUserLocation()
    func userLocationError() {
        viewLocationForDelegate.dismissView()
        let alert = UIAlertController(title: "Location Services", message: "Corpsboard could not update your location.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //TODO: Double check to make sure lazy inits aren't required on some of the properties
    
    //MARK:-
    //MARK: Helper Functions
    
    func resumeOpening() {
        switch tryingToOpen {
        case .Profile: self.openProfile()
        case .LiveChat: self.openChat()
        case .Map: self.openMap()
        case .Messages: self.openMessages()
        case .NearMe: self.openNearMe()
        case .Store: self.openStore()
        default: break
        }
    }
    
    func openShowAtIndex(indexPath: NSIndexPath, tableView: UITableView) {
        if tableView === tableLastShows {
            self.showToOpen = arrayOfShowsForTable1[indexPath.row]
            if self.showToOpen != nil {
                self.performSegueWithIdentifier("openShow", sender: self)
            }
        } else if tableView === tableNextShows {
            self.showToOpen = arrayOfShowsForTable2[indexPath.row]
            if self.showToOpen != nil {
                self.performSegueWithIdentifier("openShow", sender: self)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "openShow" {
            let vc = segue.destinationViewController as! CBShowDetailsViewController
            vc.show = self.showToOpen
        } else if segue.identifier == "profile" {
            let vc = segue.destinationViewController as! ProfileTableViewController
            if let user = PUser.currentUser() {
                vc.userProfile = user
            }
        } else if segue.identifier == "today" {
            if let vc = segue.destinationViewController as? DailyScheduleViewController {
                vc.day = Server.sharedInstance.day
            }
        } else if segue.identifier == "profile1" {
            let vc = segue.destinationViewController as! CBUserProfileViewController
            if let user = PUser.currentUser() {
                vc.userProfile = user
            }
        }
    }
    
    func makePrediction() {
        self.performSegueWithIdentifier("contest", sender: self)
    }
    
    func checkForNewVersion() {
        let releasedVersion = Server.sharedInstance.objAdmin?.releasedVersion
        if let info = NSBundle.mainBundle().infoDictionary {
            let userVersion = info["CFBundleShortVersionString"] as! String
            if releasedVersion != userVersion {
                self.newVersion()
            }
        }
    }
    
    func newVersion() {
        
    }
    
    func updateUserMessages() {
        self.setMsgBadge()
    }
    
    func setMsgBadge() {
        if Server.sharedInstance.numberOfMessages > 0 {
            self.badgeMessages.badgeText = "\(Server.sharedInstance.numberOfMessages)"
        } else {
            self.badgeMessages.badgeText = ""
        }
    }
    
    func setAdminBadge() {
        var num = 0
        num += (Server.sharedInstance.objAdmin?.feedback)!
        num += (Server.sharedInstance.objAdmin?.photos)!
        num += (Server.sharedInstance.objAdmin?.usersReported)!
        num += (Server.sharedInstance.objAdmin?.problems)!
        if num > 0 {
            self.badgeAdmin.badgeText = "\(num)"
        } else {
            self.badgeAdmin.badgeText = ""
        }
    }

}
