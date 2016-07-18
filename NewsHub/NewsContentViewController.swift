//
//  NewsContentViewController.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-14.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class NewsContentViewController: UIViewController {
	
	var dataSource: News!
	@IBOutlet weak var tableView: UITableView!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		navigationController?.navigationBarHidden = false
		
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.translucent = true
		self.navigationController?.view.backgroundColor = UIColor.clearColor()
	
		tableView.rowHeight = UITableViewAutomaticDimension
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
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

extension NewsContentViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let identifier = indexPath.section == 0 ? Common.titleCellIdentifier : Common.contentCellIdentifier
		let cell = tableView.dequeueReusableCellWithIdentifier(identifier)
		if indexPath.section == 0 {
			(cell as! titleCell).titleLabel.text = dataSource.title
		} else {
			dataSource.downloadDetails { [unowned self] (news) in
				if let loadedNews = news {
					(cell as! contentCell).contentLabel.text = loadedNews.content
					self.dataSource = loadedNews
					tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 1)], withRowAnimation: .Automatic)
				} else {
					let alert = UIAlertController(title: "Error", message: "News failed loading", preferredStyle: .Alert)
					let action = UIAlertAction(title: "OK", style: .Cancel) { [unowned self] _ in
						self.navigationController?.popToRootViewControllerAnimated(true)
					}
					alert.addAction(action)
					alert.view.tintColor = self.view.tintColor
					self.presentViewController(alert, animated: true, completion: nil)
				}
			}
		}
		return cell!
	}
	
	func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.section == 0 {
			return 75
		} else {
			return 170
		}
	}
}