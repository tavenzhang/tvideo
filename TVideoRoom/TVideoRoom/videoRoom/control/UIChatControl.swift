

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
		NSNotificationCenter.defaultCenter().removeObserver(self);
		chatVc?.sendBlock = nil;
	}

	func addNSNotification() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.chatReceiveMessage30001), name: E_SOCKERT_Chat_30001, object: nil);
	}

	func initView() {
		chatVc = TChatViewControl();
		chatVc!.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
		chatVc?.view.backgroundColor = UIColor.clearColor();
		chatVc?.sendBlock = chatSendChatMessage;
		view?.addSubview(chatVc!.view);
		chatVc?.view.backgroundColor = ROOM_SCROOL_BG_COLOR;
		giftVc = GiftViewControl();
		view?.addSubview(giftVc!.view);
		giftVc?.view.snp_makeConstraints(closure: { (make) in
			make.bottom.equalTo(self.view.snp_bottom);
			make.width.equalTo(self.view);
			make.height.equalTo(200);
		})
		chatVc?.chatGiftBlock = clickGiftBtnHandle;
		chatVc?.chatCancelBlock = chatCancel;
		giftVc?.view.hidden = true;
		// view?.backgroundColor = UIColor.blueColor();
	}

	func clickGiftBtnHandle() {
		giftVc?.view.hidden = false;
	}

	func chatCancel() {
		giftVc?.view.hidden = true;
	}

	func adjust(w: CGFloat, h: CGFloat) -> Void {
		chatVc?.view.width = w;
		chatVc?.view.height = h;
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
		let mees = ChatMessage();
		mees.messageType = .Text;
		mees.content = msg;
		chatVc?.receiveMessage(mees);
//		if (DataCenterModel.sharedInstance.roomData.key == "")
//		{
//			showSimplpAlertView(self, tl: "error", msg: "您还未登录不能发言", btnHiht: "登录", okHandle: {
//				self.tabBarController?.selectedIndex = 3;
//			})
//		}
//		else {
//			let chatMsg = s_msg_30001(type: 0, ruid: 0, cnt: msg);
//			SocketManager.sharedInstance.sendMessage(chatMsg);
//		}
	}

}
