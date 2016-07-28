//
//  SettingViewController.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-27.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {
	
	var dataSource: [SettingContent<News>] = []
	var viewTitle: String!
	var content: String? = nil
	
	var originalColour: UIColor?
	var originalShadow: UIImage?
	var originalBackground: UIImage?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if viewTitle == "Liked" {
			content = "Everything you liked is here"
			var service = NewsLikeService()
			service.newsLiked { [weak self] news in
				self?.dataSource = news.map { SettingContent.News($0) }
				self?.tableView.reloadData()
			}
		}
		
		originalColour = navigationController?.navigationBar.backgroundColor
		originalShadow = navigationController?.navigationBar.shadowImage
		originalBackground = navigationController?.navigationBar.backgroundImageForBarMetrics(.Default)
		
		tableView.estimatedRowHeight = 90
		navigationController?.navigationBarHidden = false
		navigationController?.navigationBar.tintColor = .blackColor()
		navigationController?.navigationBar.backItem?.title = ""
	}
	
	override func viewWillAppear(animated: Bool) {
		navigationController?.navigationBar.backgroundColor = .whiteColor()
		navigationController?.navigationBar.shadowImage = UIImage()
		navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		
		revertNavigationBar()
		navigationController?.navigationBarHidden = true
	}
	
	private func revertNavigationBar() {
		navigationController?.navigationBar.backgroundColor = originalColour
		navigationController?.navigationBar.setBackgroundImage(originalBackground, forBarMetrics: .Default)
		navigationController?.navigationBar.shadowImage = originalShadow
	}
	
	// MARK: - Navigation
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		guard let identifier = segue.identifier, let indexPath = tableView.indexPathForSelectedRow else { return }
		if identifier == Common.segueNewsDetailsIdentifier, case .News(let news) = dataSource[indexPath.row] {
				revertNavigationBar()
				let destinationVC = segue.destinationViewController as! NewsContentViewController
				destinationVC.dataSource = news
				destinationVC.hidesBottomBarWhenPushed = true
		}
	}
	
	// MARK: - Table view data source
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 2
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return section == 0 ? 1 : dataSource.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			guard let cell = tableView.dequeueReusableCellWithIdentifier(Common.headerIdentifier) as? headerCell else {
				return UITableViewCell()
			}
			cell.titleLabel.text = viewTitle
			cell.subtitleLabel.text = content ?? ""
			return cell
		} else {
			let content = dataSource[indexPath.row]
			switch content {
			case .News(let news):
				let identifier = news.imageLink == nil ? Common.newsNoImageIdentifier : Common.newsNormalIdentifier
				guard let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? NewsCell else { return UITableViewCell() }
				cell.titleLabel.text = news.title
				if news.imageLink != nil && news.image == nil {
					news.downloadThumbnail { [weak self] in
						if let news = $0 {
							self?.dataSource[indexPath.row] = SettingContent.News(news)
							self?.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
						}
					}
				}
				if news.image != nil {
					(cell as! NewsNormalCell).newsImageView.image = news.image
				}
				return cell as! UITableViewCell
			case .Setting(let info):
				guard let cell = tableView.dequeueReusableCellWithIdentifier(Common.newsNoImageIdentifier, forIndexPath: indexPath) as? NewsNoImageCell else {
					return UITableViewCell()
				}
				cell.titleLabel.text = info
				return cell
			}
		}
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return indexPath.section == 0 ? 110 : UITableViewAutomaticDimension
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if viewTitle == "Liked" && indexPath.section == 1 {
			performSegueWithIdentifier(Common.segueNewsDetailsIdentifier, sender: nil)
		}
	}
}
