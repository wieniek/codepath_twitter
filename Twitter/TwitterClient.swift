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
  
  var loginSuccess: (() -> Void)?
  var loginFailure: ((Error) -> Void)?
  
  func login(success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
    
    loginSuccess = success
    loginFailure = failure
    
    TwitterClient.sharedInstance?.deauthorize()
    TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "wieniekTwitter://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
      print("I got a token")
      
      if let token = requestToken?.token {
        let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")!
        UIApplication.shared.open(url, options: [:], completionHandler: {(success) in print("Open url success.")})
      } }, failure: { (error: Error!) -> Void in
        print("error: \(error.localizedDescription)")
        self.loginFailure?(error)
    })
  }
  
  func currentAccount() {
    get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      
      // Print Twitter account details
      // print("account: \(response!)")
      
      let userDictionary = response as! NSDictionary
      let user = User(dictionary: userDictionary)
      
      print("name: \(user.name ?? "")")
      print("screen name: \(user.screenName ?? "")")
      print("profile url: \(String(describing: user.profileUrl))")
      print("description: \(user.tagline ?? "")")
      
    }, failure: { (task: URLSessionDataTask?, error: Error) in
      print("error: \(error.localizedDescription )")
    })
  }
  
  func handleOpenUrl(url: URL) {
    let requestToken = BDBOAuth1Credential(queryString: url.query)
    
    fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
      
      self.loginSuccess?()

    }, failure: { (error: Error?) in
      print("error: \(error!.localizedDescription)")
      self.loginFailure?(error!)
    })
  }
  
  func homeTimeline() {
    get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in

      // Print tweets
      if let dictionaries = response as? [NSDictionary] {
        let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
        for tweet in tweets {
          print("tweet: \(tweet.text ?? "")")
        }
      } else {
        print("no tweets")
      }
    }, failure: { (task: URLSessionDataTask?, error: Error) in
      print("error: \(error.localizedDescription )")
    })
  }
}
