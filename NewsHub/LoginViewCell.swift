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
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(viewDidSwipeDown))
		swipeGesture.delaysTouchesBegan = false
		swipeGesture.cancelsTouchesInView	= false
		swipeGesture.direction = .Down
		self.addGestureRecognizer(swipeGesture)
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
		var login = LoginService()
		login.login(email, password: password) { [unowned self] (info) in
			guard let error = info where error != "SUCCESS" else {
				self.delegate?.dismiss()
				return
			}
			let alert = UIAlertController(title: "Fail", message: error, preferredStyle: .Alert)
			alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
			alert.view.tintColor = self.tintColor
			self.delegate?.present(alert)
		}
	}
	
	@IBAction func registerButtonPressed(sender: AnyObject) {
		delegate?.switchView()
	}
	
	func viewDidSwipeDown(gesture: UISwipeGestureRecognizer) {
		guard gesture.direction == .Down else { return }
		delegate?.dismiss()
	}
}

extension LoginViewCell: UITextFieldDelegate {
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		if textField === emailField {
			passwordField.becomeFirstResponder()
		} else {
			textField.resignFirstResponder()
			loginButtonPressed(textField)
		}
		return true
	}
}