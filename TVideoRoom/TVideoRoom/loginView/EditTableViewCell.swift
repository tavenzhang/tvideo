//
//  EditTableViewCell.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/10/16.
//  Copyright © 2016年 张新华. All rights reserved.
//

import UIKit

class EditTableViewCell: UITableViewCell {

	class func cellFormTablView(_ tableView: UITableView, _ indexPath: IndexPath) -> EditTableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? EditTableViewCell ;
		if (cell == nil)
		{
			tableView.register(EditTableViewCell.self, forCellReuseIdentifier: "cell");
			cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? EditTableViewCell ;
		}
		return cell!;
	}

	var imgIco: UIImageView = UIImageView();
	var lbname = UILabel.lableSimple("", corlor: UIColor.black, size: 14);
	var lbNum = UILabel.lableSimple("", corlor: UIColor.red, size: 14);

	override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
		super.init(style: style, reuseIdentifier: reuseIdentifier);
		self.addSubview(imgIco);
		self.addSubview(lbname);
		self.addSubview(lbNum);
		imgIco.snp.makeConstraints { (make) in
			make.centerY.equalTo(self);
			make.width.height.equalTo(30);
			make.left.equalTo(self.snp.left).offset(20);
		}
		lbname.snp.makeConstraints { (make) in
			make.centerY.equalTo(self);
			make.left.equalTo(imgIco.snp.right).offset(20);
		}
		lbNum.snp.makeConstraints { (make) in
			make.centerY.equalTo(self);
			make.left.equalTo(lbname.snp.right).offset(10);
		}
		self.accessoryType = .disclosureIndicator;
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	var dataModel: MyinfoItemModel? {
		didSet {
			imgIco.image = UIImage(named: (dataModel?.icoName)!);
			lbname.text = dataModel?.editName;
			lbNum.text = (dataModel?.msgNum)! > 0 ? "(\(dataModel!.msgNum))" : "";
		}
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)

		// Configure the view for the selected state
	}

}
