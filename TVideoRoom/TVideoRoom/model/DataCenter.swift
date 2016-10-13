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
	case HostIcoLV;
	case UserIcoLv;
	case VipIcoLv;
}

func lvIcoNameGet(ico: Int32, type: icoLvType) -> String
{
	var resultStr: String = "";
	switch type
	{
	case .HostIcoLV:
		resultStr = "hlvr\(ico)";
	case .UserIcoLv:
		resultStr = "rlv\(ico)";
		case.VipIcoLv:
		resultStr = "vip\(ico)";
	}
	return resultStr;
}

func deserilObjectWithDictonary(json: NSDictionary, cls: AnyClass) -> AnyObject?
{
	let modelTool = DictModelManager.sharedManager
	let model = modelTool.objectWithDictionary(json, cls: cls);
	return model;
}

func deserilObjectsWithArray(array: NSArray, cls: AnyClass) -> NSArray?
{
	let modelTool = DictModelManager.sharedManager
	let arr = modelTool.objectsWithArray(array, cls: cls);
	return arr
}

//数据管理中心
class DataCenterModel {

	internal static let sharedInstance = DataCenterModel()
	private init() { }
	var isOneRoom: Bool = false;
	// 主页数据；
	var homeData: HomeData = HomeData();
	// 房间内数据
	var roomData: RoomData = RoomData();

}