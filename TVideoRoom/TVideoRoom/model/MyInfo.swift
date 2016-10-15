//
//  MyInfo.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/10/6.
//  Copyright © 2016年 张新华. All rights reserved.
//

import Foundation

class LoginModel: NSObject, DictModelProtocol {
	var ret: Bool = false;
	// var myres:[]?
	// var gg:[]?
	var room_url: String?;
	var js_url: String?;
	var downloadUrl: String?;
	var img_url: String?;
	var info: PersonInfoModel?;
	var myfav: [Activity]?

	static func customClassMapping() -> [String: String]? {
		return ["myfav": "\(Activity.self)", "info": "\(PersonInfoModel.self)"];
	}
}
class PersonInfoModel: NSObject {
	// var description: String?;
	var vip: NSNumber?;
	var uid: NSNumber?;
	var sex: NSNumber?;
	var point: NSNumber?;
	var vip_end: String?;
	var safemail: String?;
	var rid: NSNumber?;
	var mails: NSNumber?;
	var icon_id: NSNumber?;
	var headimg: String?;
	var roled: NSNumber?;
	var lv_rich: NSNumber?;
	var nickname: String?;
	var lv_exp: NSNumber?;
}

