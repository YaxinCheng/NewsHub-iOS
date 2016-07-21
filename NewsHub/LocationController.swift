//
//  LocationController.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-20.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class LocationController: UITableViewController {
	
	var locations: [String] = []
	weak var delegate: NewsViewDelegate?
	override func viewDidLoad() {
		super.viewDidLoad()
		
		var loader = LocationLoader()
		loader.loads { result in
			guard let locations = result else { return }
			self.locations = locations
			self.tableView.reloadData()
		}
	}

	// MARK: - Table view data source
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return locations.count
	}
	
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
		cell.textLabel?.text = capitalizeFirst(locations[indexPath.row])
		
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let location = locations[indexPath.row]
		delegate?.pick(location)
		dismissViewControllerAnimated(true, completion: nil)
	}
}

private func capitalizeFirst(string: String) -> String {
	if string.isEmpty { return "" }
	let first = String(string.characters.first!).uppercaseString
	return first + String(string.characters.dropFirst())
}