//
//  moreHeaderCell.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-12.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class moreHeaderCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
			separatorInset = UIEdgeInsets(top: 0, left: self.bounds.size.width * 2, bottom: 0, right: 0)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
