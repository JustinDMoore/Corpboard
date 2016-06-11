//
//  SelectPhotoViewController.swift
//  CorpBoard
//
//  Created by Justin Moore on 6/11/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit
import ParseUI

protocol delegateSelectPhoto: class {
    func coverSubmitForApproval(image: UIImage)
    func coverPhotoObject(photoObject: PPhoto)
    func coverImage(image: UIImage)
}

class SelectPhotoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Outlets
    @IBOutlet weak var segmentAlbum: UISegmentedControl!
    @IBOutlet weak var tablePhotos: UITableView!
    
    let queryPhotos = PFQuery(className: PPhoto.parseClassName())
    weak var delegate: delegateSelectPhoto?
    var viewLoading = Loading()
    var arrayOfDefaultPhotoObjects = [PPhoto]()
    var arrayOfDefaultPhotos = [PFImageView]()
    var arrayOfUserPhotoObjects = [PPhoto]()
    var arrayOfUserPhotos = [PFImageView]()
    var uploading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablePhotos.hidden = true
        segmentAlbum.hidden = true
        loading()
        getPhotos()
        segmentAlbum.addTarget(self, action: #selector(SelectPhotoViewController.segmentChanged), forControlEvents: .ValueChanged)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.navigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)
        let backBtn = UISingleton.sharedInstance.getBackButton()
        backBtn.addTarget(self, action: #selector(SchedulesViewController.goBack), forControlEvents: .TouchUpInside)
        let backButton = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backButton
        self.title = "Cover Image"
    }
    
    func segmentChanged() {
        reload()
    }
    
    func loading() {
        viewLoading = NSBundle.mainBundle().loadNibNamed("Loading", owner: self, options: nil).first as! Loading
        self.view.addSubview(viewLoading)
        viewLoading.center = self.view.center
        viewLoading.animate()
    }
    
    func stopLoading() {
        viewLoading.removeFromSuperview()
    }
    
    func goBack() {
        queryPhotos.cancel()
        stopLoading()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func getPhotos() {
        queryPhotos.whereKey("type", equalTo: PPhoto.typeOfPhoto.Cover.rawValue)
        queryPhotos.whereKey("approved", equalTo: true)
        queryPhotos.orderByAscending("name")
        queryPhotos.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, err: NSError?) in
            if let objects = objects as? [PPhoto] {
                for obj in objects {
                    if obj.userSubmitted {
                        self.arrayOfUserPhotoObjects.append(obj)
                    } else {
                        self.arrayOfDefaultPhotoObjects.append(obj)
                    }
                    
                    let imgView = PFImageView()
                    imgView.file = obj.photo
                    imgView.loadInBackground({ (image: UIImage?, err: NSError?) in
                        if obj.userSubmitted {
                            self.arrayOfUserPhotos.append(imgView)
                        } else {
                            self.arrayOfDefaultPhotos.append(imgView)
                        }
                        
                        if self.arrayOfDefaultPhotos.count + self.arrayOfUserPhotos.count == objects.count {
                            self.tablePhotos.hidden = false
                            self.reload()
                        }
                    })
                }
            } else {
                let alert = UIAlertController(title: "Cover Image", message: "Unable not load images.", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(cancelAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func reload() {
        tablePhotos.reloadData()
        stopLoading()
    }
    
    //MARK:-
    //MARK: UITableView Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentAlbum.selectedSegmentIndex == 0 { // default
            if !tableView.hidden {
                return arrayOfDefaultPhotoObjects.count + 1
            } else { return 0 }
        } else { // user submitted }
            if !arrayOfUserPhotoObjects.isEmpty {
                return arrayOfUserPhotoObjects.count + 1
            } else {
                return 2
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("custom")!
            let btnCamera = cell.viewWithTag(1) as! UIButton
            let btnUpload = cell.viewWithTag(2) as! UIButton
            let btnCamera2 = cell.viewWithTag(3) as! UIButton
            let btnUpload2 = cell.viewWithTag(4) as! UIButton
            
            btnCamera.addTarget(self, action: #selector(SelectPhotoViewController.camera), forControlEvents: .TouchUpInside)
            btnUpload.addTarget(self, action: #selector(SelectPhotoViewController.upload), forControlEvents: .TouchUpInside)
            btnCamera2.addTarget(self, action: #selector(SelectPhotoViewController.camera), forControlEvents: .TouchUpInside)
            btnUpload2.addTarget(self, action: #selector(SelectPhotoViewController.upload), forControlEvents: .TouchUpInside)
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("photoCell")!
            cell.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, cell.bounds.size.width)
            var obj: PPhoto?
            if segmentAlbum.selectedSegmentIndex == 0 {
                obj = arrayOfDefaultPhotoObjects[indexPath.row - 1]
            } else {
                if !arrayOfUserPhotoObjects.isEmpty {
                    obj = arrayOfUserPhotoObjects[indexPath.row - 1]
                } else { //no user pictures yet
                    obj = nil
                    cell = UITableViewCell(style: .Value1, reuseIdentifier: "blank")
                    cell.textLabel!.text = "No user submitted cover images yet. Be the first to submit yours!"
                    cell.textLabel?.font = UIFont.systemFontOfSize(12)
                    cell.textLabel?.textColor = UIColor.lightGrayColor()
                    cell.backgroundColor = UIColor.blackColor()
                    cell.textLabel?.numberOfLines = 0
                    cell.textLabel?.textAlignment = .Center
                    cell.textLabel?.sizeToFit()
                }
            }
            
            if obj != nil {
                let imgFile = obj?.photo
                if let imgView = cell.viewWithTag(1) as? PFImageView {
                    imgView.file = imgFile
                    imgView.loadInBackground()
                    imgView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)
                }
            }
        }
        cell.selectionStyle = .None
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 139
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 139
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 { return }
        
        var imgObject: PPhoto?
        
        if segmentAlbum.selectedSegmentIndex == 0 {
            imgObject = arrayOfDefaultPhotoObjects[indexPath.row - 1]
        } else {
            imgObject = arrayOfUserPhotoObjects[indexPath.row - 1]
        }
        
        if imgObject != nil {
            goBack()
            delegate?.coverPhotoObject(imgObject!)
        }
    }
    
    func camera() {
        uploading = false
        let picker = UIImagePickerController()
        picker.sourceType = .PhotoLibrary
        picker.delegate = self
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func upload() {
        uploading = true
        let alert = UIAlertController(title: "Upload Cover Image", message: "Have a drum corps themed cover image that you want to share with other users?" + "" + "For best quality, images should be 320w x 290h and must be less than 10MB." + "" + "TERMS" + "" + "Any user will be able to use your uploaded cover image in their profile. By uploading an image, you agree to allow Corpsboard and it's users to use the image. Your image will be reviewed, usually within a few minutes, prior to being made available to users.", preferredStyle: .Alert)

        let agreeAction = UIAlertAction(title: "I Agree", style: .Default) { (action: UIAlertAction) in
            let picker = UIImagePickerController()
            picker.sourceType = .PhotoLibrary
            picker.delegate = self
            self.presentViewController(picker, animated: true, completion: nil)
        }
        alert.addAction(agreeAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // UIImagePicker Delegates
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        if uploading {
            delegate?.coverSubmitForApproval(image)
            goBack()
        } else {
            delegate?.coverImage(image)
            goBack()
        }
    }
}








