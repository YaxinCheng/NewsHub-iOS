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
		
		originalColour = navigationController?.navigationBar.backgroundColor
		originalShadow = navigationController?.navigationBar.shadowImage
		originalBackground = navigationController?.navigationBar.backgroundImage(for: .default)
		
		tableView.estimatedRowHeight = 90
		navigationController?.isNavigationBarHidden = false
		navigationController?.navigationBar.tintColor = .black
		navigationController?.navigationBar.backItem?.title = ""
	}
	
	override func viewWillAppear(_ animated: Bool) {
		navigationController?.navigationBar.backgroundColor = .white
		navigationController?.navigationBar.shadowImage = UIImage()
		navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		revertNavigationBar()
		navigationController?.isNavigationBarHidden = true
	}
	
	fileprivate func revertNavigationBar() {
		navigationController?.navigationBar.backgroundColor = originalColour
		navigationController?.navigationBar.setBackgroundImage(originalBackground, for: .default)
		navigationController?.navigationBar.shadowImage = originalShadow
	}
	
	// MARK: - Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let identifier = segue.identifier, let indexPath = tableView.indexPathForSelectedRow else { return }
		if identifier == Common.segueNewsDetailsIdentifier, case .news(let news) = dataSource[(indexPath as NSIndexPath).row] {
				revertNavigationBar()
				let destinationVC = segue.destination as! NewsContentViewController
				destinationVC.dataSource = news
				destinationVC.hidesBottomBarWhenPushed = true
		}
	}
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 2
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return section == 0 ? 1 : dataSource.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if (indexPath as NSIndexPath).section == 0 {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: Common.headerIdentifier) as? headerCell else {
				return UITableViewCell()
			}
			cell.titleLabel.text = viewTitle
			cell.subtitleLabel.text = content ?? ""
			return cell
		} else {
			let content = dataSource[(indexPath as NSIndexPath).row]
			switch content {
			case .news(let news):
				guard let cell = tableView.dequeueReusableCell(withIdentifier: Common.newsNormalIdentifier) as? NewsNormalCell else { return UITableViewCell() }
				cell.titleLabel.text = news.title
				if news.imageLink != nil && news.image == nil {
					news.downloadThumbnail { [weak self] in
						if let news = $0 {
							self?.dataSource[(indexPath as NSIndexPath).row] = SettingContent.news(news)
							self?.tableView.reloadRows(at: [indexPath], with: .automatic)
						}
					}
				}
				if news.image != nil {
					cell.newsImageView.image = news.image
					cell.sourceIconView.isHidden = false
					cell.sourceIconView.image = news.source.sourceIcon
				} else {
					cell.sourceIconView.isHidden = true
					cell.newsImageView.image = news.source.normalPlaceholder
				}
				return cell
			case .setting(let info):
				guard let cell = tableView.dequeueReusableCell(withIdentifier: Common.newsNormalIdentifier, for: indexPath) as? NewsNormalCell else {
					return UITableViewCell()
				}
				cell.newsImageView.removeFromSuperview()
				cell.sourceIconView.removeFromSuperview()
				cell.titleLabel.text = info
				return cell
			}
		}
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return (indexPath as NSIndexPath).section == 0 ? 110 : UITableViewAutomaticDimension
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if viewTitle == "Liked" && (indexPath as NSIndexPath).section == 1 {
			performSegue(withIdentifier: Common.segueNewsDetailsIdentifier, sender: nil)
		}
	}
}
