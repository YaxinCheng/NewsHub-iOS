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
		return 5
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0, 1, 2, 3:
			return 1
		default:
			return NewsHub.sharedHub.normalNews.count
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		switch indexPath.section  {
		case 0:
			guard let cell = tableView.dequeueReusableCellWithIdentifier(Common.headerIdentifier) as? headerCell else {
				return UITableViewCell()
			}
			cell.dateLabel.text = NSDate().formatDate().uppercaseString
			cell.titleLabel.text = "News"
			return cell
		case 1, 2, 3:
			let identifiers = [Common.headlinesIdentifier, Common.sourceIdentifier, Common.moreHeaderCellIdentifier]
			let identifier: String = identifiers[indexPath.section - 1]
			guard let cell = tableView.dequeueReusableCellWithIdentifier(identifier) else {
				return UITableViewCell()
			}
			return cell
		case 4:
			let news = NewsHub.sharedHub.normalNews[indexPath.row]
			news.downloadImage { [unowned self] (news) in
				if let loadedNews = news {
					if NewsHub.sharedHub.normalNews[indexPath.row] != loadedNews {
						NewsHub.sharedHub.normalNews[indexPath.row] = loadedNews
						self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
					}
				}
			}
			let identifier: String
			if indexPath.row == 0 {
				identifier = news.image == nil ? Common.FnewsNoImageIdentifier : Common.FnewsNormalIdentifier
			} else {
				identifier = news.image == nil ? Common.newsNoImageIdentifier : Common.newsNormalIdentifier
			}
			guard let cell = tableView.dequeueReusableCellWithIdentifier(identifier) else {
				return UITableViewCell()
			}
			if let image = news.image {
				(cell as! NewsNormalCell).newsImageView.image = image
			}
			(cell as! NewsCell).titleLabel.text = news.title
			return cell
		default:
			return UITableViewCell()
		}
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		switch indexPath.section  {
		case 0:
			return 70
		case 1:
			return 300
		case 2:
			return 178
		case 3:
			return 36
		case 4:
			return indexPath.row == 0 ? 134 : 110
		default:
			return UITableViewAutomaticDimension
		}
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 4 {
			performSegueWithIdentifier(Common.segueNewsDetailsIdentifier, sender: self)
		}
	}
}
