//
//  AppDelegate.swift
//  Twitter
//
//  Created by Wieniek Sliwinski on 4/10/17.
//  Copyright © 2017 Home User. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    let twitterBlue = UIColor(red: 64/255, green: 153/255, blue: 255/255, alpha: 1.0)
    UINavigationBar.appearance().tintColor = UIColor.white
    UINavigationBar.appearance().barTintColor = twitterBlue
    
    if User.currentUser != nil {
      print("There is a current user")
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
      window?.rootViewController = vc
    }
    
    NotificationCenter.default.addObserver(forName: User.userDidLogoutNotification, object: nil, queue: OperationQueue.main) { (Notification) in
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let vc = storyboard.instantiateInitialViewController()
      self.window?.rootViewController = vc
    }
    
    return true
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    print(url.description)
    
    TwitterClient.sharedInstance?.handleOpenUrl(url: url)
    
    return true
  }
}
