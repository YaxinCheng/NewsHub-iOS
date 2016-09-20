//
//  LoginCells.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-15.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class LoginCells: UICollectionViewCell {
	weak var delegate: LoginCellsDelegate?
	@IBOutlet weak var actionButton: UIButton!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		let control = UIControl(frame: self.contentView.frame)
		control.addTarget(self, action: #selector(backgrounTouched), for: .touchUpInside)
		self.contentView.insertSubview(control, at: 0)
		
		actionButton.layer.cornerRadius = 17
		actionButton.layer.borderColor = tintColor.cgColor
		actionButton.layer.borderWidth = 1
		actionButton.layer.masksToBounds = true
		
		activityIndicator.hidesWhenStopped = true
		activityIndicator.isHidden =  true
	}
	
	func backgrounTouched(_ sender: UIControl) {
		self.contentView.endEditing(true)
	}
}
