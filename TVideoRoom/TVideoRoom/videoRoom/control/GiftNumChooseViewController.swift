//
//  GiftNumChooseViewController.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/10/10.
//  Copyright © 2016年 张新华. All rights reserved.
//

import UIKit

typealias clickCallFun = (_ data: AnyObject) -> Void;

class GiftNumChooseViewController: UITableViewController {
	var dataList: [GiftChooseModel]? = [];
	var callFun: clickCallFun?;
	override func viewDidLoad() {
		super.viewDidLoad()

		self.tableView.separatorStyle = .none;
		self.tableView.rowHeight = 30;
		self.tableView.separatorStyle = .singleLine;
		self.tableView.backgroundColor = UIColor.white;
		self.view.frame = CGRect(x: 0, y: 0, width: 150, height: 300)
		addGiftDetail("随机", 1, false);
		addGiftDetail("随机", 5, false);
		addGiftDetail("随机", 10, false);
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
		dataList = dataList?.sorted(by: { $0.data < $1.data });
		self.tableView.register(GiftChooseCell.self, forCellReuseIdentifier: "cell");
		self.tableView.reloadData();
	}

	deinit {
		callFun = nil;
	}

	func addGiftDetail(_ lbT: String, _ numT: Int, _ vip: Bool)
	{
		let model = GiftChooseModel(lb: lbT, num: numT, isVip: vip);
		dataList?.append(model)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func onCloseWindow() {
		dismiss(animated: true, completion: nil);
	}

	// MARK: - Table view data source

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return (dataList?.count)!;
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let cell = GiftChooseCell.cellFormTablView(tableView, indexPath) ;
		cell.dataModel = dataList?[(indexPath as NSIndexPath).row];
		return cell;
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let model = (dataList?[(indexPath as NSIndexPath).row])!;
		if (callFun != nil)
		{
			callFun?(model);
		}
		onCloseWindow();
	}

}
