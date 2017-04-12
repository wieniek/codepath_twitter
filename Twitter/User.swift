//
//  User.swift
//  Twitter
//
//  Created by Wieniek Sliwinski on 4/10/17.
//  Copyright © 2017 Home User. All rights reserved.
//

import UIKit

class User {
  
  var userDictionary: [String:Any]
  var name: String?
  var screenName: String?
  var profileUrl: URL?
  var tagline: String?
  
  static let userDidLogoutNotification = NSNotification.Name(rawValue: "UserDidLogout")
  
  init(dictionary: [String:Any]) {
    userDictionary = dictionary
    name = dictionary["name"] as? String
    screenName = dictionary["screen_name"] as? String
    if let profileUrlString = dictionary["profile_image_url_https"] as? String {
      profileUrl = URL(string: profileUrlString)
    }
    tagline = dictionary["description"] as? String
  }
  
  static var _currentUser: User?
  
  class var currentUser: User? {
    get{
      if _currentUser == nil {
        let defaults = UserDefaults.standard
        let userData = defaults.object(forKey: "currentUserData") as? Data
        
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
        defaults.set(data, forKey: "currentUserData")
        print("User data saved to user defaults")
      } else {
        defaults.set(nil, forKey: "currentUserData")
        print("User data NIL")
      }
      defaults.synchronize()
    }
  }
}
