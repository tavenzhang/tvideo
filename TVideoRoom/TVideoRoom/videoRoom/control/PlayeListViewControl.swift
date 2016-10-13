//
//  PlayeListViewControl.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/10/13.
//  Copyright © 2016年 张新华. All rights reserved.
//
enum playTableStyle: Int {
	case manager;
	case users;
}

class PlayeListViewControl: UIViewController, UITableViewDelegate, UITableViewDataSource {

	var dataList: [playInfoModel]? = [];

	var segmentedClick: ((index: Int) -> Void)?;
	var segmentVC: TSegmentedControl?;
	var curTableStyle: playTableStyle = .users;

	var tableView: UITableView = UITableView();

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self);
		segmentedClick = nil;
		segmentedClick = nil;
	}

	override func viewDidLoad() {
		addNotifycation();
		self.view.backgroundColor = ROOM_SCROOL_BG_COLOR;

		self.tableView.separatorStyle = .None;
		self.view.addSubview(tableView);
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		self.tableView.rowHeight = self.view.width / 9;
		self.tableView.backgroundColor = UIColor.clearColor();
		self.tableView.allowsSelection = false;
		segmentVC = TSegmentedControl(items: ["观众", "管理员"], didSelectedIndex: { [weak self](index) -> () in
			if 0 == index {
				self?.curTableStyle = .users;
			} else if 1 == index {
				self?.curTableStyle = .manager;
			}
			self?.flushListView(DataCenterModel.sharedInstance.roomData.playerList);
		})
		self.view.addSubview(segmentVC!);
		segmentVC?.snp_makeConstraints(closure: { (make) in
			make.top.equalTo(self.view.snp_top).offset(5);
			make.width.equalTo(self.view.width * 2 / 3);
			make.centerX.equalTo(0);
		})
		self.tableView.snp_makeConstraints { (make) in
			make.width.equalTo(self.view.snp_width);
			make.top.equalTo((segmentVC?.snp_bottom)!).offset(5);
			make.bottom.equalTo(self.view.snp_bottom);
		}

	}

	func addNotifycation() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updataListView), name: PlayLIST_CHANGE, object: nil);
		self.tableView.reloadData();
	}

	// 刷新列表
	func updataListView(notice: NSNotification) -> Void {
		flushListView(DataCenterModel.sharedInstance.roomData.playerList)
	}

	func flushListView(dataModelArr: [playInfoModel]) {

		if (curTableStyle == .users)
		{
			dataList = dataModelArr.filter({ (playInfoModel) -> Bool in
				return (playInfoModel.ruled?.intValue == 0 && playInfoModel.name != "");
			})
			dataList = dataList?.sort({ (a, b) -> Bool in
				var result = false;
				if (a.vip?.intValue > b.vip?.intValue)
				{
					result = true;
				}
				else if (a.vip?.intValue < b.vip?.intValue) {

					result = false;
				}
				else {
					result = a.richLv.intValue > b.richLv.intValue;
				}
				return result;
			});
		}
		else {
			dataList = dataModelArr.filter({ (playInfoModel) -> Bool in
				return (playInfoModel.ruled?.intValue > 0 && playInfoModel.name != "");
			});
			dataList = dataList?.sort({ (a, b) -> Bool in
				var result = false;
				if (a.ruled?.intValue > b.ruled?.intValue)
				{
					result = true;
				}
				else if (a.ruled?.intValue < b.ruled?.intValue) {

					result = false;
				}
				else {
					result = a.richLv.intValue > b.richLv.intValue;
				}
				return result;
			});
		}
		self.tableView.reloadData();
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return (dataList?.count)!;
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		let cell = playListCell.cellFormTablView(tableView, indexPath) ;
		cell.dataModel = (dataList?[indexPath.row])!;
		return cell;
	}
}

