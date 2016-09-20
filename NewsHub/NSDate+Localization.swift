//
//  NSDate+Localization.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-24.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation

extension Date {
	func formatDate() -> String {
		let dateFmt = DateFormatter()
		dateFmt.dateFormat = "EEEE, MMMM dd"
		dateFmt.timeZone = TimeZone.autoupdatingCurrent
		return dateFmt.string(from: self)
	}
	
	func localTime() -> String {
		let dateFmt = DateFormatter()
		dateFmt.dateFormat = "yyyy-MM-dd hh:mm:ss"
		let localTimeZone = TimeZone.autoupdatingCurrent
		dateFmt.timeZone = localTimeZone
		return dateFmt.string(from: self)
	}
}
