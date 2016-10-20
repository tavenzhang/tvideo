//
//  GiftChooseCell.swift
//  TVideoRoom
//
//  Created by  on 16/10/10.
//  Copyright © 2016年 . All rights reserved.
//

import UIKit

class GiftChooseCell: UITableViewCell {

	class func cellFormTablView(_ tableView: UITableView, _ indexPath: IndexPath) -> GiftChooseCell {

		var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? GiftChooseCell ;
		if (cell == nil)
		{
			tableView.register(RankGiftCell.self, forCellReuseIdentifier: "cell");
			cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? GiftChooseCell ;
		}
		return cell!;

	}

	override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
		super.init(style: style, reuseIdentifier: reuseIdentifier);
		self.backgroundColor = UIColor.clear;
		self.accessoryType = .none;
		self.addSubview(txtLable);
		self.txtLable.snp_makeConstraints { (make) in
			make.left.equalTo(self.snp_left).offset(20);
			make.centerY.equalTo(self);
		}
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)

		// Configure the view for the selected state
	}

	var txtLable: UILabel = UILabel.lableSimple("title", corlor: UIColor.black, size: 14, align: NSTextAlignment.center) ;

	var dataModel: GiftChooseModel? {

		didSet {
			let attrDic = [NSForegroundColorAttributeName: UIColor.purple];
			let numStr = NSMutableAttributedString(string: "\(dataModel!.data)个   ", attributes: attrDic);
			let lbStr = NSAttributedString(string: dataModel!.label);
			numStr.append(lbStr);
			txtLable.attributedText = numStr;
		}
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}

}
