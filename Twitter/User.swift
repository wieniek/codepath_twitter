//
//  User.swift
//  Twitter
//
//  Created by Wieniek Sliwinski on 4/10/17.
//  Copyright © 2017 Home User. All rights reserved.
//

import UIKit

class User: NSObject {
  
  var name: String?
  var screnName: String?
  var profileUrl: URL?
  var tagline: String?
  
  init(dictionary: NSDictionary) {
    
    name = dictionary["name"] as? String
    screnName = dictionary["screen_name"] as? String
    if let profileUrlString = dictionary["profile_image_url_https"] as? String {
      profileUrl = URL(string: profileUrlString)
    }
    tagline = dictionary["description"] as? String
  }
}
