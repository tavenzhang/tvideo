//
//  HomeViewData.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/6/27.
//  Copyright © 2016年 张新华. All rights reserved.
//

import Foundation
import UIKit

/// 房间内具体信息
class RoomData: NSObject {

	var port: Int = 9013;
	var sid: String = "";
	var roomId: Int = 1761828
	var pass: String = "";
	var isPublish = false;
	var publishUrl = "";
	var key = "d382538698b6e79c7d2ea8914e12e623";
	var aeskey = "";
	var rtmpList = [RtmpInfo]();
	var lastRtmpUrl: String = "";
	var rtmpPath: String {
		get {
			return lastRtmpUrl + "/" + sid + " live=1";
		}
	}
	var socketIp: String? ;
	var isVideoPlaying: Bool = false;
}

class RtmpInfo {
	var rtmpUrl: String = "";
	var rtmpName: String = "";
	var isEnable: Bool = false;
}

class HomeData: NSObject {
	var AdList: [Activity]?;
	var hotList: [Activity]?;
	var homeList: [Activity]?;
	var oneByOneList: [Activity]?;
	var totalList: [Activity]?;
}

class Activity: BaseDeSerialsModel {
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