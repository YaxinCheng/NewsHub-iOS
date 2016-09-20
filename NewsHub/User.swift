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
		return name.components(separatedBy: " ")[0]
	}
}

extension User: PropertySerializable {	
	var properties: [String: AnyObject] {
		var properties = Dictionary<String, AnyObject>()
		properties["email"] = email as AnyObject?
		properties["name"] = name as AnyObject?
		properties["status"] = status as AnyObject?
		return properties
	}
	
	init(with managedObject: NSManagedObject) {
		self.email = managedObject.value(forKey: "email") as! String
		self.name = managedObject.value(forKey: "name") as! String
		self.status = managedObject.value(forKey: "status") as! Bool
	}
}

extension User: Persistable {
	var primaryKeyAttribute: String {
		return "email"
	}
	
	var primaryKeyValue: AnyObject {
		return email as AnyObject
	}
}
