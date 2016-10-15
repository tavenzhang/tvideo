//
//  GiftRankCell.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/10/8.
//  Copyright © 2016年 张新华. All rights reserved.
//

import SnapKit

class RankGiftCell: UITableViewCell {

	class func cellFormTablView(_ tableView: UITableView, _ indexPath: IndexPath) -> RankGiftCell {

		var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? RankGiftCell ;
		if (cell == nil)
		{
			tableView.register(RankGiftCell.self, forCellReuseIdentifier: "cell");
			cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RankGiftCell ;
		}
		return cell!;

	}

	override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
		super.init(style: style, reuseIdentifier: reuseIdentifier);
		self.backgroundColor = UIColor.clear;
		self.accessoryType = .none;
		self.txtRank.snp_makeConstraints { (make) in
			make.top.equalTo(10);
			make.left.equalTo(self.snp_left).offset(20);
		}
		self.txtName.snp_makeConstraints { (make) in
			make.top.equalTo(10);
			make.centerX.equalTo(0);
			// make.left.equalTo(self.width / 2 - 50);
		}

		self.txtMoeny.snp_makeConstraints { (make) in
			make.top.equalTo(10);
			make.right.equalTo(self.snp_right).offset(-20);
		}
	}

	lazy var txtRank: UILabel = {
		var lb = self.createLB("1", corlor: UIColor.blue);
		self.contentView.addSubview(lb);
		return lb;
	}()
	lazy var txtName: UILabel = {
		var lb: UILabel = self.createLB("天下第一天下第一", corlor: UIColor.black);
		self.contentView.addSubview(lb);
		return lb;
	}()
	lazy var txtMoeny: UILabel = {
		var lb = self.createLB("111111111", corlor: UIColor.red);
		self.contentView.addSubview(lb);
		return lb;
	}()

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func createLB(_ title: String, corlor: UIColor) -> UILabel {
		let lb = UILabel();
		lb.textColor = corlor;
		lb.text = title;
		lb.font = UIFont.boldSystemFont(ofSize: 14);
		lb.textAlignment = NSTextAlignment.left;
		lb.adjustsFontSizeToFitWidth = false;
		return lb;
	}

	var dataModel: RankGiftModel? {

		didSet {
			txtRank.text = dataModel!.rankStr;
			txtName.text = dataModel!.name;
			txtMoeny.text = "\(dataModel!.score!) ￥";
		}
	}

}
