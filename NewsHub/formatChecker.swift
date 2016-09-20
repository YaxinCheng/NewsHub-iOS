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
	func checkEmpty(_ anything: String, fieldInfo: String) throws  {
		if anything.isEmpty {
			throw FormatNotMatchException.isEmpty(errorMessage: fieldInfo + " Can't Be Empty")
		}
	}
	
	func checkLength(_ anything: String, maximum length: Int, fieldInfo: String) throws  {
		if anything.characters.count > length {
			throw FormatNotMatchException.tooLong(errorMessage: fieldInfo + " Is Too Long")
		}
	}
	
	func checkEmail(_ email: String) throws  {
		let regexForAccount: Regex = ".+@.+\\..+"
		let spaceDetecting: Regex = ".*\\s.*"
		if spaceDetecting.matches(email) {
			throw FormatNotMatchException.wrongFormat(errorMessage: "Email Can't Contain Spaces")
		}
		if !regexForAccount.matches(email) {
			throw FormatNotMatchException.wrongFormat(errorMessage: "Please Input The Correct Format For The Email")
		}
	}
	
	func checkNumbers(_ anything: String, fieldInfo: String ) throws  {
		let numberFmt: Regex = ".*[0-9]*.*"
		if !numberFmt.matches(anything) {
			throw FormatNotMatchException.wrongFormat(errorMessage: "\(fieldInfo) Must Contain At Least One Number")
		}
	}
	
	func checkAllNumbers(_ anything: String, fieldInfo: String ) throws  {
		let numberFmt: Regex = "^[0-9]+$"
		if !numberFmt.matches(anything) {
			throw FormatNotMatchException.wrongFormat(errorMessage: "\(fieldInfo) Must Be All Numbers")
		}
	}
	
	func checkUpperCase(_ anything: String, fieldInfo: String ) throws  {
		let upperCaseFmt: Regex = ".*[A-Z]+.*"
		if !upperCaseFmt.matches(anything) {
			throw FormatNotMatchException.wrongFormat(errorMessage: fieldInfo + " Must Contain At Least One Capital Letter")
		}
	}
	
	func checkLowerCase(_ anything: String, fieldInfo: String ) throws  {
		let lowerCaseFmt: Regex = ".*[a-z]+.*"
		if !lowerCaseFmt.matches(anything) {
			throw FormatNotMatchException.wrongFormat(errorMessage: fieldInfo + " Must Contain At Least One Lower Case Letter")
		}
	}
	
	func checkSpecialCharacter(_ anything: String, fieldInfo: String ) throws  {
		let lowerCaseFmt: Regex = ".*\\W.*"
		if !lowerCaseFmt.matches(anything) {
			throw FormatNotMatchException.wrongFormat(errorMessage: fieldInfo + " Must Contain At Least One Special Character")
		}
	}
}

enum FormatNotMatchException: Error {
	case isEmpty(errorMessage: String)
	case tooLong(errorMessage: String)
	case wrongFormat(errorMessage: String)
}
