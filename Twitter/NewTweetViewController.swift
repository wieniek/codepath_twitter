//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by Wieniek Sliwinski on 4/14/17.
//  Copyright © 2017 Home User. All rights reserved.
//

import UIKit
import AFNetworking

class NewTweetViewController: UIViewController {
  
  var user: User?
  
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var userImage: UIImageView!
  @IBOutlet weak var tweetTextView: UITextView!
  
  @IBAction func cancelButton(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func tweetButton(_ sender: UIBarButtonItem) {
    
    TwitterClient.sharedInstance?.postNewTweet(withText: "This is a test tweet 876876", success: callBackSuccess, failure: callBackFailure)
    
  }
  
  func callBackSuccess(withResult result: Tweet) {
    print("Success: \(result)")
  }
  
  func callBackFailure(withError error: Error) {
    print("Error: \(error.localizedDescription)")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    user = User.currentUser
    userNameLabel.text = user?.name ?? ""
    screenNameLabel.text = user?.screenName ?? ""
    if let url = user?.profileUrl {
      userImage.setImageWith(url)
    }
    
    
    // Do any additional setup after loading the view.
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
