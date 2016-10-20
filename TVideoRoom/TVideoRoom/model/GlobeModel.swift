import Foundation
import SwiftyJSON

import Foundation
import UIKit

class VersionModel: NSObject, DictModelProtocol {
	var name: String?;
	var version: NSNumber?;
	var page_active: String?;
	var domains: [DomainModel]?;

	static func customClassMapping() -> [String: String]? {
		return ["domains": "\(DomainModel.self)"];
	}
}

class DomainModel: NSObject {
	var domain: String?;
	var vdomain: String?;
	var pdomain: String?;
	var isOneRoom: NSNumber?;
}

//用于主页加载数据的函数钩子
typealias loadDataFun = (Bool) -> Void;
//弹窗回掉
typealias alertHanld = () -> Void;
//登陆回调
typealias loginAlertHandle = (_ name: String, _ pwd: String) -> Void;
//简单输入
typealias sinputAlertHandle = (_ data: String) -> Void;
//发送聊天
typealias SendMessageBlock = (_ msg: String) -> Void
//发送礼物
typealias ChatGiftBlock = () -> Void
//点击发送
typealias SendBtnClickBlock = () -> Void
//选择发送礼物数量
typealias clickCallFun = (_ data: AnyObject) -> Void;
//自定义bar 按钮点击
typealias tabClickBlock = (_ tag: Int) -> Void;
