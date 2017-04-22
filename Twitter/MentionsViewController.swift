//
//  MentionsViewController.swift
//  Twitter
//
//  Created by Wieniek Sliwinski on 4/19/17.
//  Copyright © 2017 Home User. All rights reserved.
//

import UIKit

class MentionsViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  var tweets: [Tweet]?
  
  @IBOutlet weak var tableView: UITableView!
  
  // Refresh control for table view
  let refreshControl = UIRefreshControl()
  
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.estimatedRowHeight = 150
    tableView.rowHeight = UITableViewAutomaticDimension
    
    // Add refresh control to table view
    refreshControl.addTarget(self, action: #selector(fetchMentionsTimeline), for: UIControlEvents.valueChanged)
    tableView.insertSubview(refreshControl, at: 0)
    
    fetchMentionsTimeline()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    tableView.reloadData()
  }
  
  func fetchMentionsTimeline() {
    
    TwitterClient.sharedInstance?.mentionsTimeline(success: { (tweets: [Tweet]) in
      self.tweets = tweets
      self.tableView.reloadData()
      self.refreshControl.endRefreshing()
      print("got the data")
    }, failure: { (error: Error) in
      print("error: \(error.localizedDescription)")
    })
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
