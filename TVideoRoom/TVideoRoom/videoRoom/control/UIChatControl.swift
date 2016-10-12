

import UIKit

class UIChatControl: UIViewController {

//	var chatVc: ChatViewController?;
//	var changeLineBtn: UIButton?;
//
//	override func viewDidLoad() {
//		super.viewDidLoad();
//		addNSNotification();
//		initView();
//	}
//
//	deinit {
//		NSNotificationCenter.defaultCenter().removeObserver(self);
//		chatVc?.sendBlock = nil;
//	}
//
//	func addNSNotification() {
//		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.chatReceiveMessage30001), name: E_SOCKERT_Chat_30001, object: nil);
//	}
//
//	func initView() {
//		chatVc = ChatViewController();
//		chatVc!.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
//		chatVc?.view.backgroundColor = UIColor.clearColor();
//		chatVc?.sendBlock = chatSendChatMessage;
//		view?.addSubview(chatVc!.view);
//		// view?.backgroundColor = UIColor.blueColor();
//	}
//
//	func adjust(w: CGFloat, h: CGFloat) -> Void {
//		chatVc!.adjust(self.view.width, h: h);
//
//	}
//
//	/**
//     接收到聊天信息
//     */
//	func chatReceiveMessage30001(notification: NSNotification) {
//		let message = notification.object as! ChatMessage;
//		chatVc?.receiveMessage(message);
//	}
//
//	/**
//     发送聊天消息
//     */
//	func chatSendChatMessage(msg: String!) -> Void {
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
//	}

}
