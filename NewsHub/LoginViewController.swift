//
//  LoginViewController.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-15.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
	
	@IBOutlet weak var collectionView: UICollectionView!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		navigationController?.isNavigationBarHidden = true
	}
	
}

extension LoginViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 2
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let identifiers = [Common.loginCellIdentifier, Common.registerCellIdentifier]
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifiers[(indexPath as NSIndexPath).row], for: indexPath) as? LoginCells else { return UICollectionViewCell() }
		cell.delegate = self
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = UI_USER_INTERFACE_IDIOM() == .pad ? collectionView.bounds.width / 2 : collectionView.bounds.width
		return CGSize(width: width, height: collectionView.bounds.height)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
	}
}

extension LoginViewController: LoginCellsDelegate {
	func dismiss() {
		self.dismiss(animated: true, completion: nil)
	}
	
	func present(_ alert: UIAlertController) {
		self.present(alert, animated: true, completion: nil)
	}
	
	func switchView() {
		guard let visibleCell = collectionView.visibleCells.first else { return }
		if visibleCell is LoginViewCell {
			collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .right, animated: true)
		} else if visibleCell is RegisterViewCell {
			collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
		}
	}
}
