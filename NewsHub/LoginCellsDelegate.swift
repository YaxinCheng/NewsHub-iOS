//
//  LoginCellsProtocol.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-15.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

protocol LoginCellsDelegate: class {
	func dismiss()
	func present(_ alert: UIAlertController)
	func switchView()
}
