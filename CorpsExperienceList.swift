//
//  CorpsExperienceList.swift
//  CorpBoard
//
//  Created by Justin Moore on 6/11/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit


protocol delegateCorpsExperience: class {
    func changedCorpsExperience(experience: [PCorpsExperience])
}

class CorpsExperienceList: UIView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    weak var delegate: delegateCorpsExperience?
    var arrayOfExperience = [PCorpsExperience]()
    
    @IBOutlet weak var tableExperience: UITableView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewDialog: UIView!
    @IBOutlet weak var btnIcon: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnSave: UIView!
    @IBOutlet weak var viewPicker: UIView!
    @IBOutlet weak var txtCorps: CBTextField!
    @IBOutlet weak var txtYear: CBTextField!
    @IBOutlet weak var txtPosition: CBTextField!
    @IBOutlet weak var btnCorpsNotListed: UIButton!
    @IBOutlet weak var btnPositionNotListed: UIButton!
    
    var pickerCorps = UIPickerView(frame: CGRectMake(0, 50, 100, 300))
    var pickerYear = UIPickerView(frame: CGRectMake(0, 50, 100, 300))
    var pickerPosition = UIPickerView(frame: CGRectMake(0, 50, 100, 300))
    var arrayOfYears = [Int]()
    var selectedCorps: PCorps?
    var toolBar = UIToolbar()
    
    func showInParent(parentNav: UINavigationController, experienceList: [PCorpsExperience]) {
        
        tableExperience.setEditing(true, animated: true)
        
        arrayOfExperience = [PCorpsExperience]()
        arrayOfExperience += experienceList
        pickerCorps.delegate = self
        pickerYear.delegate = self
        pickerPosition.delegate = self
        
        pickerCorps.dataSource = self
        pickerYear.dataSource = self
        pickerPosition.dataSource = self
        
        pickerCorps.showsSelectionIndicator = true
        pickerYear.showsSelectionIndicator = true
        pickerPosition.showsSelectionIndicator = true
        
        txtPosition.delegate = self
        txtYear.delegate = self
        txtCorps.delegate = self
        
        txtCorps.inputView = pickerCorps
        txtYear.inputView = pickerYear
        txtPosition.inputView = pickerPosition
        
        pickerCorps.backgroundColor = UIColor.blackColor()
        pickerYear.backgroundColor = UIColor.blackColor()
        pickerPosition.backgroundColor = UIColor.blackColor()
        
        toolBar.barStyle = UIBarStyle.BlackTranslucent
        toolBar.translucent = false
        toolBar.tintColor = UISingleton.sharedInstance.gold
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done   ", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CorpsExperienceList.pickerDone))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        txtCorps.inputAccessoryView = toolBar
        txtYear.inputAccessoryView = toolBar
        txtPosition.inputAccessoryView = toolBar
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year], fromDate: date)
        var year = components.year
        while year > 1971 {
            arrayOfYears.append(year)
            year -= 1
        }

        
        clipsToBounds = true
        layer.cornerRadius = 8
        
        tableExperience.delegate = self
        tableExperience.dataSource = self

       parentNav.view.addSubview(self)
        viewContainer.backgroundColor = UIColor.clearColor()
        
        //DIALOG VIEW TOP ROUNDED CORNERS
        let shapePath2 = UIBezierPath(roundedRect: viewDialog.bounds, byRoundingCorners: [.TopLeft, .TopRight], cornerRadii: CGSizeMake(10, 10))
        
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.frame = viewDialog.bounds
        shapeLayer2.path = shapePath2.CGPath
        shapeLayer2.strokeColor = UIColor.whiteColor().CGColor
        shapeLayer2.fillColor = UISingleton.sharedInstance.maroon.CGColor
        viewDialog.layer.insertSublayer(shapeLayer2, below: tableExperience.layer)
        
        //BUTTON BOTTOM CORNERS ROUND
        let shapePath = UIBezierPath(roundedRect: btnSave.bounds, byRoundingCorners: [.BottomLeft, .BottomRight], cornerRadii: CGSizeMake(10, 10))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = btnSave.bounds
        shapeLayer.path = shapePath.CGPath
        shapeLayer.fillColor = UISingleton.sharedInstance.gold.CGColor
        shapeLayer.strokeColor = UISingleton.sharedInstance.gold.CGColor
        shapeLayer.lineWidth = 1
        btnSave.layer.insertSublayer(shapeLayer, below: btnSave.layer)
        
        //set image and button tint colors to match app
        btnIcon.tintColor = UISingleton.sharedInstance.gold
        btnSave.tintColor = UISingleton.sharedInstance.maroon
        btnSave.backgroundColor = UIColor.clearColor()
        
        //add top border line on button
        let lineView = UIView(frame: CGRectMake(0, 0, btnSave.frame.size.width, 1))
        lineView.backgroundColor = UIColor.whiteColor()
        btnSave.addSubview(lineView)
        
        self.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        
        backgroundColor = UIColor.clearColor()
        viewContainer.alpha = 0
        btnSave.alpha = 0
        frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
        //alpha = 0
        
        tableExperience.reloadData()

        //1
        UIView.animateWithDuration(0.50, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.7, options: .CurveLinear, animations: {
            
           self.viewContainer.transform = CGAffineTransformScale(self.viewDialog.transform, 0.8, 0.8)
            
        }) { (done: Bool) in
            
            //2
            UIView.animateWithDuration(0.25, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: .CurveLinear, animations: {
                self.alpha = 1
                self.viewContainer.alpha = 1
                self.viewContainer.transform = CGAffineTransformIdentity
            }) { (done: Bool) in
                
                
                //set up button for showing
                self.btnSave.frame = CGRectMake(self.btnSave.frame.origin.x, self.btnSave.frame.origin.y - self.btnSave.frame.size.height, self.btnSave.frame.size.width, self.btnSave.frame.size.height)
            }//end 2
            
        }//end 1
    }
    
    func pickerDone() {
        txtPosition.resignFirstResponder()
        txtYear.resignFirstResponder()
        txtCorps.resignFirstResponder()
    }
    
    func showButton() {
        if btnSave.tag == 0 { //check to see if we're already showing or not
            btnSave.tag = 1
            
            UIView.animateWithDuration(0.25, delay: 0.05, options: .CurveEaseIn, animations: {
                
                self.btnSave.alpha = 1
                self.btnSave.frame = CGRectMake(self.btnSave.frame.origin.x, self.btnSave.frame.origin.y + self.btnSave.frame.size.height, self.btnSave.frame.size.width, self.btnSave.frame.size.height)
                
                }, completion: { (done: Bool) in
              print("done: \(self.btnSave)")
            })
        }
    }
    
    func hideButton() {
        print("hide: \(btnSave)")
        if btnSave.tag == 1 { //check to see if we're already showing or not
            btnSave.tag = 0
            UIView.animateWithDuration(0.25, delay: 0.05, options: .CurveEaseIn, animations: {
                
                self.btnSave.alpha = 1
                self.btnSave.frame = CGRectMake(self.btnSave.frame.origin.x, self.btnSave.frame.origin.y - self.btnSave.frame.size.height, self.btnSave.frame.size.width, self.btnSave.frame.size.height)
                
                }, completion: { (done: Bool) in
              print("done: \(self.btnSave)")
            })
        }
    }
    
    @IBAction func notNow(sender: UIButton) {
        closeView()
    }
    
    func closeView() {
        UIView.animateWithDuration(0.25,
                                   delay: 0.09,
                                   usingSpringWithDamping: 1,
                                   initialSpringVelocity: 0.7,
                                   options: UIViewAnimationOptions.CurveLinear,
                                   animations: { 
                                    self.viewContainer.transform = CGAffineTransformScale(self.viewContainer.transform, 0.0, 0.0)
        }) { (done: Bool) in
            self.removeFromSuperview()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfExperience.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        if indexPath.row == 0 { //add experience cell
            cell.textLabel!.text = "    Add Experience"
            let imageView = UIImageView(frame: CGRectMake(5, 9, 25, 25))
            imageView.backgroundColor = UIColor.clearColor()
            imageView.image = UIImage(named: "addExperience")
            cell.addSubview(imageView)
        } else {
            cell.selectionStyle = .None
            if indexPath.row - 1 <= arrayOfExperience.count {
                let exp = arrayOfExperience[indexPath.row - 1]
                let str = "\(exp.corpsName), \(exp.year) - \(exp.position)"
                cell.textLabel!.text = str
            }
        }
        cell.backgroundColor = UISingleton.sharedInstance.maroon
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont.systemFontOfSize(12)
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        } else {
            return true
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row == 0 {
            addNewCorpsExperience()
        }
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let obj = arrayOfExperience[indexPath.row - 1]
        obj.deleteInBackground()
        arrayOfExperience.removeAtIndex(indexPath.row - 1)
        tableExperience.reloadData()
        delegate?.changedCorpsExperience(arrayOfExperience)
    }
    
    func addNewCorpsExperience() {
        pick()
    }
    
    //MARK:-
    //MARK:PickerView
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var string = ""

        
        if pickerView == pickerYear {
            if row == 0 { string = "-Select Year-" }
            else { string = "\(arrayOfYears[row - 1])" }
        } else if pickerView == pickerPosition {
            if row == 0 { string = "-Select Position-" }
            else { string = (Server.sharedInstance.objAdmin?.arrayOfCorpsExperiencePositions[row - 1])! }
        } else if pickerView == pickerCorps {
            if row == 0 { string = "-Select Corps-" }
            else {
                let corps = Server.sharedInstance.arrayOfAllCorps![row-1]
                string = corps.corpsName
            }
        }
        return NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerYear {
            return arrayOfYears.count + 1
        } else if pickerView == pickerPosition {
            return Server.sharedInstance.objAdmin!.arrayOfCorpsExperiencePositions.count + 1
        } else if pickerView == pickerCorps {
            return Server.sharedInstance.arrayOfAllCorps!.count + 1
        } else {
            return 1
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerYear {
            if row == 0 { txtYear.text = "" }
            else { txtYear.text = "\(arrayOfYears[row - 1])" }
        } else if pickerView == pickerPosition {
            if row == 0 { txtPosition.text = "" }
            else { txtPosition.text = Server.sharedInstance.objAdmin?.arrayOfCorpsExperiencePositions[row - 1] }
        } else if pickerView == pickerCorps {
            if row == 0 {
                selectedCorps = nil;
                txtCorps.text = "";
            } else {
                let corps = Server.sharedInstance.arrayOfAllCorps![row - 1]
                selectedCorps = corps;
                txtCorps.text = corps.corpsName
            }
        }
    }
    
    @IBAction func btnCorpsNotListed(sender: UIButton) {
        txtCorps.resignFirstResponder()
        txtCorps.text = ""
        selectedCorps = nil
        if sender.tag == 0 { //default
            if btnPositionNotListed.tag == 1 {
                btnPositionNotListed(btnPositionNotListed)
            }
            sender.tag = 1
            sender.setTitle("Back to List", forState: .Normal)
            sender.setTitle("Back to List", forState: .Selected)
            txtCorps.inputView = nil
            txtCorps.caretEnabled = true
            toolBar.translucent = true
        } else {
            sender.tag = 0
            sender.setTitle("Not Listed?", forState: .Normal)
            sender.setTitle("Not Listed?", forState: .Selected)
            txtCorps.inputView = pickerCorps
            txtCorps.caretEnabled = false
            toolBar.translucent = false
        }
        txtCorps.becomeFirstResponder()
    }
    
    @IBAction func btnPositionNotListed(sender: UIButton) {
        txtPosition.resignFirstResponder()
        txtPosition.text = ""
        if sender.tag == 0 { //default
            if btnCorpsNotListed.tag == 1 {
                btnCorpsNotListed(btnCorpsNotListed)
            }
            sender.tag = 1
            sender.setTitle("Back to List", forState: .Normal)
            sender.setTitle("Back to List", forState: .Selected)
            txtPosition.inputView = nil
            txtPosition.caretEnabled = true
            toolBar.translucent = true
        } else {
            sender.tag = 0
            sender.setTitle("Not Listed?", forState: .Normal)
            sender.setTitle("Not Listed?", forState: .Selected)
            txtPosition.inputView = pickerPosition
            txtPosition.caretEnabled = false
            toolBar.translucent = false
        }
        txtPosition.becomeFirstResponder()
    }
    
    @IBAction func saveExperience(sender: UIButton) {
        if !(txtCorps.text?.isEmpty)! && !(txtYear.text?.isEmpty)! && !(txtPosition.text?.isEmpty)! {
            let experience = PCorpsExperience()
            if let selectedCorps = selectedCorps {
                experience.corps = selectedCorps
            }
            if let name = txtCorps.text {
                experience.corpsName = name
            }
            if let position = txtPosition.text {
                experience.position = position
            }
            experience.user = PUser.currentUser()!
            
            if let year:Int = Int(txtYear.text!) {
                experience.year = year
            }
            
            experience.saveInBackground()
            arrayOfExperience.append(experience)
            delegate?.changedCorpsExperience(arrayOfExperience)
            tableExperience.reloadData()
            doneSaving()
        } else {
            shake()
        }
    }
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.04
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(viewContainer.center.x - 10, viewContainer.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(viewContainer.center.x + 10, viewContainer.center.y))
        viewContainer.layer.addAnimation(animation, forKey: "position")
    }
    
    func pick() {
        
        viewPicker.hidden = false
        
        //hide table
        UIView.animateWithDuration(0.25, delay: 0.05, options: .CurveEaseIn, animations: {
            
            self.tableExperience.alpha = 0
            
            }, completion: { (done: Bool) in
                self.tableExperience.hidden = true
                //show picker
                
                self.viewDialog.bringSubviewToFront(self.viewPicker)
                
                UIView.animateWithDuration(0.25, delay: 0.05, options: .CurveEaseIn, animations: {
                    
                    self.viewPicker.alpha = 1
                    
                    }, completion: { (done: Bool) in
                        
                })
        })
        
        showButton()
    }
    
    func doneSaving() {
        txtYear.text = ""
        txtPosition.text = ""
        txtCorps.text = ""
        txtYear.resignFirstResponder()
        txtPosition.resignFirstResponder()
        txtCorps.resignFirstResponder()
        
        hideButton()
        tableExperience.hidden = false
        //hide table
        UIView.animateWithDuration(0.25, delay: 0.05, options: .CurveEaseIn, animations: {
            
            self.viewPicker.alpha = 0
            
            }, completion: { (done: Bool) in
                self.viewPicker.hidden = true
                //show picker
                
                //self.viewDialog.bringSubviewToFront(self.tableExperience)
                
                UIView.animateWithDuration(0.25, delay: 0.05, options: .CurveEaseIn, animations: {
                    
                    self.tableExperience.alpha = 1
                    
                    }, completion: { (done: Bool) in
                        
                })
        })
    }
    
    @IBAction func goBack(sender: UIButton) {
        doneSaving()
    }
}










