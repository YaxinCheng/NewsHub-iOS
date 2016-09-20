//
//  LogoutService.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-23.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation

struct LogoutService: UserServiceProtocol {
	var endPoint: String {
		return "/logout"
	}
	
	func process(JSON: [String : AnyObject]?, error: Error?) {
		if error != nil {
			completion?(error?.localizedDescription)
		} else {
			do {
				try clearCookies()
			} catch {
				completion?("\(error)")
			}
			completion?(nil)
		}
	}
	
	var completion: ((String?) -> Void)?
	
	mutating func logout(_ completion: @escaping (String?) -> Void) {
		guard let _ = UserManager.sharedManager.currentUser else { return }
		self.completion = completion
		sendRequest(method: .get, with: [:])
	}
	
	func clearCookies() throws {
		let user = UserManager.sharedManager.currentUser
		try user?.deleteFromCache()
		UserManager.sharedManager.userStatus = false
		for eachCookie in HTTPCookieStorage.shared.cookies(for: URL(string: "https://hubnews.herokuapp.com")!) ?? [] {
			HTTPCookieStorage.shared.deleteCookie(eachCookie)
		}
		UserManager.sharedManager.currentUser = nil
	}
}
