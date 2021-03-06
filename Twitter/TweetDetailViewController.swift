//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Wieniek Sliwinski on 4/14/17.
//  Copyright © 2017 Home User. All rights reserved.
//

import UIKit
import AFNetworking

class TweetDetailViewController: UIViewController {
  
  var tweet: Tweet!
  
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var userImage: UIImageView!
  @IBOutlet weak var tweetTextLabel: UILabel!
  
  @IBOutlet weak var rtCount: UILabel!
  @IBOutlet weak var favCount: UILabel!
  
  @IBOutlet weak var rtButton: UIButton!
  @IBOutlet weak var replyButton: UIButton!
  @IBOutlet weak var favButton: UIButton!
  
  var isFavorite: Bool {
    get {
      return tweet.isFavorite
    }
    set {
      var image: UIImage?
      if newValue {
        image = UIImage(named: "favred")
      } else {
        image = UIImage(named: "favgrey")
      }
      favButton.setImage(image, for: .normal)
      tweet.isFavorite = newValue
      favCount.text = String(tweet?.favoritesCount ?? 0)
    }
  }
  var isRetweeted: Bool {
    get {
      return tweet.isRetweeted
    }
    set {
      var image: UIImage?
      if newValue {
        image = UIImage(named: "rtgreen")
      } else {
        image = UIImage(named: "rtgrey")
      }
      rtButton.setImage(image, for: .normal)
      tweet.isRetweeted = newValue
      rtCount.text = String(tweet?.retweetCount ?? 0)
    }
  }
  
  @IBAction func rtButton(_ sender: UIButton) {
    isRetweeted = !isRetweeted
  }
  
  @IBAction func replyButton(_ sender: UIButton) {
  }
  
  @IBAction func favButton(_ sender: UIButton) {
    
    isFavorite = !isFavorite
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    userNameLabel.text = tweet?.name ?? ""
    screenNameLabel.text = "@\(tweet?.screenName ?? "")"
    if let imageUrl = tweet?.imageUrl {
      userImage.setImageWith(imageUrl)
    }
    tweetTextLabel.text = tweet?.text ?? ""
    
    rtCount.text = String(tweet?.retweetCount ?? 0)
    favCount.text = String(tweet?.favoritesCount ?? 0)
    
    // Set favorite button icon
    if let isFav = tweet?.isFavorite {
      if isFav {
        favButton.imageView?.image = UIImage(named: "favred")
      }
    }
    // Set retweet button icon
    if let isRT = tweet?.isRetweeted {
      if isRT {
        rtButton.imageView?.image = UIImage(named: "rtgreen")
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "ReplySegue" {
      
      let viewController = segue.destination as! NewTweetViewController
      viewController.responseId = tweet.id
      viewController.retweetingTo = tweet.screenName
    }
  }
}
