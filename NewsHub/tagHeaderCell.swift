//
//  tagHeaderCell.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-13.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class tagHeaderCell: UITableViewCell {

	@IBOutlet weak var tagLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
			separatorInset = UIEdgeInsets(top: 0, left: self.bounds.size.width * 2, bottom: 0, right: 0)
    }
}
