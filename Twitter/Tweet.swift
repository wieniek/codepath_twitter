//
//  Tweet.swift
//  Twitter
//
//  Created by Wieniek Sliwinski on 4/10/17.
//  Copyright © 2017 Home User. All rights reserved.
//

import UIKit

class Tweet: NSObject {
  
  var id: String?
  var name: String?
  var screenName: String?
  var imageUrl: URL?
  var text: String?
  var timestamp: Date?
  var retweetCount = 0
  var favoritesCount = 0
  var isFavorite = false {
    didSet {
      TwitterClient.sharedInstance?.setFavoriteFlag(forTweet: self, as: isFavorite, success: callbackSuccess(tweet:), failure: callbackFailure(error:))
      if isFavorite {
        favoritesCount += 1
      } else {
        favoritesCount -= 1
      }
    }
  }
  var isRetweeted = false {
    didSet {
      TwitterClient.sharedInstance?.setRetweetFlag(forTweet: self, as: isRetweeted, success: callbackSuccess(tweet:), failure: callbackFailure(error:))
      if isRetweeted {
        retweetCount += 1
      } else {
        retweetCount -= 1
      }
    }
  }
  
  func callbackSuccess(tweet: Tweet) {
    print("set as sucessful")
  }
  
  func callbackFailure(error: Error) {
    print("set as error")
  }
  
  init(dictionary: NSDictionary) {
    
    id = dictionary[Const.id] as? String
    let user = dictionary[Const.user] as? NSDictionary
    name = user?[Const.name] as? String
    screenName = user?[Const.screenName] as? String
    
    if let imageUrlString = user?[Const.imageUrl] as? String {
      imageUrl = URL(string: imageUrlString)
    }
    
    text = dictionary[Const.text] as? String
    retweetCount = (dictionary[Const.rtCount] as? Int) ?? 0
    favoritesCount = (dictionary[Const.favCount] as? Int) ?? 0
    
    let timestampString = dictionary[Const.createdAt] as? String
    if let timestampString = timestampString {
      let formatter = DateFormatter()
      formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
      timestamp = formatter.date(from: timestampString)
      //print("date = \(timestamp!)")
    }
  }
  
  class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
    
    var tweets = [Tweet]()
  
    for dictionary in dictionaries {
      let tweet = Tweet(dictionary: dictionary)
      tweets.append(tweet)
    }
    return tweets
  }
}


