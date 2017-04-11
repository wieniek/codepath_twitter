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
    
    if User.currentUser != nil {
      print("There is a current user")
    } else {
      print("There is no current user")
    }
    
    return true
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    print(url.description)
    
    TwitterClient.sharedInstance?.handleOpenUrl(url: url)
    
    return true
  }
}
