//
//  NewsContentViewController.swift
//  NewsHub
//
//  Created by Yaxin Cheng on 2016-07-14.
//  Copyright © 2016 Yaxin Cheng. All rights reserved.
//

import UIKit

class NewsContentViewController: UIViewController {
	
	var dataSource: News!
	@IBOutlet weak var tableView: UITableView!
	fileprivate var imageLoaded: Bool = false
	fileprivate var backgroundImage: UIView!
	@IBOutlet weak var topConstraint: NSLayoutConstraint!
	fileprivate var originalShadow: UIImage?
	fileprivate var imageView: UIImageView?
	fileprivate var originalBackground: UIImage?
	fileprivate var originalColour: UIColor?
	fileprivate var heartButton: UIBarButtonItem!
	
	fileprivate weak var emotionVC: NewsEmotionViewController?
	fileprivate var reactedEmotion: emotion? {
		didSet {
			guard let button = heartButton else { return }
			if reactedEmotion == nil {
				(button.customView as! UIButton).setImage(UIImage(named: "hearticon")?.withRenderingMode(.alwaysTemplate), for: UIControlState())
			} else {
				(button.customView as! UIButton).setImage(reactedEmotion?.image, for: UIControlState())
			}
		}
	}
	fileprivate var viewStyle: NewsBarStyle = .light {
		didSet {
			navigationController?.navigationBar.tintColor = viewStyle.barColour
			navigationController?.navigationBar.barStyle = viewStyle.barStyle
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		originalShadow = self.navigationController?.navigationBar.shadowImage
		originalColour = self.navigationController?.view.backgroundColor
		originalBackground = self.navigationController?.navigationBar.backgroundImage(for: .default)
		
		// Create and initialize the navigation bar background view
		backgroundImage = { [unowned self] in
			let view = UIView()
			let height: CGFloat = self.view.traitCollection.verticalSizeClass == .compact ? 32 : 64
			view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height)
			view.backgroundColor = .white
			view.layer.opacity = 0
			return view
		}()
		view.addSubview(backgroundImage)
		
		navigationController?.navigationBar.backItem?.title = ""
		tableView.rowHeight = UITableViewAutomaticDimension
		
		var likeService = NewsLikeService()
		likeService.checkReact(dataSource) { [weak self] (result) in
			self?.reactedEmotion = result
		}
		
		heartButton = {
			let button = UIButton(type: .custom)
			button.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
			button.titleLabel?.text = ""
			button.setImage(UIImage(named: "hearticon")?.withRenderingMode(.alwaysTemplate), for: UIControlState())
			button.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
			return UIBarButtonItem(customView: button)
		}()
		navigationItem.rightBarButtonItem = heartButton
		
		let gesture: UILongPressGestureRecognizer = {
			let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(heartButtonLongPressed))
			longPressGesture.cancelsTouchesInView = false
			longPressGesture.delaysTouchesBegan = true
			return longPressGesture
		}()
		heartButton.customView?.addGestureRecognizer(gesture)
		
		let centre = NotificationCenter.default
		centre.addObserver(self, selector: #selector(orientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		navigationController?.navigationBar.shadowImage = originalShadow
		navigationController?.navigationBar.setBackgroundImage(originalBackground, for: .default)
		navigationController?.view.backgroundColor = originalColour
		navigationController?.navigationBar.tintColor = .black
		
		navigationItem.rightBarButtonItem = nil
		
		var likesService = NewsLikeService()
		likesService.react(dataSource, Emotion: reactedEmotion)
	}
	
	func orientationDidChange(_ notification: Notification) {
		let height: CGFloat = UIDeviceOrientationIsLandscape(UIDevice.current.orientation) && self.view.traitCollection.verticalSizeClass == .compact ? 32: 64
		backgroundImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height)
		setImageView()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationController?.navigationBar.shadowImage = UIImage()
		navigationController?.view.backgroundColor = UIColor.clear
		navigationController?.isNavigationBarHidden = false
		
		viewStyle = .light
		
		dataSource.downloadDetails { [weak self] (news) in
			defer {
				self?.tableView.reloadData()
				self?.loadNewsImage()
			}
			if let loadedNews = news {
				self?.dataSource = loadedNews
			} else {
				let alert = UIAlertController(title: "Error", message: "News failed loading", preferredStyle: .alert)
				let action = UIAlertAction(title: "OK", style: .cancel) { [weak self] _ in
					_ = self?.navigationController?.popToRootViewController(animated: true)
				}
				alert.addAction(action)
				alert.view.tintColor = self?.view.tintColor
				self?.present(alert, animated: true, completion: nil)
			}
		}
	}

	fileprivate func loadNewsImage() {
		guard imageLoaded == false else { return }
		dataSource.downloadImage { [weak self] in
			guard let image = $0 else { return }
			self?.viewStyle = image.isDark ? .dark : .light
			self?.imageView = UIImageView(image: image)
			self?.imageView!.contentMode = .scaleToFill
			self?.imageLoaded = true
			self?.setImageView()
		}
	}
	
	fileprivate func setImageView() {
		guard imageLoaded == true else { return }
		
		self.topConstraint.constant = -130
		self.imageView!.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width + 5, height: 200)
		let headerView = UIView()
		headerView.backgroundColor = .white
		headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width + 5, height: 220)
		headerView.addSubview(self.imageView!)
		
		self.tableView.tableHeaderView = headerView
	}
	
	func likeButtonPressed(_ sender: UIBarButtonItem) {
		reactedEmotion = reactedEmotion == nil ? .liked : nil
	}
	
	func heartButtonLongPressed(_ gesture: UILongPressGestureRecognizer) {
		switch gesture.state {
		case .began:
			performSegue(withIdentifier: Common.segueEmitionViewIdentifier, sender: nil)
		case .changed, .ended:
			let touchPoint = gesture.location(in: emotionVC?.view)
			emotionVC?.touched = (touchPoint, gesture.state)
		default:
			break
		}
	}
	
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let identifier = segue.identifier else { return }
		if identifier == Common.segueEmitionViewIdentifier {
			let destinationVC = segue.destination as! NewsEmotionViewController
			emotionVC = destinationVC
			destinationVC.modalPresentationStyle = .popover
			destinationVC.popoverPresentationController?.barButtonItem = heartButton
			destinationVC.popoverPresentationController?.delegate = self
		}
	}
	
	@IBAction func backFromEmotion(_ segue: UIStoryboardSegue) {
		let sourceVC = segue.source as! NewsEmotionViewController
		guard let emotion = sourceVC.selectedEmotion else { return }
		reactedEmotion = emotion
	}
}

extension NewsContentViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let identifier = (indexPath as NSIndexPath).section == 0 ? Common.titleCellIdentifier : Common.contentCellIdentifier
		let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
		if (indexPath as NSIndexPath).section == 0 {
			(cell as! titleCell).titleLabel.text = dataSource.title
		} else {
			(cell as! contentCell).contentTextView.text = dataSource.content
			if imageLoaded == true {
				(cell as! contentCell).activityIndicator.stopAnimating()
			}
		}
		return cell!
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		if (indexPath as NSIndexPath).section == 0 {
			return 75
		} else {
			return 170
		}
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let alpha = Float(scrollView.contentOffset.y / 50)
		if alpha >= 1 {
			navigationController?.navigationBar.barStyle = .default
			navigationController?.navigationBar.tintColor = .black
			navigationItem.title = dataSource.title
			backgroundImage.layer.opacity = 1
			navigationController?.navigationBar.shadowImage = originalShadow
		} else if alpha > 0 {
			backgroundImage.layer.opacity = alpha
			if alpha > 0.5 {
				navigationController?.navigationBar.barStyle = viewStyle.barStyle
				navigationController?.navigationBar.tintColor = viewStyle.barColour
			}
		} else {
			navigationItem.title = ""
			backgroundImage.layer.opacity = 0
			navigationController?.navigationBar.shadowImage = UIImage()
		}
	}
}

extension NewsContentViewController: UIPopoverPresentationControllerDelegate {
	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return .none
	}
}
