//
//  UIVideoPlayControl.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/10/7.
//  Copyright © 2016年 张新华. All rights reserved.
//

import UIKit
import TRtmpPlay

class UIVideoPlayControl: UIViewController {

	fileprivate var vc: KxMovieViewController?;
	var lastRtmpUrl: String = "";

	override func viewDidLoad() {
		super.viewDidLoad();
		addNSNotification();
		initView();
		self.view.backgroundColor = UIColor.black.withAlphaComponent(0.9);
	}

	deinit {
		NotificationCenter.default.removeObserver(self);
		vc?.close();
		vc = nil;
	}

	func addNSNotification() {
		NotificationCenter.default.addObserver(self, selector: #selector(self.rtmpStartPlay), name: NSNotification.Name(rawValue: RTMP_START_PLAY), object: nil);
	}

	func initView() {

	}

	// 测试rtmp 播放
	func rtmpStartPlay(_ notification: Notification) {
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
		if (lastRtmpUrl.contains("rtmp"))
		{
			print("rtmp filepath=\(lastRtmpUrl)");
			var parametersD = [AnyHashable: Any]();
			parametersD[KxMovieParameterMinBufferedDuration] = 2;
			parametersD[KxMovieParameterMaxBufferedDuration] = 10;
			// KxMovieViewController.movieViewController(withContentPath: <#T##String!#>, parameters: [AnyHashable: Any]!)
			vc = KxMovieViewController.movieViewController(withContentPath: lastRtmpUrl, parameters: parametersD) as! KxMovieViewController?;
			vc!.view.frame = CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height);
			self.view.addSubview(vc!.view);
			self.view.bringSubview(toFront: vc!.view);
			// self.view.bringSubviewToFront(backBtn);
			// vc!.view.addGestureRecognizer(ges!);
		}
		else {
			showSimplpAlertView(self, tl: "主播已停止直播", msg: "请选择其他房间试试！", btnHiht: "了解");
		}
	}

	// 切换线路
	func showChangSheetView(_ tag: Int)
	{
		let alert = UIAlertController(title: "视频卡顿 请换线试试", message: nil, preferredStyle: .actionSheet);
		alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: self.selectNewLine));
		let rtmpList = DataCenterModel.sharedInstance.roomData.rtmpList;
		for item in rtmpList
		{
			let isNow = lastRtmpUrl.contains(item.rtmpUrl);
			if (item.isEnable && !isNow)
			{
				alert.addAction(UIAlertAction(title: item.rtmpName, style: .destructive, handler: selectNewLine));
			}

		}
		present(alert, animated: true, completion: nil);
	}

	// 最终选择线路
	func selectNewLine(_ action: UIAlertAction) {
		let rtmpList = DataCenterModel.sharedInstance.roomData.rtmpList;
		for item in rtmpList
		{
			if (action.title! == item.rtmpName)
			{
				let ns = Notification(name: Notification.Name(rawValue: RTMP_START_PLAY), object: item.rtmpUrl);
				rtmpStartPlay(ns);
				return;
			}
		}
	}

}
