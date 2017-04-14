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
  
  @IBOutlet weak var rtButton: UIButton!
  
  @IBOutlet weak var replyButton: UIButton!
  
  @IBOutlet weak var favButton: UIButton!
  @IBOutlet weak var favCount: UILabel!
  
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
    }
  }
  
  
  @IBAction func rtButton(_ sender: UIButton) {
  }
  
  @IBAction func replyButton(_ sender: UIButton) {
  }
  
  
  @IBAction func favButton(_ sender: UIButton) {
    
    print("isFav1 = \(isFavorite)")
    isFavorite = !isFavorite
    print("isFav2 = \(isFavorite)")
    
  }
  
  
  @IBAction func backButton(_ sender: UIBarButtonItem) {
    
    dismiss(animated: true, completion: nil)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    userNameLabel.text = tweet?.name ?? ""
    screenNameLabel.text = "@\(tweet?.screenName ?? "")"
    if let imageUrl = tweet?.imageUrl {
      userImage.setImageWith(imageUrl)
    }
    // Set favorite button icon
    if let isFav = tweet?.isFavorite {
      if isFav {
        favButton.imageView?.image = UIImage(named: "favred")
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
