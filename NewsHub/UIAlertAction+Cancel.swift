//
//  UIAlertAction+Cancel.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-25.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation
import UIKit.UIAlertController

extension UIAlertAction {
	static var cancel: UIAlertAction {
		return UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
	}
}
