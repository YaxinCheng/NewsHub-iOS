//
//  contentCell.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-18.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class contentCell: UITableViewCell {
	
	@IBOutlet weak var contentTextView: UITextView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
		activityIndicator.hidesWhenStopped = true
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
}
