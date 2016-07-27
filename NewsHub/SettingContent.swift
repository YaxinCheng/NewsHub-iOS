//
//  SettingContent.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-27.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation
import UIKit.UIImage

struct SettingContent {
	var title: String
	var imageLink: String?
	var image: UIImage?
	var contentLink: String?
	
	init?(with JSON: NSDictionary) {
		guard let title = JSON["title"] as? String,
			let imageLink = JSON["img"] as? String,
			let contentLink = JSON["_id"] as? String
		else { return nil }
		self.title = title
		self.imageLink = imageLink
		self.contentLink = contentLink
	}
	
	init(title: String, image: UIImage? = nil, contentLink: String? = nil) {
		self.title = title
		self.image = image
		self.contentLink = contentLink
	}
	
	func downloadImage(callback: (SettingContent?) -> Void) {
		guard let link = imageLink else { return callback(nil) }
		let queue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
		dispatch_async(queue) {
			guard let url = NSURL(string: link),
				let data = NSData(contentsOfURL: url),
				let image = UIImage(data: data) else {
					callback(nil)
					return
			}
			var loadedContent = self
			loadedContent.image = image
			dispatch_async(dispatch_get_main_queue()) {
				callback(loadedContent)
			}
		}
	}
}