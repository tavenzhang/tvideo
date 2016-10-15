//
//  GiftViewControl.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/10/7.
//  Copyright © 2016年 张新华. All rights reserved.
//

import UIKit
import SnapKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
	switch (lhs, rhs) {
	case let (l?, r?):
		return l < r
	case (nil, _?):
		return true
	default:
		return false
	}
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
	switch (lhs, rhs) {
	case let (l?, r?):
		return l <= r
	default:
		return !(rhs < lhs)
	}
}
;

class GiftViewControl: UIViewController {

	fileprivate var giftCollectionView: LFBCollectionView!;
	var giftDataList: [GiftDetailModel] = [];
	var dataRoom: RoomData?;
	// 礼物数量选择
	var chooseView: GiftNumChooseViewController?;
	var curShopNum: Int = 1;
	var curSelectGift: GiftDetailModel?;
	var giftMenuBar: TabBarMenu?;
	override func viewDidLoad() {
		addNSNotification();
		dataRoom = DataCenterModel.sharedInstance.roomData;
		buildCollectionView();
		buildGiftSendBar();
		prepareData();
		self.view.backgroundColor = UIColor.white;
		self.view.height = 20;
	}

	deinit {
		giftMenuBar = nil;
		NotificationCenter.default.removeObserver(self);
	}

	func addNSNotification() {
		NotificationCenter.default.addObserver(self, selector: #selector(self.moneyChangeHandle), name: NSNotification.Name(rawValue: MONEY_CHANGE), object: nil);
	}

	func prepareData() {
		if (dataRoom?.giftDataManager.count <= 0) {
			HttpTavenService.requestJson(getVHttp(HTTP_GIFT_Table), completionHadble: { [weak self](dataResult) in
				if (dataResult.isSuccess)
				{
					if (dataResult.dataJson != nil)
					{
						let dataList = dataResult.dataJson?.array;
						self!.dataRoom?.giftDataManager = [GiftCateoryModel]();

						if (dataList?.count)! > 0 {
							for item in dataList! {
								let model: GiftCateoryModel = deserilObjectWithDictonary(item.dictionaryObject! as NSDictionary, cls: GiftCateoryModel.classForCoder()) as! GiftCateoryModel;
								self!.dataRoom?.giftDataManager.append(model);
							}
						}
					}
				}
				self?.buildGiftMenuBar();
			})
		}
		else {
			buildGiftMenuBar()
		}
	}

	// 建立菜单
	func buildGiftMenuBar() {
		var menuNameList = [String]();
		for item in (dataRoom?.giftDataManager)!
		{
			menuNameList.append(item.name);
		}
		giftMenuBar = TabBarMenu();
		self.view.addSubview(giftMenuBar!);
		giftMenuBar?.snp.makeConstraints { (make) in
			make.bottom.equalTo(giftCollectionView.snp.top);
			make.height.equalTo(25);
			make.width.equalTo(self.view.width * 3 / 4);
		}
		self.view.layoutIfNeeded();
		giftMenuBar?.creatBtnByList(menuNameList, txtSize: 14, color: UIColor.colorWithCustom(225, g: 50, b: 125), underLinColor: UIColor.gray);
		giftMenuBar?.regClickHandle({ [weak self](tag) in
			let index = Int(tag);
			self?.giftDataList = (self?.dataRoom?.giftDataManager[index].items)!;
			LogHttp("giftDataList------\(self!.giftDataList)");
			self?.giftCollectionView.reloadData();
			let attStr = NSMutableAttributedString(string: "礼物: ");
			self?.txtChangeLB?.attributedText = attStr;
			self?.curSelectGift = nil;
		})
		if ((self.dataRoom?.giftDataManager.count)! > 0)
		{
			self.giftDataList = (self.dataRoom?.giftDataManager[0].items)!;
			self.giftCollectionView.reloadData();
		}
	}

	// 建立集合
	func buildCollectionView() -> Void {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal;
		layout.minimumInteritemSpacing = 0;
		layout.minimumLineSpacing = -1;
		layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
		giftCollectionView = LFBCollectionView(frame: CGRect(x: 0, y: self.view.width, width: self.view.width, height: 150), collectionViewLayout: layout)
		giftCollectionView.delegate = self
		giftCollectionView.dataSource = self
		giftCollectionView.showsHorizontalScrollIndicator = false;
		giftCollectionView.backgroundColor = LFBGlobalBackgroundColor;
		giftCollectionView.register(GiftShopCell.self, forCellWithReuseIdentifier: "Cell");
		view.addSubview(giftCollectionView);

		giftCollectionView.snp_makeConstraints { (make) in
			make.bottom.equalTo(self.view.snp_bottom).offset(-35);
			make.width.equalTo(self.view.width);
			make.height.equalTo(141);
			make.left.equalTo(self.view.snp_left);
		}

	}

	var btnSend: UIButton?;
	var btnMoney: UIButton?;
	var txtChangeLB: UILabel?;
	var btnNum: UIButton?;
	var icoMoneImg: UIImageView?;

	func buildGiftSendBar() {
		btnMoney = UIButton.BtnSimple("充值 |", titleColor: UIColor.colorWithCustom(225, g: 50, b: 125), image: nil, hightLightImage: nil, target: self, action: #selector(self.c2sAddMoneyClick));
		// btnMoney!.backgroundColor = UIColor.colorWithCustom(225, g: 50, b: 125);
		// btnMoney!.layer.cornerRadius = 10;
		// btnMoney!.layer.masksToBounds = true;
		view.addSubview(btnMoney!);
		btnMoney!.snp_makeConstraints { (make) in
			make.bottom.equalTo(self.view.snp_bottom).offset(-5);
			make.left.equalTo(self.view.snp_left).offset(5);
			make.width.equalTo(60);
		}
		btnSend = UIButton.BtnSimple("赠送", titleColor: UIColor.white, image: nil, hightLightImage: nil, target: self, action: #selector(self.c2sSendGift));
		btnSend!.backgroundColor = UIColor.colorWithCustom(225, g: 50, b: 125);
		btnSend!.layer.cornerRadius = 10;
		btnSend!.layer.masksToBounds = true;
		view.addSubview(btnSend!);
		btnSend!.snp_makeConstraints { (make) in
			make.centerY.equalTo(btnMoney!.snp_centerY);
			make.right.equalTo(self.view.snp_right).offset(-5);
			make.width.equalTo(60);
		}

		btnNum = UIButton.BtnSimple("X1  >", titleColor: UIColor.brown, image: nil, hightLightImage: nil, target: self, action: #selector(self.showChooseView));
		// btnSend!.backgroundColor = UIColor.colorWithCustom(225, g: 50, b: 125);
		btnNum!.layer.borderWidth = 1;
		btnNum!.layer.borderColor = UIColor.gray.cgColor;
		btnNum!.layer.cornerRadius = 10;
		btnNum!.layer.masksToBounds = true;

		view.addSubview(btnNum!);
		btnNum!.snp_makeConstraints { (make) in
			make.centerY.equalTo(btnSend!.snp_centerY);
			make.right.equalTo(btnSend!.snp_left).offset(-5);
			make.width.equalTo(60);
		}

		txtChangeLB = UILabel.lableSimple("余额:", corlor: UIColor.black, size: 10);
		view.addSubview(txtChangeLB!);
		txtChangeLB!.snp_makeConstraints { (make) in
			make.centerY.equalTo(btnMoney!.snp_centerY);
			make.left.equalTo((self.btnMoney?.snp_right)!).offset(2);
			// make.width.equalTo(60);
		}
		icoMoneImg = UIImageView(image: UIImage(named: "money"));
		icoMoneImg?.scale(2, ySclae: 2);
		view.addSubview(icoMoneImg!);
		icoMoneImg!.snp_makeConstraints { (make) in
			make.centerY.equalTo(btnMoney!.snp_centerY);
			make.left.equalTo((txtChangeLB?.snp_right)!).offset(9);
		}
		chooseNumLB(1);
	}

	func c2sSendGift() {
		if (curSelectGift != nil && curShopNum > 0)
		{
			let totalMoney = (curSelectGift?.price?.intValue)! * curShopNum;
			if (totalMoney > DataCenterModel.sharedInstance.roomData.myMoney) {
				showSimplpAlertView(self, tl: "", msg: "您的余额不足无法赠送该礼物！")
			}
			else {
				let msg = s_msg_40001(gid: Int((curSelectGift?.gid)!), uid: DataCenterModel.sharedInstance.roomData.roomId, gnum: curShopNum);
				SocketManager.sharedInstance.socketM!.sendMessage(msg);
			}
			LogHttp("送礼物");
		}
		else {
			showSimplpAlertView(self, tl: "", msg: "请先选择礼物！")
		}
	}

	func c2sAddMoneyClick() {
		showSimplpAlertView(self, tl: "", msg: "手机充值暂未开放！")
	}

	func showChooseView() {
		if (chooseView == nil)
		{
			chooseView = GiftNumChooseViewController();
			chooseView?.callFun = chooseNumFuc;
		};
		chooseView!.preferredContentSize = CGSize(width: 150, height: 300)
		chooseView!.modalPresentationStyle = .popover;
		let pvc = chooseView!.popoverPresentationController! as UIPopoverPresentationController;
		pvc.permittedArrowDirections = .up;
		pvc.sourceView = btnNum;
		pvc.sourceRect = btnNum!.bounds;
		pvc.delegate = self;
		present(chooseView!, animated: true, completion: nil);
	}

	func chooseNumFuc(_ data: AnyObject?) {
		let model = data as! GiftChooseModel;
		chooseNumLB(model.data);
	}

	func chooseNumLB(_ num: Int) {
		curShopNum = num;
		btnNum?.setTitle("X\(num)  >", for: UIControlState());
	}

	func moneyChangeHandle(_ notice: Notification?) {
		let moneyNum = DataCenterModel.sharedInstance.roomData.myMoney;
		let attStr = NSMutableAttributedString(string: "余额: ");
		let attrDic = [NSForegroundColorAttributeName: UIColor.purple];
		let nameStr = NSAttributedString(string: moneyNum.description, attributes: attrDic);
		attStr.append(nameStr);
		self.txtChangeLB?.attributedText = attStr;
	}
}

extension GiftViewControl: UIPopoverPresentationControllerDelegate
{
	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle
	{
		return UIModalPresentationStyle.none;
	}

}

extension GiftViewControl: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return (giftDataList.count);
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! GiftShopCell
		cell.shopGiftModel = giftDataList[(indexPath as NSIndexPath).row];
		return cell;
	}

	// 设置item 宽
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		var itemSize = CGSize.zero
		itemSize = CGSize(width: 65, height: 70)
		return itemSize
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

		return CGSize.zero
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		return CGSize.zero
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let shopGiftModel = giftDataList[(indexPath as NSIndexPath).row];
		curSelectGift = shopGiftModel;
	}

}

