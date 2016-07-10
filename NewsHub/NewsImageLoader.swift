//
//  NewsImageLoader.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-09.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

struct NewsImageLoader: NewsLoader {
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
}