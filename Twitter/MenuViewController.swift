//
//  MenuViewController.swift
//  Twitter
//
//  Created by Wieniek Sliwinski on 4/19/17.
//  Copyright © 2017 Home User. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetsViewControllerDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var profileNameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  
  private var profileNavigationController: UIViewController!
  private var tweetsNavigationController: UIViewController!
  private var mentionsNavigationController: UIViewController!
  
  var viewControllers: [UIViewController] = []
  
  var hamburgerViewController: HamburgerViewController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    profileNavigationController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
    tweetsNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
    mentionsNavigationController = storyboard.instantiateViewController(withIdentifier: "MentionsNavigationController")
    
    let tweetsViewController = tweetsNavigationController.childViewControllers.first as? TweetsViewController
    
    tweetsViewController?.delegate = self
    
    viewControllers.append(profileNavigationController)
    viewControllers.append(tweetsNavigationController)
    viewControllers.append(mentionsNavigationController)
    
    // Set profile fields
    profileNameLabel.text = User.currentUser?.name ?? ""
    screenNameLabel.text = User.currentUser?.screenName ?? ""
    if let url = User.currentUser?.profileUrl {
      profileImage.setImageWith(url)
    }
    
    // On bootup load the tweets vc
    hamburgerViewController.contentViewController = tweetsNavigationController
    
  }
  
  func tweets(viewController controller: TweetsViewController, didSelectTweetWithName screenName: String?) {
    
//    // removing old controller
//    controller.willMove(toParentViewController: nil)
//    controller.view.removeFromSuperview()
//    controller.didMove(toParentViewController: nil)
//    
//    print("switching to profile. name = \(screenName ?? "NONE")")
//    let vc = profileNavigationController.childViewControllers.first as? ProfileViewController
//    if let screenName = screenName {
//      vc?.parameters = ["screen_name":screenName]
//    }
//    hamburgerViewController.contentViewController = profileNavigationController
    
//    print("switching to profile. name = \(screenName ?? "NONE")")
//    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//    let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
//    if let screenName = screenName {
//    profileViewController.parameters = ["screen_name":screenName]
//    }
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Const.menuTitles.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
    
    let titles = Const.menuTitles
    cell.menuTitleLabel.text = titles[indexPath.row]
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // deselect the gray selection
    tableView.deselectRow(at: indexPath, animated: true)
    
    if indexPath.row == Const.menuTitles.count - 1 {
      // last menu item is Sign Out
      TwitterClient.sharedInstance?.logout()
    } else {
      // Switch between controllers based on menu selection
      hamburgerViewController.contentViewController = viewControllers[indexPath.row]
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
