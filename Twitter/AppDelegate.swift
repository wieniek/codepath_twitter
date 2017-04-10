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
    // Override point for customization after application launch.
    return true
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    print(url.description)
    
    let requestToken = BDBOAuth1Credential(queryString: url.query)
    
    let client = TwitterClient.sharedInstance!
    
    client.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
      print("I got the access token!")
      client.homeTimeline()
      client.currentAccount()
    }, failure: { (error: Error?) in
      print("error: \(error?.localizedDescription ?? "unknown")")
    })
    
    return true
  }
}

