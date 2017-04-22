//
//  Constants.swift
//  Twitter
//
//  Created by Wieniek Sliwinski on 4/16/17.
//  Copyright © 2017 Home User. All rights reserved.
//

import Foundation

let Const = Constants.self

struct Constants {
  
  // Hamburger menu titles
  
  static let menuTitles = ["Profile", "Timeline", "Mentions", "Sign Out"]
  
  // Twitter Client
  static let baseUrl = "https://api.twitter.com"
  static let consumerKey = "zBQcNlKexqOeeKM1bCg6z8iwI"
  static let consumerSecret = "SvgpeLyUWimMm5Ogo8ty9tGMpBCKVsTDryPsQgpjpsZkiJzKx7"
  
  // Oauth
  static let oauthUrl = "https://api.twitter.com/oauth/authorize?oauth_token="
  static let requestToken = "oauth/request_token"
  static let accessToken = "oauth/access_token"
  static let oauthCallback = "wieniekTwitter://oauth"

  // Endpoints
  
  static let accountEndPoint = "1.1/account/verify_credentials.json"
  static let retweetEndPoint = "https://api.twitter.com/1.1/statuses/retweet/"
  static let unretweetEndPoint = "https://api.twitter.com/1.1/statuses/unretweet/"
  static let favCreateEndPoint = "/1.1/favorites/create.json?id="
  static let favDestroyEndPoint = "/1.1/favorites/destroy.json?id="
  static let timelineEndPoint = "1.1/statuses/home_timeline.json"
  static let mentionsEndPoint = "1.1/statuses/mentions_timeline.json"
  static let updateEndPoint = "/1.1/statuses/update.json?status="
  static let userTimelineEndPoint = "/1.1/statuses/user_timeline.json"
  
  // Dictionary keys
  
  static let id = "id_str"
  static let user = "user"
  static let name = "name"
  static let screenName = "screen_name"
  static let imageUrl = "profile_image_url_https"
  static let bannerUrl = "profile_banner_url"
  static let text = "text"
  static let rtCount = "retweet_count"
  static let favCount = "favourites_count"
  static let followersCount = "followers_count"
  static let followingCount = "friends_count"
  static let tweetCount = "statuses_count"
  static let createdAt = "created_at"
  static let description = "description"
  static let currentUserData = "currentUserData"
}
