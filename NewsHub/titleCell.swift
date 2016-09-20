//
//  titleCell.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-17.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class titleCell: UITableViewCell {
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var view: UIView!
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
}
