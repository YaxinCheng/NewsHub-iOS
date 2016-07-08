//
//  NewsSourceContentCell.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-08.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class NewsSourceContentCell: UICollectionViewCell {
    
	@IBOutlet weak var imageView: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		imageView.layer.cornerRadius = 5
		imageView.layer.masksToBounds = true
	}
}
