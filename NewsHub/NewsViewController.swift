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
		navigationController?.isNavigationBarHidden = true
		if Common.location.isEmpty {
			Common.location = "halifax"
		}
		seeker.loadNews()
		let centre = NotificationCenter.default
		centre.addObserver(self, selector: #selector(newsDidRefresh), name: NSNotification.Name(rawValue: Common.newsRefreshDidFinish), object: nil)
		tableView.tableFooterView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.isNavigationBarHidden = true
	}
	
	func newsDidRefresh(_ notification: Notification) {
		pageCounter += 1
		tableView.reloadData()
		(tableView.tableFooterView as? UIActivityIndicatorView)?.stopAnimating()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let identifier = segue.identifier else { return }
		if identifier == Common.segueNewsDetailsIdentifier {
			if let indexPath = tableView.indexPathForSelectedRow {
				let news = NewsHub.hub().taggedNews[(indexPath as NSIndexPath).section - 4][(indexPath as NSIndexPath).row - 1]
				let destinationVC = segue.destination as! NewsContentViewController
				destinationVC.hidesBottomBarWhenPushed = true
				destinationVC.dataSource = news
			} else {
				let index = sender as! Int
				let news = NewsHub.hub().headlines[index]
				let destinationVC = segue.destination as! NewsContentViewController
				destinationVC.hidesBottomBarWhenPushed = true
				destinationVC.dataSource = news
			}
		} else if identifier == Common.popOverIdentifier {
			let destinationVC = segue.destination as! LocationController
			destinationVC.delegate = self
			destinationVC.modalPresentationStyle = .popover
			destinationVC.popoverPresentationController?.sourceView = sender as! UIButton
			destinationVC.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: ((sender as AnyObject).bounds.width), height: ((sender as AnyObject).bounds.height))
			destinationVC.popoverPresentationController?.delegate = self
		} else if identifier == Common.segueNewsSourceIdentifier {
			let destinationVC = segue.destination as! NewsSourceController
			let source = NewsSource.available[sender as! Int]
			destinationVC.source = source
		}
	}
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 4 + NewsHub.hub().taggedNews.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0, 1, 2, 3:
			return 1
		default:
			return NewsHub.hub().taggedNews[section - 4].count + 1
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch (indexPath as NSIndexPath).section  {
		case 0:
			guard let cell = tableView.dequeueReusableCell(withIdentifier: Common.headerIdentifier) as? headerCell else {
				return UITableViewCell()
			}
			cell.dateLabel.text = Date().formatDate().uppercased()
			cell.titleLabel.text = Common.location.uppercased()
			return cell
		case 1, 2, 3:
			let identifiers = [Common.headlinesIdentifier, Common.sourceIdentifier, Common.moreHeaderCellIdentifier]
			let identifier: String = identifiers[(indexPath as NSIndexPath).section - 1]
			if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? NewsHeadlineCell {
				cell.delegate = self
				cell.source = .all
				return cell
			} else if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? NewsSourceCell {
				cell.delegate = self
				return cell
			} else {
				return tableView.dequeueReusableCell(withIdentifier: identifier) ?? UITableViewCell()
			}
		default:
			if (indexPath as NSIndexPath).row == 0 {
				guard let cell = tableView.dequeueReusableCell(withIdentifier: Common.tagHeaderCellIdentifier) as? tagHeaderCell else {
					return UITableViewCell()
				}
				cell.tagLabel.text = NewsHub.hub().taggedNews.tag(for: (indexPath as NSIndexPath).section - 4).uppercased()
				return cell
			}
			
			let news = NewsHub.hub().taggedNews[(indexPath as NSIndexPath).section - 4][(indexPath as NSIndexPath).row - 1]
			if news.imageLink != nil && news.image == nil {
				news.downloadThumbnail { [weak self] (news) in
					if let loadedNews = news {
						if NewsHub.hub().taggedNews[(indexPath as NSIndexPath).section - 4][(indexPath as NSIndexPath).row - 1] != loadedNews {
							NewsHub.hub().taggedNews[(indexPath as NSIndexPath).section - 4][(indexPath as NSIndexPath).row - 1] = loadedNews
							self?.tableView.reloadRows(at: [indexPath], with: .automatic)
						}
					}
				}
			}
			guard let cell = tableView.dequeueReusableCell(withIdentifier: Common.newsNormalIdentifier) as? NewsNormalCell else {
				return UITableViewCell()
			}
			if let image = news.image {
				cell.newsImageView.image = image
				cell.sourceIconView.isHidden = false
				cell.sourceIconView.image = news.source.sourceIcon
			} else {
				cell.newsImageView.image = news.source.normalPlaceholder
				cell.sourceIconView.isHidden = true
			}
			cell.titleLabel.text = news.title
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch (indexPath as NSIndexPath).section  {
		case 0:
			return 90
		case 1:
			return 300
		case 2:
			return 178
		case 3:
			return 36
		default:
			return (indexPath as NSIndexPath).row == 0 ? 24 : 110
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if (indexPath as NSIndexPath).section >= 4 && (indexPath as NSIndexPath).row != 0 {
			performSegue(withIdentifier: Common.segueNewsDetailsIdentifier, sender: self)
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height && tableView.visibleCells.count > 0 && pageCounter > 1 {
			(tableView.tableFooterView as? UIActivityIndicatorView)?.startAnimating()
			seeker.loadMore(at: pageCounter)
		}
	}
}

extension NewsViewController: NewsViewDelegate {
	func showContentView(at index: Int) {
		performSegue(withIdentifier: Common.segueNewsDetailsIdentifier, sender: index)
	}
	
	func showCategoryView(at index: Int) {
		performSegue(withIdentifier: Common.segueNewsSourceIdentifier, sender: index)
	}
	
	func pick(location: String) {
		Common.location = location
		NewsHub.hub().clear()
		pageCounter = 1
		seeker.loadNews()
	}
}

extension NewsViewController: UIPopoverPresentationControllerDelegate {
	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return .none
	}
}

extension NewsViewController: UITabBarControllerDelegate {
	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
		
	}
}
