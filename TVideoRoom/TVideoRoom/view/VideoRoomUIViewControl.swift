//
//  VideoRoomUIView.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/6/26.
//  Copyright © 2016年 张新华. All rights reserved.
//
import UIKit
import TRtmpPlay
import TChat

class VideoRoomUIView: UIViewController {
	private var vc: KxMovieViewController?;
	private var chatVc: ChatViewController?;
	private var _uiChatView: UIView?;
	private var ges: UITapGestureRecognizer?;
	var roomId: Int = 0;

	lazy var backBtn: UIButton = {
		// 设置返回按钮属性
		let backBtn2 = UIButton(type: UIButtonType.Custom)
		backBtn2.setImage(UIImage(named: "v2_goback"), forState: .Normal);
		backBtn2.titleLabel?.hidden = true
		backBtn2.addTarget(self, action: #selector(VideoRoomUIView.backBtnClick), forControlEvents: .TouchUpInside)
		backBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
		backBtn2.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
		let btnW: CGFloat = ScreenWidth > 375.0 ? 50 : 44
		backBtn2.frame = CGRectMake(20, 10, btnW, 40);
		return backBtn2
	}()

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

	}

	// 隐藏状态栏
	override func prefersStatusBarHidden() -> Bool {

		return true;
	}

	deinit {
		SocketManager.sharedInstance.closeSocket();
		NSNotificationCenter.defaultCenter().removeObserver(self);
		vc = nil;
	}

	override func viewDidAppear(animated: Bool) {

	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func addNSNotification() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VideoRoomUIView.rtmpStartPlay), name: RTMP_START_PLAY, object: nil);
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VideoRoomUIView.chatReceiveMessage30001), name: E_SOCKERT_Chat_30001, object: nil);
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
						let serverList = serverStr.componentsSeparatedByString(",");
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
		let path = notification.object as? String;
		let filePath = path! + " live=1";
		print("rtmp filepath=\(filePath)");
		let parametersD = NSMutableDictionary();
		parametersD[KxMovieParameterMinBufferedDuration] = 2;
		parametersD[KxMovieParameterMaxBufferedDuration] = 10;

		if ((vc) != nil)
		{
			vc?.close();
			vc!.view.removeGestureRecognizer(ges!);
			vc!.view.removeFromSuperview();
			vc = nil;
		}
		if ((path != nil) && (path != ""))
		{
			vc = KxMovieViewController.movieViewControllerWithContentPath(filePath, parameters: parametersD as [NSObject: AnyObject]) as? KxMovieViewController ;

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
