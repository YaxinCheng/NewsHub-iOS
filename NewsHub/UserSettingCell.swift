//
//  UserSettingCell.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-26.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class UserSettingCell: UITableViewCell {
	
	@IBOutlet weak var iconImageView: UIImageView!
	@IBOutlet weak var settingLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
}
