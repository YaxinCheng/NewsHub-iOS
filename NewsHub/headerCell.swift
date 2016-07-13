//
//  headerCell.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-08.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class headerCell: UITableViewCell {
	
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var settingButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	@IBAction func settingPressed(sender: AnyObject) {
		let animation = CABasicAnimation(keyPath: "transform.rotation.z")
		animation.duration = 0.2
		animation.repeatCount = 1
		animation.fromValue = 0
		animation.toValue = M_PI / 2
		animation.removedOnCompletion = false
		animation.fillMode = kCAFillModeForwards
		(sender as! UIButton).layer.addAnimation(animation, forKey: "rotate")
	}
}
