//
//  Common.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-08.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation

extension NSDate {
	func formatDate() -> String {
		let dateFmt = NSDateFormatter()
		dateFmt.dateFormat = "EEEE, MMMM dd"
		dateFmt.timeZone = NSTimeZone.localTimeZone()
		return dateFmt.stringFromDate(self)
	}
	
	func localTime() -> String {
		let dateFmt = NSDateFormatter()
		dateFmt.dateFormat = "yyyy-MM-dd hh:mm:ss"
		let localTimeZone = NSTimeZone.localTimeZone()
		dateFmt.timeZone = localTimeZone
		return dateFmt.stringFromDate(self)
	}
}

struct Common {
	static let headerIdentifier = "headerCell"
	static let headlinesIdentifier = "headlineCell"
	static let headCollectionCellIdentifier = "headlineContentCell"
	static let sourceIdentifier = "sourceCell"
	static let sourceCollectionCellIdentifier = "sourceContentCell"
	static let newsNormalIdentifier = "NewsNormalCell"
	static let newsNoImageIdentifier = "NewsNoImageCell"
	static let segueNewsDetailsIdentifier = "showNewsDetails"
	static let newsRefreshDidFinish = "NewsRefreshDidFinish"
	static let moreHeaderCellIdentifier = "moreHeaderCell"
	static let tagHeaderCellIdentifier = "taggedHeaderCell"
	static let loginViewIndentifier = "showLoginView"
	static let loginCellIdentifier = "loginCell"
	static let registerCellIdentifier = "registerCell"
	static let titleCellIdentifier = "titleCell"
	static let contentCellIdentifier = "contentCell"
	static let userTypeCellIdentifier = "userTypeCell"
	static let popOverIdentifier = "presentLocationPicker"
	static let segueNewsSourceIdentifier = "showNewsSource"
	
	static var location: String {
		get {
			let userDefault = NSUserDefaults.standardUserDefaults()
			return userDefault.stringForKey("preferedLocation") ?? ""
		} set {
			let userDefault = NSUserDefaults.standardUserDefaults()
			userDefault.setObject(newValue, forKey: "preferedLocation")
		}
	}
}
