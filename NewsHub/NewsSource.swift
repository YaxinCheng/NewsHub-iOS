//
//  NewsSource.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-06.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation
import UIKit.UIImage

enum NewsSource: String {
	case all = ""
	case metro = "metro"
	case chronicle = "chronicle"
	
	var url: String {
		switch self {
		case .metro:
			return "http://www.metronews.ca/halifax.html"
		case .chronicle:
			return "http://thechronicleherald.ca"
		default:
			return ""
		}
	}
	
	static var available: [NewsSource] {
		return [.metro, .chronicle]
	}
	
	var logo: UIImage {
		if self == .all {
			return UIImage()
		}
		return UIImage(named: self.rawValue)!
	}
	
	var placeHolder: UIImage {
		return UIImage(named: self.rawValue + "Placeholder")!
	}
	
	var themeColour: UIColor {
		switch self {
		case .metro:
			return UIColor(red: 83/255, green: 159/255, blue: 40/255, alpha: 1)
		case .chronicle:
			return UIColor(red: 159/255, green: 25/255, blue: 27/255, alpha: 1)
		default:
			return UIColor.clear
		}
	}
	
	var sourceIcon: UIImage {
		if self == .all {
			return UIImage()
		}
		return UIImage(named: self.rawValue + "Icon")!
	}
	
	var normalPlaceholder: UIImage {
		if self == .all {
			return UIImage()
		}
		return UIImage(named: self.rawValue + "NormalPlaceholder")!
	}
}
