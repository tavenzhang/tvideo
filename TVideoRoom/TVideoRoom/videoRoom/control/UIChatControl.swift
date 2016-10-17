

import UIKit
import SnapKit

class UIChatControl: UIViewController {

	var chatVc: TChatViewControl?;
	var giftVc: GiftViewControl?;

	var isShowGift: Bool = false;

	override func viewDidLoad() {
		super.viewDidLoad();
		addNSNotification();
		initView();
	}

	deinit {
		NotificationCenter.default.removeObserver(self);
		chatVc?.sendBlock = nil;
	}

	func addNSNotification() {
		NotificationCenter.default.addObserver(self, selector: #selector(self.chatReceiveMessage30001), name: NSNotification.Name(rawValue: E_SOCKERT_Chat_30001), object: nil);
	}

	func initView() {
		chatVc = TChatViewControl();
		chatVc!.view.frame = CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height);
		chatVc?.view.backgroundColor = UIColor.clear;
		chatVc?.sendBlock = chatSendChatMessage;
		view?.addSubview(chatVc!.view);
		chatVc?.view.backgroundColor = ROOM_SCROOL_BG_COLOR;
		giftVc = GiftViewControl();
		view?.addSubview(giftVc!.view);
		// giftVc?.view.frame = CGRectMake(0, self.view.height, self.view.width, 200)
		giftVc?.view.snp_makeConstraints { (make) in
			make.bottom.equalTo(self.view.snp_bottom);
			make.width.equalTo(self.view);
			make.height.equalTo(210);
		}
		chatVc?.chatGiftBlock = clickGiftBtnHandle;
		chatVc?.chatCancelBlock = chatCancel;
		giftVc?.view.isHidden = true;
//		let msgVo = ChatMessage();
//		msgVo.sendName = "小兰提醒";
//		msgVo.content = "视频顿不流程，或者出现openfire，请尝试一下切换线路！";
//		msgVo.isSender = false;
//		msgVo.messageType = .text;
	}

	func clickGiftBtnHandle() {
		giftVc?.view.isHidden = false;
		self.giftVc?.view.top = self.view.height;
		UIView.animate(withDuration: 0.3, animations: {
			self.giftVc?.view.top = self.view.height - (self.giftVc?.view.height)!;
		})
	}

	func chatCancel() {
		// giftVc?.view.hidden = true;
		UIView.animate(withDuration: 0.3, animations: {
			self.giftVc?.view.top = self.view.height;
		})
	}

	func adjust(_ w: CGFloat, h: CGFloat) -> Void {
//		chatVc?.view.width = w;
//		chatVc?.view.height = h;
	}

	/**
     接收到聊天信息
     */
	func chatReceiveMessage30001(_ notification: Notification) {
		let message = notification.object as! ChatMessage;
		chatVc?.receiveMessage(message);
	}

	/**
     发送聊天消息
     */
	func chatSendChatMessage(_ msg: String!) -> Void {
//		let mees = ChatMessage();
//		mees.messageType = .Text;
//		mees.content = msg;
//		chatVc?.receiveMessage(mees);
		if (!DataCenterModel.isLogin)
		{
			showSimplpAlertView(self, tl: "", msg: "您还未登录不能发言", btnHiht: "登录", okHandle: { [weak self] in
				self?.tabBarController?.selectedIndex = 3;
				self?.navigationController?.popViewController(animated: true);
			})
		}
		else {
			let chatMsg = s_msg_30001(type: 0, ruid: 0, cnt: msg);
			SocketManager.sharedInstance.sendMessage(chatMsg);
		}
	}

}
