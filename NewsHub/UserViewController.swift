//
//  UserViewController.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-14.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		navigationController?.navigationBarHidden = true
		if UserManager.sharedManager.userStatus == false {
			popLoginView()
		}
		tableView.estimatedRowHeight = 100
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		if UserManager.sharedManager.currentUser != nil {
			tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
		}
	}
	
	
	// MARK: - Navigation
//	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//		guard let identifier = segue.identifier else { return }
//		switch identifier {
//		case Common.seguePasswordChangeIdentifier:
//			
//		default:
//			break
//		}
//	}

	
	func popLoginView() {
		parentViewController?.parentViewController?.performSegueWithIdentifier(Common.loginViewIndentifier, sender: nil)
	}
}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			guard let cell = tableView.dequeueReusableCellWithIdentifier(Common.headerIdentifier) as? headerCell else {
				return UITableViewCell()
			}
			if let currentUser = UserManager.sharedManager.currentUser {
				cell.titleLabel.text = "HI " + currentUser.firstName
			} else {
				cell.titleLabel.text = "User"
			}
			return cell
		} else {
			guard let cell = tableView.dequeueReusableCellWithIdentifier(Common.userTypeCellIdentifier) else {
				return UITableViewCell()
			}
			return cell
		}
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		switch indexPath.section {
		case 0:
			return 90
		default:
			return UITableViewAutomaticDimension
		}
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 0 {
			let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
			actionSheet.addAction(segueToChangePassword())
			actionSheet.addAction(logoutAction())
			actionSheet.addAction(.Cancel)
			presentViewController(actionSheet, animated: true, completion: nil)
		}
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
}

private extension UIAlertAction {
	static var Cancel: UIAlertAction {
		return UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
	}
}

private extension UserViewController {
	private func logoutAction() -> UIAlertAction {
		let logout = UIAlertAction(title: "Log Out", style: .Destructive) { [unowned self] _ in
			var logout = LogoutService()
			logout.logout { [unowned self] in
				if let errorInfo = $0 {
					let alert = UIAlertController(title: "Error", message: errorInfo, preferredStyle: .Alert)
					alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
					self.presentViewController(alert, animated: true, completion: nil)
				} else {
					self.popLoginView()
				}
			}
		}
		return logout
	}
	
	private func segueToChangePassword() -> UIAlertAction {
		let segue = UIAlertAction(title: "Change Password", style: .Default) { [unowned self] _ in
			self.performSegueWithIdentifier(Common.seguePasswordChangeIdentifier, sender: nil)
		}
		return segue
	}
}