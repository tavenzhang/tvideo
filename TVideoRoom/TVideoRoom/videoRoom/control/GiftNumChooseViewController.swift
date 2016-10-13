//
//  GiftNumChooseViewController.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/10/10.
//  Copyright © 2016年 张新华. All rights reserved.
//

import UIKit

typealias clickCallFun = (data: AnyObject) -> Void;

class GiftNumChooseViewController: UITableViewController {
	var dataList: [GiftChooseModel]? = [];
	var callFun: clickCallFun?;
	override func viewDidLoad() {
		super.viewDidLoad()

		self.tableView.separatorStyle = .None;
		self.tableView.rowHeight = 30;
		self.tableView.separatorStyle = .SingleLine;
		self.tableView.backgroundColor = UIColor.whiteColor();
		self.view.frame = CGRectMake(0, 0, 150, 300)
		addGiftDetail("随机", 1, false);
		addGiftDetail("随机", 5, false);
		addGiftDetail("亲吻", 50, false);
		addGiftDetail("笑脸", 99, false);
		addGiftDetail("心", 188, false);
		addGiftDetail("天使心", 365, false);
		addGiftDetail("我爱你", 520, false);
		addGiftDetail("发发发", 888, false);
		addGiftDetail("一生一世", 1314, false);
		addGiftDetail("两性相爱", 66, true);
		addGiftDetail("心门钥匙", 66, true);
		addGiftDetail("蝴蝶", 366, true);
		addGiftDetail("丘比特之箭", 666, true);
		dataList = dataList?.sort({ $0.data > $1.data });
		self.tableView.registerClass(GiftChooseCell.self, forCellReuseIdentifier: "cell");
		self.tableView.reloadData();
	}

	deinit {
		callFun = nil;
	}

	func addGiftDetail(lbT: String, _ numT: Int, _ vip: Bool)
	{
		let model = GiftChooseModel(lb: lbT, num: numT, isVip: vip);
		dataList?.append(model)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func onCloseWindow() {
		dismissViewControllerAnimated(true, completion: nil);
	}

	// MARK: - Table view data source

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return (dataList?.count)!;
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		let cell = GiftChooseCell.cellFormTablView(tableView, indexPath) ;
		cell.dataModel = dataList?[indexPath.row];
		return cell;
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let model = (dataList?[indexPath.row])!;
		if (callFun != nil)
		{
			callFun?(data: model);
		}
		onCloseWindow();
	}

}
