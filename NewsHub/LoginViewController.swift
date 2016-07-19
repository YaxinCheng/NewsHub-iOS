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
		navigationController?.navigationBarHidden = true
	}
	
}

extension LoginViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 2
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let identifiers = [Common.loginCellIdentifier, Common.registerCellIdentifier]
		guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifiers[indexPath.row], forIndexPath: indexPath) as? LoginCells else { return UICollectionViewCell() }
		cell.delegate = self
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
		return 0
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
	}
}

extension LoginViewController: LoginCellsDelegate {
	func dismiss() {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func present(alert: UIAlertController) {
		self.presentViewController(alert, animated: true, completion: nil)
	}
	
	func switchView() {
		guard let visibleCell = collectionView.visibleCells().first else { return }
		if visibleCell is LoginViewCell {
			collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: 1, inSection: 0), atScrollPosition: .Right, animated: true)
		} else if visibleCell is RegisterViewCell {
			collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Left, animated: true)
		}
	}
}
