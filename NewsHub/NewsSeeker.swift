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
	
	var source: NewsSource = .all
	
	func process(json: NSDictionary, error: Error?) {
		if error != nil {
			print(error?.localizedDescription)
			return
		}
		let headline = json["headlines"] as? [NSDictionary] ?? []
		let normal = json["normal"] as? [NSDictionary] ?? []
		NewsHub.hub(for: source).headlines += headline.map { News(with: $0) }
		NewsHub.hub(for: source).taggedNews += normal.map { News(with: $0) }
		let centre = NotificationCenter.default
		let notification = Notification(name: Notification.Name(rawValue: Common.newsRefreshDidFinish), object: nil)
		centre.post(notification)
	}
	
	func loadNews() {
		sendRequest(from: source)
	}
	
	func loadMore(at page: Int) {
		sendRequest(from: source, at: page)
	}
}

