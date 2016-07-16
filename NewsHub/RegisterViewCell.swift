//
//  RegisterCell.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-15.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class RegisterViewCell: LoginCells {
	@IBOutlet weak var emailField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	@IBOutlet weak var userNameField: UITextField!
	
	@IBOutlet weak var confirmButton: UIButton!
	
	@IBOutlet weak var emailIndicator: UIImageView!
	@IBOutlet weak var passwordIndicator: UIImageView!
	@IBOutlet weak var userNameIndicator: UIImageView!
	
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		confirmButton.layer.borderWidth = 1
		confirmButton.layer.borderColor = UIColor.blackColor().CGColor
		confirmButton.layer.cornerRadius = 17
		confirmButton.layer.masksToBounds	= true
		
		emailIndicator.layer.opacity = 0
		passwordIndicator.layer.opacity = 0
		userNameIndicator.layer.opacity = 0
		
		activityIndicator.hidesWhenStopped = true
		activityIndicator.hidden = true
	}
	
	@IBAction func registerButtonPressed(sender: AnyObject) {
		activityIndicator.hidden = false
		activityIndicator.startAnimating()
		guard
			let email = emailField.text?.lowercaseString,
			let password = passwordField.text,
			let userName = userNameField.text
		else { return }
		var register = RegisterManager()
		register.registerAccount(email, password: password, userName: userName) { [unowned self] (info) in
			defer {
				self.activityIndicator.stopAnimating()
			}
			guard let error = info where error != "Register Successfully"	else {
				UIView.animateWithDuration(0.2) { [unowned self] in
					self.emailIndicator.layer.opacity = 1
					self.passwordIndicator.layer.opacity = 1
					self.userNameIndicator.layer.opacity = 1
				}
				return
			}
			let alert = UIAlertController(title: "Warning", message: error, preferredStyle: .Alert)
			alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
			alert.view.tintColor = UIColor.blackColor()
			self.delegate?.present(alert)
		}
	}
}
