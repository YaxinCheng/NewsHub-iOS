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
	
	var seeker = NewsSeeker()
	var pageCounter = 1
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		navigationController?.navigationBarHidden = true
		if Common.location.isEmpty {
			Common.location = "halifax"
		}
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
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		guard let identifier = segue.identifier else { return }
		if identifier == Common.segueNewsDetailsIdentifier {
			if let indexPath = tableView.indexPathForSelectedRow {
				let news = NewsHub.hub().taggedNews[indexPath.section - 4][indexPath.row - 1]
				let destinationVC = segue.destinationViewController as! NewsContentViewController
				destinationVC.dataSource = news
			} else {
				let index = sender as! Int
				let news = NewsHub.hub().headlines[index]
				let destinationVC = segue.destinationViewController as! NewsContentViewController
				destinationVC.dataSource = news
			}
		} else if identifier == Common.popOverIdentifier {
			let destinationVC = segue.destinationViewController as! LocationController
			destinationVC.delegate = self
			destinationVC.modalPresentationStyle = .Popover
			destinationVC.popoverPresentationController?.sourceView = sender as! UIButton
			destinationVC.popoverPresentationController?.delegate = self
		} else if identifier == Common.segueNewsSourceIdentifier {
			let destinationVC = segue.destinationViewController as! NewsSourceController
			let source = NewsSource.available[sender as! Int]
			destinationVC.source = source
		}
	}
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 4 + NewsHub.hub().taggedNews.count
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0, 1, 2, 3:
			return 1
		default:
			return NewsHub.hub().taggedNews[section - 4].count + 1
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		switch indexPath.section  {
		case 0:
			guard let cell = tableView.dequeueReusableCellWithIdentifier(Common.headerIdentifier) as? headerCell else {
				return UITableViewCell()
			}
			cell.dateLabel.text = NSDate().formatDate().uppercaseString
			cell.titleLabel.text = Common.location.uppercaseString
			return cell
		case 1, 2, 3:
			let identifiers = [Common.headlinesIdentifier, Common.sourceIdentifier, Common.moreHeaderCellIdentifier]
			let identifier: String = identifiers[indexPath.section - 1]
			if let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? NewsHeadlineCell {
				cell.delegate = self
				cell.source = .All
				return cell
			} else if let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? NewsSourceCell {
				cell.delegate = self
				return cell
			} else {
				return tableView.dequeueReusableCellWithIdentifier(identifier) ?? UITableViewCell()
			}
		default:
			if indexPath.row == 0 {
				guard let cell = tableView.dequeueReusableCellWithIdentifier(Common.tagHeaderCellIdentifier) as? tagHeaderCell else {
					return UITableViewCell()
				}
				cell.tagLabel.text = NewsHub.hub().taggedNews.tag(for: indexPath.section - 4).uppercaseString
				return cell
			}
			
			let news = NewsHub.hub().taggedNews[indexPath.section - 4][indexPath.row - 1]
			news.downloadThumbnail { [weak self] (news) in
				if let loadedNews = news {
					if NewsHub.hub().taggedNews[indexPath.section - 4][indexPath.row - 1] != loadedNews {
						NewsHub.hub().taggedNews[indexPath.section - 4][indexPath.row - 1] = loadedNews
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
			return 90
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
		if indexPath.section >= 4 && indexPath.row != 0 {
			performSegueWithIdentifier(Common.segueNewsDetailsIdentifier, sender: self)
		}
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
	
	func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height && tableView.visibleCells.count > 0 {
			(tableView.tableFooterView as? UIActivityIndicatorView)?.startAnimating()
			seeker.loadMore(at: pageCounter)
		}
	}
}

extension NewsViewController: NewsViewDelegate {
	func showContentView(at index: Int) {
		performSegueWithIdentifier(Common.segueNewsDetailsIdentifier, sender: index)
	}
	
	func showCategoryView(at index: Int) {
		performSegueWithIdentifier(Common.segueNewsSourceIdentifier, sender: index)
	}
	
	func pick(location: String) {
		Common.location = location
		NewsHub.hub().clear()
		pageCounter = 1
		seeker.loadNews()
	}
}

extension NewsViewController: UIPopoverPresentationControllerDelegate {
	func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
		return .None
	}
}

extension NewsViewController: UITabBarControllerDelegate {
	func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
		
	}
}
