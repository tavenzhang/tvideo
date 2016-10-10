//
//  GiftViewControl.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/10/7.
//  Copyright © 2016年 张新华. All rights reserved.
//

import UIKit
import SnapKit;

class GiftViewControl: BaseUIViewController, SWComboxViewDelegate {

	private var flag: Int = -1
	private var collectionView: LFBCollectionView!
	private var lastContentOffsetY: CGFloat = 0;
	// 热播列表
	var dataRoom: RoomData?;
	var giftDataList: [GiftInfoModel] = [];

	override func viewDidLoad() {
		dataRoom = DataCenterModel.sharedInstance.roomData;
		buildCollectionView();
		prepareData();
		self.view.backgroundColor = UIColor.whiteColor();

	}

	deinit {

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

						if dataList?.count > 0 {
							for item in dataList! {
								let model: GiftCateoryModel = deserilObjectWithDictonary(item.dictionaryObject!, cls: GiftCateoryModel.classForCoder()) as! GiftCateoryModel;
								self!.dataRoom?.giftDataManager.append(model);
							}
						}

					}
				}
				self?.giftDataList = (self!.dataRoom?.giftDataManager[0].items)!;
				self?.collectionView.reloadData();
			})
		}
		else {
			self.giftDataList = (self.dataRoom?.giftDataManager[0].items)!;
			self.collectionView.reloadData();
		}
	}

	var btnSend: UIButton?;
	var btnMoney: UIButton?;
	var txtChangeLB: UILabel?;
	var containner1: UIView = UIView();
	// 建立集合
	func buildCollectionView() -> Void {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .Horizontal;
		layout.minimumInteritemSpacing = -1;
		layout.minimumLineSpacing = -2;
		layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
		// layout.headerReferenceSize = CGSizeMake(0, 22);
		collectionView = LFBCollectionView(frame: CGRectMake(0, self.view.width, self.view.width, 140), collectionViewLayout: layout)
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.showsHorizontalScrollIndicator = false;
		collectionView.backgroundColor = LFBGlobalBackgroundColor;
		collectionView.registerClass(GiftShopCell.self, forCellWithReuseIdentifier: "Cell");
		view.addSubview(collectionView);

		collectionView.snp_makeConstraints { (make) in
			make.bottom.equalTo(self.view.snp_bottom).offset(-35);
			make.width.equalTo(self.view.width);
			make.height.equalTo(140);
		}
		// self.view.layoutIfNeeded();
		// self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0);

		btnMoney = UIButton.BtnSimple("充值", titleColor: UIColor.whiteColor(), image: nil, hightLightImage: nil, target: self, action: #selector(self.addMoneyClick));
		btnMoney!.backgroundColor = UIColor.colorWithCustom(0, g: 181, b: 219);
		btnMoney!.layer.cornerRadius = 10;
		btnMoney!.layer.masksToBounds = true;
		view.addSubview(btnMoney!);
		btnMoney!.snp_makeConstraints { (make) in
			make.bottom.equalTo(self.view.snp_bottom).offset(-5);
			make.right.equalTo(self.view.snp_right).offset(-5);
			make.width.equalTo(60);
		}
		btnSend = UIButton.BtnSimple("赠送", titleColor: UIColor.whiteColor(), image: nil, hightLightImage: nil, target: self, action: #selector(self.sendGift));
		btnSend!.backgroundColor = UIColor.colorWithCustom(225, g: 50, b: 125);
		btnSend!.layer.cornerRadius = 10;
		btnSend!.layer.masksToBounds = true;
		view.addSubview(btnSend!);
		btnSend!.snp_makeConstraints { (make) in
			make.centerY.equalTo(btnMoney!.snp_centerY);
			make.right.equalTo(btnMoney!.snp_left).offset(-5);
			make.width.equalTo(60);
		}
		txtChangeLB = UILabel.lableSimple("礼物:", corlor: UIColor.blackColor(), size: 12);
		view.addSubview(txtChangeLB!);
		txtChangeLB!.snp_makeConstraints { (make) in
			make.centerY.equalTo(btnMoney!.snp_centerY);
			make.left.equalTo(self.view.snp_left).offset(10);
			// make.width.equalTo(60);
		}
		var helper: SWComboxTitleHelper
		helper = SWComboxTitleHelper()

		let list = ["good", "middle", "bad"]
		view.addSubview(containner1);

		containner1.snp_makeConstraints { (make) in
			make.centerY.equalTo(0);
			make.right.equalTo((btnSend?.snp_left)!).offset(-10);
			make.width.equalTo(100);
			make.height.equalTo(20);
		}
		self.view.layoutIfNeeded();
        var frame = self.containner1.frame;
		var comboxView: SWComboxView;
		comboxView = SWComboxView.loadInstanceFromNibNamedToContainner(self.containner1)!
		comboxView.bindData(list, comboxHelper: helper, seletedIndex: 1, comboxDelegate: self, containnerView: self.view);
	}

	func sendGift() {
		LogHttp("sendGift");
	}

	func addMoneyClick() {
		LogHttp("addMoneyClick");
	}

	// MARK: delegate
	func selectedAtIndex(index: Int, withCombox: SWComboxView)
	{
	}
	func tapComboxToOpenTable(combox: SWComboxView)
	{

	}
}

extension GiftViewControl: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return (giftDataList.count);
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! GiftShopCell
		cell.shopGiftModel = giftDataList[indexPath.row];
		return cell;
	}

	// 设置item 宽
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		var itemSize = CGSizeZero
		itemSize = CGSizeMake(65, 70)
		return itemSize
	}

	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

		return CGSizeZero
	}

	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//		if section == 0 {
//			return CGSizeMake(ScreenWidth, HomeCollectionViewCellMargin)
//		} else if section == 1 {
//			// return CGSizeMake(ScreenWidth, HomeCollectionViewCellMargin*2)
//		}
		return CGSizeZero
	}

	func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true;
	}

	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let shopGiftModel = giftDataList[indexPath.row];
		let attStr = NSMutableAttributedString(string: "礼物: ");
		let attrDic = [NSForegroundColorAttributeName: UIColor.purpleColor()];
		// let nameStr = NSAttributedString(string: "\(shopGiftModel.name!)(\(shopGiftModel.price!)钻)", attributes: attrDic);
		let nameStr = NSAttributedString(string: shopGiftModel.name!, attributes: attrDic);
		attStr.appendAttributedString(nameStr);
		txtChangeLB?.attributedText = attStr;
		// txtChangeLB?.text = "赠送: \(shopGiftModel.name)";
		LogHttp("click");
		LogHttp("collectionView");
	}

}

