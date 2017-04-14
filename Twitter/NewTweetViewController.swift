//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by Wieniek Sliwinski on 4/14/17.
//  Copyright © 2017 Home User. All rights reserved.
//

import UIKit
import AFNetworking

class NewTweetViewController: UIViewController, UITextViewDelegate {
  
  var user: User?
  
  var charRemaining: Int? {
    didSet {
      charRemainingLabel.text = String(charRemaining ?? 0)
    }
  }
  
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var userImage: UIImageView!
  @IBOutlet weak var tweetTextView: UITextView!
  
  @IBOutlet weak var charRemainingLabel: UILabel!
  
  
  @IBAction func cancelButton(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func tweetButton(_ sender: UIBarButtonItem) {
    
    if let text = tweetTextView.text {
      TwitterClient.sharedInstance?.postNewTweet(withText: text, success: callBackSuccess, failure: callBackFailure)
    }
    dismiss(animated: true, completion: nil)
  }
  
  func callBackSuccess(withResult result: Tweet) {
    print("Success: \(result)")
  }
  
  func callBackFailure(withError error: Error) {
    print("Error: \(error.localizedDescription)")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tweetTextView.delegate = self
    user = User.currentUser
    userNameLabel.text = user?.name ?? ""
    screenNameLabel.text = user?.screenName ?? ""
    if let url = user?.profileUrl {
      userImage.setImageWith(url)
    }
    
    
    // Do any additional setup after loading the view.
  }
  
  func textViewDidChange(_ textView: UITextView) {
    //self.updateCounterColorState()
    //self.updateTweetBtnState()
    //self.updateLimitCounter()
    //self.updatePlaceHodlerUI()
    
    charRemaining = 150 - tweetTextView.text.characters.count
  }
  
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if textView.text.characters.count == 150 && !text.isEmpty{
      return false
    }
    return true
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
