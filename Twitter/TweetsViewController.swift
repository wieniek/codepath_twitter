//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Wieniek Sliwinski on 4/11/17.
//  Copyright © 2017 Home User. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  var tweets: [Tweet]?
  
  @IBOutlet weak var tableView: UITableView!
  
  // Refresh control for table view
  let refreshControl = UIRefreshControl()
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "TweetViewCell", for: indexPath) as! TweetViewCell
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.estimatedRowHeight = 150
    tableView.rowHeight = UITableViewAutomaticDimension
    
    // Add refresh control to table view
    refreshControl.addTarget(self, action: #selector(fetchHomeTimeline), for: UIControlEvents.valueChanged)
    tableView.insertSubview(refreshControl, at: 0)
    
    fetchHomeTimeline()
    
//    TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
//      
//      self.tweets = tweets
//      self.tableView.reloadData()
//      
//      for tweet in tweets {
//        print("tweet: \(tweet.text ?? "")")
//      }
//    }, failure: { (error: Error) in
//      print("error: \(error.localizedDescription)")
//    })
    
  }
  
  // Display HUD and then asynch data load with callbacks
  func fetchHomeTimeline() {
    // Display HUD right before network request is made
    // MBProgressHUD.showAdded(to: self.view, animated: true)
    // Fetch data from network url
    // Movie.fetch(fromEndPoint: endPoint, successCallback: loadFetch, errorCallback: showErrorView)
    
    TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
      self.tweets = tweets
      self.tableView.reloadData()
      self.refreshControl.endRefreshing()
    }, failure: { (error: Error) in
      print("error: \(error.localizedDescription)")
    })
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onLogoutButton(_ sender: UIBarButtonItem) {
    
    TwitterClient.sharedInstance?.logout()
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
