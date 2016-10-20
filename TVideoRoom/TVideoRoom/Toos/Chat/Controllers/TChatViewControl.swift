//
//  TChatViewControl.swift
//  TVideoRoom

import UIKit;
import SnapKit;



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
	var nsBund: Bundle!

	var keyBoardNeedLayout = true

	var curKeyBordType: KeyBoardType = .txtBoard;

	var chatGiftBlock: ChatGiftBlock?;

	var chatCancelBlock: ChatGiftBlock?;

	override func viewDidLoad() {
		self.view.autoresizesSubviews = false
		initView();
		self.view.backgroundColor = UIColor.white;
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
		self.bottomView!.layer.borderColor = UIColor.gray.cgColor;
		bottomView?.snp.makeConstraints { (make) in
			make.height.equalTo(45);
			make.bottom.equalTo(self.view.snp.bottom);
			make.left.equalTo(-1);
			make.right.equalTo(self.view.snp.right).offset(1);
		}
		// 强制先渲染一下

		self.tableView = UITableView();
		self.tableView?.delegate = self;
		self.tableView?.dataSource = self;
		self.tableView!.separatorStyle = .none
		self.tableView!.backgroundColor = UIColor.gray;
		self.view.addSubview(tableView!);
		self.tableView!.showsVerticalScrollIndicator = false
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.cancelFocus))
		self.tableView!.addGestureRecognizer(tapGesture);
		self.tableView!.backgroundColor = UIColor.clear;
		self.view.addSubview(self.tableView!);
		self.tableView!.snp.makeConstraints { (make) in
			make.width.equalTo(self.view.width);
			make.top.equalTo(self.view.snp.top);
			make.bottom.equalTo(self.bottomView!.snp.top);
		}

		self.view.layoutIfNeeded()
		self.textField = UITextField();
		self.textField?.returnKeyType = .send;
		self.textField!.delegate = self;
		self.bottomView!.addSubview(textField!);
		self.textField?.text = "";
		self.textField?.placeholder = " 在这里互动吧！"
		self.textField?.layer.cornerRadius = 5;
		self.textField?.layer.borderWidth = 1;
		self.textField?.layer.borderColor = UIColor.gray.cgColor;
		self.textField?.layer.masksToBounds = true;

		self.bottomView!.addSubview(faceTield);
		self.bottomView!.addSubview(textField!);

		faceTield.isHidden = true;
		textField?.snp.makeConstraints { (make) in
			make.centerX.equalTo(self.bottomView!).offset(-5);
			make.centerY.equalTo(self.bottomView!);

			make.width.equalTo(self.view.snp.width).offset(-85);
			make.height.equalTo(30);

		}

		let giftImage = UIImage(named: "giftBtnNew");
		btnGift = UIButton.BtnSimple("", titleColor: UIColor.clear, image: giftImage, hightLightImage: giftImage, target: self, action: #selector(self.giftClick));
		// btnGift?.backgroundColor = UIColor.red;
		// self.btnGift?.imageView?.contentMode = .;
		self.btnGift?.scale(2, ySclae: 2);
		self.bottomView!.addSubview(btnGift!);
		//self.bottomView!.backgroundColor = UIColor.brown;
		self.btnGift?.snp.makeConstraints({ (make) in
			make.width.height.equalTo(40);
			make.left.equalTo((self.textField?.snp.right)!).offset(10);
			make.centerY.equalTo(self.bottomView!);
		})

		let faceImage = UIImage(named: "facebtn");
		btnFace = UIButton.BtnSimple("", titleColor: UIColor.clear, image: faceImage, hightLightImage: faceImage, target: self, action: #selector(self.emtionClick));
		self.bottomView!.addSubview(btnFace!);

		btnFace?.snp.makeConstraints({ (make) in
			make.right.equalTo((self.textField?.snp.left)!).offset(-5);
			make.centerY.equalTo(self.bottomView!);
		})

		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil);
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil);

	}

	func giftClick() {
		if (chatGiftBlock != nil)
		{
			chatGiftBlock!();
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil);
	}

	// 接收 消息格式

	func receiveMessage(_ msg: ChatMessage) {
		messages.append(msg)
		tableView!.reloadData()
		self.tableViewScrollToBottom()
	}

	// 发送消息
	func sendMessage(_ text: String) {

		let textNew = text.trimmingCharacters(in: CharacterSet.whitespaces);
		if textNew.characters.count == 0 {
			return
		}
		if sendBlock != nil {
			sendBlock!(textNew);
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
		let numberOfRows = tableView!.numberOfRows(inSection: numberOfSections - 1)
		if numberOfRows > 0 {
			let indexPath = IndexPath(row: numberOfRows - 1, section: (numberOfSections - 1))
			tableView!.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
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
					let appendText = text! + faceName
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

	func textFieldDidBeginEditing(_ textField: UITextField) // became first responder
	{
		curKeyBordType = .txtBoard;
	}
	// MARK: - UITextFieldDelegate 关闭键盘;
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.sendMessage(textField.text!)
		return true
	}

	// MARK: - Notification event
	func keyboardWillShow(_ notification: Notification) {

		if (curKeyBordType == .txtBoard)
		{
			UIView.animate(withDuration: 0.5, animations: {
				self.view.frame = CGRect(x: 0, y: -258, width: self.view.bounds.width, height: self.view.bounds.height)
				self.keyBoardNeedLayout = false
				self.view.layoutIfNeeded()
			});
		}
		else {
			UIView.animate(withDuration: 0.5, animations: {
				self.view.frame = CGRect(x: 0, y: -185, width: self.view.bounds.width, height: self.view.bounds.height)
				self.keyBoardNeedLayout = false
				self.view.layoutIfNeeded()
			})
		}
	}
	// 键盘闭合
	func keyboardWillHide(_ notification: Notification) {
		if let userInfo = (notification as NSNotification).userInfo,
			let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
			let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
			let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {

				let frame = value.cgRectValue
				let intersection = frame.intersection(self.view.frame)

				let deltaY = intersection.height

				UIView.animate(withDuration: duration, delay: 0.0,
					options: UIViewAnimationOptions(rawValue: curve),
					animations: { _ in
						self.view.frame = CGRect(x: 0, y: deltaY, width: self.view.bounds.width, height: self.view.bounds.height)
						self.keyBoardNeedLayout = true
						self.view.layoutIfNeeded()
					}, completion: nil);
		}
	}
}

extension TChatViewControl: UITableViewDataSource, UITableViewDelegate
{

	// MARK: - UITableViewDataSource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		LogHttp("message counet=%d", args: [messages.count])
		return messages.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = ChatCell.cellWithTableView(tableView)
		cell.message = messages[(indexPath as NSIndexPath).row]
		return cell
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let message = messages[(indexPath as NSIndexPath).row]
		return ChatCell.heightOfCellWithMessage(message)
	}
}
