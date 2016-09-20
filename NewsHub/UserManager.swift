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
	
	fileprivate init() {
		if let cookies = HTTPCookieStorage.shared.cookies(for: URL(string: "https://hubnews.herokuapp.com")!) , !cookies.isEmpty {
			userStatus = true
			currentUser = User.currentUser()
		} else {
			userStatus = false
			currentUser = nil
		}
	}
}
