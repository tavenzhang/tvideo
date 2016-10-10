//
//  HomeViewData.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/6/27.
//  Copyright © 2016年 张新华. All rights reserved.
//

import Foundation
import UIKit

class HomeData: NSObject {
	var AdList: [Activity]?;
	var hotList: [Activity]?;
	var homeList: [Activity]?;
	var oneByOneList: [Activity]?;
	var totalList: [Activity]?;
}

class RankGiftModel: NSObject {
	// // 本场贡献  {"cmd":15001,"items":[{"uid":2228479,"hidden":0,"name":"糖糖的小鱼","score":50,"richLv":5,"vip":0,"num":0,"car":0}]}
	var score: NSNumber?;
	var name: String?;
	var uid: NSNumber?;
	var hidden: NSNumber?;
	var rankStr: String?;
}

class Activity: NSObject {
	var headimg: String?;
	var live_time: String?;
	var username: String? ;
	var uid: NSNumber?;
	var live_status: NSNumber?;
	var total: NSNumber?;
	var lv_type: NSNumber?;
	var img: String? {
		get {
			return headimg;
		}
		set {
			headimg = newValue;
		}
	}

	var hostImg: String? {
		// var str= /video_gs/video/img/get_cover?uid=1842653&v=1466860291999
		if ((headimg! as NSString).containsString("&v=")) {
			var tempArr = self.headimg?.componentsSeparatedByString("&v=");
			let newStr = String(format: "http://p1.1room1.co/public/images/anchorimg/%@.jpg", (String(uid!) + "_" + String(tempArr![1])));
			return newStr;
		}
		else {
			return self.headimg!
		}
	}
}