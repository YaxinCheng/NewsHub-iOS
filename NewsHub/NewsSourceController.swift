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
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.navigationBarHidden = false
		navigationItem.title = "\(source)"
	}

	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		guard let identifier = segue.identifier where identifier == Common.segueNewsDeatailsFromSourceIdentifier else { return }
		let (section, row): (Int, Int)
		if let indexPath = sender as? NSIndexPath {
			(section, row) = (indexPath.section, indexPath.row)
		} else if let index = sender as? Int {
			(section, row) = (-1, index)
		} else { return }
		let news = section == -1 ? dataSource.headlines[row] : dataSource.taggedNews[section - 2][row - 1]
		let destinationVC = segue.destinationViewController as! NewsContentViewController
		destinationVC.dataSource = news
	}
}

extension NewsSourceController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2 + dataSource.taggedNews.count
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return section < 2 ? 1 : dataSource.taggedNews[section - 2].count + 1
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		switch indexPath.section {
		case 0:
			guard let cell = tableView.dequeueReusableCellWithIdentifier(Common.headlinesIdentifier) as? NewsHeadlineCell else {
				return UITableViewCell()
			}
			cell.delegate = self
			cell.source = self.source
			return cell
		case 1:
			return tableView.dequeueReusableCellWithIdentifier(Common.moreHeaderCellIdentifier) ?? UITableViewCell()
		default:
			if indexPath.row == 0 {
				guard let cell = tableView.dequeueReusableCellWithIdentifier(Common.tagHeaderCellIdentifier) as? tagHeaderCell else {
					return UITableViewCell()
				}
				cell.tagLabel.text = dataSource.taggedNews.tag(for: indexPath.section - 2).uppercaseString
				return cell
			}
			let news = dataSource.taggedNews[indexPath.section - 2][indexPath.row - 1]
			news.downloadThumbnail { [weak self] (news) in
				if let loadedNews = news {
					if self?.dataSource.taggedNews[indexPath.section - 2][indexPath.row - 1] != loadedNews {
						self?.dataSource.taggedNews[indexPath.section - 2][indexPath.row - 1] = loadedNews
						self?.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
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
			return 300
		case 1:
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
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section > 1 {
			performSegueWithIdentifier(Common.segueNewsDeatailsFromSourceIdentifier, sender: indexPath)
		}
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
}

extension NewsSourceController: NewsViewDelegate {
	func showContentView(at index: Int) {
		performSegueWithIdentifier(Common.segueNewsDeatailsFromSourceIdentifier, sender: index)
	}
	
	@available(*, deprecated = 1.0)
	func showCategoryView(at index: Int) {
	}
	
	@available(*, deprecated = 1.0)
	func pick(location: String) {
	}
}