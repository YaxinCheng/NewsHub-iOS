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
		swipeGesture.direction = .down
		self.addGestureRecognizer(swipeGesture)
	}
	
	@IBAction func dismissButtonPressed(_ sender: AnyObject) {
		delegate?.dismiss()
	}
	
	@IBAction func loginButtonPressed(_ sender: AnyObject) {
		defer {
			activityIndicator.stopAnimating()
		}
		activityIndicator.isHidden = false
		activityIndicator.startAnimating()
		guard
			let email = emailField.text?.lowercased(),
			let password = passwordField.text
			else { return }
		var login = LoginService()
		login.login(email: email, password: password) { [weak self] (info) in
			guard let error = info , error != "SUCCESS" else {
				self?.delegate?.dismiss()
				return
			}
			let alert = UIAlertController(title: "Fail", message: error, preferredStyle: .alert)
			alert.addAction(.cancel)
			alert.view.tintColor = self?.tintColor
			self?.delegate?.present(alert)
		}
	}
	
	@IBAction func registerButtonPressed(_ sender: AnyObject) {
		delegate?.switchView()
	}
	
	func viewDidSwipeDown(_ gesture: UISwipeGestureRecognizer) {
		guard gesture.direction == .down else { return }
		delegate?.dismiss()
	}
}

extension LoginViewCell: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField === emailField {
			passwordField.becomeFirstResponder()
		} else {
			textField.resignFirstResponder()
			loginButtonPressed(textField)
		}
		return true
	}
}
