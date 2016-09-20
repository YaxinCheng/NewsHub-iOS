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
	
	fileprivate var handler: ((_ images: UIImage?, _ error: Error?) -> Void)?
	
	func process(json: NSDictionary, error: Error?) {
		if error != nil {
			handler?(nil, error)
		} else if let error = json["Error"] as? String {
			handler?(nil, NSError(domain: error, code: 700, userInfo: nil))
		} else {
			guard let imageString = json["img"] as? String,
				let imageData = Data(base64Encoded: imageString, options: .ignoreUnknownCharacters),
				let image = UIImage(data: imageData)
				else { return }
			handler?(image, nil)
		}
	}
	
	mutating func loadThumbnail(from news: News, completion: ((UIImage?, Error?) -> Void)?) {
		if let link = news.imageLink {
			handler = completion
			sendRequest(method: .post, with: ["url": link])
		}
	}
	
	func loadImage(from news: News, completion: @escaping ((UIImage?) -> Void)) {
		var targetImage: UIImage? = nil
		defer {
			DispatchQueue.main.async {
				completion(targetImage)
			}
		}
		guard let url = news.imageLink , !url.isEmpty else { return }
		let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
		queue.sync {
			guard
				let imageURL = URL(string: url),
				let imageData = try? Data(contentsOf: imageURL),
				let image = UIImage(data: imageData)
			else { return }
			targetImage = image
		}
	}
}
