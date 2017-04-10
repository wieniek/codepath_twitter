//
//  TwitterClient.swift
//  Twitter
//
//  Created by Wieniek Sliwinski on 4/10/17.
//  Copyright © 2017 Home User. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
  
  static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "zBQcNlKexqOeeKM1bCg6z8iwI", consumerSecret: "SvgpeLyUWimMm5Ogo8ty9tGMpBCKVsTDryPsQgpjpsZkiJzKx7")
  
  func currentAccount() {
    get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      // Print Twitter account details
      // print("account: \(response!)")
      let user = response as? NSDictionary
      print("name: \(user?["name"] ?? "not found")")
      
    }, failure: { (task: URLSessionDataTask?, error: Error) in
      print("error: \(error.localizedDescription )")
    })
  }
  
  func homeTimeline() {
    get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      // Print tweets
      if let tweets = response as? [NSDictionary] {
        for tweet in tweets {
          print("tweet: \(tweet["text"] ?? "no text")")
        }
      } else {
        print("no tweets")
      }
    }, failure: { (task: URLSessionDataTask?, error: Error) in
      print("error: \(error.localizedDescription )")
    })
  }
}
