//
//  NewsList.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-13.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation

struct NewsList {
	private var internalList: [String: [News]]
	private var tags: NSMutableOrderedSet
	
	init() {
		tags = NSMutableOrderedSet()
		internalList = [:]
	}
	
	mutating func append(newValue: News) {
		if tags.containsObject(newValue.tag) {
			internalList[newValue.tag]?.append(newValue)
		} else {
			tags.addObject(newValue.tag)
			internalList[newValue.tag] = [newValue]
		}
	}
	
	var count: Int {
		return tags.count
	}
	
	subscript(index: Int) -> [News] {
		get {
			let tag = tags.objectAtIndex(index) as! String
			return internalList[tag]!
		} set {
			let tag = tags.objectAtIndex(index) as! String
			internalList[tag]! = newValue
		}
	}
	
	mutating func append(list: Array<News>) {
		for eachNews in list {
			append(eachNews)
		}
	}
	
	func tag(for index: Int)	-> String {
		return tags.objectAtIndex(index) as! String
	}
}

func + (lhs: NewsList, rhs: Array<News>) -> NewsList {
	var newList = lhs
	newList.append(rhs)
	return newList
}

func += (inout lhs: NewsList, rhs: Array<News>) {
	lhs.append(rhs)
}