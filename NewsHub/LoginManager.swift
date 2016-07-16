//
//  LoginManager.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-15.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation

struct LoginManager: UserSideManager, formatChecker {
	var endPoint: String {
		return "/login"
	}
	
	var completion: ((String?) -> Void)?
	
	func process(JSON: [String : AnyObject]?, error: NSError?) {
		if error != nil {
			completion?(error?.localizedDescription)
		} else if let errorInfo = JSON?["ERROR"] as? String {
			completion?(errorInfo)
		} else if let user = User(with: JSON!) {
			UserManager.sharedManager.currentUser = user
			completion?("SUCCESS")
		} else {
			completion?("Unknown Error Happened, Please Try Again")
		}
	}
	
	mutating func login(email: String, password: String, completion: (String?)->Void) {
		do {
			try checkEmpty(email, fieldInfo: "Email")
			try checkEmpty(password, fieldInfo: "Password")
			try checkLength(password, maximum: 30, fieldInfo: "Password")
		} catch FormatNotMatchException.IsEmpty(errorMessage: let error) {
			completion(error)
			return
		} catch FormatNotMatchException.TooLong(errorMessage: let error) {
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