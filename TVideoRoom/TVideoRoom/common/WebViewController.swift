//
//  WebViewController.swift
//  TVideoRoom
//
//  Created by  on 16/6/26.
//  Copyright © 2016年 . All rights reserved.
//

import UIKit
//web页面容器
class WebViewController: UIViewController {

	fileprivate var webView = UIWebView(frame: ScreenBounds)
	fileprivate var urlStr: String?
	fileprivate let loadProgressAnimationView: LoadProgressAnimationView = LoadProgressAnimationView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 3))

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
		view.addSubview(webView)
		webView.addSubview(loadProgressAnimationView);
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented");
	}

	convenience init(navigationTitle: String, urlStr: String, isOpenNow: Bool = true) {

		self.init(nibName: nil, bundle: nil)
		navigationItem.title = navigationTitle
		if (isOpenNow) {
			webView.loadRequest(URLRequest(url: URL(string: urlStr)!));
			LogHttp("WebViewController openUrl--------\(urlStr)");
		}
		self.urlStr = urlStr
	}

	override func viewDidLoad() {
		super.viewDidLoad();
		buildRightItemBarButton()
		view.backgroundColor = UIColor.colorWithCustom(230, g: 230, b: 230)
		webView.backgroundColor = UIColor.colorWithCustom(230, g: 230, b: 230)
		webView.delegate = self
		print("ScreenBounds.x=\(ScreenBounds.origin.x)---ScreenBounds.y=\(ScreenBounds.origin.y)");
		print("ScreenBounds.height=\(ScreenBounds.height)---ScreenBounds.width=\(ScreenBounds.width)");
		webView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0);
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.barTintColor = LFBNavigationBarWhiteBackgroundColor
	}

	fileprivate func buildRightItemBarButton() {
		let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 44))
		rightButton.setImage(UIImage(named: "v2_refresh"), for: UIControlState())
		rightButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -53)
		rightButton.addTarget(self, action: #selector(WebViewController.refreshClick), for: UIControlEvents.touchUpInside)
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
	}

	// MARK: - Action
	func refreshClick() {
		if urlStr != nil && urlStr!.characters.count > 1 {
			webView.loadRequest(URLRequest(url: URL(string: urlStr!)!))
			LogHttp("WebViewController openUrl--------\(urlStr)");
		}
	}
}

extension WebViewController: UIWebViewDelegate {

	func webViewDidStartLoad(_ webView: UIWebView) {
		loadProgressAnimationView.startLoadProgressAnimation()

	}

	func webViewDidFinishLoad(_ webView: UIWebView) {
		loadProgressAnimationView.endLoadProgressAnimation()
		LogHttp("open finished--------\(urlStr)");
	}
}
