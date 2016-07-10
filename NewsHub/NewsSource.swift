//
//  NewsSource.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-06.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

enum NewsSource: String {
	case All = ""
	case Metro = "metro"
	case Chronicle = "chronicle"
	
	var URL: String {
		switch self {
		case .Metro:
			return "http://www.metronews.ca/halifax.html"
		case .Chronicle:
			return "http://thechronicleherald.ca"
		default:
			return ""
		}
	}
	
	static var available: [NewsSource] {
		return [.Metro, .Chronicle]
	}
	
	var logo: UIImage {
		if self == .All {
			return UIImage()
		}
		return UIImage(named: self.rawValue)!
	}
}