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
}

func SHA256(info: String) -> String? {
	guard let data = info.dataUsingEncoding(NSUTF8StringEncoding) else { return nil }
	var hash = [UInt8](count: Int(CC_SHA256_DIGEST_LENGTH), repeatedValue: 0)
	_ = CC_SHA256(data.bytes, CC_LONG(data.length), &hash)
	return hash.reduce("") {
		$0!.stringByAppendingFormat("%02x", $1)
	}
}