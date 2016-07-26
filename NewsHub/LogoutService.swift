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
	
	func process(JSON: [String : AnyObject]?, error: NSError?) {
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
	
	mutating func logout(completion: (String?) -> Void) {
		guard let _ = UserManager.sharedManager.currentUser else { return }
		self.completion = completion
		sendRequest(.GET, with: [:])
	}
	
	func clearCookies() throws {
		let user = UserManager.sharedManager.currentUser
		try user?.deleteFromCache()
		UserManager.sharedManager.userStatus = false
		for eachCookie in NSHTTPCookieStorage.sharedHTTPCookieStorage().cookiesForURL(NSURL(string: "https://hubnews.herokuapp.com")!) ?? [] {
			NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(eachCookie)
		}
		UserManager.sharedManager.currentUser = nil
	}
}