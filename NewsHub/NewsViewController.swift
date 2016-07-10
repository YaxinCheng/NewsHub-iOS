//
//  NewsViewController.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-07.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		navigationController?.navigationBarHidden = true
		let seeker = NewsSeeker()
		seeker.loadNews()
		let centre = NSNotificationCenter.defaultCenter()
		centre.addObserver(self, selector: #selector(newsDidRefresh), name: Common.newsRefreshDidFinish, object: nil)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.navigationBarHidden = true
	}
	
	
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
		guard let identifier = segue.identifier else { return }
		switch identifier {
		case Common.segueNewsDetailsIdentifier:
			navigationController?.navigationBarHidden = false
		default:
			break
		}
	}
	
	func newsDidRefresh(notification: NSNotification) {
		tableView.reloadData()
	}
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 4
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0, 1, 2:
			return 1
		default:
			return 2
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		switch (indexPath.section, indexPath.row) {
		case (0, _):
			guard let cell = tableView.dequeueReusableCellWithIdentifier(Common.headerIdentifier) as? headerCell else {
				return UITableViewCell()
			}
			cell.dateLabel.text = NSDate().formatDate().uppercaseString
			cell.titleLabel.text = "News"
			return cell
		case (1, _):
			guard let cell = tableView.dequeueReusableCellWithIdentifier(Common.headlinesIdentifier) as? NewsHeadlineCell else {
				return UITableViewCell()
			}
			return cell
		case (2, _):
			guard let cell = tableView.dequeueReusableCellWithIdentifier(Common.sourceIdentifier) as? NewsSourceCell else {
				return UITableViewCell()
			}
			return cell
		case (3, 0):
			let news = NewsHub.sharedHub.normalNews[indexPath.row]
			guard let cell = tableView.dequeueReusableCellWithIdentifier(Common.FnewsNormalIdentifier) as? NewsNormalCell else {
				return UITableViewCell()
			}
			cell.newsImageView.image = UIImage(named: "example.jpg")
			cell.titleLabel.text = "Justin Trudau"
			return cell
		case (3,_):
			guard let cell = tableView.dequeueReusableCellWithIdentifier(Common.newsNormalIdentifier) as? NewsNormalCell else {
				return UITableViewCell()
			}
			cell.newsImageView.image = UIImage(named: "example.jpg")
			cell.titleLabel.text = "Justin Trudau"
			return cell
		default:
			return UITableViewCell()
		}
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		switch (indexPath.section, indexPath.row) {
		case (0, _):
			return 70
		case (1, _):
			return 300
		case (2, _):
			return 162
		case (3, 0):
			return 143
		case (3, _):
			return 119
		default:
			return UITableViewAutomaticDimension
		}
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 3 {
			performSegueWithIdentifier(Common.segueNewsDetailsIdentifier, sender: self)
		}
	}
}
