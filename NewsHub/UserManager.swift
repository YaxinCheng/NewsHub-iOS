//
//  UserManager.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-15.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation

struct UserManager {
	static var sharedManager: UserManager = UserManager()
	var currentUser: User?
	var userStatus: Bool
	
	private init() {
		if let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookiesForURL(NSURL(string: "https://hubnews.herokuapp.com")!) where !cookies.isEmpty {
			userStatus = true
		} else {
			userStatus = false
		}
	}
}