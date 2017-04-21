//
//  User.swift
//  Twitter
//
//  Created by Wieniek Sliwinski on 4/10/17.
//  Copyright © 2017 Home User. All rights reserved.
//

import UIKit

class User {
  
  let userDictionary: [String:Any]
  let name: String?
  let screenName: String?
  let profileUrl: URL?
  let bannerUrl: URL?
  let tagline: String?
  let tweets: Int?
  let favorites: Int?
  let followers: Int?
  let following: Int?
  
  static let userDidLogoutNotification = NSNotification.Name(rawValue: "UserDidLogout")
  
  init(dictionary: [String:Any]) {
    userDictionary = dictionary
    name = dictionary[Const.name] as? String
    screenName = dictionary[Const.screenName] as? String
    if let profileUrlString = dictionary[Const.imageUrl] as? String {
      profileUrl = URL(string: profileUrlString)
    } else {
      profileUrl = nil
    }
    if let bannerUrlString = dictionary[Const.bannerUrl] as? String {
      bannerUrl = URL(string: bannerUrlString)
    } else {
      bannerUrl = nil
    }
    tagline = dictionary[Const.description] as? String
    tweets = dictionary[Const.tweetCount] as? Int
    favorites = dictionary[Const.favCount] as? Int
    followers = dictionary[Const.followersCount] as? Int
    following = dictionary[Const.followingCount] as? Int
  }
  
  static var _currentUser: User?
  
  class var currentUser: User? {
    get{
      if _currentUser == nil {
        let defaults = UserDefaults.standard
        let userData = defaults.object(forKey: Const.currentUserData) as? Data
        
        if let userData = userData {
          let dictionary = try? JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
          
          if let dictionary = dictionary {
            _currentUser = User(dictionary: dictionary)
          }
        }
      }
      return _currentUser
    }
    set(user) {
      let defaults = UserDefaults.standard
      if let user = user {
        let data = try? JSONSerialization.data(withJSONObject: user.userDictionary, options: [])
        defaults.set(data, forKey: Const.currentUserData)
        print("User data saved to user defaults")
      } else {
        defaults.set(nil, forKey: Const.currentUserData)
        print("User data NIL")
      }
      defaults.synchronize()
    }
  }
}
