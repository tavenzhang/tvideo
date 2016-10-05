//
//  HttpTaven.swift

import Alamofire
import SwiftyJSON

var domain = "www.lgfxiu.com";
var vdomain = "v.lgfxiu.com";
var pdomain = "p.lgfxiu.com";

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

func getWWWHttp(src: String) -> String {
	return NSString(format: src, domain) as String;
}

//{
//	get {
//		return "http://\(domain)/videolist.json?_=1466990345519sJvR";
//	}
//}
//var HTTP_HOME_LIST: String {
//	get {
//		return "http://\(domain)/videolistall.json";
//	}
//}

var HTTP_ONBYONE_LIST: String {
	get {
		return "http://\(domain)/videolistord/json";
	}
}

var HTTP_VIDEO_ROOM: String {
	get {
		return "http://\(vdomain)/video_gs/socketServer?rid=%d&flag=%@";
	}
}
var HTTP_LOGIN: String {
	get {
		return "http://\(domain)/login";
	}
}

var HTTP_IMAGE: String {
	get {
		return "http://\(pdomain)/%@?w=356&h=266";
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
		// return "http://www.baidu.com";
		return "http://orchidf.com:12315/app.html";
		// return "http://\(domain)/%@?w=356&h=266";
	}
}

class HttpResult: NSObject {

	var dataJson: JSON?;

	var data: NSData?;

	var isSuccess: Bool = false;

	init(dataR: NSData?, reuslt: Bool) {
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

	class func requestJson(url: String, isGet: Bool = true, para: [String: AnyObject]? = nil, completionHadble: (HttpResult) -> Void) -> Void {
		LogHttp("http send----->%@", args: url);
		let method: Alamofire.Method = isGet ? .GET : .POST;
		Alamofire.request(method, url, parameters: para).responseData() {
			(Res: Response<NSData, NSError>) in
			var reulstH: HttpResult?
			switch Res.result {
			case .Success(let data):
				reulstH = HttpResult(dataR: data, reuslt: true)
				if ((reulstH!.dataJson) != nil)
				{
					LogHttp("http  recive<------Success data ==: %@", args: ((reulstH!.dataJson)?.description)!);
				}
				else {
					LogHttp("http  recive<------Success data ==: %@", args: data.toUtf8String());
				}
			case .Failure(let error):
				LogHttp("http  recive<------Request failed with error: %@", args: error);
				reulstH = HttpResult(dataR: nil, reuslt: true)
			}
			completionHadble(reulstH!);
		}
	}

	static func requestDetail(method: Alamofire.Method, url: URLStringConvertible, parameters: [String: AnyObject]?, encoding: ParameterEncoding, headers: [String: String]?) -> Void {
		Alamofire.request(method, url, parameters: parameters, encoding: encoding, headers: headers);
	}

}
