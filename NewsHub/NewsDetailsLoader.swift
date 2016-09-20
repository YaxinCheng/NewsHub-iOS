//
//  NewsDetailsLoader.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-06.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation

struct NewsDetailsLoader: NewsLoaderProtocol {
	
	var endPoint: String {
		return "/api/details"
	}
	
	fileprivate var handler: ((_ news: News?, _ error: Error?)->())?
	
	func process(json: NSDictionary, error: Error?) {
		if error != nil {
			// Deal with error
			handler?(nil, error)
		} else {
			let news = News(with: json)
			handler?(news, nil)
		}
	}
	
	mutating func loadDetails(from news: News, completion: @escaping (News?, Error?)->()) {
		handler = completion
		sendRequest(method: .post, with: ["url": news.contentLink, "source": news.source.rawValue])
	}
}
