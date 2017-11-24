//
//  MPProfileSharedViewController.swift
//  MarsProfile
//
//  Created by TechMadmin on 27/07/17.
//  Copyright © 2017 com.mars.MarsProfile. All rights reserved.
//

import UIKit

class MPProfileSharedViewController: MPBaseViewController,UIWebViewDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var sharedSourcesLabel: UILabel!
    @IBOutlet weak var infoWebView:UIWebView!
    var updatedProfileImage:UIImage?
    var imageSuccessfullyUploadedToYammer:Bool = false
    var imageSuccessfullyUploadedToOneDrive:Bool = false
    var imageSharedToSource:String?
    
    // MARK: ViewController methods 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        infoWebView.scrollView.showsVerticalScrollIndicator = false
        infoWebView.scrollView.bounces = false
        infoWebView.delegate = self
        if(Display.pad){
            infoWebView.loadHTMLString(kHtmlStringForProfileConfirmationForIPad, baseURL: nil)
        }else{
           infoWebView.loadHTMLString(kHtmlStringForProfileConfirmationForIPhone, baseURL: nil)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        if(updatedProfileImage != nil){
            profileImage.image = updatedProfileImage
            profileImage.contentMode = UIViewContentMode.scaleAspectFill;
            profileImage.layer.borderWidth = 1
            profileImage.layer.masksToBounds = false
            profileImage.layer.borderColor = kPhotoSelctorBorderColor.cgColor
            profileImage.layer.cornerRadius = profileImage.frame.size.height/2.0
            profileImage.clipsToBounds = true
            sharedSourcesLabel.text = imageSharedToSource!
        }
    }
 
    @IBAction func homeProfileSharedTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func openLinkForDW(_ sender:Any?){
        UIApplication.shared.open(URL(string:kDWLink)!, options: ["":""], completionHandler: nil)
    }
    // MARK: Delegates and callbacks
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if(navigationType == UIWebViewNavigationType.linkClicked){
            UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
            return false
        }
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
