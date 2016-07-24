//
//  NewsSeeker.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-04.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation

struct NewsSeeker: NewsLoaderProtocol	{
	var endPoint: String {
		return "/api/news"
	}
	
	var source: NewsSource = .All
	
	func process(json: NSDictionary, error: NSError?) {
		if error != nil {
			print(error?.localizedDescription)
			return
		}
		let headline = json["headlines"] as? [NSDictionary] ?? []
		let normal = json["normal"] as? [NSDictionary] ?? []
		NewsHub.hub(for: source).headlines += headline.map { News(with: $0) }
		NewsHub.hub(for: source).taggedNews += normal.map { News(with: $0) }
		let centre = NSNotificationCenter.defaultCenter()
		let notification = NSNotification(name: Common.newsRefreshDidFinish, object: nil)
		centre.postNotification(notification)
	}
	
	func loadNews() {
		sendRequest(from: source)
	}
	
	func loadMore(at page: Int) {
		sendRequest(from: source, at: page)
	}
}

