//
//  UITextField+Boarder.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-15.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit.UITextField
import UIKit.UIColor
import Foundation

extension UITextField {
	@IBInspectable var borderColour: UIColor! {
		set {
			let border = CALayer()
			let width = CGFloat(1)
			border.borderColor = newValue.cgColor// Colour
			border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width + 10, height: self.frame.size.height)// Set frame. y is the set the line
			
			border.borderWidth = width// the height of the line
			
			self.layer.addSublayer(border)// Add to sublayer
			self.layer.masksToBounds = true
		} get {
			return UIColor.clear
		}
	}
}
