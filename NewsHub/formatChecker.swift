//
//  formatChecker.swift
//  Fresh Lead
//
//  Created by Yaxin Cheng on 2016-06-24.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import Foundation

protocol formatChecker {
}

extension formatChecker {
	func checkEmpty(anything: String, fieldInfo: String) throws  {
		if anything.isEmpty {
			throw FormatNotMatchException.IsEmpty(errorMessage: fieldInfo + " Can't Be Empty")
		}
	}
	
	func checkLength(anything: String, maximum length: Int, fieldInfo: String) throws  {
		if anything.characters.count > length {
			throw FormatNotMatchException.TooLong(errorMessage: fieldInfo + " Is Too Long")
		}
	}
	
	func checkEmail(email: String) throws  {
		let regexForAccount: Regex = ".+@.+\\..+"
		let spaceDetecting: Regex = ".*\\s.*"
		if spaceDetecting.matches(email) {
			throw FormatNotMatchException.WrongFormat(errorMessage: "Email Can't Contain Spaces")
		}
		if !regexForAccount.matches(email) {
			throw FormatNotMatchException.WrongFormat(errorMessage: "Please Input The Correct Format For The Email")
		}
	}
	
	func checkNumbers(anything: String, fieldInfo: String ) throws  {
		let numberFmt: Regex = ".*[0-9]*.*"
		if !numberFmt.matches(anything) {
			throw FormatNotMatchException.WrongFormat(errorMessage: "\(fieldInfo) Must Contain At Least One Number")
		}
	}
	
	func checkAllNumbers(anything: String, fieldInfo: String ) throws  {
		let numberFmt: Regex = "^[0-9]+$"
		if !numberFmt.matches(anything) {
			throw FormatNotMatchException.WrongFormat(errorMessage: "\(fieldInfo) Must Be All Numbers")
		}
	}
	
	func checkUpperCase(anything: String, fieldInfo: String ) throws  {
		let upperCaseFmt: Regex = ".*[A-Z]+.*"
		if !upperCaseFmt.matches(anything) {
			throw FormatNotMatchException.WrongFormat(errorMessage: fieldInfo + " Must Contain At Least One Capital Letter")
		}
	}
	
	func checkLowerCase(anything: String, fieldInfo: String ) throws  {
		let lowerCaseFmt: Regex = ".*[a-z]+.*"
		if !lowerCaseFmt.matches(anything) {
			throw FormatNotMatchException.WrongFormat(errorMessage: fieldInfo + " Must Contain At Least One Lower Case Letter")
		}
	}
	
	func checkSpecialCharacter(anything: String, fieldInfo: String ) throws  {
		let lowerCaseFmt: Regex = ".*\\W.*"
		if !lowerCaseFmt.matches(anything) {
			throw FormatNotMatchException.WrongFormat(errorMessage: fieldInfo + " Must Contain At Least One Special Character")
		}
	}
}

enum FormatNotMatchException: ErrorType {
	case IsEmpty(errorMessage: String)
	case TooLong(errorMessage: String)
	case WrongFormat(errorMessage: String)
}