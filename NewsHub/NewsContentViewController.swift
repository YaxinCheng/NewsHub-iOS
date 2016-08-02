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
	private var imageLoaded: Bool = false
	private var backgroundImage: UIView!
	@IBOutlet weak var topConstraint: NSLayoutConstraint!
	private var originalShadow: UIImage?
	private var imageView: UIImageView?
	private var originalBackground: UIImage?
	private var originalColour: UIColor?
	private var heartButton: UIBarButtonItem!
	
	private weak var emotionVC: NewsEmotionViewController?
	
	private var liked: Bool = false {
		didSet {
			guard let button = heartButton else { return }
			let tag = liked ? 1 : 0
			let image = liked ? UIImage(named: "hearticon-highlight")?.imageWithRenderingMode(.AlwaysTemplate) : UIImage(named: "hearticon")?.imageWithRenderingMode(.AlwaysTemplate)
			button.tag = tag
			(button.customView as! UIButton).setImage(image, forState: .Normal)
		}
	}
	private var viewStyle: NewsBarStyle = .Light {
		didSet {
			navigationController?.navigationBar.tintColor = viewStyle.barColour
			navigationController?.navigationBar.barStyle = viewStyle.barStyle
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		originalShadow = self.navigationController?.navigationBar.shadowImage
		originalColour = self.navigationController?.view.backgroundColor
		originalBackground = self.navigationController?.navigationBar.backgroundImageForBarMetrics(.Default)
		
		// Create and initialize the navigation bar background view
		backgroundImage = { [unowned self] in
			let view = UIView()
			let height: CGFloat = self.view.traitCollection.verticalSizeClass == .Compact ? 32 : 64
			view.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: height)
			view.backgroundColor = .whiteColor()
			view.layer.opacity = 0
			return view
		}()
		view.addSubview(backgroundImage)
		
		navigationController?.navigationBar.backItem?.title = ""
		tableView.rowHeight = UITableViewAutomaticDimension
		
		var likeService = NewsLikeService()
		likeService.checkLike(dataSource) { [weak self] (result) in
			self?.liked = result
		}
		
		heartButton = {
			let button = UIButton(type: .Custom)
			button.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
			button.titleLabel?.text = ""
			button.setImage(UIImage(named: "hearticon")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
			button.addTarget(self, action: #selector(likeButtonPressed), forControlEvents: .TouchUpInside)
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
		
		let centre = NSNotificationCenter.defaultCenter()
		centre.addObserver(self, selector: #selector(orientationDidChange), name: UIDeviceOrientationDidChangeNotification, object: nil)
	}
	
	override func viewWillDisappear(animated: Bool) {
		navigationController?.navigationBar.shadowImage = originalShadow
		navigationController?.navigationBar.setBackgroundImage(originalBackground, forBarMetrics: .Default)
		navigationController?.view.backgroundColor = originalColour
		navigationController?.navigationBar.tintColor = .blackColor()
		
		navigationItem.rightBarButtonItem = nil
		
		var likesService = NewsLikeService()
		likesService.react(dataSource) { [weak self] in
			guard let info = $0 else { return }
			let alert = UIAlertController(title: nil, message: info, preferredStyle: .Alert)
			let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { _ in
				self?.liked = !(self?.liked ?? false)
			}
			alert.addAction(cancel)
			self?.presentViewController(alert, animated: true, completion: nil)
		}
	}
	
	func orientationDidChange(notification: NSNotification) {
		let height: CGFloat = UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation) && self.view.traitCollection.verticalSizeClass == .Compact ? 32: 64
		backgroundImage.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: height)
		setImageView()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
		navigationController?.navigationBar.shadowImage = UIImage()
		navigationController?.view.backgroundColor = UIColor.clearColor()
		navigationController?.navigationBarHidden = false
		
		viewStyle = .Light
		
		dataSource.downloadDetails { [weak self] (news) in
			defer {
				self?.tableView.reloadData()
				self?.loadNewsImage()
			}
			if let loadedNews = news {
				self?.dataSource = loadedNews
			} else {
				let alert = UIAlertController(title: "Error", message: "News failed loading", preferredStyle: .Alert)
				let action = UIAlertAction(title: "OK", style: .Cancel) { [weak self] _ in
					self?.navigationController?.popToRootViewControllerAnimated(true)
				}
				alert.addAction(action)
				alert.view.tintColor = self?.view.tintColor
				self?.presentViewController(alert, animated: true, completion: nil)
			}
		}
	}

	private func loadNewsImage() {
		guard imageLoaded == false else { return }
		dataSource.downloadImage { [weak self] in
			guard let image = $0 else { return }
			self?.viewStyle = image.isDark ? .Dark : .Light
			self?.imageView = UIImageView(image: image)
			self?.imageView!.contentMode = .ScaleToFill
			self?.imageLoaded = true
			self?.setImageView()
		}
	}
	
	private func setImageView() {
		guard imageLoaded == true else { return }
		
		self.topConstraint.constant = -130
		self.imageView!.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width + 5, height: 200)
		let headerView = UIView()
		headerView.backgroundColor = .whiteColor()
		headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width + 5, height: 220)
		headerView.addSubview(self.imageView!)
		
		self.tableView.tableHeaderView = headerView
	}
	
	func likeButtonPressed(sender: UIBarButtonItem) {
		self.liked = !self.liked
	}
	
	func heartButtonLongPressed(gesture: UILongPressGestureRecognizer) {
		switch gesture.state {
		case .Began:
			performSegueWithIdentifier(Common.segueEmitionViewIdentifier, sender: nil)
		case .Ended:
			let touchPoint = gesture.locationInView(emotionVC?.view)
			emotionVC?.touchedPoint = touchPoint
			emotionVC?.dismissViewControllerAnimated(true, completion: nil)
		default:
			break
		}
	}
	
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		guard let identifier = segue.identifier else { return }
		if identifier == Common.segueEmitionViewIdentifier {
			let destinationVC = segue.destinationViewController as! NewsEmotionViewController
			emotionVC = destinationVC
			destinationVC.modalPresentationStyle = .Popover
			destinationVC.popoverPresentationController?.sourceView = heartButton.customView
			destinationVC.popoverPresentationController?.delegate = self
		}
	}
	
	@IBAction func backFromEmotion(segue: UIStoryboardSegue) {
		let sourceVC = segue.sourceViewController as! NewsEmotionViewController
		guard let emotion = sourceVC.selectedEmotion else { return }
		var likeService = NewsLikeService()
		let image: UIImage? = emotion.image
		(heartButton.customView as! UIButton).setImage(image, forState: .Normal)
		likeService.react(dataSource, emotion: emotion.rawValue) { [weak self] in
			guard let info = $0 else { return }
			let alert = UIAlertController(title: nil, message: info, preferredStyle: .Alert)
			let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { _ in
				self?.liked = !(self?.liked ?? false)
			}
			alert.addAction(cancel)
			self?.presentViewController(alert, animated: true, completion: nil)
		}
	}
}

extension NewsContentViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let identifier = indexPath.section == 0 ? Common.titleCellIdentifier : Common.contentCellIdentifier
		let cell = tableView.dequeueReusableCellWithIdentifier(identifier)
		if indexPath.section == 0 {
			(cell as! titleCell).titleLabel.text = dataSource.title
		} else {
			(cell as! contentCell).contentTextView.text = dataSource.content
			if imageLoaded == true {
				(cell as! contentCell).activityIndicator.stopAnimating()
			}
		}
		return cell!
	}
	
	func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.section == 0 {
			return 75
		} else {
			return 170
		}
	}
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		let alpha = Float(scrollView.contentOffset.y / 50)
		if alpha >= 1 {
			navigationController?.navigationBar.barStyle = .Default
			navigationController?.navigationBar.tintColor = .blackColor()
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
	func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
		return .None
	}
}