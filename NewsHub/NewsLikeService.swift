//
//  NewsLikeService.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-27.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation

struct NewsLikeService: NewsLoaderProtocol {
	var endPoint: String {
		return "/api/likes"
	}
	
	var checkCompletion: ((Bool) -> Void)?
	var newsLikedCompletion: (([News]) -> Void)?
	var completion: ((String?) -> Void)?
	
	func process(json: NSDictionary, error: NSError?) {
		if error != nil {
			newsLikedCompletion?([])
			completion?(error?.localizedDescription)
		} else if let errorInfo = json["ERROR"] as? String {
			newsLikedCompletion?([])
			completion?(errorInfo)
			checkCompletion?(false)
		} else if let newsJSON = json["SUCCESS"] as? [NSDictionary] {
			let news = newsJSON.map { News(with: $0) }
			newsLikedCompletion?(news)
		} else if let _ = json["SUCCESS"] as? String {
			completion?(nil)
			checkCompletion?(true)
		} else {
			newsLikedCompletion?([])
			completion?("Unknown error")
			checkCompletion?(false)
		}
	}
	
	mutating func newsLiked(completion: ([News]) -> Void) {
		self.newsLikedCompletion = completion
		sendRequest()
	}
	
	mutating func like(news: News, completion: (String?) -> Void) {
		self.completion = completion
		sendRequest(.PUT, with: ["url": news.contentLink])
	}
	
	mutating func checkLike(news: News, completion: (Bool) -> Void) {
		guard let _ = UserManager.sharedManager.currentUser else {
			completion(false)
			return
		}
		self.checkCompletion = completion
		sendRequest(.POST, with: ["url": news.contentLink])
	}
}