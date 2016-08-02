//
//  emotion.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-08-02.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation
import UIKit.UIImage

enum emotion: String {
	case liked
	case thumbup
	case thumbdown
	
	init?(rawValue: String) {
		switch rawValue {
		case "like", "likes", "liked":
			self = .liked
		case "thumbup":
			self = .thumbup
		case "thumbdown":
			self = .thumbdown
		default:
			return nil
		}
	}
	
	init?(value: Int) {
		switch value {
		case -1:
			self = .thumbdown
		case 0:
			self = .liked
		case 1:
			self = .thumbup
		default:
			return nil
		}
	}
	
	var image: UIImage? {
		switch self {
		case .liked:
			return UIImage(named: "hearticon-highlight")?.imageWithRenderingMode(.AlwaysTemplate)
		case .thumbup:
			return UIImage(named: "thumbupicon")?.imageWithRenderingMode(.AlwaysTemplate)
		case .thumbdown:
			return UIImage(named: "thumbdownicon")?.imageWithRenderingMode(.AlwaysTemplate)
		}
	}
}