//
//  NewsLoaderProtocol.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-04.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation
import Alamofire

protocol NewsLoaderProtocol {
	var api: String { get }
	var endPoint: String { get }
	
	func sendRequest(method: HTTPMethod, with parameters: [String: String],from source: NewsSource, at page: Int)
	func process(json: NSDictionary, error: Error?)
}

extension NewsLoaderProtocol {
	var api: String {
		return "https://hubnews.herokuapp.com"
	}
	
	func sendRequest(method: HTTPMethod = .get, with parameters: [String: String] = [:], from source: NewsSource = .all, at page: Int = 1) {
		let request: DataRequest
		if method == .get {
			let url = source == .all ? api + endPoint : api + endPoint + "/" + source.rawValue
			request = Alamofire.request(url, method: method, headers: ["page": "\(page)", "location": Common.location])
		} else {
			request = Alamofire.request(api + endPoint, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: ["page": "\(page)", "location": Common.location])
		}
		request.responseJSON { (response) in
			switch response.result {
			case .success(let result):
				if let json = result as? NSDictionary , json["message"] == nil {
					self.process(json: json, error: nil)
				}
			case .failure(let error):
				self.process(json: [:], error: error)
			}
		}
	}
}

