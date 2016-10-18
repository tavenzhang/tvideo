//
//  HttpTaven.swift

import Alamofire
import SwiftyJSON
import Alamofire

var HTTP_VERSION = "https://raw.githubusercontent.com/ataven2016/tvideo/master/verson.json";

var Http_Domain: String = "";
var Http_VDomain: String = "";
var Http_PDomain: String = "";

var HTTP_ACITVE_PAGE: String = "";

var MyActivePage: String {
	get {
		if (HTTP_ACITVE_PAGE == "") {
			let ret = UserDefaults.standard.string(forKey: default_Active);
			if (ret != nil && ret != "")
			{
				HTTP_ACITVE_PAGE = ret!;
				return ret!;
			}
			else {
				return "";
			}
		}
		else {
			return HTTP_ACITVE_PAGE;
		}
	}
}

var MyDomain: String {
	get {
		if (Http_Domain == "") {
			let ret = UserDefaults.standard.string(forKey: default_domain);
			if (ret != nil && ret != "")
			{
				Http_Domain = ret!;
				return ret!;
			}
			else {
				return "";
			}
		}
		else {
			return Http_Domain;
		}
	}
}

var MyVdomain: String {
	get {
		if (Http_VDomain == "") {
			let ret = UserDefaults.standard.string(forKey: default_vdomain);
			if (ret != nil && ret != "")
			{
				Http_VDomain = ret!;
				return ret!;
			}
			else {
				return "";
			}
		}
		else {
			return Http_VDomain;
		}
	}
}

var MyPdomain: String {
	get {
		if (Http_PDomain == "") {
			let ret = UserDefaults.standard.string(forKey: default_pdomain);
			if (ret != nil && ret != "")
			{
				Http_PDomain = ret!;
				return ret!;
			}
			else {
				return "";
			}
		}
		else {
			return Http_PDomain;
		}
	}
}
//原始老接口
let HTTP_HOST_LIST: String = "http://%@/videolist.json";
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
var HTTP_GIFT_ICO_URL: String {
	get {
		return DataCenterModel.sharedInstance.isOneRoom ? "http://s.mmbroadcast.net/flash/V2.4.21/image/gift_material/" : "http://%@/flash/image/gift_material/";
	}
}

//获取排行榜数据
var HTTP_RANK_DATA: String = "http://%@/videolist.json";

func getWWWHttp(_ src: String, _ isRandom: Bool = false) -> String {
	if (!isRandom) {
		return NSString(format: src as NSString, MyDomain) as String;
	}
	else {
		return (NSString(format: src as NSString, MyDomain) as String) + "?a=" + Date().timeIntervalSince1970.description;
	}
}

func getGiftImagUrl(_ gidStr: String) -> String {
	let imageUrl = getWWWHttp(HTTP_GIFT_ICO_URL) + gidStr + ".png";
	return imageUrl;
}

func getVHttp(_ src: String) -> String {
	return NSString(format: src as NSString, MyVdomain) as String;
}

var HTTP_VIDEO_ROOM: String {
	get {
		return "http://\(MyVdomain)/video_gs/socketServer?rid=%d&flag=%@";
	}
}

var HTTP_IMAGE: String {
	get {
		return DataCenterModel.sharedInstance.isOneRoom ? "http://\(MyVdomain)/%@" : "http://\(MyPdomain)/%@?w=356&h=266";
	}
}
var HTTP_SMALL_IMAGE: String {
	get {
		return DataCenterModel.sharedInstance.isOneRoom ? "http://\(MyVdomain)/%@" : "http://\(MyPdomain)/%@?w=40&h=40";
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
					LogHttp("http  recive<------not json data ==: %@", args: dataM.toUtf8String());
				}
			case .failure(let error):
				LogHttp("http  recive<------Request failed with error: %@", args: error as CVarArg);
				reulstH = HttpResult(dataR: nil, reuslt: false)
			}
			completionHadble(reulstH!);
		}
	}

	static var flushCount = 0;
	// 强制刷新域名
	class func flushVersonData(callFun: versionCallFun?) -> Void {
		HttpTavenService.requestJson(HTTP_VERSION + "?a=\(Date().timeIntervalSince1970)") { (dataResult) in
			if (dataResult.dataJson != nil && dataResult.isSuccess) {
				let versionMode = deserilObjectWithDictonary(dataResult.dataJson!.dictionaryObject! as NSDictionary, cls: VersionModel.self) as! VersionModel;
				if (dataResult.isSuccess) {
					HTTP_ACITVE_PAGE = versionMode.page_active!;
					var oneDomainList = [DomainModel]();
					var lgfDomainList = [DomainModel]();
					for item in versionMode.domains! {
						if (item.isOneRoom?.intValue != 1) {
							lgfDomainList.append(item);
						}
						else {
							oneDomainList.append(item);
						}
					}
					var domainMode: DomainModel?;
					if (flushCount > 10 && oneDomainList.count > 0) {
						DataCenterModel.sharedInstance.isOneRoom = true;
						domainMode = oneDomainList[Int(arc4random_uniform(UInt32(oneDomainList.count)))]
					}
					else {
						let index = Int(arc4random_uniform(UInt32(lgfDomainList.count)));
						domainMode = lgfDomainList[index];
					}
					Http_Domain = domainMode!.domain!;
					Http_VDomain = domainMode!.vdomain!;
					Http_PDomain = domainMode!.pdomain!;
					if (callFun != nil) {
						flushCount = flushCount + 1;
						callFun!();
					}
				}
			}
		}
	}
}

