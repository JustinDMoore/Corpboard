//
//  VideoCollectionViewController.swift
//  CorpBoard
//
//  Created by Justin Moore on 6/9/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class VideoCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.registerClass(VideoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
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
    
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Server.sharedInstance.arrayOfVideoPlayerViews.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! VideoCell
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
}
