//
//  contentCell.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-18.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class contentCell: UITableViewCell {

	@IBOutlet weak var contentLabel: UILabel!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
			activityIndicator.hidesWhenStopped = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
