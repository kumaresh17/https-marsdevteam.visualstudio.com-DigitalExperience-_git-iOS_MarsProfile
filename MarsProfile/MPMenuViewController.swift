//
//  MPMenuViewController.swift
//  MarsProfile
//
//  Created by TechMadmin on 24/07/17.
//  Copyright © 2017 com.mars.MarsProfile. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import MessageUI


class MPMenuViewController: MPBaseViewController, UITableViewDelegate,UITableViewDataSource, MFMailComposeViewControllerDelegate,UIWebViewDelegate{
    
    static let MenuCellReuseIdentifier = "MPMenuOptionTableViewCell"
    static let MenuCellReuseIdentifierAbout = "MPMenuOptionAboutTableViewCell"
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var versionLabel: UILabel!
    private let menuSectionOption:[String] = [kAboutApp, kContact];
    private let menuOption:[String] = [kReportIssue, kShareThisApp, kAppLogout]
    private let menuOptionImage:[String] = ["Reportissue", "Recommend", "profile-icon"]
    // MARK: Controllers methods
    override func viewDidLoad() {
        // Register the table view cell class and its reuse id
        //self.title = kAppName
        self.tableView.register(UINib(nibName: MPMenuViewController.MenuCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: MPMenuViewController.MenuCellReuseIdentifier)
        self.tableView.register(UINib(nibName: MPMenuViewController.MenuCellReuseIdentifierAbout, bundle: nil), forCellReuseIdentifier: MPMenuViewController.MenuCellReuseIdentifierAbout)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        self.navigationController?.navigationBar.isHidden = false
        versionLabel.text = kAppVersion
    }
    // MARK: IBAction
    @IBAction func openLinkForDW(_ sender:Any?){
        UIApplication.shared.open(URL(string:kDWLink)!, options: ["":""], completionHandler: nil)
    }
    // MARK: TableView delegate and data source methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let rowHeight:CGFloat?
        
        if(indexPath.section == 0){ 
            if(DisplayType.iphone4 == Display.typeIsLike || DisplayType.iphone5 == Display.typeIsLike){
                rowHeight = 110.0
            }else{
                rowHeight = 130.0
            }
        }else{
            if(DisplayType.iphone4 == Display.typeIsLike || DisplayType.iphone5 == Display.typeIsLike){
                rowHeight = 50.0
            }else{
                rowHeight = 54.0
            }
        }
        return rowHeight!
    }
    // height of header section-  vary based on iphone4/6
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        let sectionHeight:CGFloat?
        if(DisplayType.iphone4 == Display.typeIsLike || DisplayType.iphone5 == Display.typeIsLike){
            sectionHeight = 50.0
        }else{
            sectionHeight = 54.0
        }
        return sectionHeight!
    }
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 1
        }
        return menuOption.count
        
    }
    // number of section in table view
    func numberOfSections(in tableView: UITableView) -> Int{
        return menuSectionOption.count
    }
    // title of section in table view
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return menuSectionOption[section]
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 1) {
            // create a new cell if needed or reuse an old one
            let cell:MPMenuOptionTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: MPMenuViewController.MenuCellReuseIdentifier) as! MPMenuOptionTableViewCell!
            // set the text from the data model
            cell.menuOptionLabel?.text = menuOption[indexPath.row]
            cell.iconImageView?.image = UIImage(named: menuOptionImage[indexPath.row])
            return cell
        }else{
            let cell:MPMenuOptionAboutTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: MPMenuViewController.MenuCellReuseIdentifierAbout) as! MPMenuOptionAboutTableViewCell!
            cell.aboutWebView.loadHTMLString(kHtmlAboutApp, baseURL: nil)
            cell.aboutWebView.delegate = self
            return cell
        }
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
//        if(indexPath.section == 1 && indexPath.row == 0){
//            //Give Feedback
//            showAlert(title: kGiveFeedbackTitle, withMessage: kGiveFeedbackMessage, andURL:kGiveFeedbackURL)
//        }else
        if(indexPath.section == 1 && indexPath.row == 0){
            //Report issue
            mailFromExternal(toMail:kReportIssueMailID, withSubject: kReportIssueSubject, andBodyMessage: kReportIssueMessageBody)
        }else if(indexPath.section == 1 && indexPath.row == 1){
            //Share this app
            mailFromExternal(toMail:"", withSubject:kShareThisAppSubject , andBodyMessage: kShareThisAppMessageBody)
        } else if(indexPath.section == 1 && indexPath.row == 2){
            let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDel.logoutApp()
            if(Display.phone){
                (self.presentingViewController as! UINavigationController).topViewController?.dismiss(animated: true, completion: nil)
            }else{
                self.dismiss(animated: true, completion: nil)
                ((self.presentingViewController as! UINavigationController).topViewController as! MPProfileViewController).showLoginController()
            }
        }
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if(navigationType == UIWebViewNavigationType.linkClicked){
            UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
            return false
        }
        return true
    }
    // MARK: Private methods
    private func showAlert(title:String, withMessage message:String, andURL url:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
            UIApplication.shared.open(URL(string: url)!, options: ["":""], completionHandler: nil)
        }
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    // Open mailbox with email editing in native iOS
    private func mailFromExternal(toMail mail:String, withSubject subject:String, andBodyMessage body:String){
        var emailContent = "mailto:\(mail)?subject=\(subject)&body=\(body)";
        emailContent = emailContent.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        if let emailURL = URL(string: emailContent) {
            if UIApplication.shared.canOpenURL(emailURL as URL) {
                UIApplication.shared.open(URL(string:emailContent)!, options: ["":""], completionHandler: nil)
            }
        }else{
            showSendMailErrorAlert()
        }
    }
    
    private func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
}
