//
//  UserViewController.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-14.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		navigationController?.navigationBarHidden = true
		parentViewController?.parentViewController?.performSegueWithIdentifier(Common.loginViewIndentifier, sender: nil)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		if let user = UserManager.sharedManager.currentUser {
			let headCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! headerCell
			headCell.titleLabel.text = "HI, " + user.name.componentsSeparatedByString(" ")[0]
		}
	}
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	
}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCellWithIdentifier(Common.headerIdentifier) as? headerCell else {
			return UITableViewCell()
		}
		return cell
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		switch indexPath.section {
		case 0:
			return 70
		default:
			return UITableViewAutomaticDimension
		}
	}
}