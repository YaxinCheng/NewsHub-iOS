//
//  NewsEmitionViewController.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-28.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class NewsEmotionViewController: UIViewController {

	var selectedEmotion: Int?
	override func viewDidLoad() {
			super.viewDidLoad()

			// Do any additional setup after loading the view.
	}
	
	/*
	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
			// Get the new view controller using segue.destinationViewController.
			// Pass the selected object to the new view controller.
	}
	*/
	var touchedPoint: CGPoint! {
		didSet {
			print("touchedPoint: \(touchedPoint.x), \(touchedPoint.y)")
			guard let button = view.hitTest(touchedPoint, withEvent: nil) as? UIButton else { return }
			touchup(button)
		}
	}
	
	@IBAction func touchup(sender: AnyObject) {
		guard let emotion = sender.tag else { return }
		selectedEmotion = emotion
		performSegueWithIdentifier(Common.unwindFromEmotionIdentifier, sender: nil)
	}
	

}
