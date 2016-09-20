//
//  UserServiceProtocol.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-15.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation
import Alamofire

protocol UserServiceProtocol {
	var api: String { get }
	var endPoint: String { get }
	func sendRequest(method: HTTPMethod, with parameters: [String: String])
	func process(JSON: [String: AnyObject]?, error: Error?)
	var completion: ((String?) -> Void)? { set get }
}

extension UserServiceProtocol {
	var api: String {
		return "https://hubnews.herokuapp.com"
	}
	
	func sendRequest(method: HTTPMethod = .post, with parameters: [String: String]) {
		let request: DataRequest
		if method == .get && parameters.isEmpty {
			request = Alamofire.request(api + endPoint, method: method)
		} else {
			request = Alamofire.request(api + endPoint, method: method, parameters: parameters, encoding: JSONEncoding.default)
		}
		request.responseJSON { (response) in
			switch response.result {
			case .success(let value):
				guard let json = value as? Dictionary<String, AnyObject> else { return }
				self.process(JSON: json, error: nil)
			case .failure(let error):
				self.process(JSON: nil, error: error)
			}
		}
	}
}
