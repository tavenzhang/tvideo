//
//  RoomDataModel.swift

/// 房间内具体信息
class RoomData: NSObject {

	var port: Int = 9013;
	var sid: String = "";
	var roomId: Int = 1761828
	var pass: String = "";
	var isPublish = false;
	var publishUrl = "";
	// var key = "d382538698b6e79c7d2ea8914e12e623";
	var key = "";
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
	var rankGifList: [RankGiftModel] = [];
	var uid:String = "0";
	// 礼物数据集合
	var giftDataManager: [GiftCateoryModel] = [];

}

class RtmpInfo {
	var rtmpUrl: String = "";
	var rtmpName: String = "";
	var isEnable: Bool = false;
}

class GiftChooseModel {

	init(lb: String, num: Int, isVip: Bool)
	{
		label = lb;
		data = num;
		vip = isVip;
	}

	var label: String = "";
	var data: Int = 0;
	var vip: Bool = false;
}

class GiftCateoryModel: NSObject, DictModelProtocol {
	// {"category":2,"name":"贵族","items":...
	var category: NSNumber?;
	var name: String = "";
	var items: [GiftInfoModel]?

	static func customClassMapping() -> [String: String]? {
		return ["items": "\(GiftInfoModel.self)"]
	}
}

//详细礼物信息
class GiftInfoModel: NSObject {
	// {"gid":310031,"price":1,"category":1,"name":"七彩魅瑰","desc":"","sort":"1","isNew":"0"},
	var gid: NSNumber?;
	var price: NSNumber?;
	var category: NSNumber?;
	var name: String?;
	var desc: String?;
	var sort: String?;
	var isNew: String?;
}

