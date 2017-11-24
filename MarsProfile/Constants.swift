//
//  Constants.swift
//  MarsProfile
//
//  Created by TechMadmin on 25/07/17.
//  Copyright © 2017 com.mars.MarsProfile. All rights reserved.
//

import Foundation
import UIKit

let kVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
let kAppVersion = "Version \(kVersion)"
let kDeviceInfo = "Model : \(UIDevice.current.localizedModel) version : \(UIDevice.current.systemVersion)"
let kAppName = "Mars Profile"
let kLoggedInUserKey = "CurrentUserLogged"
let kIsLoggedInUserKey = "IsCurrentUserLogged"
let kLoggedInUserIdKey = "LoggedInUserIdKey"
let kUserFirstNameKey = "UserFirstNameKey"
let kUserLastNameKey = "UserLastNameKey"

let kUINavTitleFont = UIFont(name: UIFont.fontNames(forFamilyName: "Dosis")[0], size: 18.0)
let kUINavBarFont = UIFont(name: UIFont.fontNames(forFamilyName: "Dosis")[0], size: 16.0)
let navigationBarColor = UIColor(red: CGFloat(56) / 255.0, green: CGFloat(150) / 255.0, blue: CGFloat(150) / 255.0, alpha: 1.0)
let kPhotoSelctorBorderColor = UIColor(red: CGFloat(186) / 255.0, green: CGFloat(187) / 255.0, blue: CGFloat(187) / 255.0, alpha: 1.0)
let kDWLink = "https://digitalworkplace.mars.com"
let kGiveFeedback = "Give Feedback"
let kGiveFeedbackTitle = "Your feedback counts!"
let kGiveFeedbackMessage = "Give Feedback"
let kGiveFeedbackURL = "http://marsvsp.effem.com/mifs/asfV3x/appstore?clientid=1073742993&vspver=7.5.3.0"
let kReportIssue = "Report a problem"
let kReportIssueMailID = "mars.service.desk@effem.com"
let kReportIssueSubject = "MobileApps issue/question - Mars Profile"
let kReportIssueMessageBody = "Facing an issue or have a question on Mars Profile?\nPlease provide a description of the issue or question with screenshots (if needed):\n \n \n \n \n \n \n Impact (please write the Impact if single user 'S' or multiple users 'M'):\n Activity (please write if Application fault 'F', Application unavailable 'U' or Request setup access 'A'):\n \n" +
    "Please do not remove the technical information below.\n-----------------------------------------------------\n" +
    "Application: Mars Profile\n" +
    "App version: v" + kAppVersion + "\n" +
    "Device Model and OS: " + kDeviceInfo + "\n" +
"Date:  \(Date.init())"
let kShareThisApp = "Share This App"
let kShareThisAppSubject = "Mars Profile – Try it!"
let kShareThisAppMessageBody = "Hey,\nI’m using Mars Profile mobile app and I love it! You can download it on the Mars Apps Store in the 'Productivity' category, you should try it!"
let kAboutApp = "ABOUT"
let kContact = "CONTACT"
let kAppLogout = "Logout"
let kHtmlStringForProfileConfirmationForIPhone = "<html><body style='font-family:Dosis-regular;font-size:16px;margin:2px'><div style=text-align: left;font-size:16px;width:100%;height:100%;vertical-align: middle'><span style='background-color:#FFFFFF;position: absolute;top: 0;left: 0;font-size:16px'>Please share the message about Mars Profile with other associates and join the <a style='color:#002CFF' href='https://www.yammer.com/effem.com/#/threads/inGroup?type=in_group&feedId=5889272'>Digital Workplace Yammer group</a> to find out more about what we're working on!</span></div></body></html>"
let kHtmlStringForProfileConfirmationForIPad = "<html><body style='font-family:Dosis-regular;font-size:22px;margin:2px'><div style=text-align: left;font-size:22px;width:100%;height:100%;vertical-align: middle'><span style='background-color:#FFFFFF;position: absolute;top: 0;left: 0;font-size:22px'>Please share the message about Mars Profile with other associates and join the <a style='color:#002CFF' href='https://www.yammer.com/effem.com/#/threads/inGroup?type=in_group&feedId=5889272'>Digital Workplace Yammer group</a> to find out more about what we're working on!</span></div></body></html>"
let kHtmlSmallString = "<html><body style='font-family:Dosis-regular;font-size:16px;margin:2px'><div style=text-align: left;font-size:16px;width:100%;height:100%;vertical-align: middle'><span style='background-color:#EEEEEE;position: absolute;top: 0;left: 0;font-size:16px;padding:10px'><b>You should use a recent, clear, close-up photo of your face</b> - no group selfies, but a picture with your pet is fine! The photo should confirm to the <a style='color:#002CFF' href='http://policies.mars/appropriate-electronic-media.aspx'>Mars Appropriate Use of Electronic Media Policy</a>.</span></div></body></html>"
let kHtmlString = "<html><body style='background-color:#EEEEEE;font-family:Dosis-regular;font-size:16px;margin:10px;'><div style='text-align: left;vertical-align: middle;'><span style='background-color:#EEEEEE;position: absolute;top: 0;left: 0;padding:10px'>To enable meaningful and efficient collaboration across the organisation and to support key business processes we ask you to upload your profile photo to Skype for Business, SharePoint, Outlook and Yammer as enabled by the Mars Profile solution. Please follow the instructions below:<br/><br/><span style='font-weight: bold;'>1. You should use a recent, clear, close-up photo of your face</span>- no group selfies, but a picture with your pet is fine. The photo should confirm to the <a style='color:#002CFF' href='http://policies.mars/appropriate-electronic-media.aspx'>Mars Appropriate Use of Electronic Media Policy</a>.<br/><br/><span style='font-weight: bold;'>2.</span> Remember this photo may be viewed by any Mars Associate.<br/><span style='font-weight: bold;'>By uploading your photo you consent for the photo to be used by the company as part of appropriate internal business processes.</span> The usage of the photo will confirm with respective Mars Security and Data Privacy Policy and Standards (<a style='color:#002CFF' href='https://team.effem.com/sites/information-security/SiteAssets/Site%20Pages/Policies%20and%20Standards/Mars%20Incorporated%20Information%20Classification%20Policy.pdf'>Mars Information Classification Policy</a>, <a style='color:#002CFF' href='https://team.effem.com/sites/information-security/SiteAssets/Site%20Pages/Policies%20and%20Standards/Mars%20Incorporated%20Information%20Handling%20Standard.pdf'>Information Handling Standard</a> and <a style='color:#002CFF' href='http://policies.mars/personal.aspx'>Mars Global Personal Data Privacy Policy</a>). </span></div></body></html>"
let kHtmlAboutApp = "<html><body style='font-family:Dosis-regular;font-size:14px;margin:2px'><div style=text-align: left;font-size:14px;width:100%;height:100%;vertical-align: middle'><span style='background-color:White;position: absolute;top: 0;left: 0;font-size:14px;padding:10px'>The Mars Profile app gives you the ability to quickly and easily add a photo to your online profiles and improve your online presence.\n Uploading a profile picture allows us to maintain a key element of human communication as the use of digital tools and ways of working \n increase. Your use of the Profile application is governed by the <a href='http://policies.mars/appropriate-electronic-media.aspx'>Mars Appropriate Use of Electronic Media Policy</a>.</span></div></body></html>"
let kSourceButtonYammerTag = 1001
let kSourceButtonOtherTag = 1002

import UIKit

public enum DisplayType {
    case unknown
    case iphone4
    case iphone5
    case iphone6
    case iphone6plus
    static let iphone7 = iphone6
    static let iphone7plus = iphone6plus
}

public final class Display {
    class var width:CGFloat { return UIScreen.main.bounds.size.width }
    class var height:CGFloat { return UIScreen.main.bounds.size.height }
    class var maxLength:CGFloat { return max(width, height) }
    class var minLength:CGFloat { return min(width, height) }
    class var zoomed:Bool { return UIScreen.main.nativeScale >= UIScreen.main.scale }
    class var retina:Bool { return UIScreen.main.scale >= 2.0 }
    class var phone:Bool { return UIDevice.current.userInterfaceIdiom == .phone }
    class var pad:Bool { return UIDevice.current.userInterfaceIdiom == .pad }
    class var carplay:Bool { return UIDevice.current.userInterfaceIdiom == .carPlay }
    class var tv:Bool { return UIDevice.current.userInterfaceIdiom == .tv }
    class var typeIsLike:DisplayType {
        if phone && maxLength < 568 {
            return .iphone4
        }
        else if phone && maxLength == 568 {
            return .iphone5
        }
        else if phone && maxLength == 667 {
            return .iphone6
        }
        else if phone && maxLength == 736 {
            return .iphone6plus
        }
        return .unknown
    }
}
