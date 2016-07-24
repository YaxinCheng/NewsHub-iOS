//
//  LocationLoader.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-20.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation

struct LocationLoader: NewsLoaderProtocol {
	var endPoint: String {
		return "/api/locations"
	}
	
	var completion: (([String]) -> Void)?
	func process(json: NSDictionary, error: NSError?) {
		if error != nil {
			completion?([])
		} else {
			guard let locations = json["locations"] as? [String] else { return }
			completion?(locations)
		}
	}
	
	mutating func loads(completion: ([String]?) -> Void) {
		self.completion = completion
		sendRequest()
	}
}