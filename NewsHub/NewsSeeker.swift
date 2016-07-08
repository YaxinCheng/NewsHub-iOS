//
//  NewsSeeker.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-04.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation

struct NewsSeeker: NewsLoader	{
	var endPoint: String {
		return "/api/news"
	}
	
	func process(json: NSDictionary, error: NSError?) {
		if error != nil {
			print(error?.localizedDescription)
			return
		}
		let headline = json["headlines"] as? [NSDictionary] ?? []
		let normal = json["normal"] as? [NSDictionary] ?? []
		NewsHub.sharedHub.headlines = headline.map { News(with: $0) }
		NewsHub.sharedHub.normalNews = normal.map { News(with: $0) }
	}
	
	func loadNews(from source: NewsSource) {
		switch source {
		case .All:
			sendRequest()
		default:
			sendRequest(with: ["endPoint": "/\(source.rawValue)"])
		}
	}
}
