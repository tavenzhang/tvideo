//
//  VideoRoomUIView.swift
//  TVideoRoom
//
import UIKit
import TRtmpPlay
import SnapKit

class VideoRoomUIViewVC: UIViewController, UIScrollViewDelegate {

	fileprivate var uiVideoControl: UIVideoPlayControl?;

	var menuBar: RoomMenuBar?;
	fileprivate var ges: UITapGestureRecognizer?;
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
		let backBtn2 = UIButton(type: UIButtonType.custom)
		backBtn2.setImage(UIImage(named: r_nav_btnBack_9x16), for: UIControlState());
		backBtn2.titleLabel?.isHidden = true
		backBtn2.addTarget(self, action: #selector(VideoRoomUIViewVC.backBtnClick), for: .touchUpInside)
		backBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
		backBtn2.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
		let btnW: CGFloat = ScreenWidth > 375.0 ? 50 : 44
		backBtn2.frame = CGRect(x: 20, y: 10, width: btnW, height: 40);
		return backBtn2
	}();

	override func viewDidLoad() {
		addNSNotification();
		self.view.frame = ScreenBounds;
		self.view.backgroundColor = UIColor.white;
		self.navigationController?.setNavigationBarHidden(true, animated: false);
		let height = self.view.width * 3 / 4;
		let vWidth = self.view.width;

		scrollView = UIScrollView(frame: UIScreen.main.bounds);
		self.automaticallyAdjustsScrollViewInsets = false;
		scrollView!.contentSize = CGSize(width: ScreenWidth * 3, height: 0);
		scrollView!.backgroundColor = UIColor.white
		// 去掉滚动条
		scrollView!.showsVerticalScrollIndicator = false
		scrollView!.showsHorizontalScrollIndicator = false
		// 去掉滚动条

		// 设置分页
		scrollView!.isPagingEnabled = true
		// 设置代理
		scrollView!.delegate = self
		// 去掉弹簧效果
		scrollView!.bounces = false

		uiVideoControl = UIVideoPlayControl();
		self.addChildViewController(uiVideoControl!);
		menuBar = RoomMenuBar(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 30));
		menuBar?.regMenuTabClick({ [weak self](type: Int) -> Void in
			self?.scrollView!.setContentOffset(CGPoint(x: CGFloat(type) * ScreenWidth, y: 0), animated: true)
		})
		self.view.addSubview(uiVideoControl!.view);
		self.view.addSubview(menuBar!);
		self.view.addSubview(backBtn);
		self.view.addSubview(scrollView!);
		uiVideoControl!.view.snp.makeConstraints { (make) in
			make.width.equalTo(vWidth);
			make.height.equalTo(height);
			make.top.equalTo(self.view.snp.top);
		}
		menuBar?.snp.makeConstraints { (make) in
			make.width.equalTo(vWidth);
			make.height.equalTo(30);
			make.top.equalTo(uiVideoControl!.view.snp.bottom);
		}
		scrollView!.snp.makeConstraints { (make) in
			make.top.equalTo((menuBar?.snp.bottom)!);
			make.bottom.equalTo(self.view.snp.bottom);
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
		giftControl?.view.x = ScreenWidth * 2;

		rankViewControl = RankGiftViewControl();
		self.addChildViewController(rankViewControl!);
		scrollView!.addSubview((rankViewControl?.view)!);
		rankViewControl?.view.frame = scrollView!.frame;
		rankViewControl?.view.x = ScreenWidth ;
		c2sGetSocket(roomId);
		giftEffectView = GiftEffectVC();
		self.view.addSubview(giftEffectView!);
		giftEffectView?.snp.makeConstraints({ (make) in
			make.edges.equalTo(self.view);
		})

	}

	deinit {
		SocketManager.sharedInstance.closeSocket();
		NotificationCenter.default.removeObserver(self);
		uiVideoControl = nil;
	}

// 隐藏状态栏
	override var prefersStatusBarHidden: Bool {

		return true;
	}

	override func viewDidAppear(_ animated: Bool) {

	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func addNSNotification() {
		NotificationCenter.default.addObserver(self, selector: #selector(self.onGiftEffectStart), name: NSNotification.Name(rawValue: GIFT_EFFECT_START), object: nil);
	}

	// 开始播放动画
	func onGiftEffectStart(_ notice: Notification) {
		let data = notice.object as! GiftInfoModel;
		giftEffectView?.addEffectGift(data);
	}

// 测速并连接socket
	fileprivate func c2sGetSocket(_ roomId: Int) {
		let pathHttp = NSString(format: HTTP_VIDEO_ROOM as NSString, roomId, "false") as String;
		DataCenterModel.sharedInstance.roomData.roomId = roomId;
		DispatchQueue.global(qos: .default).async {
			HttpTavenService.requestJson(pathHttp) {
				(dataResutl: HttpResult) in
				if (dataResutl.isSuccess)
				{
					if ((dataResutl.dataJson != nil) && (dataResutl.dataJson!["ret"].int == 1))
					{
						let serverStr = decodeAES(dataResutl.dataJson!["server"].string!) ;
						var serverList = serverStr.components(separatedBy: ",");
						if (DataCenterModel.sharedInstance.isOneRoom)
						{
							let port: Int = Int(serverStr.components(separatedBy: "|")[1])!;
							let str = serverStr.components(separatedBy: "|")[0];
							let ipList = str.components(separatedBy: ",");
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
		self.navigationController?.popViewController(animated: true);
		self.navigationController?.setNavigationBarHidden(false, animated: false);
	}

// 滚动scrollview
	func scrollViewDidScroll(_ scrollView: UIScrollView) {

		let page: CGFloat = scrollView.contentOffset.x / ScreenWidth
		if ((self.menuBar) != nil)
		{
			self.menuBar!.movebtnByTag(Int(page + 0.5)) ;
			// let offsetX: CGFloat = scrollView.contentOffset.x / ScreenWidth * (self.menuBar!.width * 0.5 - Home_Seleted_Item_W * 0.5 - 15)
			// self.menuBar!.setSelectedType(Int(page + 0.5)) ;
		}

	}

}
