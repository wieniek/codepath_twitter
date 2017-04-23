//
//  HamburgerViewController.swift
//  Twitter
//
//  Created by Wieniek Sliwinski on 4/19/17.
//  Copyright © 2017 Home User. All rights reserved.
//

import UIKit

enum MenuState {
  case open
  case closed
}

class HamburgerViewController: UIViewController {
  
  @IBOutlet weak var menuView: UIView!
  @IBOutlet weak var contentView: UIView!
  
  @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
  
  var menuState = MenuState.closed
  
  var originalLeftMargin: CGFloat!
  
  var menuViewController: UIViewController! {
    didSet {
      view.layoutIfNeeded()
      menuViewController.willMove(toParentViewController: self)
      menuView.addSubview(menuViewController.view)
      menuViewController.didMove(toParentViewController: self)
    }
  }
  
  var contentViewController: UIViewController! {
    didSet(oldContentViewController) {
      view.layoutIfNeeded()
      
      // Remove old view controler
      if oldContentViewController != nil {
        oldContentViewController.willMove(toParentViewController: nil)
        oldContentViewController.view.removeFromSuperview()
        oldContentViewController.didMove(toParentViewController: nil)
      }
      
      // add new view controler
      contentViewController.willMove(toParentViewController: self)
      contentView.addSubview(contentViewController.view)
      contentViewController.didMove(toParentViewController: self)
      
      // Close menu
      UIView.animate(withDuration: 0.3, animations: { () -> Void in
        self.leftMarginConstraint.constant = 0
        self.view.layoutIfNeeded()
        self.menuState = .closed
      })
    }
  }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
    
    let translation = sender.translation(in: view)
    let velocity = sender.velocity(in: view)
    
    if sender.state == UIGestureRecognizerState.began {
      originalLeftMargin = leftMarginConstraint.constant
    } else if sender.state == UIGestureRecognizerState.changed {
      leftMarginConstraint.constant = originalLeftMargin + translation.x
    } else if sender.state == UIGestureRecognizerState.ended {
      UIView.animate(withDuration: 0.3, animations: {
        if velocity.x > 0 {
          self.leftMarginConstraint.constant = self.view.frame.size.width - 250
          self.menuState = .open
        } else {
          self.leftMarginConstraint.constant = 0
          self.menuState = .closed
        }
        self.view.layoutIfNeeded()
      })
    }
  }
  
  func toggleMenu() {
    UIView.animate(withDuration: 0.3, animations: {
      if self.menuState == .closed {
        self.leftMarginConstraint.constant = self.view.frame.size.width - 250
        self.menuState = .open
      } else {
        self.leftMarginConstraint.constant = 0
        self.menuState = .closed
      }
      self.view.layoutIfNeeded()
    })
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
