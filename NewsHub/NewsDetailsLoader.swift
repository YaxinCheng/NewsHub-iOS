//
//  NewsDetailsLoader.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-06.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation

struct NewsDetailsLoader: NewsLoader {
	
	var endPoint: String {
		return "/api/details"
	}
	
	private var handler: ((news: News?, error: NSError?)->())?
	
	func process(json: NSDictionary, error: NSError?) {
		if error != nil {
			// Deal with error
			handler?(news: nil, error: error)
		} else {
			let news = News(with: json)
			handler?(news: news, error: nil)
		}
	}
	
	mutating func loadDetails(from news: News, completion: (News?, NSError?)->()) {
		handler = completion
		sendRequest(.POST, with: ["url": news.contentLink, "source": news.source.rawValue])
	}
}