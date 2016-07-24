//
//  User.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-15.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation
import CoreData.NSManagedObject

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
	
	static func currentUser() -> User? {
		do {
			return try restoreFromCache().last
		} catch {
			return nil
		}
	}
	
	var firstName: String {
		return name.componentsSeparatedByString(" ")[0]
	}
}

extension User: PropertySerializable {	
	var properties: [String: AnyObject] {
		var properties = Dictionary<String, AnyObject>()
		properties["email"] = email
		properties["name"] = name
		properties["status"] = status
		return properties
	}
	
	init(with managedObject: NSManagedObject) {
		self.email = managedObject.valueForKey("email") as! String
		self.name = managedObject.valueForKey("name") as! String
		self.status = managedObject.valueForKey("status") as! Bool
	}
}

extension User: Persistable {
	var primaryKeyAttribute: String {
		return "email"
	}
	
	var primaryKeyValue: AnyObject {
		return email
	}
}
