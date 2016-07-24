//
//  PasswordChangeViewController.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-24.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class PasswordChangeViewController: UITableViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false
		
		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem()
		tableView.estimatedRowHeight = 31
	}
	
	// MARK: - Table view data source
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 3
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return section == 0 ? 1 : 2
	}
	
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		switch (indexPath.section, indexPath.row) {
		case (0, _):
			return tableView.dequeueReusableCellWithIdentifier(Common.headerIdentifier) ?? UITableViewCell()
		case (_, 0):
			guard let subtitle = tableView.dequeueReusableCellWithIdentifier(Common.moreHeaderCellIdentifier) as? moreHeaderCell else {
				return UITableViewCell()
			}
			subtitle.titleLabel.text = indexPath.section == 0 ? "OLD PASSWORD" : "NEW PASSWORD"
			return subtitle
		case (_, 1):
			return tableView.dequeueReusableCellWithIdentifier(Common.textFieldCellIdentifier) ?? UITableViewCell()
		default:
			return UITableViewCell()
		}
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		switch (indexPath.section, indexPath.row) {
		case (0, _):
			return 90
		case (_, 0):
			return 36
		default:
			return UITableViewAutomaticDimension
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
