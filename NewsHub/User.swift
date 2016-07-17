//
//  User.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-17.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit
import CoreData


class User: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
	
	class func initialize(with JSON: Dictionary<String, AnyObject>) throws -> User {
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let context = appDelegate.managedObjectContext
		guard let user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: context) as? User else {
			throw UserError.InitializeError
		}
		user.email = JSON["_id"] as! String
		user.name = JSON["name"] as! String
		appDelegate.saveContext()
		return user
	}
	
	class func currentUser() -> User? {
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let context = appDelegate.managedObjectContext
		
		let fetch = NSFetchRequest(entityName: "User")
		do {
			guard let onlyUser = try context.executeFetchRequest(fetch) as? [User] where onlyUser.count == 1 else {
				return nil
			}
			return onlyUser[0]
		} catch {
			return nil
		}
	}
	
	class func save() {
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		appDelegate.saveContext()
	}
	
	var firstName: String {
		return name.componentsSeparatedByString(" ").first ?? name
	}
}

enum UserError: ErrorType {
	case InitializeError
}