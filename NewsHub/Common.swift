//
//  Common.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-08.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation

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
	static let segueNewsDeatailsFromSourceIdentifier = "segueToNewsFromSource"
	static let textFieldCellIdentifier = "textFieldCell"
	static let seguePasswordChangeIdentifier = "segueToPasswordChange"
	static let segueUserViewIdentifier = "segueToUesrView"
	static let segueSettingViewIdentifier = "showSetting"
	static let segueEmitionViewIdentifier = "showEmotionView"
	
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
