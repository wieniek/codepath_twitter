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
    
    let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "zBQcNlKexqOeeKM1bCg6z8iwI", consumerSecret: "SvgpeLyUWimMm5Ogo8ty9tGMpBCKVsTDryPsQgpjpsZkiJzKx7")
    
    twitterClient?.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
      print("I got the access token!")
      twitterClient?.get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
        
        // Print Twitter account details
        // print("account: \(response!)")
        let user = response as? NSDictionary
        print("name: \(user?["name"] ?? "not found")")
        
      }, failure: { (task: URLSessionDataTask?, error: Error) in
        print("error: \(error.localizedDescription )")
      })
      
    }, failure: { (error: Error?) in
      print("error: \(error?.localizedDescription ?? "unknown")")
    })
    
    twitterClient?.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
      print("I got the access token!")
      twitterClient?.get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
        
        // Print tweets
        let tweets = response as? [NSDictionary]
        for tweet in tweets! {
          print("tweet: \(tweet["text"] ?? "error")")
        }
        
      }, failure: { (task: URLSessionDataTask?, error: Error) in
        print("error: \(error.localizedDescription )")
      })
      
    }, failure: { (error: Error?) in
      print("error: \(error?.localizedDescription ?? "unknown")")
    })
    
    return true
  }
}

