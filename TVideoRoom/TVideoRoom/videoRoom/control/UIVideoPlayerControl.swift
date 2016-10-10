//
//  UIVideoPlayControl.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/10/7.
//  Copyright © 2016年 张新华. All rights reserved.
//

import UIKit
import TRtmpPlay
import TChat

class UIVideoPlayControl: UIViewController {

	private var vc: KxMovieViewController?;
	var lastRtmpUrl: String = "";

	override func viewDidLoad() {
		super.viewDidLoad();
		addNSNotification();
		initView();
		self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.9);
	}

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self);
		vc?.close();
		vc = nil;
	}

	func addNSNotification() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.rtmpStartPlay), name: RTMP_START_PLAY, object: nil);
	}

	func initView() {

	}

	// 测试rtmp 播放
	func rtmpStartPlay(notification: NSNotification) {
		// [-] 正常播放模式 式正常播放模式 30043581144191618|15526D99B51B7DAA0CF99539B82F013B rtmp://119.63.47.233:9945/proxypublish
		let roomData = DataCenterModel.sharedInstance.roomData;
		roomData.lastRtmpUrl = notification.object as! String;
		lastRtmpUrl = roomData.rtmpPath;
		if (vc != nil)
		{
			vc?.close();
			vc?.view.removeFromSuperview();
			// vc?.view.removeGestureRecognizer(ges!);
			vc = nil;
		}
		if (lastRtmpUrl.containsString("rtmp"))
		{
			print("rtmp filepath=\(lastRtmpUrl)");
			let parametersD = NSMutableDictionary();
			parametersD[KxMovieParameterMinBufferedDuration] = 2;
			parametersD[KxMovieParameterMaxBufferedDuration] = 10;
			vc = KxMovieViewController.movieViewControllerWithContentPath(lastRtmpUrl, parameters: parametersD as [NSObject: AnyObject]) as? KxMovieViewController ;
			vc!.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
			self.view.addSubview(vc!.view);
			self.view.bringSubviewToFront(vc!.view);
			// self.view.bringSubviewToFront(backBtn);
			// vc!.view.addGestureRecognizer(ges!);
		}
		else {
			showSimplpAlertView(self, tl: "主播已停止直播", msg: "请选择其他房间试试！", btnHiht: "了解");
		}
	}

	// 切换线路
	func showChangSheetView(tag: Int)
	{
		let alert = UIAlertController(title: "视频卡顿 请换线试试", message: nil, preferredStyle: .ActionSheet);
		alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: self.selectNewLine));
		let rtmpList = DataCenterModel.sharedInstance.roomData.rtmpList;
		for item in rtmpList
		{
			let isNow = lastRtmpUrl.containsString(item.rtmpUrl);
			if (item.isEnable && !isNow)
			{
				alert.addAction(UIAlertAction(title: item.rtmpName, style: .Destructive, handler: selectNewLine));
			}

		}
		presentViewController(alert, animated: true, completion: nil);
	}

	// 最终选择线路
	func selectNewLine(action: UIAlertAction) {
		let rtmpList = DataCenterModel.sharedInstance.roomData.rtmpList;
		for item in rtmpList
		{
			if (action.title! == item.rtmpName)
			{
				let ns = NSNotification(name: RTMP_START_PLAY, object: item.rtmpUrl);
				rtmpStartPlay(ns);
				return;
			}
		}
	}

}
