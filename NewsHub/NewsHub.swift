//
//  NewsHub.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-04.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation

struct NewsHub {
	static var sharedHub = NewsHub()
	
	var headlines: [News]
	var normalNews: [News]
	
	var news: [News] {
		return headlines + normalNews
	}
	
	private init() {
		headlines = []
		normalNews = []
	}
	
}