//
//  NewsViewController.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-07.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
			navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		switch indexPath.row {
		case 0:
			guard let cell = tableView.dequeueReusableCellWithIdentifier(Common.headerIdentifier) as? headerCell else {
				return UITableViewCell()
			}
			cell.dateLabel.text = NSDate().formatDate().uppercaseString
			cell.titleLabel.text = "News"
			return cell
		case 1:
			guard let cell = tableView.dequeueReusableCellWithIdentifier(Common.headlinesIdentifier) as? NewsHeadlineCell else {
				return UITableViewCell()
			}
			return cell
		case 2:
			guard let cell = tableView.dequeueReusableCellWithIdentifier(Common.sourceIdentifier) as? NewsSourceCell else {
				return UITableViewCell()
			}
			return cell
		default:
			return UITableViewCell()
		}
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		switch indexPath.row {
		case 0:
			return 80
		case 1:
			return 300
		case 2:
			return 162
		default:
			return UITableViewAutomaticDimension
		}
	}
}
