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
	case light
	case dark
	
	var barStyle: UIBarStyle {
		switch self {
		case .light:
			return .default
		case .dark:
			return .black
		}
	}
	
	var barColour: UIColor {
		switch self {
		case .light:
			return .black
		case .dark:
			return .white
		}
	}
}
