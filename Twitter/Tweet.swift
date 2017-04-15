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
    }
  }
  var isRetweeted = false {
    didSet {
      TwitterClient.sharedInstance?.setRetweetFlag(forTweet: self, as: isRetweeted, success: callbackSuccess(tweet:), failure: callbackFailure(error:))
    }
  }
  
  func callbackSuccess(tweet: Tweet) {
    print("set as sucessful")
  }
  
  func callbackFailure(error: Error) {
    print("set as error")
  }
  
  init(dictionary: NSDictionary) {
    
    id = dictionary["id_str"] as? String
    let user = dictionary["user"] as? NSDictionary
    name = user?["name"] as? String
    screenName = user?["screen_name"] as? String
    
    if let imageUrlString = user?["profile_image_url_https"] as? String {
      imageUrl = URL(string: imageUrlString)
    }
    
    text = dictionary["text"] as? String
    retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
    favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
    
    let timestampString = dictionary["created_at"] as? String
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


