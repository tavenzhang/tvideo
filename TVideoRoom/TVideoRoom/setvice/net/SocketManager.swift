
import TAmf3Socket
import SwiftyJSON
import NSLogger
import TRtmpPlay

class SocketManager {

	internal static let sharedInstance = SocketManager()
	// 消息处理函数
	var socketM: Amf3SocketManager?;

	private init() {
		socketM = Amf3SocketManager(heartTime: 10, msgHeadSize: 2, isByteBigEndian: true);
		socketM!.onMsgResultHandle = onMsghandle;
		socketM!.onTLogHandle = self.socketlog;
	}
	deinit
	{
		NSNotificationCenter.defaultCenter().removeObserver(self);
	}

	// 测速并选择最快的socket
	func testFastSocket(ipList: [String]) -> Void
	{
		DataCenterModel.sharedInstance.roomData.socketIp = nil;
		DataCenterModel.sharedInstance.roomData.port = 0;
		for item in ipList {
			let queue = dispatch_queue_create("testSocket", DISPATCH_QUEUE_CONCURRENT);
			dispatch_async(queue) {
				let as3Socket: Amf3SocketManager = Amf3SocketManager(heartTime: 10, msgHeadSize: 2, isByteBigEndian: true);
				let ip = item.componentsSeparatedByString(":")[0];
				let port = Int(item.componentsSeparatedByString(":")[1]);
				LogSocket("test ip=\(ip)---port--\(port)---start");
				as3Socket.onConnectSocket(ip, port: port!, timeOut: 0) {
					as3Socket.closeSocket();
					dispatch_async(dispatch_get_main_queue()) {
						[weak self] in
						if (DataCenterModel.sharedInstance.roomData.socketIp == nil)
						{
							LogSocket("best choose line =\(ip)---port--\(port)---finished!");
							DataCenterModel.sharedInstance.roomData.socketIp = ip;
							DataCenterModel.sharedInstance.roomData.port = port!;
							self?.startConnectSocket(ip, mport: port!);
						}
					}
				}
			}
		}
	}

	func socketlog(log: String) -> Void {
		LogSocket("%@", args: log);
	}
	// 开启socket 连接
	func startConnectSocket(host: String, mport: Int, timeOut: NSTimeInterval = 0) -> Void
	{
		socketM!.onConnectSocket(host, port: mport, timeOut: timeOut) {
			[weak self] in
			self?.sendMessage(S_msg_base(_cmd: 10000));
			self?.socketM?.heartMessage = s_msg_heart_9999(_cmd: 9999);
		}
	}
	// 关闭socket 连接
	func closeSocket() -> Void
	{
		socketM!.closeSocket();
		DataCenterModel.sharedInstance.roomData.socketIp = nil;
		DataCenterModel.sharedInstance.roomData.port = 0;
	}

	func sendMessage(message: S_msg_base) -> Void {
		socketM!.sendMessage(message);
	}

	func onMsghandle(message: AnyObject) -> Void {
		let json = JSON(message);
		let cmd = json["cmd"].int!;
		let dataCenterM = DataCenterModel.sharedInstance;
		LogSocket("reve:<--cmd=%d---%@", args: cmd, json.description);
		switch cmd {
		case MSG_10000: // 登陆验证
			dataCenterM.roomData.aeskey = json["limit"].string!;
			var r_msg: r_msg_10000?;
			var s_msge: s_msg_10001?;
			if (dataCenterM.isOneRoom)
			{
				r_msg = r_msg_10000(_data: ("d:87568799b3e29j7d2ea8914e12e623" + String(dataCenterM.roomData.roomId) + "juggg123"), _aesKey: dataCenterM.roomData.aeskey);
				s_msge = s_msg_10001(cmd: MSG_10001, _roomId: dataCenterM.roomData.roomId, _pass: dataCenterM.roomData.pass, _roomLimit: r_msg!.getAesk(), _isPublish: dataCenterM.roomData.isPublish, _publishUrl: dataCenterM.roomData.publishUrl, _sid: dataCenterM.roomData.sid, _key: "d382538698b6e79c7d2ea8914e12e623");
			}
			else {
				let r_msg = r_msg_10000(_data: (dataCenterM.roomData.key + String(dataCenterM.roomData.roomId) + "73uxh9*@(58u)fgxt"), _aesKey: dataCenterM.roomData.aeskey);
				s_msge = s_msg_10001(cmd: MSG_10001, _roomId: dataCenterM.roomData.roomId, _pass: dataCenterM.roomData.pass, _roomLimit: r_msg.getAesk(), _isPublish: dataCenterM.roomData.isPublish, _publishUrl: dataCenterM.roomData.publishUrl, _sid: dataCenterM.roomData.sid, _key: dataCenterM.roomData.key);
			}
			socketM!.sendMessage(s_msge);
		case MSG_10001:
			dataCenterM.roomData.myMoney = json["points"].int!;
			noticeMsgMianThread(MONEY_CHANGE, nil);
		case MSG_10002: // 进入房间
			let s_8002 = s_msg_noBody(_cmd: MSG_80002);
			socketM!.sendMessage(s_8002);
			let s_15001 = s_msg_noBody(_cmd: MSG_15001);
			socketM!.sendMessage(s_15001);
			let s_10001 = s_msg_11001(s: 0, e: 20);
			let s_11008 = s_msg_noBody(_cmd: MSG_11008);
			socketM!.sendMessage(s_10001);
			socketM!.sendMessage(s_11008);
			break
		case MSG_10009: // 钻石金额变化
			dataCenterM.roomData.myMoney = json["points"].int!;
			noticeMsgMianThread(MONEY_CHANGE, nil);
		case MSG_11002: // 进入房间
			LogHttp("MSG_11002---dictionaryObject=\(json.dictionaryObject)");
			DataCenterModel.sharedInstance.roomData.uid = (json["uid"].int32?.description)!;
			let playerMode = deserilObjectWithDictonary(json.dictionaryObject!, cls: playInfoModel.self) as! playInfoModel! ;
			dataCenterM.roomData.changPlayerList([playerMode]);
			noticeMsgMianThread(PlayLIST_CHANGE, nil);
		case MSG_11003: // 退出房间
			let playerMode = deserilObjectWithDictonary(json.dictionaryObject!, cls: playInfoModel.self) as! playInfoModel! ;
			dataCenterM.roomData.changPlayerList([playerMode], isDelete: true);
			noticeMsgMianThread(PlayLIST_CHANGE, nil);
		case MSG_11008: // 获取管理员列表
			fallthrough;
		case MSG_11001: // 获取用户列表
			var sarray = json["items"].arrayObject as? NSArray;
			if (sarray != nil) && (sarray?.count > 0)
			{
				let dataList: [playInfoModel] = deserilObjectsWithArray(json["items"].arrayObject! as NSArray, cls: playInfoModel.self) as! [playInfoModel];
				dataCenterM.roomData.changPlayerList(dataList);
				noticeMsgMianThread(PlayLIST_CHANGE, nil);
			}
		case MSG_15001:
			dataCenterM.roomData.rankGifList.removeAll();
			fallthrough;
		case MSG_15002:
			let dataList = json["items"].arrayObject;
			if (dataList != nil)
			{
				let newModeList = deserilObjectsWithArray(dataList!, cls: RankGiftModel.classForCoder()) as? [RankGiftModel];
				for newItem in newModeList! {
					var isAdd = true;
					for data in dataCenterM.roomData.rankGifList {
						if (data.uid == newItem.uid)
						{
							data.score = NSNumber(int: (data.score?.intValue)! + (newItem.score?.intValue)!);
							isAdd = false;
							break;
						}
					}
					if (isAdd) {
						dataCenterM.roomData.rankGifList.append(newItem);
					}
				}
			}
			noticeMsgMianThread(RANK_GIft_UPTA, dataCenterM.roomData.rankGifList);
		case MSG_80002: // 获取到播放列表
			let rtmpListStr = json["userrtmp"].string;
			if (rtmpListStr != "") {
				let rtmpList = rtmpListStr?.componentsSeparatedByString(",");
				var resultIpList = [RtmpInfo]();
				for item in rtmpList! {
					let rtmpInfo = RtmpInfo()
					let str = item.componentsSeparatedByString("@@")[0] as String!;
					let name = item.componentsSeparatedByString("@@")[1] as String!;
					if (str as NSString).containsString("rtmp") {
						rtmpInfo.rtmpUrl = str;
						rtmpInfo.rtmpName = name;
						resultIpList.append(rtmpInfo);
					}
				}
				let queue = dispatch_queue_create("testRtmp", DISPATCH_QUEUE_CONCURRENT);
				var index = 0;
				dataCenterM.roomData.rtmpList.removeAll();
				if (resultIpList.count > 0) {
					for rtmpData in resultIpList {
						index += 1;
						dispatch_async(queue) {
							let ret = KxMovieViewController.testRtmpConnect(rtmpData.rtmpUrl);
							LogSocket("test connection----ret=\(ret)====item=\(rtmpData.rtmpUrl)")
							if (ret > 0) {
								rtmpData.isEnable = true;

								// if (dataCenterM.roomData.rtmpList.count <= 1) {
								dispatch_async(dispatch_get_main_queue()) {
									dataCenterM.roomData.rtmpList.append(rtmpData);
									if (dataCenterM.roomData.rtmpList.count <= 1) {
										let msg2001 = s_msg_20001(cmd: MSG_20001, rtmpStr: dataCenterM.roomData.rtmpList[0].rtmpUrl);
										self.socketM!.sendMessage(msg2001);
									}
									// }
								}
							}
						}
					}
				}
			}
			break;
		case MSG_20001:
			var itemInfo = json["items"][0];
			if (itemInfo != nil)
			{
				dataCenterM.roomData.lastRtmpUrl = itemInfo["rtmp"].string!;
				dataCenterM.roomData.sid = itemInfo["sid"].string!;
				noticeMsgMianThread(RTMP_START_PLAY, dataCenterM.roomData.lastRtmpUrl);
			}
			else {
				dataCenterM.roomData.lastRtmpUrl = "";
				dataCenterM.roomData.sid = "";
				noticeMsgMianThread(RTMP_START_PLAY, "");
			}
			break;
		case MSG_500: // break
			// var info = json["msg"].string
			break;
		case MSG_11002:
			if (json["richLv"].int >= 2)
			{
				var msgVo: ChatMessage?;
				msgVo = ChatMessage();
				msgVo?.sendName = "欢迎 [" + json["name"].string! + "] 进入直播间!";
				msgVo?.content = "";
				msgVo?.isSender = false;
				msgVo?.messageType = .Text;
				noticeMsgMianThread(E_SOCKERT_Chat_30001, msgVo!)
			}
			break
		case MSG_30001:
			let type = json["type"].int;
			var msgVo: ChatMessage?;
			var semdName = json["sendName"].string! + ":";
			switch type! {
			case 8:
				break;
			case 3:
				semdName = "[系统消息]"
				fallthrough
			case 6:
				semdName = "[系统消息]"
				fallthrough
			default:
				msgVo = ChatMessage();
				msgVo?.sendName = semdName;
				msgVo?.content = json["content"].string!;
				msgVo?.isSender = false;
				msgVo?.messageType = .Text;
			}
			if ((msgVo) != nil)
			{
				noticeMsgMianThread(E_SOCKERT_Chat_30001, msgVo!)
			}
		case MSG_40001:
			let giftInfo = GiftInfoModel();
			giftInfo.senderNickString = json["sendName"].string!;
			giftInfo.giftNameString = "";
			giftInfo.giftCounts = json["gnum"].uInt32!;
			giftInfo.giftThumbnailPath = getGiftImagUrl(json["gid"].int32!.description);
			noticeMsgMianThread(GIFT_EFFECT_START, giftInfo);
		case MSG_500: // 多处登陆。
			dataCenterM.roomData.reset();
			showMainThreatAlert("", content: "账号登陆异常，请退出房间重新登陆!");
		case MSG_15555: // 各种错误提醒
			let msg = ErrAlertManger.instance.getDescByError(json["errorCode"].intValue);
			showMainThreatAlert("", content: msg);
		default:
			break
		}
	}
	func showMainThreatAlert(title: String, content: String) {
		dispatch_async(dispatch_get_main_queue()) {
			showSimplpAlertView(UIApplication.sharedApplication().keyWindow?.rootViewController, tl: title, msg: content);
		}
	}
	func noticeMsgMianThread(msg: String, _ data: AnyObject?) {
		dispatch_async(dispatch_get_main_queue()) {
			NSNotificationCenter.defaultCenter().postNotificationName(msg, object: data);
		}
	}

}