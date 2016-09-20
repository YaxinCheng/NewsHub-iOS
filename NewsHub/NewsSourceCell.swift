//
//  NewsSourceCell.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-08.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class NewsSourceCell: UITableViewCell {
	
	@IBOutlet weak var collectionView: UICollectionView!
	weak var delegate: NewsViewDelegate?

}

extension NewsSourceCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return NewsSource.available.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Common.sourceCollectionCellIdentifier, for: indexPath) as? NewsSourceContentCell {
			cell.imageView.image = NewsSource.available[(indexPath as NSIndexPath).row].logo
			return cell
		}
		return UICollectionViewCell()
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 231, height: 119)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		delegate?.showCategoryView(at: (indexPath as NSIndexPath).row)
	}
}
