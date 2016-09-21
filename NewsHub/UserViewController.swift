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
		navigationController?.isNavigationBarHidden = true
		tableView.estimatedRowHeight = 100
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if UserManager.sharedManager.userStatus == false {
			popLoginView()
		}
		
		tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
	}
	
	func popLoginView() {
		parent?.parent?.performSegue(withIdentifier: Common.loginViewIndentifier, sender: nil)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let identifier = segue.identifier else {
			return
		}
		if identifier == Common.segueSettingViewIdentifier {
			let destinationVC = segue.destination as! SettingViewController
			destinationVC.viewTitle = "Liked"
		}
	}
}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return section == 0 ? 1 : 3
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if (indexPath as NSIndexPath).section == 0 {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: Common.headerIdentifier) as? headerCell else {
				return UITableViewCell()
			}
			if let currentUser = UserManager.sharedManager.currentUser {
				cell.titleLabel.text = "HI " + currentUser.firstName
			} else {
				cell.titleLabel.text = "User"
			}
			return cell
		} else {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: Common.userTypeCellIdentifier) as? UserSettingCell else {
				return UITableViewCell()
			}
			let images = ["heart", "gear", "about"]
			let texts = ["Liked", "Setting", "About"]
			cell.iconImageView.image = UIImage(named: images[(indexPath as NSIndexPath).row])
			cell.settingLabel.text = texts[(indexPath as NSIndexPath).row]
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch (indexPath as NSIndexPath).section {
		case 0:
			return 120
		default:
			return UITableViewAutomaticDimension
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if (indexPath as NSIndexPath).section == 0 {
			let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
			actionSheet.addAction(changePasswordAction())
			actionSheet.addAction(logoutAction())
			actionSheet.addAction(.cancel)
			present(actionSheet, animated: true, completion: nil)
		} else if (indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 0 {
			performSegue(withIdentifier: Common.segueSettingViewIdentifier, sender: nil)
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

private extension UserViewController {
	func logoutAction() -> UIAlertAction {
		let logout = UIAlertAction(title: "Log Out", style: .destructive) { [weak self] _ in
			var logout = LogoutService()
			logout.logout { [weak self] in
				if let errorInfo = $0 {
					let alert = UIAlertController(title: "Error", message: errorInfo, preferredStyle: .alert)
					alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
					self?.present(alert, animated: true, completion: nil)
				} else {
					self?.popLoginView()
				}
			}
		}
		return logout
	}
	
	func changePasswordAction() -> UIAlertAction {
		let segue = UIAlertAction(title: "Change Password", style: .default) { [weak self] _ in
			self?.performSegue(withIdentifier: Common.seguePasswordChangeIdentifier, sender: nil)
		}
		return segue
	}
}
