//
//  TweetViewCell.swift
//  Twitter
//
//  Created by Wieniek Sliwinski on 4/13/17.
//  Copyright © 2017 Home User. All rights reserved.
//

import UIKit
import AFNetworking

class TweetViewCell: UITableViewCell {
  
  
  //  user profile picture
  //  username
  //  tweet text
  //  timestamp
  //  retweet count
  //  fav count
  
  
  
  // Cell label outlets
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var timestampLabel: UILabel!
  @IBOutlet weak var retweetsLabel: UILabel!
  @IBOutlet weak var favoritiesLabel: UILabel!
  @IBOutlet weak var userImage: UIImageView!
  
  var tweet: Tweet? {
    didSet {
      userNameLabel.text = tweet?.name ?? ""
      screenNameLabel.text = "@\(tweet?.screenName ?? "")"
      tweetTextLabel.text = tweet?.text ?? ""
      if let timestamp = tweet?.timestamp {
        timestampLabel.text = ago(fromDate: timestamp)
      }
      retweetsLabel.text = String(describing: tweet?.retweetCount ?? 0)
      favoritiesLabel.text = String(describing: tweet?.favoritesCount ?? 0)
      if let imageUrl = tweet?.imageUrl {
        userImage.setImageWith(imageUrl)
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func ago(fromDate date: Date) -> String{
    let ellapseTimeSeconds = Int(-date.timeIntervalSinceNow)
    var output: String = ""
    if ellapseTimeSeconds < 15{
      output = "now"
    }else if ellapseTimeSeconds < 60{
      output = "\(ellapseTimeSeconds)s"
    }else if ellapseTimeSeconds < 60 * 60{
      output = "\(ellapseTimeSeconds / 60)m"
    }else if ellapseTimeSeconds < 60  * 60 * 24{
      output = "\(ellapseTimeSeconds / 3600)h"
    }else if ellapseTimeSeconds < 60 * 60 * 24 * 7{
      output = "\(ellapseTimeSeconds / (3600 * 24))d"
    }else{
      output = "\(ellapseTimeSeconds / (3600 * 24 * 7))w"
    }
    return output;
  }
  
}
