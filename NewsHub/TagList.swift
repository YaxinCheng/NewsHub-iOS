//
//  NewsList.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-13.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation

struct TagList<Element: TagProtocol> {
	fileprivate var internalList: [String: [Element]]
	fileprivate var tags: NSMutableOrderedSet
	
	init() {
		tags = NSMutableOrderedSet()
		internalList = [:]
	}
	
	mutating func append(_ newValue: Element) {
		if tags.contains(newValue.tag) {
			internalList[newValue.tag]?.append(newValue)
		} else {
			tags.add(newValue.tag)
			internalList[newValue.tag] = [newValue]
		}
	}
	
	var count: Int {
		return tags.count
	}
	
	subscript(index: Int) -> [Element] {
		get {
			let tag = tags.object(at: index) as! String
			return internalList[tag]!
		} set {
			let tag = tags.object(at: index) as! String
			internalList[tag]! = newValue
		}
	}
	
	mutating func append(contentOf list: Array<Element>) {
		for eachNews in list {
			append(eachNews)
		}
	}
	
	func tag(for index: Int)	-> String {
		return tags.object(at: index) as! String
	}
}

func + (lhs: TagList<News>, rhs: Array<News>) -> TagList<News> {
	var newList = lhs
	newList.append(contentOf: rhs)
	return newList
}

func += (lhs: inout TagList<News>, rhs: Array<News>) {
	lhs.append(contentOf: rhs)
}
