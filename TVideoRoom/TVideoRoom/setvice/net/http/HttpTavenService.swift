//
//  HttpTaven.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/6/27.
//  Copyright © 2016年 张新华. All rights reserved.

import Alamofire
import SwiftyJSON
//获取主播列表
let HTTP_HOST_LIST = "http://www.d1fang.net/videolist.json?_=1466990345519sJvR";
let HTTP_HOST_LIST2 = "http://www.521mitao.com/videoList?_=1469268972940UQCB&type=all";
let HTTP_VIDEO_ROOM = "http://v.d1fang.net/video_gs/socketServer?rid=%d&flag=%@";

let HTTP_LOGIN = "http://www.d1fang.net/login";

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

    class func requestJson(url: String,isGet:Bool=true, para: [String: AnyObject]?=nil,completionHadble: (HttpResult) -> Void) -> Void {
		LogHttp("http send----->%@", args: url);
        let method:Alamofire.Method = isGet ? .GET:.POST;
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
