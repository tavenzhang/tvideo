//
//  VideoRoomUIView.swift
//  TVideoRoom
//
import UIKit
import TRtmpPlay
import SnapKit

class VideoRoomUIViewVC: UIViewController, UIScrollViewDelegate {

	private var uiVideoControl: UIVideoPlayControl?;

	var menuBar: RoomMenuBar?;
	private var ges: UITapGestureRecognizer?;
	var roomId: Int = 0;
	var lastRtmpUrl: String = "";
	// 滚动ui
	var scrollView: UIScrollView?;

	var changeLineBtn: UIButton?;

	var uiChatVC: UIChatControl?;

	var giftControl: PlayeListViewControl?;

	var rankViewControl: RankGiftViewControl?;

	var giftEffectView: GiftEffectVC?;

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

	override func viewDidLoad() {
		addNSNotification();
		self.view.frame = ScreenBounds;
		self.view.backgroundColor = UIColor.whiteColor();
		self.navigationController?.setNavigationBarHidden(true, animated: false);
		let height = self.view.width * 3 / 4;
		let vWidth = self.view.width;

		scrollView = UIScrollView(frame: UIScreen.mainScreen().bounds);
		self.automaticallyAdjustsScrollViewInsets = false;
		scrollView!.contentSize = CGSizeMake(ScreenWidth * 3, 0);
		scrollView!.backgroundColor = UIColor.whiteColor()
		// 去掉滚动条
		scrollView!.showsVerticalScrollIndicator = false
		scrollView!.showsHorizontalScrollIndicator = false
		// 去掉滚动条

		// 设置分页
		scrollView!.pagingEnabled = true
		// 设置代理
		scrollView!.delegate = self
		// 去掉弹簧效果
		scrollView!.bounces = false

		uiVideoControl = UIVideoPlayControl();
		self.addChildViewController(uiVideoControl!);
		menuBar = RoomMenuBar(frame: CGRectMake(0, 0, self.view.width, 30));
		menuBar?.regMenuTabClick({ [weak self](type: Int) -> Void in
			self?.scrollView!.setContentOffset(CGPointMake(CGFloat(type) * ScreenWidth, 0), animated: true)
		})
		self.view.addSubview(uiVideoControl!.view);
		self.view.addSubview(menuBar!);
		self.view.addSubview(backBtn);
		self.view.addSubview(scrollView!);
		uiVideoControl!.view.snp_makeConstraints { (make) in
			make.width.equalTo(vWidth);
			make.height.equalTo(height);
			make.top.equalTo(self.view.snp_top);
		}
		menuBar?.snp_makeConstraints { (make) in
			make.width.equalTo(vWidth);
			make.height.equalTo(30);
			make.top.equalTo(uiVideoControl!.view.snp_bottom);
		}
		scrollView!.snp_makeConstraints { (make) in
			make.top.equalTo((menuBar?.snp_bottom)!);
			make.bottom.equalTo(self.view.snp_bottom);
			make.width.equalTo(vWidth);
		}

		menuBar?.changeBtnClick = uiVideoControl?.showChangSheetView;
		ges = UITapGestureRecognizer(target: self, action: #selector(onTableVieo));
		// self.view.addGestureRecognizer(ges!);

		uiChatVC = UIChatControl();
		self.addChildViewController(uiChatVC!);
		// var frme =  scrollView!.frame;
		uiChatVC?.view.frame = scrollView!.frame;
		scrollView!.addSubview((uiChatVC?.view)!);
		uiChatVC?.view.frame = scrollView!.frame;
		uiChatVC?.view.x = 0;

		giftControl = PlayeListViewControl();
		self.addChildViewController(giftControl!);
		scrollView!.addSubview((giftControl?.view)!);
		giftControl?.view.frame = scrollView!.frame;
		giftControl?.view.x = ScreenWidth;

		rankViewControl = RankGiftViewControl();
		self.addChildViewController(rankViewControl!);
		scrollView!.addSubview((rankViewControl?.view)!);
		rankViewControl?.view.frame = scrollView!.frame;
		rankViewControl?.view.x = ScreenWidth * 2;
		c2sGetSocket(roomId);
		giftEffectView = GiftEffectVC();
		self.view.addSubview(giftEffectView!);
		giftEffectView?.snp_makeConstraints(closure: { (make) in
			make.edges.equalTo(self.view);
		})

	}

	deinit {
		SocketManager.sharedInstance.closeSocket();
		NSNotificationCenter.defaultCenter().removeObserver(self);
		uiVideoControl = nil;
	}

// 隐藏状态栏
	override func prefersStatusBarHidden() -> Bool {

		return true;
	}

	override func viewDidAppear(animated: Bool) {

	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func addNSNotification() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onGiftEffectStart), name: GIFT_EFFECT_START, object: nil);
	}

	// 开始播放动画
	func onGiftEffectStart(notice: NSNotification) {
		let data = notice.object as! GiftInfoModel;
		giftEffectView?.addEffectGift(data);
	}

// 测速并连接socket
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

// 隐藏聊天输入内容
	func onTableVieo()
	{
		uiChatVC?.chatVc?.cancelFocus();
	}

	func backBtnClick() {
		self.navigationController?.popViewControllerAnimated(true);
		self.navigationController?.setNavigationBarHidden(false, animated: false);
	}

// 滚动scrollview
	func scrollViewDidScroll(scrollView: UIScrollView) {

		let page: CGFloat = scrollView.contentOffset.x / ScreenWidth
		if ((self.menuBar) != nil)
		{
			self.menuBar!.movebtnByTag(Int(page + 0.5)) ;
			// let offsetX: CGFloat = scrollView.contentOffset.x / ScreenWidth * (self.menuBar!.width * 0.5 - Home_Seleted_Item_W * 0.5 - 15)
			// self.menuBar!.setSelectedType(Int(page + 0.5)) ;
		}

	}

}
