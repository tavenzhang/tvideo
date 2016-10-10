//
//  RankViewControl.swift
//  TVideoRoom
//

import UIKit

class RankGiftViewControl: UITableViewController {

	var dataList: [RankGiftModel]? = [];

	override func viewDidLoad() {
		self.tableView.separatorStyle = .None;
		addNotifycation();
		self.tableView.rowHeight = self.view.width/10;
        self.tableView.backgroundColor = UIColor.colorWithCustom(240, g: 240, b: 240, a: 1)

	}

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self);
	}

	func addNotifycation() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updataListView), name: RANK_GIft_UPTA, object: nil);
		self.tableView.registerClass(RankGiftCell.self, forCellReuseIdentifier: "cell");

		self.tableView.reloadData();
	}

	func updataListView(notice: NSNotification) -> Void {
		dataList = notice.object as? [RankGiftModel];
		dataList = dataList?.sort({ $0.score?.intValue > $1.score?.intValue })
		for (index, item) in (dataList?.enumerate())!
		{
			let indexT = index + 1;
			item.rankStr = indexT > 9 ? indexT.description : "0\(indexT)";
		}
		self.tableView.reloadData();
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return (dataList?.count)!;
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! RankGiftCell ;
		cell.dataModel = dataList?[indexPath.row];
		return cell;
	}

}

