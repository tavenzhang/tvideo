//
//  RankViewControl.swift
//  TVideoRoom

class RankGiftViewControl: UITableViewController {

	var dataList: [RankGiftModel]? = [];

	override func viewDidLoad() {
		self.tableView.separatorStyle = .none;
		addNotifycation();
		self.tableView.rowHeight = self.view.width / 10;
		self.tableView.backgroundColor = ROOM_SCROOL_BG_COLOR;
		self.tableView.allowsSelection = false;
	}

	deinit {
		NotificationCenter.default.removeObserver(self);
	}

	func addNotifycation() {
		NotificationCenter.default.addObserver(self, selector: #selector(self.updataListView), name: NSNotification.Name(rawValue: RANK_GIft_UPTA), object: nil);
		self.tableView.reloadData();
	}

	func updataListView(_ notice: Notification) -> Void {
		dataList = notice.object as? [RankGiftModel];
		if ((dataList?.count)! > 1)
		{
			dataList = dataList?.sorted(by: { ($0.score?.int32Value)! > ($1.score?.int32Value)! });
		}

		for (index, item) in (dataList?.enumerated())!
		{
			let indexT = index + 1;
			item.rankStr = indexT > 9 ? indexT.description : "0\(indexT)";
		}
		self.tableView.reloadData();
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return (dataList?.count)!;
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let cell = RankGiftCell.cellFormTablView(tableView, indexPath) ;
		cell.dataModel = dataList?[(indexPath as NSIndexPath).row];

		return cell;
	}

}

