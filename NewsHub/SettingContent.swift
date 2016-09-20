//
//  SettingContent.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-28.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation

enum SettingContent<Type> {
	case setting(String)
	case news(Type)
}
