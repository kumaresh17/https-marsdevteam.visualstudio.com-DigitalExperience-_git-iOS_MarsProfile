//
//  MPShareSourceViewController.swift
//  MarsProfile
//
//  Created by TechMadmin on 25/07/17.
//  Copyright © 2017 com.mars.MarsProfile. All rights reserved.
//

import UIKit

class MPShareSourceViewController: MPBaseViewController, UITableViewDataSource,UITableViewDelegate {
    var updatedProfileImage:UIImage?

    @IBOutlet weak var shareActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var sourcesTableView: UITableView!
    
    private let MPShareSourceYammerTableViewCell = "MPShareSourceYammerTableViewCell"
    private let MPShareSourceOneDriveTableViewCell = "MPShareSourceOneDriveableViewCell"
    private var isYammerSelected:Bool = true
    private var isOtherSelected:Bool = true
    private var isYammerSelectedButError:Bool = false
    private var imageToUpload: UIImage?
    private var imageSuccessfullyUploadedToYammer = false
    private var imageSuccessfullyUploadedToOneDrive = false
    
    private var webHandler:MPWebserviceHandler?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.yammerNotificationReceived(_:)), name: NSNotification.Name(rawValue: "YMYammerSDKLoginDidCompleteNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.yammerNotificationFailed(_:)), name: NSNotification.Name(rawValue: "YMYammerSDKLoginDidFailNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.yammerNotificationCancelled(_:)), name: NSNotification.Name(rawValue: "YMYammerSDKLoginDidCancelNotification"), object: nil)

        self.sourcesTableView.register(UINib(nibName: MPShareSourceYammerTableViewCell, bundle: nil), forCellReuseIdentifier: MPShareSourceYammerTableViewCell)
        self.sourcesTableView.register(UINib(nibName: MPShareSourceOneDriveTableViewCell, bundle: nil), forCellReuseIdentifier: MPShareSourceOneDriveTableViewCell)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(updatedProfileImage != nil){
            profileImage.image = updatedProfileImage
            profileImage.contentMode = UIViewContentMode.scaleAspectFill;
            profileImage.layer.borderWidth = 1
            profileImage.layer.masksToBounds = false
            profileImage.layer.borderColor = kPhotoSelctorBorderColor.cgColor
            
            profileImage.clipsToBounds = true
        }
        if((isYammerSelected || isOtherSelected) && updatedProfileImage != nil){
            shareButton.isEnabled = true
            backButton.isEnabled = true
        }
        
        
        UIGraphicsBeginImageContextWithOptions(profileImage.frame.size, true, 0)
        profileImage.layer.render(in: UIGraphicsGetCurrentContext()!)
        imageToUpload = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
       // profileImage.layer.cornerRadius = profileImage.frame.size.height/2.0 // This is to show the Profile picture in rounded.
        
        self.perform(#selector(makeProfilePicRounded), with: nil, afterDelay: 2.0)
        
    }
    
    func makeProfilePicRounded() -> Void {
        profileImage.layer.cornerRadius = profileImage.frame.size.height/2.0 // This is to show the Profile picture in rounded.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // height of section in table view
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return self.sourcesTableView.frame.size.height/2.0
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
        
    }
    // number of section in table view
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0) {
            // create a new cell if needed or reuse an old one
            let cell:MPShareSourceYammerTableViewCell = tableView.dequeueReusableCell(withIdentifier: MPShareSourceYammerTableViewCell) as! MPShareSourceYammerTableViewCell!
            setButtonState(button: cell.sourceButton, withState: true)
            cell.sourceButton.tag = kSourceButtonYammerTag;
            cell.sourceButton.addTarget(self, action: #selector(MPShareSourceViewController.sourceTapped(_:)), for: UIControlEvents.touchUpInside)
            return cell
        }else{
            // create a new cell if needed or reuse an old one
            let cell:MPShareSourceOneDriveableViewCell = tableView.dequeueReusableCell(withIdentifier: MPShareSourceOneDriveTableViewCell) as! MPShareSourceOneDriveableViewCell!
            setButtonState(button: cell.sourceButton, withState: true)
            cell.sourceButton.tag = kSourceButtonOtherTag;
            cell.sourceButton.addTarget(self, action: #selector(MPShareSourceViewController.sourceTapped(_:)), for: UIControlEvents.touchUpInside)
            return cell
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        profileImage.image = nil
        navigationController?.popViewController(animated: true);
    }
    
    @IBAction func shareButtonTapped(_ sender: Any){
        shareButton.isEnabled = false
        backButton.isEnabled = false
        shareActivityIndicator.startAnimating()
        if(isYammerSelected){
            YMLoginClient.sharedInstance().startLogin(withContextViewController: self)
        }
        else{
            uploadImageToSelectedSources()
        }
    }
    func yammerNotificationReceived(_ obj: Notification) {
        print("Succes")
        isYammerSelectedButError = false
        uploadImageToSelectedSources()
    }
    
    func yammerNotificationFailed(_ obj: Notification) {
        print("Failed")
        isYammerSelectedButError = true
        uploadImageToSelectedSources()
    }
    func yammerNotificationCancelled(_ obj: Notification) {
        print("Failed")
        isYammerSelectedButError = true
        uploadImageToSelectedSources()
    }
    
    func uploadImageToSelectedSources(){
        webHandler = MPWebserviceHandler.sMPWebserviceHandler
        if(imageToUpload == nil){
            //Show error message
        }else{
        webHandler?.uploadImageToSources(isImageUploadToYammer: self.isYammerSelected, isImageUploadToOutlook: isOtherSelected, imageToUpload: /*self.updatedProfileImage!*/imageToUpload!, completionHandler: { (isImageUploadedToYammerX: Bool, isImageUploadedToOutlook:Bool, errorForYammer:Error?,  errorForOutlook:Error?) in
            DispatchQueue.main.async {
                var isImageUploadedToYammer = isImageUploadedToYammerX
                if(self.isYammerSelected && self.isYammerSelectedButError){
                    isImageUploadedToYammer = false
                }
                self.shareButton.isEnabled = true
                self.backButton.isEnabled = true
                self.shareActivityIndicator.stopAnimating()
                if(isImageUploadedToYammer && isImageUploadedToOutlook && errorForYammer == nil && errorForOutlook == nil){
                    self.imageSuccessfullyUploadedToYammer = true;
                    self.imageSuccessfullyUploadedToOneDrive = true;
                    
                }else if(isImageUploadedToYammer && !isImageUploadedToOutlook){
                    //Show alert that ntuploaded
                    self.imageSuccessfullyUploadedToYammer = true;
                    self.imageSuccessfullyUploadedToOneDrive = false
                    //self.showAlert(with: "Share", andMessage: "Could not share your image to Outlook")
                }else if((!isImageUploadedToYammer) && isImageUploadedToOutlook){
                    //Show alert that ntuploaded
                    self.imageSuccessfullyUploadedToOneDrive = true;
                    self.imageSuccessfullyUploadedToYammer = false;
                    //self.showAlert(with: "Share", andMessage: "Could not share your image to Yammer")
                }else{
                    self.imageSuccessfullyUploadedToYammer = false;
                    self.imageSuccessfullyUploadedToYammer = false
                   
                }
                if((!self.imageSuccessfullyUploadedToYammer) && (!self.imageSuccessfullyUploadedToOneDrive)){
                     self.showAlert(with: "Share", andMessage: "Could not share your image to sources")
                    
                    }
                else{
                    self.performSegue(withIdentifier: "ToProfileShared", sender: self)
                }
            }
        })
        }
    }
    
    func showAlert(with title:String, andMessage message:String){
        let alertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
    
    func sourceTapped(_ sender: AnyObject) {
        let button = sender as! UIButton
        setButtonState(button: button, withState: !button.isSelected)
        setSourceState(button: button, withState: button.isSelected)
    }
    
    private func setButtonState(button: UIButton, withState selected:Bool){
        button.isSelected = selected
        if(selected == true){
            button.setImage(UIImage(named: "checked_checkbox"), for: UIControlState.selected)
        }else{
            button.setImage(UIImage(named: "unchecked_checkbox"), for: UIControlState.normal)
        }
    }
    
    private func setSourceState(button: UIButton, withState selected:Bool){
        if(button.tag == kSourceButtonYammerTag){
            isYammerSelected = selected
        }else if(button.tag == kSourceButtonOtherTag){
            isOtherSelected = selected
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // TODO:
        if(segue.identifier == "ToProfileShared"){
            let destVC = segue.destination as! MPProfileSharedViewController
            destVC.updatedProfileImage = updatedProfileImage
            var sourcesToShared = ""
            if(isYammerSelected && self.imageSuccessfullyUploadedToYammer){
                sourcesToShared = " Yammer"
            }
            if(isOtherSelected && self.imageSuccessfullyUploadedToOneDrive){
                if(imageSuccessfullyUploadedToYammer && isYammerSelected){
                    sourcesToShared.append(",")
                }
                sourcesToShared.append(" Outlook, Sharepoint and Skype for Business")
            }
            if(sourcesToShared == ""){
                sourcesToShared = "Could not upload to sources, Please try again."
            }else{
                let tracker = AppDelegate.getTracker()
                print("GetTracker -- \(tracker)")
                
                tracker.send((GAIDictionaryBuilder.createEvent(withCategory: "ProfilePic", action: "Uploaded", label: UserDefaults.standard.string(forKey: kLoggedInUserKey), value: nil).build()) as! [AnyHashable : Any]!)
                
               // [tracker set:kGAIScreenName value:screenName];
                //[tracker send:[[GAIDictionaryBuilder createScreenView] build]];
                
                /*tracker.set(kGAIScreenName, value: "Profile Picture")
                let builder = GAIDictionaryBuilder.createScreenView()
                tracker.send(builder?.build()! as! [NSObject : AnyObject])
 */
                
                tracker.set(kGAIScreenName, value: "Profile Picture")
                let build = (GAIDictionaryBuilder.createScreenView().build() as NSDictionary) as! [AnyHashable: Any]
                tracker.send(build)
                
                
            }
            destVC.imageSuccessfullyUploadedToYammer = self.imageSuccessfullyUploadedToYammer
            destVC.imageSuccessfullyUploadedToOneDrive = self.imageSuccessfullyUploadedToOneDrive
            destVC.imageSharedToSource = sourcesToShared
        }
    }
}
