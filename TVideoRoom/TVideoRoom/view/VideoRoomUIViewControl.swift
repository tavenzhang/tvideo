//
//  VideoRoomUIView.swift
//  TVideoRoom
//
import UIKit
import TRtmpPlay
import TChat

class VideoRoomUIViewVC: UIViewController {
	private var vc: KxMovieViewController?;
	private var chatVc: ChatViewController?;
	private var _uiChatView: UIView?;
	private var ges: UITapGestureRecognizer?;
	var roomId: Int = 0;
	var lastRtmpUrl: String = "";
	lazy var backBtn: UIButton = {
		// 设置返回按钮属性
		let backBtn2 = UIButton(type: UIButtonType.Custom)
		backBtn2.setImage(UIImage(named: r_nav_btnBack_9x16), forState: .Normal);
		backBtn2.titleLabel?.hidden = true
		backBtn2.addTarget(self, action: #selector(VideoRoomUIViewVC.backBtnClick), forControlEvents: .TouchUpInside)
		backBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
		backBtn2.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
		let btnW: CGFloat = ScreenWidth > 375.0 ? 50 : 44
		backBtn2.frame = CGRectMake(20, 10, btnW, 40);
		return backBtn2
	}();

	var changeLineBtn: UIButton?;

	override func viewDidLoad() {
		self.view.backgroundColor = UIColor.whiteColor();
		addNSNotification();
		self.navigationController?.setNavigationBarHidden(true, animated: false);
		self.view.addSubview(backBtn);
		chatVc = ChatViewController();
		_uiChatView = UIView();
		let height = (self.view.height - self.view.width * 3 / 4);
		_uiChatView?.frame = CGRect(x: 0, y: self.view.width * 3 / 4, width: self.view.width, height: height);
		chatVc!.adjust(self.view.width, h: height);
		chatVc?.view.backgroundColor = UIColor.clearColor();
		chatVc?.sendBlock = chatSendChatMessage;
		_uiChatView?.addSubview(chatVc!.view);
		self.view.addSubview(_uiChatView!);
		ges = UITapGestureRecognizer(target: self, action: #selector(onTableVieo));
		c2sGetSocket(roomId);
		changeLineBtn = UIButton.BtnSimple("切换线路", titleColor: UIColor.purpleColor(), image: nil, hightLightImage: nil, target: self, action: #selector(self.changeLine));
		changeLineBtn?.frame = CGRectMake(10, 10, 50, 30);
		_uiChatView?.addSubview(changeLineBtn!);
	}

	func changeLine()
	{
		let alert = UIAlertController(title: "视频卡顿 请换线试试", message: nil, preferredStyle: .ActionSheet);
		alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: self.selectNewLine));
		let rtmpList = DataCenterModel.sharedInstance.roomData.rtmpList;
		for item in rtmpList
		{

			let isNow = lastRtmpUrl.containsString(item.rtmpUrl);
			if (isNow)
			{
				LogHttp("item.rtmpUrl=\(lastRtmpUrl)");
				LogHttp("item.rtmpUrl contian=\(lastRtmpUrl.containsString(item.rtmpUrl))--name\(item.rtmpName)");
				continue;
			}
			if (item.isEnable && !isNow)
			{
				alert.addAction(UIAlertAction(title: item.rtmpName, style: .Default, handler: selectNewLine));
			}

		}
		presentViewController(alert, animated: true, completion: nil);
	}

	// 最终选择线路
	func selectNewLine(action: UIAlertAction) {
		let rtmpList = DataCenterModel.sharedInstance.roomData.rtmpList;
		for item in rtmpList
		{
			if (action.title! == item.rtmpName)
			{
				let ns = NSNotification(name: RTMP_START_PLAY, object: item.rtmpUrl);
				rtmpStartPlay(ns);
				return;
			}
		}
	}

	// 隐藏状态栏
	override func prefersStatusBarHidden() -> Bool {

		return true;
	}

	deinit {
		SocketManager.sharedInstance.closeSocket();
		NSNotificationCenter.defaultCenter().removeObserver(self);
		vc?.close()
		vc = nil;
	}

	override func viewDidAppear(animated: Bool) {

	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func addNSNotification() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VideoRoomUIViewVC.rtmpStartPlay), name: RTMP_START_PLAY, object: nil);
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VideoRoomUIViewVC.chatReceiveMessage30001), name: E_SOCKERT_Chat_30001, object: nil);
	}

	// 获取socket 列表
	private func c2sGetSocket(roomId: Int) {
		let pathHttp = NSString(format: HTTP_VIDEO_ROOM, roomId, "false") as String;
		DataCenterModel.sharedInstance.roomData.roomId = roomId;
		dispatch_async(dispatch_get_global_queue(0, 0)) {
			HttpTavenService.requestJson(pathHttp) {
				(dataResutl: HttpResult) in
				if (dataResutl.isSuccess)
				{
					if ((dataResutl.dataJson != nil) && (dataResutl.dataJson!["ret"].int == 1))
					{
						let serverStr = decodeAES(dataResutl.dataJson!["server"].string!) ;
						var serverList = serverStr.componentsSeparatedByString(",");
						if (DataCenterModel.sharedInstance.isOneRoom)
						{
							let port: Int = Int(serverStr.componentsSeparatedByString("|")[1])!;
							let str = serverStr.componentsSeparatedByString("|")[0];
							let ipList = str.componentsSeparatedByString(",");
							serverList = [String]();
							for item in ipList {
								serverList.append("\(item):\(port)") ;
							}
						}
						SocketManager.sharedInstance.testFastSocket(serverList);
					}
					else {
						showSimplpAlertView(self, tl: "服务获取失败", msg: "请稍等一会再试试!");
					}
				}
				else {
					showSimplpAlertView(self, tl: "房间id无效", msg: "请选择其他房间试试!");
				}
			}
		}
	}
	/**
     接收到聊天信息
     */
	func chatReceiveMessage30001(notification: NSNotification) {
		let message = notification.object as! ChatMessage;
		chatVc?.receiveMessage(message);
	}
	/**
     发送聊天消息
     */
	func chatSendChatMessage(msg: String!) -> Void {
		if (DataCenterModel.sharedInstance.roomData.key == "")
		{
			showSimplpAlertView(self, tl: "error", msg: "您还未登录不能发言", btnHiht: "登录", okHandle: {
				self.tabBarController?.selectedIndex = 3;
			})
		}
		else {
			let chatMsg = s_msg_30001(type: 0, ruid: 0, cnt: msg);
			SocketManager.sharedInstance.sendMessage(chatMsg);
		}
	}

	// 测试rtmp 播放
	func rtmpStartPlay(notification: NSNotification) {
		// [-] 正常播放模式 式正常播放模式 30043581144191618|15526D99B51B7DAA0CF99539B82F013B rtmp://119.63.47.233:9945/proxypublish
		let roomData = DataCenterModel.sharedInstance.roomData;
		roomData.lastRtmpUrl = notification.object as! String;
		lastRtmpUrl = roomData.rtmpPath;
		if (vc != nil)
		{
			vc?.close();
			vc?.view.removeFromSuperview();
			vc?.view.removeGestureRecognizer(ges!);
			vc = nil;
		}
		if (lastRtmpUrl.containsString("rtmp"))
		{
			print("rtmp filepath=\(lastRtmpUrl)");
			let parametersD = NSMutableDictionary();
			parametersD[KxMovieParameterMinBufferedDuration] = 2;
			parametersD[KxMovieParameterMaxBufferedDuration] = 10;
			vc = KxMovieViewController.movieViewControllerWithContentPath(lastRtmpUrl, parameters: parametersD as [NSObject: AnyObject]) as? KxMovieViewController ;
			vc!.view.frame = CGRectMake(0, 0, self.view.width, self.view.width * 3 / 4)
			self.view.addSubview(vc!.view);
			self.view.bringSubviewToFront(vc!.view);
			self.view.bringSubviewToFront(backBtn);
			vc!.view.addGestureRecognizer(ges!);
		}
		else {
			showSimplpAlertView(self, tl: "主播已停止直播", msg: "请选择其他房间试试！", btnHiht: "了解");
		}
	}

	// 隐藏聊天输入内容
	func onTableVieo()
	{
		chatVc?.cancelFocus();
	}

	func backBtnClick() {
		self.navigationController?.popViewControllerAnimated(true);
		self.navigationController?.setNavigationBarHidden(false, animated: false);
		chatVc?.sendBlock = nil;
	}

	@IBAction func obClick(sender: AnyObject) {

	}

}
