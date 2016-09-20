//
//  News.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-04.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation
import UIKit.UIImage

struct News: Hashable, Equatable, TagProtocol {
	var title: String
	var content: String
	let contentLink: String
	let source: NewsSource
	var date: Date?
	var imageLink: String?
	var image: UIImage?
	var tag: String
	fileprivate var imageLoaded = false
	fileprivate static var imageLoader = NewsImageLoader()
	fileprivate var detailsLoaded = false
	fileprivate static var detailsLoader = NewsDetailsLoader()
	
	var hashValue: Int {
		return contentLink.hash
	}
	
	init(with json: NSDictionary) {
		title = json["title"] as! String
		contentLink = json["_id"] as! String
		imageLink = json["img"] as? String
		content = json["content"] as! String
		source = NewsSource(rawValue: json["source"] as! String)!
		tag = json["tag"] as! String
		if let date = json["date"] as? String {
			let dateFmt = DateFormatter()
			dateFmt.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
			self.date = dateFmt.date(from: date)
		}
	}
	
	var hasImage: Bool {
		return imageLink?.isEmpty ?? false
	}
	
	func downloadThumbnail(_ completion: @escaping (_ news: News?) -> Void) {
		if imageLoaded == true {
			completion(self)
		} else {
			let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
			queue.async {
				News.imageLoader.loadThumbnail(from: self) { (image, error) in
					if error != nil {
						DispatchQueue.main.async {
							completion(nil)
						}
					} else {
						var loadedNews = self
						loadedNews.image = image
						loadedNews.imageLoaded = true
						DispatchQueue.main.async {
							completion(loadedNews)
						}
					}
				}
			}
		}
	}
	
	func downloadImage(_ completion: @escaping (_ image: UIImage?) -> Void) {
		News.imageLoader.loadImage(from: self) {
			completion($0)
		}
	}
	
	func downloadDetails(_ completion: @escaping (_ news: News?) -> Void) {
		if detailsLoaded == true {
			completion(self)
		} else {
			let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
			queue.async {
				News.detailsLoader.loadDetails(from: self) { (news, error) in
					if var loadedNews = news {
						loadedNews.detailsLoaded = true
						DispatchQueue.main.async {
							completion(loadedNews)
						}
					} else {
						DispatchQueue.main.async {
							completion(nil)
						}
					}
				}
			}
		}
	}
}

func == (lhs: News, rhs: News) -> Bool {
	return lhs.contentLink == rhs.contentLink && lhs.imageLoaded == rhs.imageLoaded
		&& lhs.image == rhs.image && lhs.content == rhs.content
}
