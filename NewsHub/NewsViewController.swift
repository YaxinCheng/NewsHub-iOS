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
	
	let seeker = NewsSeeker()
	var pageCounter = 1
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		navigationController?.navigationBarHidden = true
		seeker.loadNews()
		let centre = NSNotificationCenter.defaultCenter()
		centre.addObserver(self, selector: #selector(newsDidRefresh), name: Common.newsRefreshDidFinish, object: nil)
		tableView.tableFooterView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.navigationBarHidden = true
	}
	
	func newsDidRefresh(notification: NSNotification) {
		pageCounter += 1
		tableView.reloadData()
		(tableView.tableFooterView as? UIActivityIndicatorView)?.stopAnimating()
	}
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 4 + NewsHub.sharedHub.taggedNews.count
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0, 1, 2, 3:
			return 1
		default:
			return NewsHub.sharedHub.taggedNews[section - 4].count + 1
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		switch indexPath.section  {
		case 0:
			guard let cell = tableView.dequeueReusableCellWithIdentifier(Common.headerIdentifier) as? headerCell else {
				return UITableViewCell()
			}
			cell.dateLabel.text = NSDate().formatDate().uppercaseString
			cell.titleLabel.text = "NEWS"
			return cell
		case 1, 2, 3:
			let identifiers = [Common.headlinesIdentifier, Common.sourceIdentifier, Common.moreHeaderCellIdentifier]
			let identifier: String = identifiers[indexPath.section - 1]
			return tableView.dequeueReusableCellWithIdentifier(identifier) ?? UITableViewCell()
		default:
			if indexPath.row == 0 {
				guard let cell = tableView.dequeueReusableCellWithIdentifier(Common.tagHeaderCellIdentifier) as? tagHeaderCell else {
					return UITableViewCell()
				}
				cell.tagLabel.text = NewsHub.sharedHub.taggedNews.tag(for: indexPath.section - 4).uppercaseString
				return cell
			}
			
			let news = NewsHub.sharedHub.taggedNews[indexPath.section - 4][indexPath.row - 1]
			news.downloadImage { [unowned self] (news) in
				if let loadedNews = news {
					if NewsHub.sharedHub.taggedNews[indexPath.section - 4][indexPath.row - 1] != loadedNews {
						NewsHub.sharedHub.taggedNews[indexPath.section - 4][indexPath.row - 1] = loadedNews
						self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
					}
				}
			}
			let identifier = news.image == nil ? Common.newsNoImageIdentifier : Common.newsNormalIdentifier
			guard let cell = tableView.dequeueReusableCellWithIdentifier(identifier) else {
				return UITableViewCell()
			}
			if let image = news.image {
				(cell as! NewsNormalCell).newsImageView.image = image
			}
			(cell as! NewsCell).titleLabel.text = news.title
			return cell
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
		default:
			return indexPath.row == 0 ? 24 : 110
		}
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section >= 4 {
			performSegueWithIdentifier(Common.segueNewsDetailsIdentifier, sender: self)
		}
	}
	
	func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height && tableView.visibleCells.count > 0 {
			(tableView.tableFooterView as? UIActivityIndicatorView)?.startAnimating()
			seeker.loadMore(at: pageCounter)
		}
	}
}
