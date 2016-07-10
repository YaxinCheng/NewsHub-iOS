//
//  NewsNormalCell.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-08.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class NewsNormalCell: UITableViewCell {

	@IBOutlet weak var newsImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
			newsImageView.layer.cornerRadius = 5
			newsImageView.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
