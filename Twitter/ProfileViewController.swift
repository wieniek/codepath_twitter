//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Wieniek Sliwinski on 4/19/17.
//  Copyright © 2017 Home User. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
  
  var tweets: [Tweet]?
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var bannerImage: UIImageView!
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var profileNameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var profileScrollView: UIScrollView!
  @IBOutlet weak var profilePageControl: UIPageControl!
  @IBOutlet weak var profileDescription: UILabel!
  @IBOutlet weak var tweetsLabel: UILabel!
  @IBOutlet weak var followersLabel: UILabel!
  @IBOutlet weak var followingLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.estimatedRowHeight = 150
    tableView.rowHeight = UITableViewAutomaticDimension
    profileScrollView.delegate = self
    profileScrollView.contentSize = CGSize(width: self.view.bounds.width * 2, height: 100)
    profileScrollView.isPagingEnabled = true
    profileScrollView.showsHorizontalScrollIndicator = false
    
    profileNameLabel.text = User.currentUser?.name ?? ""
    screenNameLabel.text = User.currentUser?.screenName ?? ""
    if let url = User.currentUser?.profileUrl {
      profileImage.setImageWith(url)
    }
    if let url = User.currentUser?.bannerUrl {
      bannerImage.setImageWith(url)
    }
    tweetsLabel.text = String(User.currentUser?.tweets ?? 0)
    followersLabel.text = String(User.currentUser?.followers ?? 0)
    followingLabel.text = String(User.currentUser?.following ?? 0)
    profileDescription.text = User.currentUser?.tagline ?? ""
    
    fetchHomeTimeline()
  }
  
  @IBAction func barItemTapped(_ sender: Any) {
    
    if let hamburgerViewController = self.view.window?.rootViewController as? HamburgerViewController {
      hamburgerViewController.toggleMenu()
    }
  }
  
  func fetchHomeTimeline() {
    
    TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
      self.tweets = tweets
      self.tableView.reloadData()
      //self.refreshControl.endRefreshing()
      print("got the data")
    }, failure: { (error: Error) in
      print("error: \(error.localizedDescription)")
    })
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let page = Int(round(profileScrollView.contentOffset.x / profileScrollView.frame.size.width))
    profilePageControl.currentPage = page
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func changePage(_ sender: UIPageControl) {
    
    
    UIView.transition(with: profileDescription,
                      duration: 0.5,
                      options: [.transitionFlipFromRight],
                      animations: {
                        if self.profilePageControl.currentPage == 0 {
                          self.profileDescription.text = User.currentUser?.tagline ?? ""
                        } else {
                          self.profileDescription.text = "This is another tagline hey.."
                        }
    }, completion: nil)
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = Bundle.main.loadNibNamed("TweetCell", owner: self, options: nil)?.first as! TweetCell
    cell.tweet = tweets?[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if let tweets = tweets {
      return tweets.count
    } else {
      return 0
    }
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
