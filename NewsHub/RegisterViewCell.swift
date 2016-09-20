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
	
	@IBOutlet weak var emailIndicator: UIImageView!
	@IBOutlet weak var passwordIndicator: UIImageView!
	@IBOutlet weak var userNameIndicator: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		emailIndicator.layer.opacity = 0
		passwordIndicator.layer.opacity = 0
		userNameIndicator.layer.opacity = 0
	}
	
	@IBAction func registerButtonPressed(_ sender: AnyObject) {
		activityIndicator.isHidden = false
		activityIndicator.startAnimating()
		guard
			let email = emailField.text?.lowercased(),
			let password = passwordField.text,
			let userName = userNameField.text
		else { return }
		var register = RegisterService()
		register.registerAccount(email, password: password, userName: userName) { [weak self] (info) in
			defer {
				self?.activityIndicator.stopAnimating()
			}
			guard let error = info , error != "Register Successfully"	else {
				UIView.animate(withDuration: 0.2, animations: { [weak self] in
					self?.emailIndicator.layer.opacity = 1
					self?.passwordIndicator.layer.opacity = 1
					self?.userNameIndicator.layer.opacity = 1
				}) 
				return
			}
			let alert = UIAlertController(title: "Warning", message: error, preferredStyle: .alert)
			alert.addAction(.Cancel)
			alert.view.tintColor = self?.tintColor
			self?.delegate?.present(alert)
		}
	}
}

extension RegisterViewCell: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField === emailField {
			passwordField.becomeFirstResponder()
		} else if textField === passwordField {
			userNameField.becomeFirstResponder()
		} else {
			textField.resignFirstResponder()
			registerButtonPressed(textField)
		}
		return true
	}
}
