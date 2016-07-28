//
//  NewsBarStyle.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-28.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation
import UIKit.UINavigationController

enum NewsBarStyle {
	case Light
	case Dark
	
	var barStyle: UIBarStyle {
		switch self {
		case .Light:
			return .Default
		case .Dark:
			return .Black
		}
	}
	
	var barColour: UIColor {
		switch self {
		case .Light:
			return .blackColor()
		case .Dark:
			return .whiteColor()
		}
	}
}