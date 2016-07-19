//
//  NewsLoader.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-04.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation
import Alamofire

protocol NewsLoader {
	var api: String { get }
	var endPoint: String { get }
	
	func sendRequest(method: Alamofire.Method, with parameters: [String: String],from source: NewsSource, at page: Int)
	func process(json: NSDictionary, error: NSError?)
}

extension NewsLoader {
	var api: String {
		return "https://hubnews.herokuapp.com"
	}
	
	func sendRequest(method: Alamofire.Method = .GET, with parameters: [String: String] = [:], from source: NewsSource = .All, at page: Int = 1) {
		let request: Request
		if method == .GET {
			request = Alamofire.request(method, api + endPoint + source.rawValue, headers: ["page": "\(page)"])
		} else {
			request = Alamofire.request(method, api + endPoint, parameters: parameters, encoding: .JSON, headers: ["page": "\(page)"])
		}
		request.responseJSON { (response) in
			switch response.result {
			case .Success(let result):
				if let json = result as? NSDictionary {
					self.process(json, error: nil)
				}
			case .Failure(let error):
				self.process([:], error: error)
			}
		}
	}
}

