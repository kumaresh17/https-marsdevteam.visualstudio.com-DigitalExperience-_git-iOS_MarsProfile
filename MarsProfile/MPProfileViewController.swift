//
//  MPProfileViewController.swift
//  MarsProfile
//
//  Created by TechMadmin on 02/08/17.
//  Copyright © 2017 com.mars.MarsProfile. All rights reserved.
//

import UIKit
import Photos
import AVKit
import ADALiOS
import SDWebImage

class MPProfileViewController: MPBaseViewController, UIPopoverPresentationControllerDelegate,UIWebViewDelegate {    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var webViewForTerms: UIWebView!
    
    @IBOutlet weak var webViewYConstraint: NSLayoutConstraint!
    @IBOutlet weak var openCameraView: UIView!
    @IBOutlet weak var openGalleryView: UIView!
    @IBOutlet weak var profileActivityIndicatorView: UIActivityIndicatorView!
    var mpLoginAuthController:MPLoginViewController?
    var authenticationContext :ADAuthenticationContext?
    var webHandler : MPWebserviceHandler?
    var profileImage:UIImage?
    private var checkAppPrerequisite = false
    private var webViewHeight:CGFloat?
    // MARK: Controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(authenticationResult(withNotification:)), name: NSNotification.Name(rawValue: "AuthenticatedUserRefreshed"), object: nil)
        checkAppPrerequisite = true;
        if(Display.pad){
            webViewForTerms.loadHTMLString(kHtmlString, baseURL: nil)
        }else{
            //if(Display.typeIsLike == DisplayType.iphone4 || Display.typeIsLike == DisplayType.iphone5){
            webViewHeight = 120.0
            webViewForTerms.loadHTMLString(kHtmlSmallString, baseURL: nil)
        }
        webViewForTerms.delegate = self
        setUpView()
        self.showLoginController()
    }
    func authenticationResult(withNotification notification : Notification) {
        print("RECEIVED SPECIFIC NOTIFICATION: \(notification)")
        checkAppPrerequisite = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        profileActivityIndicatorView.startAnimating()
        webHandler = MPWebserviceHandler.sMPWebserviceHandler
        let isLoggedInAlready = UserDefaults.standard.bool(forKey: kIsLoggedInUserKey)
        
        if(isLoggedInAlready && checkAppPrerequisite){
            
            webHandler?.fetchOutlookProfile({ (result:Any?, error:Error?) in
                if(error == nil && result != nil && (result as? NSDictionary) != nil){
                    let resultedDict = (result as! NSDictionary)
                    let userName = resultedDict.object(forKey: "displayName") as? String
                    let firstName = resultedDict.object(forKey: "givenName") as? String
                    let lastName = resultedDict.object(forKey: "surname") as? String
                    let userId = resultedDict.object(forKey: "id") as? String
                    if(userName != nil){
                        UserDefaults.standard.set(userName!, forKey: kLoggedInUserKey)
                        UserDefaults.standard.set(userId!, forKey: kLoggedInUserIdKey)
                        if(firstName != nil){
                            UserDefaults.standard.set(firstName!, forKey: kUserFirstNameKey)
                        }
                        if(lastName != nil){
                            UserDefaults.standard.set(lastName!, forKey: kUserLastNameKey)
                        }
                        UserDefaults.standard.synchronize()
                        DispatchQueue.main.async {
                            self.userNameLabel.text = userName!
                        }
                        self.downlaodProfileImage()
                    }
                }else{
                    DispatchQueue.main.async {
                        var errorDescription = "Error in fetching profile"
                        if((error as NSError?) != nil){
                            errorDescription = (error! as NSError).localizedDescription
                        }
                        let alertController = UIAlertController(title: "Error", message:
                            errorDescription, preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                        self.profileActivityIndicatorView.stopAnimating()
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            })
            checkAppPrerequisite = false
        }
        profileImageView.contentMode = UIViewContentMode.scaleAspectFill;
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        
        profileImageView.layer.borderColor = kPhotoSelctorBorderColor.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2.0
        profileImageView.clipsToBounds = true
        profileActivityIndicatorView.contentMode = UIViewContentMode.scaleAspectFill;
        profileActivityIndicatorView.layer.borderWidth = 1
        profileActivityIndicatorView.layer.masksToBounds = false
        
        profileActivityIndicatorView.layer.borderColor = kPhotoSelctorBorderColor.cgColor
        profileActivityIndicatorView.layer.cornerRadius = self.profileActivityIndicatorView.frame.size.width/2.0
        profileActivityIndicatorView.clipsToBounds = true
        self.navigationController?.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: kUINavBarFont ?? UIFont.systemFont(ofSize: 16.0), NSForegroundColorAttributeName: UIColor.white], for: .normal)
        self.view.updateConstraintsIfNeeded()
    }
    
    private func setUpView(){
        openCameraView.contentMode = UIViewContentMode.scaleAspectFit;
        openCameraView.layer.borderWidth = 5
        openCameraView.layer.masksToBounds = true
        openCameraView.layer.borderColor = kPhotoSelctorBorderColor.cgColor
        openCameraView.layer.cornerRadius = 10.0
        openCameraView.clipsToBounds = true
        
        openGalleryView.contentMode = UIViewContentMode.scaleAspectFit;
        openGalleryView.layer.borderWidth = 5
        openGalleryView.layer.masksToBounds = true
        openGalleryView.layer.borderColor = kPhotoSelctorBorderColor.cgColor
        openGalleryView.layer.cornerRadius = 10.0
        openGalleryView.clipsToBounds = true
    }
    
    // MARK: Button Action
    @IBAction func openCameraTapped(_ sender: AnyObject) {
        //loginViaADAL()
        //Photos
        let cameraVc = CameraOverlayViewController(nibName: "CameraOverlayViewController", bundle: Bundle.main)
        cameraVc.isCameraToUse = true
        self.navigationController?.pushViewController(cameraVc, animated: true)
    }
    @IBAction func openGalleryTapped(_ sender: AnyObject) {
        //Photos
        let cameraVc = CameraOverlayViewController(nibName: "CameraOverlayViewController", bundle: Bundle.main)
        cameraVc.isCameraToUse = false
        self.navigationController?.pushViewController(cameraVc, animated: true)
    }
    
    @IBAction func termsButtonTapped(_ sender: Any) {
        let button = sender as! UIButton
        if(webViewYConstraint.constant == webViewHeight){
            webViewYConstraint.constant = 340
            button.setImage(UIImage.init(named: "Arrow"), for: UIControlState.normal)
            button.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi));
            webViewForTerms.loadHTMLString(kHtmlString, baseURL: nil)
        }
        else{
            webViewYConstraint.constant = webViewHeight!
            button.setImage(UIImage.init(named: "Arrow"), for: UIControlState.normal)
            button.transform = CGAffineTransform(rotationAngle: CGFloat(0));
            webViewForTerms.loadHTMLString(kHtmlSmallString, baseURL: nil)
        }
        
        self.view.updateConstraints()
    }
    
    @IBAction func moreTapped(_ sender: Any) {
        let button = sender as! UIBarButtonItem
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MPMenuViewController")
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        popover.barButtonItem = button
        popover.delegate = self
        vc.preferredContentSize = CGSize(width: 320.0, height: 580.0)
        present(vc, animated: true, completion:nil)
    }
    
    // MARK: Delegates and callbacks
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if(navigationType == UIWebViewNavigationType.linkClicked){
            UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
            return false
        }
        return true
    }
    
    func sendImage(toView image: UIImage!) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        profileImage = image
        self.dismiss(animated: true) {
            self.performSegue(withIdentifier: "ToShareSourceSegue", sender: self)
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.fullScreen
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let navigationController = UINavigationController(rootViewController: controller.presentedViewController)
        navigationController.navigationBar.barTintColor = navigationBarColor
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.tintColor = UIColor.white
        
        let btnDone = UIBarButtonItem(barButtonSystemItem:.done , target: self, action: #selector(MPProfileViewController.dismiss as (MPProfileViewController) -> () -> ()))
        
        let image = UIImage(named: "ProfileLogo-WithTextWhite.png")
        let imageView = UIImageView(image: image)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 110.0, height: (self.navigationController?.navigationBar.bounds.size.height)!-15.0)
        let view = UIView(frame:CGRect(x: 10, y: -15.0, width: 110.0, height: (self.navigationController?.navigationBar.bounds.size.height)!-15.0))
        view.addSubview(imageView)
        
        navigationController.topViewController?.navigationItem.rightBarButtonItem = btnDone
        navigationController.topViewController?.navigationItem.titleView = view
        return navigationController
    }
    
    func loginViewDidFinish(notification:Notification) -> Void {
        self.dismiss(animated: true) {
            print("login DOne")
        }
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Swift.Void)?) {
        super.dismiss(animated: true) {
            self.showLoginController()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier! == "ToShareSourceSegue"){
            let destVC = segue.destination as! MPShareSourceViewController
            destVC.updatedProfileImage = profileImage
        }
    }
    func showLoginController(){
        let isLoggedInAlready = UserDefaults.standard.bool(forKey: kIsLoggedInUserKey)
        
        if(!isLoggedInAlready){
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            userNameLabel.text = ""
            profileImageView.image = UIImage(named: "placeholder-user-photo.png")
            mpLoginAuthController = storyboard.instantiateViewController(withIdentifier: "MPLoginViewController") as? MPLoginViewController
            self.present(mpLoginAuthController!, animated: true, completion: nil)
        }
    }
    private func downlaodProfileImage(){
        let loginUserName = UserDefaults.standard.string(forKey:kLoggedInUserKey)
        let lastName = UserDefaults.standard.string(forKey:kUserLastNameKey)
        let firstName = UserDefaults.standard.string(forKey:kUserFirstNameKey)
        if((loginUserName != nil) && (lastName != nil || firstName != nil)){
            webHandler = MPWebserviceHandler.sMPWebserviceHandler
            webHandler?.downloadProfileImage(completionHandler: { (result:UIImage?, error:Error?) in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AuthenticatedUserRefreshed"), object: nil)
                if(error == nil && result != nil){
                    DispatchQueue.main.async(execute: {
                        self.profileImageView.image = result
                        self.profileActivityIndicatorView.stopAnimating()
                    })
                }else{
                    print("Could not download image")
                    DispatchQueue.main.async {
                        var errorDescription = "Error in fetching profile"
                        if((error as NSError?) != nil){
                            errorDescription = (error! as NSError).localizedDescription
                        }
                        let alertController = UIAlertController(title: "Error", message:
                            errorDescription, preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                        self.profileActivityIndicatorView.stopAnimating()
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

