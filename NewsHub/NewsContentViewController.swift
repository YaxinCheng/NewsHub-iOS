//
//  NewsContentViewController.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-14.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class NewsContentViewController: UIViewController {
	
	var dataSource: News!
	@IBOutlet weak var tableView: UITableView!
	private var imageLoaded: Bool = false
	private var backgroundImage: UIView!
	@IBOutlet weak var topConstraint: NSLayoutConstraint!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		navigationController?.navigationBarHidden = false
		
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.view.backgroundColor = UIColor.clearColor()
		
		backgroundImage = UIView()
		backgroundImage.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 64)
		backgroundImage.backgroundColor = .whiteColor()
		backgroundImage.layer.opacity = 0
		view.addSubview(backgroundImage)
	
		tableView.rowHeight = UITableViewAutomaticDimension
		
		dataSource.downloadDetails { [unowned self] (news) in
			defer {
				self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 1)], withRowAnimation: .Automatic)
				self.loadNewsImage()
				self.topConstraint.constant = -130
			}
			if let loadedNews = news {
				self.dataSource = loadedNews
			} else {
				let alert = UIAlertController(title: "Error", message: "News failed loading", preferredStyle: .Alert)
				let action = UIAlertAction(title: "OK", style: .Cancel) { [unowned self] _ in
					self.navigationController?.popToRootViewControllerAnimated(true)
				}
				alert.addAction(action)
				alert.view.tintColor = self.view.tintColor
				self.presentViewController(alert, animated: true, completion: nil)
			}
		}

	}

	private func loadNewsImage() {
		guard imageLoaded == false else { return }
		dataSource.downloadImage { [unowned self] in
			guard let image = $0 else { return }
			let imageView = UIImageView(image: image)
			imageView.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 200)
			imageView.contentMode = .ScaleToFill
			self.tableView.tableHeaderView = imageView
			self.imageLoaded = true
		}
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

extension NewsContentViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let identifier = indexPath.section == 0 ? Common.titleCellIdentifier : Common.contentCellIdentifier
		let cell = tableView.dequeueReusableCellWithIdentifier(identifier)
		if indexPath.section == 0 {
			(cell as! titleCell).titleLabel.text = dataSource.title
		} else {
			(cell as! contentCell).contentTextView.text = dataSource.content
			(cell as! contentCell).activityIndicator.startAnimating()
		}
		return cell!
	}
	
	func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.section == 0 {
			return 75
		} else {
			return 170
		}
	}
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		let alpha = Float(scrollView.contentOffset.y / 50)
		if alpha >= 1 {
			navigationItem.title = dataSource.title
			backgroundImage.layer.opacity = 1
		} else if alpha > 0 {
			backgroundImage.layer.opacity = alpha
		} else {
			navigationItem.title = ""
			backgroundImage.layer.opacity = 0
		}
	}
}