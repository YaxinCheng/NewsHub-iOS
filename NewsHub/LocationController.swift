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
		loader.loads {[weak self] result in
			guard let locations = result else { return }
			self?.locations = locations
			self?.tableView.reloadData()
		}
	}

	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return locations.count
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
		cell.textLabel?.text = capitalizeFirst(locations[(indexPath as NSIndexPath).row])
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let location = locations[(indexPath as NSIndexPath).row]
		delegate?.pick(location)
		dismiss(animated: true, completion: nil)
	}
}

private func capitalizeFirst(_ string: String) -> String {
	if string.isEmpty { return "" }
	let first = String(string.characters.first!).uppercased()
	return first + String(string.characters.dropFirst())
}
