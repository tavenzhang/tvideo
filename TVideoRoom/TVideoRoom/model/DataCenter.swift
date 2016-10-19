//
//  DataProxy.swift
//  TVideo
//
//  Created by 张新华 on 16/6/1.
//  Copyright © 2016年 张新华. All rights reserved.
//

import Foundation
import SwiftyJSON

enum icoLvType: Int {
	case hostIcoLV;
	case userIcoLv;
	case vipIcoLv;
}

func lvIcoNameGet(_ ico: Int32, type: icoLvType) -> String
{
	var resultStr: String = "";
	switch type
	{
	case .hostIcoLV:
		resultStr = "hlvr\(ico)";
	case .userIcoLv:
		resultStr = "rlv\(ico)";
		case.vipIcoLv:
		resultStr = "vip\(ico)";
	}
	return resultStr;
}

func deserilObjectWithDictonary(_ json: NSDictionary, cls: AnyClass) -> AnyObject?
{
	let modelTool = DictModelManager.sharedManager
	let model = modelTool.objectWithDictionary(json, cls);
	return model;
}

func deserilObjectsWithArray(_ array: NSArray, cls: AnyClass) -> NSArray?
{
	let modelTool = DictModelManager.sharedManager
	let arr = modelTool.objectsWithArray(array, cls);
	return arr
}


//数据管理中心
class DataCenterModel {

	internal static let sharedInstance = DataCenterModel()
	fileprivate init() { }

	var isOneRoom: Bool = false;
	// 主页数据；
	var homeData: HomeData = HomeData();
	// 房间内数据
	var roomData: RoomData = RoomData();

	class var isLogin: Bool {
		return (DataCenterModel.sharedInstance.roomData.key != "");
	}

	class func enterVideoRoom(rid: Int, vc: UINavigationController?) {
		if (isLogin) {
			let roomview: VideoRoomUIViewVC = VideoRoomUIViewVC();
			roomview.roomId = rid;
			DataCenterModel.sharedInstance.roomData.roomId = rid;
			vc?.pushViewController(roomview, animated: true);

		}
		else {
            showAlertHandle(vc!, tl: "您当前是游客", cont: "无法参与送礼和聊天，你确定以游客身份进入吗", okHint: "登陆", cancelHint: "进入", canlHandle: {
                let roomview: VideoRoomUIViewVC = VideoRoomUIViewVC();
                DataCenterModel.sharedInstance.roomData.roomId = rid;
                roomview.roomId = rid;
                vc?.pushViewController(roomview, animated: true);
                }, okHandle: {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: SHOW_LOGOM_VIEW), object: nil);
            })
		}
	}

}
