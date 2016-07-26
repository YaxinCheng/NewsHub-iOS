//
//  NewsHub.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-04.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation

final class NewsHub {
	static var allHubs: [NewsSource: NewsHub] = Dictionary<NewsSource, NewsHub>()
	
	var headlines: [News]
	var taggedNews: TagList<News>
	
	private init() {
		headlines = []
		taggedNews = TagList()
	}
	
	func clear() {
		headlines = []
		taggedNews = TagList()
	}
	
	static func hub(for source: NewsSource = .All) -> NewsHub {
		if let hub = allHubs[source] {
			return hub
		} else {
			let hub = NewsHub()
			allHubs[source] = hub
			return hub
		}
	}
}