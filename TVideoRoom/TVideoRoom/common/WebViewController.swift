//
//  WebViewController.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/6/26.
//  Copyright © 2016年 张新华. All rights reserved.
//

import UIKit
//web页面容器
class WebViewController: UIViewController {
    
    private var webView = UIWebView(frame: ScreenBounds)
    private var urlStr: String?
    private let loadProgressAnimationView: LoadProgressAnimationView = LoadProgressAnimationView(frame: CGRectMake(0, 0, ScreenWidth, 3))
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        view.addSubview(webView)
        webView.addSubview(loadProgressAnimationView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(navigationTitle: String, urlStr: String) {
        self.init(nibName: nil, bundle: nil)
        navigationItem.title = navigationTitle
        webView.loadRequest(NSURLRequest(URL: NSURL(string: urlStr)!))
        print("openUrl--------\(urlStr)");
        self.urlStr = urlStr
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildRightItemBarButton()
        view.backgroundColor = UIColor.colorWithCustom(230, g: 230, b: 230)
        webView.backgroundColor = UIColor.colorWithCustom(230, g: 230, b: 230)
        webView.delegate = self
        print("ScreenBounds.x=\(ScreenBounds.origin.x)---ScreenBounds.y=\(ScreenBounds.origin.y)")
        print("ScreenBounds.height=\(ScreenBounds.height)---ScreenBounds.width=\(ScreenBounds.width)")
        webView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0);
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = LFBNavigationBarWhiteBackgroundColor
    }
    
    private func buildRightItemBarButton() {
        let rightButton = UIButton(frame: CGRectMake(0, 0, 60, 44))
        rightButton.setImage(UIImage(named: "v2_refresh"), forState: UIControlState.Normal)
        rightButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -53)
        rightButton.addTarget(self, action: #selector(WebViewController.refreshClick), forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    // MARK: - Action
    func refreshClick() {
        if urlStr != nil && urlStr!.characters.count > 1 {
            webView.loadRequest(NSURLRequest(URL: NSURL(string: urlStr!)!))
        }
    }
}

extension WebViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(webView: UIWebView) {
        loadProgressAnimationView.startLoadProgressAnimation()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        loadProgressAnimationView.endLoadProgressAnimation()
    }
}
