//
//  TwitterClient.swift
//  Twitter
//
//  Created by Wieniek Sliwinski on 4/10/17.
//  Copyright © 2017 Home User. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

protocol TwitterClientDelegate: class {
  
  func twitterClient(didCreateNewTweet newTweet: Tweet)
  
}

class TwitterClient: BDBOAuth1SessionManager {
  
  weak var delegate: TwitterClientDelegate?
  
  static let sharedInstance = TwitterClient(baseURL: URL(string: Const.baseUrl), consumerKey: Const.consumerKey, consumerSecret: Const.consumerSecret)
  
  var loginSuccess: (() -> Void)?
  var loginFailure: ((Error) -> Void)?
  
  func login(success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
    
    loginSuccess = success
    loginFailure = failure
    
    TwitterClient.sharedInstance?.deauthorize()
    TwitterClient.sharedInstance?.fetchRequestToken(withPath: Const.requestToken, method: "GET", callbackURL: URL(string: Const.oauthCallback), scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
      print("I got a token")
      
      if let token = requestToken?.token {
        let url = URL(string: Const.oauthUrl + "\(token)")!
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
    get(Const.accountEndPoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      
      let userDictionary = response as! [String : Any]
      let user = User(dictionary: userDictionary)
      success(user)
      
    }, failure: { (task: URLSessionDataTask?, error: Error) in
      failure(error)
    })
  }
  
  func handleOpenUrl(url: URL) {
    let requestToken = BDBOAuth1Credential(queryString: url.query)
    
    fetchAccessToken(withPath: Const.accessToken, method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
      
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
  
  func setRetweetFlag(forTweet tweet: Tweet, as isRetweeted: Bool, success: @escaping (Tweet) -> Void, failure: @escaping (Error) -> Void) {
    
    guard let id = tweet.id else {
      return
    }
    var endPoint: String
    if isRetweeted {
      endPoint = Const.retweetEndPoint + "\(id).json"
    } else {
      endPoint = Const.unretweetEndPoint + "\(id).json"
    }
    
    post(endPoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      print("Response = \(response!)")
      success(tweet)
    }, failure: { (task: URLSessionDataTask?, error: Error) in
      print("Error = \(error)")
      failure(error)
    })
  }
  
  func setFavoriteFlag(forTweet tweet: Tweet, as isFavorite: Bool, success: @escaping (Tweet) -> Void, failure: @escaping (Error) -> Void) {
    
    guard let id = tweet.id else {
      return
    }
    var endPoint: String
    if isFavorite {
      endPoint = Const.favCreateEndPoint + id
    } else {
      endPoint = Const.favDestroyEndPoint + id
    }
    
    post(endPoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      print("Response = \(response!)")
      success(tweet)
    }, failure: { (task: URLSessionDataTask?, error: Error) in
      print("Error = \(error)")
      failure(error)
    })
  }
  
  func homeTimeline(success: @escaping ([Tweet]) -> Void, failure: @escaping (Error) -> Void) {
    get(Const.timelineEndPoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      if let dictionaries = response as? [NSDictionary] {
        let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
        success(tweets)
      }
    }, failure: { (task: URLSessionDataTask?, error: Error) in
      failure(error)
    })
  }
  
  func showUser(parameters: Dictionary<String, String>, success: @escaping (User?) -> Void, failure: @escaping (Error) -> Void) {
    
    get(Const.showUserEndPoint, parameters: parameters, progress: nil, success: { (task:
      URLSessionDataTask, response: Any?) in
      print("got response")
      if let dictionaries = response as? [String:Any] {
        success(User(dictionary: dictionaries))
        print("got user")
      }
    }, failure: { (task: URLSessionDataTask?, error: Error) in
      print("Error = \(error.localizedDescription)")
      failure(error)
    })
  }
 
  func userTimeline(parameters: Dictionary<String, String>, success: @escaping ([Tweet]) -> Void, failure: @escaping (Error) -> Void) {
    get(Const.userTimelineEndPoint, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      if let dictionaries = response as? [NSDictionary] {
        let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
        success(tweets)
      }
    }, failure: { (task: URLSessionDataTask?, error: Error) in
      failure(error)
    })
  }
  
  func mentionsTimeline(success: @escaping ([Tweet]) -> Void, failure: @escaping (Error) -> Void) {
    get(Const.mentionsEndPoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      if let dictionaries = response as? [NSDictionary] {
        let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
        success(tweets)
      }
    }, failure: { (task: URLSessionDataTask?, error: Error) in
      failure(error)
    })
  }
  
  func updateStatus(withText text: String, inResponseToId responseId: String?, success: @escaping (Tweet) -> Void, failure: @escaping (Error) -> Void) {
    
    guard let encodedText = text.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
      return
    }
    
    let endPoint = Const.updateEndPoint + encodedText
    
    var params: [String: AnyObject]?
    if let responseId = responseId {
      params = ["in_reply_to_status_id_str": responseId as AnyObject]
    }
    
    post(endPoint, parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      print("Response = \(response!)")
      
      if let response = response as? NSDictionary {
        let newTweet = Tweet(dictionary: response)
        self.delegate?.twitterClient(didCreateNewTweet: newTweet)
        success(newTweet)
      }
      
    }, failure: { (task: URLSessionDataTask?, error: Error) in
      print("Error = \(error)")
      failure(error)
      
    })
  }
}
