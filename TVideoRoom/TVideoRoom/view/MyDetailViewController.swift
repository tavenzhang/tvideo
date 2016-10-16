//
//  MyDetailView.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/6/26.
//  Copyright © 2016年 张新华. All rights reserved.
//

import UIKit
import SnapKit

class MyDetailViewController: BaseUIViewController, UITableViewDelegate, UITableViewDataSource {

	var infoView: LoginView?
	var tableData: [MyinfoItemModel] = [MyinfoItemModel]();
	var focusModel: MyinfoItemModel?;
	var roomData: RoomData?;
	var oneByoneData: MyinfoItemModel?;
	var privateMail: MyinfoItemModel?;
	var myItems: MyinfoItemModel?;
	var myConsume: MyinfoItemModel?;
	var configData: MyinfoItemModel?;
	var loginOutData: MyinfoItemModel?;
	var tableView: UITableView = UITableView();

	override func viewDidLoad() {
		super.viewDidLoad();
		roomData = DataCenterModel.sharedInstance.roomData;
		infoView = LoginView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 230));
		infoView?.parentViewVC = self;
		navigationItem.title = "个人信息";
		// self.view.addSubview(infoView!);
		self.view.addSubview(tableView);
		tableView.tableHeaderView = infoView;
		tableView.dataSource = self;
		tableView.delegate = self;
		tableView.snp.makeConstraints { (make) in
			make.edges.equalTo(self.view);
		}
		initData();

		tableView.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
		// tableView.allowsSelection = false;
		tableView.reloadData();

	}

	func initData() {
		// 初始化数据
		focusModel = MyinfoItemModel();
		focusModel?.icoName = "icoFoucs";
		focusModel?.editName = "我的关注";
		focusModel?.actionKey = "focus";
		focusModel?.msgNum = 0;
		tableData.append(focusModel!);
		// 一对一数据
		oneByoneData = MyinfoItemModel();
		oneByoneData?.icoName = "icoOneByOne";
		oneByoneData?.editName = "我的一对一";
		oneByoneData?.actionKey = "oneByonew";
		oneByoneData?.msgNum = 0;
		tableData.append(oneByoneData!);
		// 我的私信
		privateMail = MyinfoItemModel();
		privateMail?.icoName = "icoPrivateMail";
		privateMail?.editName = "我的私信";
		privateMail?.actionKey = "mail";
		privateMail?.msgNum = 0;
		tableData.append(privateMail!);
		// 我的道具
		myItems = MyinfoItemModel();
		myItems?.icoName = "icoItems";
		myItems?.editName = "我的道具";
		myItems?.actionKey = "item";
		myItems?.msgNum = 0;
		tableData.append(myItems!);
		// 消费记录
		myConsume = MyinfoItemModel();
		myConsume?.icoName = "icoConsume";
		myConsume?.editName = "消费记录";
		myConsume?.actionKey = "consume";
		myConsume?.msgNum = 0;
		tableData.append(myConsume!);
		// 设置
		configData = MyinfoItemModel();
		configData?.icoName = "icoConfig";
		configData?.editName = "设置";
		configData?.actionKey = "config";
		configData?.msgNum = 0;
		tableData.append(configData!);
		// 退出登录
		loginOutData = MyinfoItemModel();
		loginOutData?.icoName = "icoLoginOut";
		loginOutData?.editName = "退出登录";
		loginOutData?.actionKey = "icoLoginOut";
		loginOutData?.msgNum = 0;
		tableData.append(loginOutData!);
	}

	func isLoginSucess() -> Bool {
		return roomData?.key != "" && roomData?.key != nil;
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return tableData.count;
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let cell = EditTableViewCell.cellFormTablView(tableView, indexPath) ;
		cell.dataModel = tableData[indexPath.row];
		return cell;
	}

	func numberOfSections(in tableView: UITableView) -> Int // Default is 1 if not implemente
	{
		return 1;
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if (section == 0)
		{
			return " "
		}
		return "";
	}
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 10;
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! EditTableViewCell;
		cell.setSelected(false, animated: true);
		if (!isLoginSucess()) {
			showAlertHandle(self, tl: "", cont: "请您先登录，再做此操作！", okHint: "去登录", cancelHint: "了解", okHandle: { [weak self] in
				self?.infoView?.clickLogin();
				}, canlHandle: nil)

		}
	}
}
