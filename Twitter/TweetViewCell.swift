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
        timestampLabel.text = format(timestamp: timestamp)
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
  
  func format(timestamp time: Date) -> String{
    
    let ellapsedSec = Int(-time.timeIntervalSinceNow)
    
    switch ellapsedSec {
    case let s where s < 60:            // minute
      return "\(ellapsedSec)s"
    case let s where s < 3600:          // hour
      return "\(ellapsedSec / 60)m"
    default:                            //day
      return "\(ellapsedSec / 3600)d"
    }
  }
  
}
