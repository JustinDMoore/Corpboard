//
//  DailyScheduleViewController.swift
//  CorpBoard
//
//  Created by Justin Moore on 5/20/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit

class DailyScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableSchedule: UITableView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblHousingLocation: UILabel!
    @IBOutlet weak var lblHousingAddress: UILabel!
    @IBOutlet weak var lblHousingCityStateZip: UILabel!
    @IBOutlet weak var lblShowName: UILabel!
    @IBOutlet weak var lblShowAddress: UILabel!
    @IBOutlet weak var lblShowCityStateZip: UILabel!
    @IBOutlet weak var viewShow: UIView!
    @IBOutlet weak var viewHousing: UIView!
    
    var day = PCalendar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableSchedule.dataSource = self
        self.tableSchedule.delegate = self
    }
}
