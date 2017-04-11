//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Wieniek Sliwinski on 4/11/17.
//  Copyright © 2017 Home User. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
  
  var tweets: [Tweet]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
      for tweet in tweets {
        print("tweet: \(tweet.text ?? "")")
      }
    }, failure: { (error: Error) in
      print("error: \(error.localizedDescription)")
    })
    
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
