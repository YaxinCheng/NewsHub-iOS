//
//  NewsViewDelegate.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-19.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation

protocol NewsViewDelegate: class {
	func showContentView(at index: Int)
	func showCategoryView(at index: Int)
	func pick(location: String)
}