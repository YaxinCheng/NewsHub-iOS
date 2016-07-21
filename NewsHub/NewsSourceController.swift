//
//  NewsSourceController.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-21.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class NewsSourceController: UIViewController {
	
	var source: NewsSource!
	var dataSource: NewsHub!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		dataSource = NewsHub.hub(for: source)
	}
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	
}

extension NewsSourceController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 0
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
}