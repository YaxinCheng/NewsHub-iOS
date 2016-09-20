//
//  LoginService.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-15.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation

struct LoginService: UserServiceProtocol, formatChecker {
	var endPoint: String {
		return "/login"
	}
	
	var completion: ((String?) -> Void)?
	
	func process(JSON: [String : AnyObject]?, error: Error?) {
		if error != nil {
			completion?(error?.localizedDescription)
		} else if let errorInfo = JSON?["ERROR"] as? String {
			completion?(errorInfo)
		} else if let user = User(with: JSON!) {
			UserManager.sharedManager.userStatus = true
			UserManager.sharedManager.currentUser = user
			try! user.saveToCache()
			completion?("SUCCESS")
		} else {
			completion?("Unknown Error Happened, Please Try Again")
		}
	}
	
	mutating func login(_ email: String, password: String, completion: @escaping (String?)->Void) {
		do {
			try checkEmpty(email, fieldInfo: "Email")
			try checkEmpty(password, fieldInfo: "Password")
			try checkLength(password, maximum: 30, fieldInfo: "Password")
		} catch FormatNotMatchException.isEmpty(errorMessage: let error) {
			completion(error)
			return
		} catch FormatNotMatchException.tooLong(errorMessage: let error) {
			completion(error)
			return
		} catch {
			completion("\(error)")
			return
		}
		self.completion = completion
		sendRequest(with: ["email": email, "password": password])
	}
	
	
}
