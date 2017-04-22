//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Wieniek Sliwinski on 4/11/17.
//  Copyright © 2017 Home User. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TwitterClientDelegate {
  
  var tweets: [Tweet]?
  
  @IBOutlet weak var tableView: UITableView!
  
  // Refresh control for table view
  let refreshControl = UIRefreshControl()
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = Bundle.main.loadNibNamed("TweetCell", owner: self, options: nil)?.first as! TweetCell
    cell.tweet = tweets?[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "TweetDetailSegue", sender: tableView.cellForRow(at: indexPath))
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if let tweets = tweets {
      return tweets.count
    } else {
      return 0
    }
  }
  
  func twitterClient(didCreateNewTweet newTweet: Tweet) {
    tweets?.insert(newTweet, at: 0)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    TwitterClient.sharedInstance?.delegate = self
    
    tableView.estimatedRowHeight = 150
    tableView.rowHeight = UITableViewAutomaticDimension
    
    // Add refresh control to table view
    refreshControl.addTarget(self, action: #selector(fetchHomeTimeline), for: UIControlEvents.valueChanged)
    tableView.insertSubview(refreshControl, at: 0)
    
    fetchHomeTimeline()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    tableView.reloadData()
  }
  
  func fetchHomeTimeline() {
    
    TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
      self.tweets = tweets
      self.tableView.reloadData()
      self.refreshControl.endRefreshing()
      print("got the data")
    }, failure: { (error: Error) in
      print("error: \(error.localizedDescription)")
    })
  }
  
  @IBAction func barItemTapped(_ sender: UIBarButtonItem) {
    if let hamburgerViewController = self.view.window?.rootViewController as? HamburgerViewController {
      hamburgerViewController.toggleMenu()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "TweetDetailSegue" {
      let cell = sender as! TweetCell
      let detailViewController = segue.destination as! TweetDetailViewController
      detailViewController.tweet = cell.tweet
    }
  }
}

