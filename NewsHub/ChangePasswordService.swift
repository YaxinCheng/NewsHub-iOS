//
//  ChangePasswordService.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-25.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation

struct ChangePasswordService: UserServiceProtocol, formatChecker {
	var endPoint: String {
		return "/uManage/password"
	}
	
	func process(JSON: [String : AnyObject]?, error: Error?) {
		if error != nil {
			completion?(error?.localizedDescription)
		} else if let errorInfo = JSON?["ERROR"] as? String {
			completion?(errorInfo)
		} else if let _ = JSON?["SUCCESS"] as? String {
			let logout = LogoutService()
			do {
				try logout.clearCookies()
			} catch {
				completion?("\(error)")
			}
			completion?(nil)
		} else {
			completion?("Unknown Error Happened")
		}
	}
	
	var completion: ((String?) -> Void)?
	
	mutating func changePassword(_ old: String, new: String, completion: @escaping (String?) -> Void) {
		guard UserManager.sharedManager.userStatus else {
			completion("User is offline")
			return
		}
		do {
			try checkEmpty(old, fieldInfo: "Old Password")
			try checkEmpty(new, fieldInfo: "New Password")
			try checkLength(new, maximum: 30, fieldInfo: "New Password")
			try checkLowerCase(new, fieldInfo: "New Password")
			try checkUpperCase(new, fieldInfo: "New Passowrd")
			try checkNumbers(new, fieldInfo: "New Passowrd")
			try checkSpecialCharacter(new, fieldInfo: "New Passowrd")
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
			completion("Unknown Error Happened")
			return
		}
		self.completion = completion
		let time = Date().localTime()
		sendRequest(with: ["password": old, "newpassword": new, "time": time])
	}
}
