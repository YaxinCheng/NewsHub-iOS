//
//  SettingViewController.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-27.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {
	
	var dataSource: [SettingContent] = []
	var viewTitle: String!
	var content: String? = nil
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if viewTitle == "Liked" {
			var service = NewsLikeService()
			service.newsLiked { [weak self] news in
				self?.dataSource = news
				self?.tableView.reloadData()
			}
		}
		tableView.estimatedRowHeight = 90
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
			let identifier = content.imageLink == nil ? Common.newsNoImageIdentifier : Common.newsNormalIdentifier
			guard let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as? NewsCell else { return UITableViewCell() }
			cell.titleLabel.text = content.title
			if content.imageLink != nil && content.image == nil {
				content.downloadImage { [weak self] in
					guard let loaded = $0 else { return }
					self?.dataSource[indexPath.row] = loaded
					tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
				}
			} else {
				(cell as! NewsNormalCell).newsImageView.image = content.image
			}
			return cell as! UITableViewCell
		}
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return indexPath.section == 0 ? 110 : UITableViewAutomaticDimension
	}
	
}
