//
//  LoginViewController.swift
//  Twitter
//
//  Created by Wieniek Sliwinski on 4/10/17.
//  Copyright © 2017 Home User. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
  
  
  
  @IBAction func onLoginButton(_ sender: UIButton) {
    
      TwitterClient.sharedInstance?.deauthorize()
      TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "wieniekTwitter://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
        print("I got a token")
        
        if let token = requestToken?.token {
          let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")!
          UIApplication.shared.open(url, options: [:], completionHandler: {(success) in print("Open url success.")})
        } }, failure: { (error: Error!) -> Void in print("error: \(error.localizedDescription)")})
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
