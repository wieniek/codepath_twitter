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
  
  var tweet: Tweet?
  
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var userImage: UIImageView!
  
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
