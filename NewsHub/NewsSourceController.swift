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
		
		let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
		activityIndicator.hidesWhenStopped = true
		tableView.tableFooterView	= activityIndicator
		
		let centre = NotificationCenter.default
		centre.addObserver(self, selector: #selector(newsDidRefresh), name: NSNotification.Name(rawValue: Common.newsRefreshDidFinish), object: nil)
	}
	
	func newsDidRefresh(_ notification: Notification) {
		pageCounter += 1
		tableView.reloadData()
		(tableView.tableFooterView as? UIActivityIndicatorView)?.stopAnimating()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.isNavigationBarHidden = false
		navigationItem.title = "\(source)"
	}

	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let identifier = segue.identifier , identifier == Common.segueNewsDeatailsFromSourceIdentifier else { return }
		let (section, row): (Int, Int)
		if let indexPath = sender as? IndexPath {
			(section, row) = ((indexPath as NSIndexPath).section, (indexPath as NSIndexPath).row)
		} else if let index = sender as? Int {
			(section, row) = (-1, index)
		} else { return }
		let news = section == -1 ? dataSource.headlines[row] : dataSource.taggedNews[section - 2][row - 1]
		let destinationVC = segue.destination as! NewsContentViewController
		destinationVC.dataSource = news
	}
}

extension NewsSourceController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2 + dataSource.taggedNews.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return section < 2 ? 1 : dataSource.taggedNews[section - 2].count + 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch (indexPath as NSIndexPath).section {
		case 0:
			guard let cell = tableView.dequeueReusableCell(withIdentifier: Common.headlinesIdentifier) as? NewsHeadlineCell else {
				return UITableViewCell()
			}
			cell.delegate = self
			cell.source = self.source
			return cell
		case 1:
			return tableView.dequeueReusableCell(withIdentifier: Common.moreHeaderCellIdentifier) ?? UITableViewCell()
		default:
			if (indexPath as NSIndexPath).row == 0 {
				guard let cell = tableView.dequeueReusableCell(withIdentifier: Common.tagHeaderCellIdentifier) as? tagHeaderCell else {
					return UITableViewCell()
				}
				cell.tagLabel.text = dataSource.taggedNews.tag(for: (indexPath as NSIndexPath).section - 2).uppercased()
				return cell
			}
			let news = dataSource.taggedNews[(indexPath as NSIndexPath).section - 2][(indexPath as NSIndexPath).row - 1]
			news.downloadThumbnail { [weak self] (news) in
				if let loadedNews = news {
					if self?.dataSource.taggedNews[(indexPath as NSIndexPath).section - 2][(indexPath as NSIndexPath).row - 1] != loadedNews {
						self?.dataSource.taggedNews[(indexPath as NSIndexPath).section - 2][(indexPath as NSIndexPath).row - 1] = loadedNews
						self?.tableView.reloadRows(at: [indexPath], with: .automatic)
					}
				}
			}
			guard let cell = tableView.dequeueReusableCell(withIdentifier: Common.newsNormalIdentifier) as? NewsNormalCell else {
				return UITableViewCell()
			}
			cell.sourceIconView.removeFromSuperview()
			cell.titleLabel.text = news.title
			if let image = news.image {
				cell.newsImageView.image = image
			} else {
				cell.newsImageView.image = news.source.normalPlaceholder
			}
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch (indexPath as NSIndexPath).section  {
		case 0:
			return 300
		case 1:
			return 36
		default:
			return (indexPath as NSIndexPath).row == 0 ? 24 : 110
		}
	}
	
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height && tableView.visibleCells.count > 0 && pageCounter > 1 {
			(tableView.tableFooterView as? UIActivityIndicatorView)?.startAnimating()
			seeker.loadMore(at: pageCounter)
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if (indexPath as NSIndexPath).section > 1 {
			performSegue(withIdentifier: Common.segueNewsDeatailsFromSourceIdentifier, sender: indexPath)
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

extension NewsSourceController: NewsViewDelegate {
	func showContentView(at index: Int) {
		performSegue(withIdentifier: Common.segueNewsDeatailsFromSourceIdentifier, sender: index)
	}
	
	@available(*, deprecated : 1.0)
	func showCategoryView(at index: Int) {
	}
	
	@available(*, deprecated : 1.0)
	func pick(_ location: String) {
	}
}
