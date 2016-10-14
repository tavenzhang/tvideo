//
//  RankViewControl.swift
//  TVideoRoom

class RankGiftViewControl: UITableViewController {

	var dataList: [RankGiftModel]? = [];

	override func viewDidLoad() {
		self.tableView.separatorStyle = .None;
		addNotifycation();
		self.tableView.rowHeight = self.view.width / 10;
		self.tableView.backgroundColor = ROOM_SCROOL_BG_COLOR;
		self.tableView.allowsSelection = false;
	}

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self);
	}

	func addNotifycation() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updataListView), name: RANK_GIft_UPTA, object: nil);
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
		let cell = RankGiftCell.cellFormTablView(tableView, indexPath) ;
		cell.dataModel = dataList?[indexPath.row];

		return cell;
	}

}

