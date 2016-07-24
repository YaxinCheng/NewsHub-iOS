//
//  NSDate+Localization.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-24.
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