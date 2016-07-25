//
//  PasswordChangeController.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-25.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class PasswordChangeController: UIViewController {
	
	@IBOutlet weak var oldField: UITextField!
	@IBOutlet weak var newField: UITextField!
	@IBOutlet weak var confirmButton: UIButton!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		confirmButton.layer.cornerRadius = 17
		confirmButton.layer.masksToBounds = true
		confirmButton.layer.borderColor = view.tintColor.CGColor
		confirmButton.layer.borderWidth = 1
		
		activityIndicator.hidesWhenStopped = true
		activityIndicator.hidden = true
	}

	@IBAction func touchToDismissKeyboard(sender: AnyObject) {
		view.endEditing(true)
	}
	
	@IBAction func confirmButtonPressed(sender: AnyObject) {
		defer {
			activityIndicator.stopAnimating()
		}
		activityIndicator.hidden = false
		activityIndicator.startAnimating()
		guard
			let old = oldField.text,
			let new = newField.text
		else { return }
		var service = ChangePasswordService()
		service.changePassword(old, new: new) { [weak self] in
			guard let errorInfo = $0 else {
				let alert = UIAlertController(title: nil, message: "Password Changed Successfully, you will have to re-login", preferredStyle: .Alert)
				let dismissAction = UIAlertAction(title: "OK", style: .Cancel) { [weak self] _ in
					self?.dismissViewControllerAnimated(true, completion: nil)
				}
				alert.addAction(dismissAction)
				self?.presentViewController(alert, animated: true, completion: nil)
				return
			}
			let alert = UIAlertController(title: "Error", message: errorInfo, preferredStyle: .Alert)
			alert.addAction(.Cancel)
			self?.presentViewController(alert, animated: true, completion: nil)
		}
	}
	
	@IBAction func cancelButtonPressed(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
}

extension PasswordChangeController: UITextFieldDelegate {
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		if textField === oldField {
			newField.becomeFirstResponder()
		} else {
			confirmButtonPressed(textField)
		}
		return true
	}
	
}
