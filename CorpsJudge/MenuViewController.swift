//
//  MenuViewController.swift
//  CorpBoard
//
//  Created by Justin Moore on 5/6/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    //MARK:-
    //MARK:Properties
    var timerBanners = NSTimer()
    var bannerCounter = 0
    
    //MARK:-
    //MARK:Outlets
    @IBOutlet weak var scrollBanners: UIScrollView!
    @IBOutlet weak var collectionNews: UICollectionView!
    
    //MARK:-
    //MARK:Lifecycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timerBanners = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(MenuViewController.scrollToNextBanner), userInfo: nil, repeats: true)
        //TODO: Create CBNewsCell.swift - or point to Obj-C Classs
        //self.collectionNews.registerClass(CBNewsCell.Class, forCellWithReuseIdentifier: "CBNewsCell")
       
        self.initUI()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK:-
    //MARK:Helpers
    func scrollToNextBanner() {
        self.bannerCounter++
        if bannerCounter == 5 {
            bannerCounter = 0
            //TODO: Get rid of these magic numbers!!
            self.scrollBanners.scrollRectToVisible(CGRectMake(640, 0, 320, 416), animated: true)
        }
    }
    
    func initUI() {
         self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "    ", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
    }
}
