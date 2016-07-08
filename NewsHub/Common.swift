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
}

struct Common {
	static let headerIdentifier = "headerCell"
	static let headlinesIdentifier = "headlineCell"
	static let headCollectionCellIdentifier = "headlineContentCell"
	static let sourceIdentifier = "sourceCell"
	static let sourceCollectionCellIdentifier = "sourceContentCell"
}