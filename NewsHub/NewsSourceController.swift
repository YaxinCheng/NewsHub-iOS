//
//  NewsSourceController.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-21.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class NewsSourceController: UIViewController {
	
	var source: NewsSource!
	var dataSource: NewsHub!
	var pageCounter: Int = 1
	var seeker: NewsSeeker!
	
	@IBOutlet weak var tableView: UITableView!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		dataSource = NewsHub.hub(for: source)
		seeker = NewsSeeker(source: source)
		seeker.loadNews()
		
		let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
		activityIndicator.hidesWhenStopped = true
		tableView.tableFooterView	= activityIndicator
		
		let centre = NSNotificationCenter.defaultCenter()
		centre.addObserver(self, selector: #selector(newsDidRefresh), name: Common.newsRefreshDidFinish, object: nil)
	}
	
	func newsDidRefresh(notification: NSNotification) {
		pageCounter += 1
		tableView.reloadData()
		(tableView.tableFooterView as? UIActivityIndicatorView)?.stopAnimating()
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

extension NewsSourceController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 3 + dataSource.taggedNews.count
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return section < 3 ? 1 : dataSource.taggedNews[section - 3].count + 1
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		switch indexPath.section {
		case 0:
			guard let cell = tableView.dequeueReusableCellWithIdentifier(Common.headerIdentifier) as? headerCell else {
				return UITableViewCell()
			}
			cell.dateLabel.text = NSDate().formatDate()
			cell.titleLabel.text = source.rawValue.uppercaseString
			return cell
		case 1, 2:
			let identifier = indexPath.section == 1 ? Common.headlinesIdentifier : Common.moreHeaderCellIdentifier
			guard let cell = tableView.dequeueReusableCellWithIdentifier(identifier) else { return UITableViewCell() }
			if indexPath.section == 1 {
				(cell as! NewsHeadlineCell).delegate = self
				(cell as! NewsHeadlineCell).source = self.source
			}
			return cell
		default:
			let previousSectionNumber = 3
			if indexPath.row == 0 {
				guard let cell = tableView.dequeueReusableCellWithIdentifier(Common.tagHeaderCellIdentifier) as? tagHeaderCell else {
					return UITableViewCell()
				}
				cell.tagLabel.text = dataSource.taggedNews.tag(for: indexPath.section - previousSectionNumber).uppercaseString
				return cell
			}
			let news = dataSource.taggedNews[indexPath.section - previousSectionNumber][indexPath.row - 1]
			news.downloadThumbnail { [unowned self] (news) in
				if let loadedNews = news {
					if self.dataSource.taggedNews[indexPath.section - previousSectionNumber][indexPath.row - 1] != loadedNews {
						self.dataSource.taggedNews[indexPath.section - previousSectionNumber][indexPath.row - 1] = loadedNews
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
			return 90
		case 1:
			return 300
		case 2:
			return 36
		default:
			return indexPath.row == 0 ? 24 : 110
		}
	}
	
	func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height && tableView.visibleCells.count > 0 {
			(tableView.tableFooterView as? UIActivityIndicatorView)?.startAnimating()
			seeker.loadMore(at: pageCounter)
		}
	}
}

extension NewsSourceController: NewsViewDelegate {
	func showContentView(at index: Int) {
		
	}
	
	@available(*, deprecated = 1.0)
	func showCategoryView(at index: Int) {
	}
	
	@available(*, deprecated = 1.0)
	func pick(location: String) {
	}
}