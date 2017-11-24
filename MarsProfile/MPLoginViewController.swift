//
//  MPLoginViewController.swift
//  MarsProfile
//
//  Created by TechMadmin on 02/08/17.
//  Copyright © 2017 com.mars.MarsProfile. All rights reserved.
//

import UIKit
import ADALiOS
class MPLoginViewController: UIViewController {
    var webHandler : MPWebserviceHandler?
    @IBOutlet weak var activityIndicator :UIActivityIndicatorView?
    @IBOutlet weak var loginView :UIView?
    // MARK: ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginView?.contentMode = UIViewContentMode.scaleAspectFill;
        self.loginView?.layer.borderWidth = 1
        self.loginView?.layer.masksToBounds = false
        
        self.loginView?.layer.borderColor = UIColor.white.cgColor
        self.loginView?.layer.cornerRadius = 4.0
        self.loginView?.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginTapped(_ sender: AnyObject) {
        webHandler = MPWebserviceHandler.sMPWebserviceHandler
        activityIndicator?.startAnimating()
        webHandler?.restClientForSharePoint.getAccessToken({ (accesstoken:String?,error: Error?) in
            if(accesstoken != nil){
                DispatchQueue.main.async {
                    UserDefaults.standard.set(true, forKey: kIsLoggedInUserKey)
                    UserDefaults.standard.synchronize()
                    self.activityIndicator?.stopAnimating()
                    self.dismiss(animated: true, completion: nil)
                }
            }else{
                DispatchQueue.main.async {
                    UserDefaults.standard.set(false, forKey: kIsLoggedInUserKey)
                    UserDefaults.standard.synchronize()
                    self.activityIndicator?.stopAnimating()
                    let alertView = UIAlertController(title: "Login Failed", message: "Login failed, Please try later.", preferredStyle: UIAlertControllerStyle.alert)
                    alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(alertView, animated: true, completion: nil)
                }
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
