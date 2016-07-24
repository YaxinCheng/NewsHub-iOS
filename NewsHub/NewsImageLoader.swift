//
//  NewsImageLoader.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-09.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation
import UIKit.UIImage

struct NewsImageLoader: NewsLoaderProtocol {
	var endPoint: String {
		return "/api/thumbnails"
	}
	
	private var handler: ((images: UIImage?, error: NSError?) -> Void)?
	
	func process(json: NSDictionary, error: NSError?) {
		if error != nil {
			handler?(images: nil, error: error)
		} else if let error = json["Error"] as? String {
			handler?(images: nil, error: NSError(domain: error, code: 700, userInfo: nil))
		} else {
			guard let imageString = json["img"] as? String,
				let imageData = NSData(base64EncodedString: imageString, options: .IgnoreUnknownCharacters),
				let image = UIImage(data: imageData)
				else { return }
			handler?(images: image, error: nil)
		}
	}
	
	mutating func loadThumbnail(from news: News, completion: ((UIImage?, NSError?) -> Void)?) {
		if let link = news.imageLink {
			handler = completion
			sendRequest(.POST, with: ["url": link])
		}
	}
	
	func loadImage(from news: News, completion: ((UIImage?) -> Void)) {
		var targetImage: UIImage? = nil
		defer {
			dispatch_async(dispatch_get_main_queue()) {
				completion(targetImage)
			}
		}
		guard let url = news.imageLink where !url.isEmpty else { return }
		let queue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
		dispatch_sync(queue) {
			guard
				let imageURL = NSURL(string: url),
				let imageData = NSData(contentsOfURL: imageURL),
				let image = UIImage(data: imageData)
			else { return }
			targetImage = image
		}
	}
}