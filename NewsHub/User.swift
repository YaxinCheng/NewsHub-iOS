//
//  User.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-15.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation

struct User {
	let email: String
	var name: String
	var status: Bool
	
	init?(with JSON: [String: AnyObject]) {
		guard
			let email = JSON["_id"] as? String,
			let name = JSON["name"] as? String,
			let status = JSON["status"] as? Bool
			else { return nil }
		
		self.email = email
		self.name = name
		self.status = status
	}
}