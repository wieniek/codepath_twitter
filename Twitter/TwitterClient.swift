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
  
  func logout() {
    User.currentUser = nil
    deauthorize()
    NotificationCenter.default.post(name: User.userDidLogoutNotification, object: nil)
  }
  
  func currentAccount(success: @escaping (User) -> Void, failure: @escaping (Error) -> Void) {
    get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      
      let userDictionary = response as! [String : Any]
      let user = User(dictionary: userDictionary)
      success(user)
      
    }, failure: { (task: URLSessionDataTask?, error: Error) in
      failure(error)
    })
  }
  
  func handleOpenUrl(url: URL) {
    let requestToken = BDBOAuth1Credential(queryString: url.query)
    
    fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
      
      self.currentAccount(success: { (user: User) in
        // Call the setter to save user data
        User.currentUser = user
        self.loginSuccess?()
      }, failure: { (error: Error) in
        self.loginFailure?(error)
      })
      
      self.loginSuccess?()
      
    }, failure: { (error: Error?) in
      print("error: \(error!.localizedDescription)")
      self.loginFailure?(error!)
    })
  }
  
  func setRetweetFlag(forTweet tweet: Tweet, as isRetweeted: Bool, success: (Tweet) -> Void, failure: (Error) -> Void) {
    
    guard let id = tweet.id else {
      return
    }
    var endPoint: String
    if isRetweeted {
      endPoint = "https://api.twitter.com/1.1/statuses/retweet/\(id).json"
    } else {
      endPoint = "https://api.twitter.com/1.1/statuses/unretweet/\(id).json"
    }
    
    post(endPoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      print("Response = \(response!)")
    }, failure: { (task: URLSessionDataTask?, error: Error) in
      print("Error = \(error)")
    })
  }
  
  func setFavoriteFlag(forTweet tweet: Tweet, as isFavorite: Bool, success: (Tweet) -> Void, failure: (Error) -> Void) {
    
    guard let id = tweet.id else {
      return
    }
    var endPoint: String
    if isFavorite {
      endPoint = "/1.1/favorites/create.json?id=" + id
    } else {
      endPoint = "/1.1/favorites/destroy.json?id=" + id
    }
    
    post(endPoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      print("Response = \(response!)")
    }, failure: { (task: URLSessionDataTask?, error: Error) in
      print("Error = \(error)")
    })
  }
  
  func homeTimeline(success: @escaping ([Tweet]) -> Void, failure: @escaping (Error) -> Void) {
    get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      if let dictionaries = response as? [NSDictionary] {
        let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
        success(tweets)
      }
    }, failure: { (task: URLSessionDataTask?, error: Error) in
      failure(error)
    })
  }
  
  func updateStatus(withText text: String, inResponseToId responseId: String?, success: (Tweet) -> Void, failure: (Error) -> Void) {
    
    guard let encodedText = text.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
      return
    }
    
    let endPoint = "/1.1/statuses/update.json?status=" + encodedText
    
    var params: [String: AnyObject]?
    if let responseId = responseId {
      params = ["in_reply_to_status_id_str": responseId as AnyObject]
    }

    post(endPoint, parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      print("Response = \(response!)")
    }, failure: { (task: URLSessionDataTask?, error: Error) in
      print("Error = \(error)")
    })
  }
}
