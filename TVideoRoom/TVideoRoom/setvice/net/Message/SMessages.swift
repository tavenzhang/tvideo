//
//  Messages.swift
//  TVideo
//
//  Created by 张新华 on 16/5/31.
//  Copyright © 2016年 张新华. All rights reserved.
//

import Foundation
import CryptoSwift
import TAmf3Socket

class s_msg_noBody: S_msg_base {

}

class s_msg_heart_9999: s_msg_noBody {
	var msg: UInt32 = arc4random();
}

//10001 进入房间
class s_msg_10001: s_msg_noBody {

	var roomid: Int = 0 ;
	var pass: String = "" ;
	var roomLimit: String = "";
	var isPublish: Bool = false;
	var publishUrl: String = "";
	var sid: String = "";
	var key = "";

	init(cmd: Int, _roomId: Int, _pass: String, _roomLimit: String, _isPublish: Bool, _publishUrl: String, _sid: String, _key: String)
	{
		super.init(_cmd: cmd)
		roomid = _roomId;
		pass = _pass;
		roomLimit = _roomLimit;
		isPublish = _isPublish;
		publishUrl = _publishUrl;
		sid = _sid;
		key = _key;
	}
}

//20002  选用播放rtmp
class s_msg_20001: s_msg_noBody {

	init(cmd: Int, rtmpStr: String)
	{
		super.init(_cmd: cmd);
		rtmp = rtmpStr;
	}
	var rtmp: String = "";

}
//发送聊天聊下
class s_msg_30001: s_msg_noBody {
	var type: Int = 0;
	var recUid: Int = 0;
	var content: String = "";
	init(type: Int, ruid: Int, cnt: String) {
		super.init(_cmd: 30001);
		self.type = type;
		recUid = ruid;
		content = cnt;
	}
}
// //Cc.log("礼物事件 ", gift_Module.gid, gift_Module.gnum, UserVoDataManger.videoOwner.uid);
//NetManager.getInstance().sendDataObject({
//"cmd": 40001,
//"gid": gift_Module.gid,
//"uid": DataCenterManger.videoOwner.uid,
//"gnum": gift_Module.gnum
//});//
class s_msg_40001: S_msg_base {
	var gid: Int = 0;
	var gnum: Int = 0
	var uid: Int = 0;
	init(gid: Int, uid: Int, gnum: Int)
	{
		super.init(_cmd: 40001);
		self.gid = gid;
		self.gnum = gnum;
		self.uid = uid;
	}
}
//获取用户列表
class s_msg_11001: S_msg_base {
	var start: Int = 0;
	var end: Int = 20
	init(s: Int, e: Int)
	{
		super.init(_cmd: 11001);
		start = s;
		end = e;
	}
}

class s_msg_11008: S_msg_base {
	var start: Int = 0;
	var end: Int = 20
	init(s: Int, e: Int)
	{
		super.init(_cmd: 40001);
		start = s;
		end = e;
	}
}