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

	var segmentedClick: ((_ index: Int) -> Void)?;
	var segmentVC: TSegmentedControl?;
	var curTableStyle: playTableStyle = .users;

	var tableView: UITableView = UITableView();

	deinit {
		NotificationCenter.default.removeObserver(self);
		segmentedClick = nil;
		segmentedClick = nil;
	}

	override func viewDidLoad() {
		addNotifycation();
		self.view.backgroundColor = ROOM_SCROOL_BG_COLOR;

		self.tableView.separatorStyle = .none;
		self.view.addSubview(tableView);
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		self.tableView.rowHeight = self.view.width / 9;
		self.tableView.backgroundColor = UIColor.clear;
		self.tableView.allowsSelection = false;
		segmentVC = TSegmentedControl(items: ["观众" as AnyObject, "管理员" as AnyObject], didSelectedIndex: { [weak self](index) -> () in
			if 0 == index {
				self?.curTableStyle = .users;
			} else if 1 == index {
				self?.curTableStyle = .manager;
			}
			self?.flushListView(DataCenterModel.sharedInstance.roomData.playerList);
		})
		self.view.addSubview(segmentVC!);
		segmentVC?.snp.makeConstraints { (make) in
			make.top.equalTo(self.view.snp.top).offset(5);
			make.width.equalTo(self.view.width * 2 / 3);
			make.centerX.equalTo(self.view);
		}
		self.tableView.snp.makeConstraints { (make) in
			make.width.equalTo(self.view.snp.width);
			make.top.equalTo((segmentVC?.snp.bottom)!).offset(5);
			make.bottom.equalTo(self.view.snp.bottom);
		}

	}

	func addNotifycation() {
		NotificationCenter.default.addObserver(self, selector: #selector(self.updataListView), name: NSNotification.Name(rawValue: PlayLIST_CHANGE), object: nil);
		self.tableView.reloadData();
	}

	// 刷新列表
	func updataListView(_ notice: Notification) -> Void {
		flushListView(DataCenterModel.sharedInstance.roomData.playerList)
	}

	func flushListView(_ dataModelArr: [playInfoModel]) {

		if (curTableStyle == .users)
		{
			dataList = dataModelArr.filter({ (playInfoModel) -> Bool in
				return (playInfoModel.ruled?.int32Value == 0 && playInfoModel.name != "");
			})
			dataList = dataList?.sorted(by: { (a, b) -> Bool in
				var result = false;
				if ((a.vip?.int32Value)! > (b.vip?.int32Value)!)
				{
					result = true;
				}
				else if ((a.vip?.int32Value)! < (b.vip?.int32Value)!) {

					result = false;
				}
				else {
					result = a.richLv.int32Value > b.richLv.int32Value;
				}
				return result;
			});
		}
		else {
			dataList = dataModelArr.filter({ (playInfoModel) -> Bool in
				return ((playInfoModel.ruled?.int32Value)! > 0 && playInfoModel.name != "");
			});
			dataList = dataList?.sorted(by: { (a, b) -> Bool in
				var result = false;
				if ((a.ruled?.int32Value)! > (b.ruled?.int32Value)!)
				{
					result = true;
				}
				else if ((a.ruled?.int32Value)! < (b.ruled?.int32Value)!) {

					result = false;
				}
				else {
					result = a.richLv.int32Value > b.richLv.int32Value;
				}
				return result;
			});
		}
		self.tableView.reloadData();
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return (dataList?.count)!;
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let cell = playListCell.cellFormTablView(tableView, indexPath) ;
		cell.dataModel = (dataList?[(indexPath as NSIndexPath).row])!;
		return cell;
	}
}

