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
  var parameters = [String: String]()
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var bannerImage: UIImageView!
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var profileNameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var profileScrollView: UIScrollView!
  @IBOutlet weak var profilePageControl: UIPageControl!
  @IBOutlet weak var profileDescription: UILabel!
  @IBOutlet weak var profileDescription2: UILabel!
  @IBOutlet weak var tweetsLabel: UILabel!
  @IBOutlet weak var followersLabel: UILabel!
  @IBOutlet weak var followingLabel: UILabel!
  
  @IBOutlet weak var decriptionLeftConstraint: NSLayoutConstraint!
  @IBOutlet weak var descriptionRightConstraint: NSLayoutConstraint!
  @IBOutlet weak var description2LeftConstraint: NSLayoutConstraint!
  @IBOutlet weak var description2RightConstraint: NSLayoutConstraint!
  
  var cachedImageViewSize: CGRect!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    cachedImageViewSize = bannerImage.frame
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.estimatedRowHeight = 150
    tableView.rowHeight = UITableViewAutomaticDimension
    profileScrollView.delegate = self
    profileScrollView.contentSize = CGSize(width: self.view.bounds.width * 2, height: 100)
    profileScrollView.isPagingEnabled = true
    profileScrollView.showsHorizontalScrollIndicator = false
    
    if let screenName = parameters["screen_name"] {
      
      // Modify bar button
      let barButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(barItemClose))
      self.navigationItem.setLeftBarButton(barButtonItem, animated: true)
      
      TwitterClient.sharedInstance?.showUser(parameters: parameters, success: {(user: User?) in
        print("success")
        self.screenNameLabel.text = screenName
        self.profileNameLabel.text = user?.name ?? ""
        
        if let url = user?.profileUrl {
          self.profileImage.setImageWith(url)
        }
        if let url = user?.bannerUrl {
          self.bannerImage.setImageWith(url)
        }
        self.tweetsLabel.text = String(user?.tweets ?? 0)
        self.followersLabel.text = String(user?.followers ?? 0)
        self.followingLabel.text = String(user?.following ?? 0)
        self.profileDescription2.text = "\(user?.tagline ?? "")"
        self.profileDescription.text = "Location:\n\(user?.location ?? "")"
        
      }
        , failure: {(error: Error) in
          print("error: \(error.localizedDescription)")
      })
      
      fetchUserTimeline(parameters: parameters)
      
    } else {
      
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
      profileDescription2.text = "\(User.currentUser?.tagline ?? "")"
      profileDescription.text = "Location:\n\(User.currentUser?.location ?? "")"
      
      fetchHomeTimeline()
    }
    
    print("profile loaded")
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {    
    let y: CGFloat = -scrollView.contentOffset.y
    
    if y > 0 {
      bannerImage.frame = CGRect(origin: CGPoint(x: 0, y: scrollView.contentOffset.y), size: CGSize(width: cachedImageViewSize.size.width + y, height: cachedImageViewSize.size.height + y))
      bannerImage.center = CGPoint(x: view.center.x, y: bannerImage.center.y)
      
      print("y = \(y)   alpha = \(min(1.0, y/140))")
      bannerImage.alpha = min(1.0, y/140 + 0.2)
      
    }
  }
  
  @IBAction func barItemTapped(_ sender: Any) {
    
    if let hamburgerViewController = self.view.window?.rootViewController as? HamburgerViewController {
      hamburgerViewController.toggleMenu()
    }
  }
  
  func barItemClose() {
    print("dismiss")
    self.navigationController?.popViewController(animated: true)
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
  
  func fetchUserTimeline(parameters: [String: String]) {
    
    TwitterClient.sharedInstance?.userTimeline(parameters: parameters, success: { (tweets: [Tweet]) in
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
    
    if sender.currentPage == 1 {
      UIView.animate(withDuration: 0.5, animations: {
        
        //self.description2LeftConstraint.constant = -1 * self.view.frame.size.width
        self.decriptionLeftConstraint.constant = -1 * self.view.frame.size.width
        self.descriptionRightConstraint.constant = 1 * self.view.frame.size.width
        self.bannerImage.alpha = 1
        self.view.layoutIfNeeded()
      })
    } else {
      UIView.animate(withDuration: 0.5, animations: {
        
        //self.description2LeftConstraint.constant = 8
        self.decriptionLeftConstraint.constant = 8
        self.descriptionRightConstraint.constant = 8
        self.bannerImage.alpha = 0.6
        self.view.layoutIfNeeded()
      })
    }
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
