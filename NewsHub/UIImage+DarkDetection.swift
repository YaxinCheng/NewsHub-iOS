//
//  UIImage+DarkDetection.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-28.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit.UIImage

extension UIImage {
	var isDark: Bool {
		let imageData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage))
		let pixels = CFDataGetBytePtr(imageData)
		var darkPixels = 0
		let length = CFDataGetLength(imageData)
		let threshold = self.size.width * self.size.height * 0.45
		for index in 0.stride(to: length, by: 4) {
			let r = Double(pixels[index])
			let g = Double(pixels[index + 1])
			let b = Double(pixels[index + 2])
			
			let luminance = (0.299 * r + 0.587 * g + 0.114 * b)
			if luminance < 150 {
				darkPixels += 1
			}
		}
		return CGFloat(darkPixels) >= threshold
	}
}
