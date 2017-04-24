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
  var responseId: String?
  var retweetingTo: String?
  
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
  @IBOutlet weak var retweetingLabel: UILabel!
  
  @IBOutlet weak var tweetButton: UIBarButtonItem! {
    didSet {
      // If response ID is set, then tweet is a reply
      if let _ = responseId {
        tweetButton.title = "Reply"
      }
    }
  }
  
  @IBAction func cancelButton(_ sender: UIBarButtonItem) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func tweetButton(_ sender: UIBarButtonItem) {
    
    if let text = tweetTextView.text {
      
      let tweetText: String
      
      if let retweetingTo = retweetingTo {
        tweetText = "@\(retweetingTo) " + text
      } else {
        tweetText = text
      }
      
      TwitterClient.sharedInstance?.updateStatus(withText: tweetText, inResponseToId: responseId, success: callBackSuccess(withResult:), failure: callBackFailure(withError:))
    }
  }
  
  func callBackSuccess(withResult result: Tweet) {
    print("Success: \(result)")
    
    let alertController = UIAlertController(title: "Tweet", message: "New tweet successfuly created!", preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
      // handle response here.
      self.navigationController?.popViewController(animated: true)
    }
    // add the OK action to the alert controller
    alertController.addAction(OKAction)
    present(alertController, animated: true) {
      
    }
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
    
    // If response ID is set, then tweet is a reply
    if let _ = responseId {
      tweetButton.title = "Reply"
      retweetingLabel.text = "Retweeting to @\(retweetingTo ?? "")"
    } else {
      tweetButton.title = "Tweet"
      retweetingLabel.isHidden = true
    }
    
    tweetTextView.becomeFirstResponder()
  }
  
  func textViewDidChange(_ textView: UITextView) {
    
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
}
