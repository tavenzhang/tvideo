//
//  HttpTaven.swift

import Alamofire
import SwiftyJSON
import Alamofire
//var domain = "www.lgfxiu.com";
//var domain = "www.kiynd.net";
//var vdomain = "v.kiynd.net";
//var pdomain = "p.lgfxiu.com";

var domain: String {
	get {
		return DataCenterModel.sharedInstance.isOneRoom ? "www.kiynd.net" : "www.lgfxiu.com";
	}
}
var vdomain: String {
	get {
		return DataCenterModel.sharedInstance.isOneRoom ? "v.kiynd.net" : "v.lgfxiu.com";
	}
}

var pdomain: String {
	get {
		return DataCenterModel.sharedInstance.isOneRoom ? "v.kiynd.net" : "p.lgfxiu.com";
	}
}

//原始老接口
let HTTP_HOST_LIST: String = "http://%@/videolist.json?_=1466990345519sJvR";
//获取大厅
var HTTP_HOME_LIST: String = "http://%@/videolistall.json";
//一对一
var HTTP_ONEBYONE_LIST: String = "http://%@/videolistord.json";
//每日精选
var HTTP_HOT_LIST: String = "http://%@/videolistrec.json";

//大秀场
var HTTP_BIG_SHOW_LIST: String = "http://%@/videolistsls.json";

//获取个人数据 getUserInfo: { url : SERVERADDR + "/indexinfo", type : 'GET'},//用户数据
var HTTP_GETUSR_INFO = "http://%@/indexinfo";

//退出登陆
var HTTP_LOGIN_OUT = "http://%@/logout";

//login
var HTTP_LOGIN = "http://%@/login";

//获取礼物数据
var HTTP_GIFT_Table = "http://%@/video_gs/conf";
//获取礼物ico
var HTTP_GIFT_ICO_URL = "http://%@/flash/image/gift_material/";

//获取排行榜数据
var HTTP_RANK_DATA: String = "http://%@/videolist.json";

//http: // www.lgfxiu.com/flash/image/gift_material/310014.png

func getWWWHttp(_ src: String) -> String {
	return NSString(format: src as NSString, domain) as String;
}

func getGiftImagUrl(_ gidStr: String) -> String {
	let imageUrl = getWWWHttp(HTTP_GIFT_ICO_URL) + gidStr + ".png";
	return imageUrl;
}

func getVHttp(_ src: String) -> String {
	return NSString(format: src as NSString, vdomain) as String;
}

var HTTP_VIDEO_ROOM: String {
	get {
		return "http://\(vdomain)/video_gs/socketServer?rid=%d&flag=%@";
	}
}

var HTTP_IMAGE: String {
	get {
		return DataCenterModel.sharedInstance.isOneRoom ? "http://\(vdomain)/%@" : "http://\(pdomain)/%@?w=356&h=266";
	}
}
var HTTP_SMALL_IMAGE: String {
	get {
		return DataCenterModel.sharedInstance.isOneRoom ? "http://\(vdomain)/%@" : "http://\(pdomain)/%@?w=40&h=40";
	}
}

var HTTP_RANK_PAGE: String {
	get {
		// return "http://\(domain)";
		return "http://www.baidu.com"

	}
}

var HTTP_ACITVE_PAGE: String {
	get {

		return "http://%@/act";
	}
}

class HttpResult: NSObject {

	var dataJson: JSON?;

	var data: Data?;

	var isSuccess: Bool = false;

	init(dataR: Data?, reuslt: Bool) {
		super.init();
		if (dataR != nil)
		{
			dataJson = JSON(data: dataR!);

			if (((dataJson?.object as? NSNull) != nil))
			{
				data = dataR;
				dataJson = nil;
			}
		}

		isSuccess = reuslt
	}
}

class HttpTavenService {

	class func requestJson(_ url: String, isGet: Bool = true, para: [String: AnyObject]? = nil, completionHadble: @escaping (HttpResult) -> Void) -> Void {
		LogHttp("http send----->%@", args: url);
		let methodType: HTTPMethod = isGet ? .get : .post;
		// Alamofire.request(<#T##url: URLConvertible##URLConvertible#>, method: HTTPMethod, parameters: Parameters?, encoding: nil, headers: <#T##HTTPHeaders?#>)
		// Alamofire.request(URLConvertible, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?)

		Alamofire.request(url, method: methodType, parameters: para, encoding: URLEncoding.default, headers: nil).responseData { (Res: DataResponse<Data>) in
			var reulstH: HttpResult?
			switch Res.result {
			case .success(let dataM):
				reulstH = HttpResult(dataR: dataM, reuslt: true)
				if ((reulstH!.dataJson) != nil)
				{
					LogHttp("http  recive<------Success data ==: %@", args: ((reulstH!.dataJson)?.description)!);
				}
				else {
					LogHttp("http  recive<------Success data ==: %@", args: dataM.toUtf8String());
				}
			case .failure(let error):
				LogHttp("http  recive<------Request failed with error: %@", args: error as CVarArg);
				reulstH = HttpResult(dataR: nil, reuslt: false)
			}
			completionHadble(reulstH!);
		}
	}

	// static func requestDetail(_ method: Alamofire.Method, url: URLStringConvertible, parameters: [String: AnyObject]?, encoding: ParameterEncoding, headers: [String: String]?) -> Void {
	// Alamofire.request(method, url, parameters: parameters, encoding: encoding, headers: headers);
	// }

}
