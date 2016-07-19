//
//  NewsHeadlineCell.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-08.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class NewsHeadlineCell: UITableViewCell {

	@IBOutlet weak var collectionView: UICollectionView!
	weak var delegate: NewsViewDelegate?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
		let centre = NSNotificationCenter.defaultCenter()
		centre.addObserver(self, selector: #selector(newsDidRefresh), name: Common.newsRefreshDidFinish, object: nil)
	}
	
	func newsDidRefresh(notification: NSNotification) {
		collectionView.reloadData()
	}
}

extension NewsHeadlineCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return NewsHub.sharedHub.headlines.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Common.headCollectionCellIdentifier, forIndexPath: indexPath) as? NewsHeadlineContentCell {
			let news = NewsHub.sharedHub.headlines[indexPath.row]
			cell.titleLabel.text = news.title
			cell.sourceLabel.text = news.source.rawValue
			cell.imageView.image = news.source.placeHolder
			news.downloadThumbnail { (news) in
				if let loadedNews = news {
					NewsHub.sharedHub.headlines[indexPath.row] = loadedNews
					cell.imageView.image = loadedNews.image
				}
			}
			return cell
		}
		return UICollectionViewCell()
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return CGSize(width: 294.4, height: collectionView.bounds.height - 6)
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
		return 0
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		delegate?.showContentView(at: indexPath.row)
	}
}
