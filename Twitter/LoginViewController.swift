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
  
  var window: UIWindow?
  
  @IBAction func onLoginButton(_ sender: UIButton) {
    
    TwitterClient.sharedInstance?.login(success: {
      print("I've logged in")
      self.performSegue(withIdentifier: "LoginSegue", sender: nil)
      
    }, failure: { (error: Error) in
      print("Error: \(error.localizedDescription)")
    })
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "LoginSeque" {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let hamburgerViewController = segue.destination as! HamburgerViewController
      let menuViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
      menuViewController.hamburgerViewController = hamburgerViewController
      hamburgerViewController.menuViewController = menuViewController
    }
  }
}
