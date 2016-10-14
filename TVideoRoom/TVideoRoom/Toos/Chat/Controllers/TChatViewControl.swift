//
//  TChatViewControl.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/10/12.
//  Copyright © 2016年 张新华. All rights reserved.
//

import UIKit;
import SnapKit;

typealias SendMessageBlock = (msg: String) -> Void
typealias ChatGiftBlock = () -> Void

enum KeyBoardType: Int {
	case txtBoard
	case faceBoard
}

class TChatViewControl: UIViewController, UITextFieldDelegate {

	var tableView: UITableView?
	var bottomView: UIView?
	var textField: UITextField?;
	// 用于获取焦点但不显示
	var faceTield: UITextField = UITextField();

	var btnFace: UIButton?;

	var btnGift: UIButton?;
	/** 表情视图 */
	var faceView: YYFaceScrollView?

	var messages: [ChatMessage] = [ChatMessage]();

	var sendBlock: SendMessageBlock?;

	var isShowFace = false
	var nsBund: NSBundle!

	var keyBoardNeedLayout = true

	var curKeyBordType: KeyBoardType = .txtBoard;

	var chatGiftBlock: ChatGiftBlock?;

	var chatCancelBlock: ChatGiftBlock?;

	override func viewDidLoad() {
		self.view.autoresizesSubviews = false
		initView();
		self.view.backgroundColor = UIColor.whiteColor();
	}
	deinit {
		chatGiftBlock = nil;
		chatCancelBlock = nil;

	}

	func initView() {
		// 加载历史聊天记录
		self.bottomView = UIView();
		self.view.addSubview(bottomView!);
		self.bottomView!.layer.borderWidth = 1;
		self.bottomView!.layer.borderColor = UIColor.grayColor().CGColor;
		bottomView?.snp_makeConstraints { (make) in
			// make.width.equalTo(self.view.snp_width).offset(2);
			make.height.equalTo(45);
			make.bottom.equalTo(self.view.snp_bottom);
			make.left.equalTo(-1);
			make.right.equalTo(self.view.snp_right).offset(1);
		}
		self.tableView = UITableView();
		self.tableView?.delegate = self;
		self.tableView?.dataSource = self;
		self.tableView!.separatorStyle = .None
		self.tableView!.backgroundColor = UIColor.grayColor();
		self.view.addSubview(tableView!);
		self.tableView!.showsVerticalScrollIndicator = false
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.cancelFocus))
		self.tableView!.addGestureRecognizer(tapGesture);
		self.tableView!.backgroundColor = UIColor.clearColor();
		self.view.addSubview(self.tableView!);
		self.tableView!.snp_makeConstraints { (make) in
			make.width.equalTo(self.view.width);
			make.top.equalTo(self.view.snp_top);
			make.bottom.equalTo(self.bottomView!.snp_top);
		}

		let giftImage = UIImage.resizableImageWithName("giftBtnNew");
		btnGift = UIButton.BtnSimple("", titleColor: UIColor.clearColor(), image: giftImage, hightLightImage: giftImage, target: self, action: #selector(self.giftClick));

		self.btnGift?.scale(2, ySclae: 2);
		self.bottomView!.addSubview(btnGift!);
		self.btnGift?.snp_makeConstraints(closure: { (make) in
			make.right.equalTo(self.bottomView!.snp_right).offset(-10);
			make.centerY.equalTo(self.bottomView!);
		})
		let faceImage = UIImage(named: "facebtn");
		btnFace = UIButton.BtnSimple("", titleColor: UIColor.clearColor(), image: faceImage, hightLightImage: faceImage, target: self, action: #selector(self.emtionClick));
		self.bottomView!.addSubview(btnFace!);
		// 强制先渲染一下
		self.view.layoutIfNeeded()
		btnFace?.snp_makeConstraints(closure: { (make) in
			make.left.equalTo(self.bottomView!.snp_left).offset(10);
			make.centerY.equalTo(self.bottomView!);
		})

		self.textField = UITextField();
		self.textField?.returnKeyType = .Send;
		self.textField!.delegate = self;
		self.bottomView!.addSubview(textField!);
		self.textField?.text = "";
		self.textField?.placeholder = " 在这里互动吧！"
		self.textField?.layer.cornerRadius = 5;
		self.textField?.layer.borderWidth = 1;
		self.textField?.layer.borderColor = UIColor.grayColor().CGColor;
		self.textField?.layer.masksToBounds;

		self.bottomView!.addSubview(faceTield);
		self.bottomView!.addSubview(textField!);
		faceTield.hidden = true;
		textField?.snp_makeConstraints(closure: { (make) in
			make.left.equalTo((btnFace?.snp_right)!).offset(12);
			make.centerY.equalTo(0);
			make.right.equalTo((btnGift?.snp_left)!).offset(-20);
			make.height.equalTo(30);
		})
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil);
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil);

	}

	func giftClick() {
		if (chatGiftBlock != nil)
		{
			chatGiftBlock!();
		}
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil);
	}

	// 接收 消息格式

	func receiveMessage(msg: ChatMessage) {
		messages.append(msg)
		tableView!.reloadData()
		self.tableViewScrollToBottom()
	}

	// 发送消息
	func sendMessage(text: String) {

		let textNew = text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet());
		if textNew.characters.count == 0 {
			return
		}
		if sendBlock != nil {
			sendBlock!(msg: textNew);
		}
		else {
			let chatMessage = ChatMessage()
			chatMessage.isSender = true
			chatMessage.sendName = "我"
			chatMessage.content = text
			// [chatMessage save];
			messages.append(chatMessage)
			tableView!.reloadData()
			self.tableViewScrollToBottom()
		}
		self.textField!.text = nil
		cancelFocus();
	}

	/** 取消事件的焦点 */
	func cancelFocus() {
		self.textField!.resignFirstResponder()
		self.textField!.inputView = nil;
		self.faceTield.resignFirstResponder();
		if (chatCancelBlock != nil)
		{
			chatCancelBlock!();
		}
	}
	/**滚动table 到底部*/
	func tableViewScrollToBottom() {
		let numberOfSections = tableView!.numberOfSections
		let numberOfRows = tableView!.numberOfRowsInSection(numberOfSections - 1)
		if numberOfRows > 0 {
			let indexPath = NSIndexPath(forRow: numberOfRows - 1, inSection: (numberOfSections - 1))
			tableView!.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
		}
	}

	func emtionClick() {

		if curKeyBordType == .faceBoard {
			curKeyBordType = .txtBoard;
			textField?.becomeFirstResponder();
		}
		else {
			if faceView == nil {
				weak var this = self
				self.faceView = YYFaceScrollView(selectBlock: { (faceName: String) -> Void in
					let text = this!.textField!.text
					let appendText = text!.stringByAppendingString(faceName)
					this?.textField!.text = appendText
				})
				self.faceView?.backgroundColor = UIColor.colorWithCustom(220, g: 220, b: 220, a: 1) ;
				// self.faceView.top = viewHeight
				self.faceView?.clipsToBounds = false
				self.faceView?.sendBlock = { () -> Void in
					let fullText = this!.textField!.text
					this?.sendMessage(fullText!)
					this?.cancelFocus()
				}
			}
			curKeyBordType = .faceBoard;
			faceTield.inputView = faceView;
			faceTield.reloadInputViews();
			faceTield.becomeFirstResponder();
		}
	}

	func textFieldDidBeginEditing(textField: UITextField) // became first responder
	{
		curKeyBordType = .txtBoard;
	}
	// MARK: - UITextFieldDelegate 关闭键盘;
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		self.sendMessage(textField.text!)
		return true
	}

	// MARK: - Notification event
	func keyboardWillShow(notification: NSNotification) {

		if (curKeyBordType == .txtBoard)
		{
//			if let userInfo = notification.userInfo,
//				value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
//				duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
//				curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
//					let frame = value.CGRectValue()
//					let intersection = CGRectIntersection(frame, self.view.frame)
//
//					let deltaY = CGRectGetHeight(intersection)
//					LogHttp("keyboardWillShow--\(deltaY)")
//					if keyBoardNeedLayout {
//						UIView.animateWithDuration(duration, delay: 0.0,
//							options: UIViewAnimationOptions(rawValue: curve),
//							animations: { _ in
//								self.view.frame = CGRectMake(0, -deltaY, self.view.bounds.width, self.view.bounds.height)
//								self.keyBoardNeedLayout = false
//								self.view.layoutIfNeeded()
//							}, completion: { (finished: Bool) -> Void in
//								self.tableViewScrollToBottom()
//						})
//					}
//			}
			UIView.animateWithDuration(0.5, animations: {
				self.view.frame = CGRectMake(0, -258, self.view.bounds.width, self.view.bounds.height)
				self.keyBoardNeedLayout = false
				self.view.layoutIfNeeded()
			});
		}
		else {
			UIView.animateWithDuration(0.5, animations: {
				self.view.frame = CGRectMake(0, -185, self.view.bounds.width, self.view.bounds.height)
				self.keyBoardNeedLayout = false
				self.view.layoutIfNeeded()
			})
		}
	}
	// 键盘闭合
	func keyboardWillHide(notification: NSNotification) {
		if let userInfo = notification.userInfo,
			value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
			duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
			curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {

				let frame = value.CGRectValue()
				let intersection = CGRectIntersection(frame, self.view.frame)

				let deltaY = CGRectGetHeight(intersection)

				UIView.animateWithDuration(duration, delay: 0.0,
					options: UIViewAnimationOptions(rawValue: curve),
					animations: { _ in
						self.view.frame = CGRectMake(0, deltaY, self.view.bounds.width, self.view.bounds.height)
						self.keyBoardNeedLayout = true
						self.view.layoutIfNeeded()
					}, completion: nil);
		}
	}
}

extension TChatViewControl: UITableViewDataSource, UITableViewDelegate
{

	// MARK: - UITableViewDataSource
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		LogHttp("message counet=%d", args: [messages.count])
		return messages.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = ChatCell.cellWithTableView(tableView)
		cell.message = messages[indexPath.row]
		return cell
	}

	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		let message = messages[indexPath.row]
		return ChatCell.heightOfCellWithMessage(message)
	}
}