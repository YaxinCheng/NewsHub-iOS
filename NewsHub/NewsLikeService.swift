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
	var completion: ((String?) -> Void)?
	
	func process(json: NSDictionary, error: NSError?) {
		if error != nil {
			completion?(error?.localizedDescription)
		} else if let errorInfo = json["ERROR"] as? String {
			completion?(errorInfo)
			checkCompletion?(nil)
		} else if let emotionString = json["SUCCESS"] as? String {
			completion?(nil)
			checkCompletion?(emotion(rawValue: emotionString))
		} else {
			completion?("Unknown error")
			checkCompletion?(nil)
		}
	}
	
	mutating func react(news: News, Emotion: emotion? = .liked) {
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