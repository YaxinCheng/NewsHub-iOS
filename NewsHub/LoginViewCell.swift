//
//  LoginViewCell.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-15.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class LoginViewCell: LoginCells {
    
	@IBOutlet weak var emailField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	@IBOutlet weak var loginButton: UIButton!
	
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		loginButton.layer.cornerRadius = 17
		loginButton.layer.borderColor = UIColor.blackColor().CGColor
		loginButton.layer.borderWidth = 1
		loginButton.layer.masksToBounds = true
		
		activityIndicator.hidesWhenStopped = true
		activityIndicator.hidden =  true
	}
	
	@IBAction func dismissButtonPressed(sender: AnyObject) {
		delegate?.dismiss()
	}
	
	@IBAction func loginButtonPressed(sender: AnyObject) {
		defer {
			activityIndicator.stopAnimating()
		}
		activityIndicator.startAnimating()
		guard
			let email = emailField.text?.lowercaseString,
			let password = passwordField.text
			else { return }
		var login = LoginManager()
		login.login(email, password: password) { [unowned self] (info) in
			guard let error = info where error != "SUCCESS" else {
				self.delegate?.dismiss()
				return
			}
			let alert = UIAlertController(title: "Fail", message: error, preferredStyle: .Alert)
			alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
			alert.view.tintColor = UIColor.blackColor()
			self.delegate?.present(alert)
		}
	}
}
