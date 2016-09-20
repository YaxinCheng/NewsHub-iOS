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
	var source: NewsSource!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
		let centre = NotificationCenter.default
		centre.addObserver(self, selector: #selector(newsDidRefresh), name: NSNotification.Name(rawValue: Common.newsRefreshDidFinish), object: nil)
	}
	
	func newsDidRefresh(_ notification: Notification) {
		collectionView.reloadData()
	}
}

extension NewsHeadlineCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return NewsHub.hub(for: source).headlines.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Common.headCollectionCellIdentifier, for: indexPath) as? NewsHeadlineContentCell {
			let news = NewsHub.hub(for: self.source).headlines[(indexPath as NSIndexPath).row]
			cell.titleLabel.text = news.title
			cell.sourceLabel.text = news.source.rawValue
			cell.imageView.image = news.source.placeHolder
			news.downloadThumbnail { [weak self] (news) in
				if let loadedNews = news, let source = self?.source {
					NewsHub.hub(for: source).headlines[(indexPath as NSIndexPath).row] = loadedNews
					cell.imageView.image = loadedNews.image
				}
			}
			return cell
		}
		return UICollectionViewCell()
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 294.4, height: collectionView.bounds.height - 6)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		delegate?.showContentView(at: (indexPath as NSIndexPath).row)
	}
}
