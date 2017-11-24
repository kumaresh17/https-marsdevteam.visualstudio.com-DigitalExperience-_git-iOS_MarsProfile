//
//  AppDelegate.swift
//  MarsProfile
//
//  Created by Preeti on 20/07/17.
//  Copyright © 2017 com.mars.MarsProfile. All rights reserved.
//

import UIKit
import SDWebImage
import ADALiOS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().backgroundColor = UIColor(red: CGFloat(56) / 255.0, green: CGFloat(150) / 255.0, blue: CGFloat(150) / 255.0, alpha: 1.0)
        UINavigationBar.appearance().isTranslucent = false
        var fontSize:CGFloat = 20.0
        if(Display.pad){
            fontSize = 22.0
        }
        //UINavigationBar.appearance().tintColor = UIColor.blue
        let font = UIFont(name: UIFont.fontNames(forFamilyName: "Dosis")[0], size: fontSize)
        //UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: font ?? UIFont.systemFont(ofSize: fontSize), NSForegroundColorAttributeName: UIColor.white], for: .normal)
       // UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: font ?? UIFont.systemFont(ofSize: fontSize), NSForegroundColorAttributeName: UIColor.white], for: .highlighted)
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: font ?? UIFont(name: "Dosis", size: fontSize)!], for: .normal)
 
        
        /* Add your client ID here */
        YMLoginClient.sharedInstance().appClientID = "ntOeUn5HKzEK5hEwVVhRxA"
        
        /* Add your client secret here */
        YMLoginClient.sharedInstance().appClientSecret = "dvOGv9sH2udNbwD6fJoqnjKQ0FwCP1zTjXEhvI7mj0"
        
        /* Add your authorization redirect URI here */
        YMLoginClient.sharedInstance().authRedirectURI = "yampicture://com.mars.yamPicture"
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func logoutApp(){
        MISADALRestClient.removeAllTokens()
        UserDefaults.standard.removeObject(forKey: kLoggedInUserKey)
        UserDefaults.standard.removeObject(forKey: kLoggedInUserIdKey)
        UserDefaults.standard.removeObject(forKey: kIsLoggedInUserKey)
        UserDefaults.standard.removeObject(forKey: kUserLastNameKey)
        UserDefaults.standard.removeObject(forKey: kUserFirstNameKey)
        YMLoginClient.sharedInstance().clearAuthTokens()
    }
    
    //
    class func getTracker() ->GAITracker{
        //For stage
         let gai = GAI.sharedInstance() /*else {
            assert(false, "Google Analytics not configured correctly")
        }*/
        let trackerId = "UA-68648601-25"//stage
        //let trackerId = "UA-104504378-1"//
        let tracker = gai?.tracker(withTrackingId: trackerId)
        gai?.trackUncaughtExceptions = true
        
        // Optional: set Logger to VERBOSE for debug information.
        // Remove before app release.
        gai?.logger.logLevel = .verbose;
        return tracker!
    }
}

