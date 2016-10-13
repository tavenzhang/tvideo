//
//  GiftChooseCell.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/10/10.
//  Copyright © 2016年 张新华. All rights reserved.
//

import UIKit

class GiftChooseCell: UITableViewCell {

	class func cellFormTablView(tableView: UITableView, _ indexPath: NSIndexPath) -> GiftChooseCell {

		var cell = tableView.dequeueReusableCellWithIdentifier("cell") as? GiftChooseCell ;
		if (cell == nil)
		{
			tableView.registerClass(RankGiftCell.self, forCellReuseIdentifier: "cell");
			cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? GiftChooseCell ;
		}
		return cell!;

	}

	override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
		super.init(style: style, reuseIdentifier: reuseIdentifier);
		self.backgroundColor = UIColor.clearColor();
		self.accessoryType = .None;
		self.addSubview(txtLable);
		self.txtLable.snp_makeConstraints { (make) in
			make.left.equalTo(self.snp_left).offset(20);
			make.centerY.equalTo(self);
		}
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)

		// Configure the view for the selected state
	}

	var txtLable: UILabel = UILabel.lableSimple("title", corlor: UIColor.blackColor(), size: 14, align: NSTextAlignment.Center) ;

	var dataModel: GiftChooseModel? {

		didSet {
			let attrDic = [NSForegroundColorAttributeName: UIColor.purpleColor()];
			let numStr = NSMutableAttributedString(string: "\(dataModel!.data)个   ", attributes: attrDic);
			let lbStr = NSAttributedString(string: dataModel!.label);
			numStr.appendAttributedString(lbStr);
			txtLable.attributedText = numStr;
		}
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}

}
