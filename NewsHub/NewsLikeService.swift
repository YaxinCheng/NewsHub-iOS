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
	
	var checkCompletion: ((emotion?) -> Void)?
	var newsLikedCompletion: (([News]) -> Void)?
	var completion: ((String?) -> Void)?
	
	func process(json: NSDictionary, error: NSError?) {
		if error != nil {
			newsLikedCompletion?([])
			completion?(error?.localizedDescription)
		} else if let errorInfo = json["ERROR"] as? String {
			newsLikedCompletion?([])
			completion?(errorInfo)
			checkCompletion?(nil)
		} else if let newsJSON = json["SUCCESS"] as? [NSDictionary] {
			let news = newsJSON.map { News(with: $0) }
			newsLikedCompletion?(news)
		} else if let emotionString = json["SUCCESS"] as? String {
			completion?(nil)
			checkCompletion?(emotion(rawValue: emotionString))
		} else {
			newsLikedCompletion?([])
			completion?("Unknown error")
			checkCompletion?(nil)
		}
	}
	
	mutating func newsLiked(completion: ([News]) -> Void) {
		self.newsLikedCompletion = completion
		sendRequest()
	}
	
	mutating func react(news: News, Emotion: emotion? = .liked, completion: (String?) -> Void) {
		self.completion = completion
		let emotionString = Emotion?.rawValue ?? "unreact"
		sendRequest(.PUT, with: ["url": news.contentLink, "emotion": emotionString])
	}
	
	mutating func checkReact(news: News, completion: (emotion?) -> Void) {
		guard let _ = UserManager.sharedManager.currentUser else {
			completion(nil)
			return
		}
		self.checkCompletion = completion
		sendRequest(.POST, with: ["url": news.contentLink])
	}
}