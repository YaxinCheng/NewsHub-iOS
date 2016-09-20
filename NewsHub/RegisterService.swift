//
//  RegisterService.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-15.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation

struct RegisterService: UserServiceProtocol, formatChecker {
	var endPoint: String {
		return "/register"
	}
	var completion: ((String?) -> Void)?
	
	func process(JSON: [String: AnyObject]?, error: Error?) {
		if error != nil {
			completion?(error?.localizedDescription)
		} else if let errorInfo = JSON?["ERROR"] as? String {
			completion?(errorInfo)
		} else if let successInfo = JSON?["SUCCESS"] as? String {
			completion?(successInfo)
		} else {
			completion?("Unkown Error Happened, Please Try Again")
		}
	}
	
	mutating func registerAccount(_ email: String, password: String, userName: String, completion: @escaping (String?)->()) {
		do {
			try checkEmpty(email, fieldInfo: "Email")
			try checkEmpty(password, fieldInfo: "Password")
			try checkEmail(email)
			try checkLength(password, maximum: 30, fieldInfo: "Password")
			try checkLength(userName, maximum: 15, fieldInfo: "UserName")
			try checkLowerCase(password, fieldInfo: "Password")
			try checkUpperCase(password, fieldInfo: "Password")
			try checkNumbers(password, fieldInfo: "Password")
			try checkSpecialCharacter(password, fieldInfo: "Password")
		} catch FormatNotMatchException.isEmpty(errorMessage: let error) {
			completion(error)
			return
		} catch FormatNotMatchException.tooLong(errorMessage: let error) {
			completion(error)
			return
		} catch FormatNotMatchException.wrongFormat(errorMessage: let error) {
			completion(error)
			return
		} catch {
			completion("\(error)")
			return
		}
		self.completion = completion
		let registerTime = Date().localTime()
		sendRequest(with: ["email": email, "password": password, "registerTime": registerTime, "name": userName])
	}
}
