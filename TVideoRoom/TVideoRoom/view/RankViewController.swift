//
//  RankViewController.swift
//  TVideoRoom

import UIKit
import Crashlytics
enum RankType: Int
{
	case rankDay;
	case rankWeek;
	case rankMonth;
	case rankHistory;
}

class RankViewController: BaseUIViewController, UITableViewDelegate, UITableViewDataSource {

	var dataList = [rankInfoModel]();
	var userDataList = [rankInfoModel]();
	var segmentedClick: ((_ index: Int) -> Void)?;
	var segmentVC: TSegmentedControl?;
	var curTableStyle: RankType = .rankDay;
	var tableView: UITableView = UITableView();
	var hrankDic = [RankType: [rankInfoModel]]() ;
	var useRankDic = [RankType: [rankInfoModel]]() ;

	deinit {
		NotificationCenter.default.removeObserver(self);
		segmentedClick = nil;
	}

	override func viewDidLoad() {
		self.view.backgroundColor = ROOM_SCROOL_BG_COLOR;
		self.navigationController?.navigationBar.barTintColor = UIColor.white;
		navigationItem.title = "排行榜";
		self.tableView.separatorStyle = .none;
		self.view.addSubview(tableView);
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		self.tableView.rowHeight = self.view.width / 9;
		self.tableView.backgroundColor = UIColor.clear;
		self.tableView.allowsSelection = false;
		segmentVC = TSegmentedControl(items: ["日榜" as AnyObject, "周榜" as AnyObject, "月榜" as AnyObject, "总榜" as AnyObject], didSelectedIndex: { [weak self](index) -> () in
			switch index {
			case 0:
				self?.curTableStyle = .rankDay;
			case 1:
				self?.curTableStyle = .rankWeek;
			case 2:
				self?.curTableStyle = .rankMonth;
			case 3:
				self?.curTableStyle = .rankHistory;
			default:
				self?.curTableStyle = .rankDay;
			}
			self!.flushListView((self?.hrankDic[(self?.curTableStyle)!])!, (self?.useRankDic[(self?.curTableStyle)!])!)
		})

		self.view.addSubview(segmentVC!);
		segmentVC?.snp_makeConstraints{ (make) in
			make.top.equalTo(self.view.snp_top).offset(5);
			make.width.equalTo(self.view.width * 3 / 4);
			make.centerX.equalTo(0);
		}
		self.tableView.snp_makeConstraints { (make) in
			make.width.equalTo(self.view.snp_width);
			make.top.equalTo((segmentVC?.snp_bottom)!).offset(5);
			make.bottom.equalTo(self.view.snp_bottom);
		}
		self.view.bringSubview(toFront: self.loadProgressAnimationView);
		self.loadProgressAnimationView.startLoadProgressAnimation();
		HttpTavenService.requestJson(getWWWHttp(HTTP_RANK_DATA)) { [weak self](dataResult) in
			self?.loadProgressAnimationView.endLoadProgressAnimation();
			if (dataResult.isSuccess) {
				self?.hrankDic[.rankDay] = deserilObjectsWithArray(dataResult.dataJson!["rank_exp_day"].arrayObject! as NSArray, cls: rankInfoModel.self) as? [rankInfoModel] ;
				self?.hrankDic[.rankWeek] = deserilObjectsWithArray(dataResult.dataJson!["rank_exp_week"].arrayObject! as NSArray, cls: rankInfoModel.self) as? [rankInfoModel] ;
				self?.hrankDic[.rankMonth] = deserilObjectsWithArray(dataResult.dataJson!["rank_exp_month"].arrayObject! as NSArray, cls: rankInfoModel.self) as? [rankInfoModel] ;
				self?.hrankDic[.rankHistory] = deserilObjectsWithArray(dataResult.dataJson!["rank_exp_his"].arrayObject! as NSArray, cls: rankInfoModel.self) as? [rankInfoModel] ;

				self?.useRankDic[.rankDay] = deserilObjectsWithArray(dataResult.dataJson!["rank_rich_day"].arrayObject! as NSArray, cls: rankInfoModel.self) as? [rankInfoModel] ;
				self?.useRankDic[.rankWeek] = deserilObjectsWithArray(dataResult.dataJson!["rank_rich_week"].arrayObject! as NSArray, cls: rankInfoModel.self) as? [rankInfoModel] ;
				self?.useRankDic[.rankMonth] = deserilObjectsWithArray(dataResult.dataJson!["rank_rich_month"].arrayObject! as NSArray, cls: rankInfoModel.self) as? [rankInfoModel] ;
				self?.useRankDic[.rankHistory] = deserilObjectsWithArray(dataResult.dataJson!["rank_rich_his"].arrayObject! as NSArray, cls: rankInfoModel.self) as? [rankInfoModel] ;
				self!.flushListView((self?.hrankDic[(self?.curTableStyle)!])!, (self?.useRankDic[(self?.curTableStyle)!])!)
			}
		}
	}

	func flushListView(_ dataModelArr: [rankInfoModel], _ uDataList: [rankInfoModel]) {
		dataList = dataModelArr;
		userDataList = uDataList;
		for (index, item) in (dataList.enumerated()) {
			item.rankId = Int(index) + 1;
			item.isHost = true;
		}
		for (index, item) in (userDataList.enumerated()) {
			item.rankId = Int(index) + 1;
			item.isHost = false;
		}
		self.tableView.reloadData();
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return section == 0 ? (dataList.count) : (userDataList.count);
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let cell = RankViewCell.cellFormTablView(tableView, indexPath) ;
		if ((indexPath as NSIndexPath).section == 0)
		{
			cell.dataModel = (dataList[(indexPath as NSIndexPath).row]);
		}
		else {
			cell.dataModel = (userDataList[(indexPath as NSIndexPath).row]);
		}

		return cell;
	}

	func numberOfSections(in tableView: UITableView) -> Int // Default is 1 if not implemente
	{
		return 2;
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if (section == 0)
		{
			return "主播排行"
		}
		else {
			return "富豪排行"
		}
	}

}
