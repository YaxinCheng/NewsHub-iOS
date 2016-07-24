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
	func sendRequest(method: Alamofire.Method, with parameters: [String: String])
	func process(JSON: [String: AnyObject]?, error: NSError?)
	var completion: ((String?) -> Void)? { set get }
}

extension UserServiceProtocol {
	var api: String {
		return "https://hubnews.herokuapp.com"
	}
	
	func sendRequest(method: Alamofire.Method = .POST, with parameters: [String: String]) {
		let request: Request
		if method == .GET && parameters.isEmpty {
			request = Alamofire.request(method, api + endPoint)
		} else {
			request = Alamofire.request(method, api + endPoint, parameters: parameters, encoding: .JSON)
		}
		request.responseJSON { (response) in
			switch response.result {
			case .Success(let value):
				guard let json = value as? Dictionary<String, AnyObject> else { return }
				self.process(json, error: nil)
			case .Failure(let error):
				self.process(nil, error: error)
			}
		}
	}
}