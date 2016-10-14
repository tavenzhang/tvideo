//
//  rankViewCell.swift

class RankViewCell: UITableViewCell {

	class func cellFormTablView(tableView: UITableView, _ indexPath: NSIndexPath) -> RankViewCell {
		var cell = tableView.dequeueReusableCellWithIdentifier("cell") as? RankViewCell ;
		if (cell == nil)
		{
			tableView.registerClass(RankViewCell.self, forCellReuseIdentifier: "cell");
			cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? RankViewCell ;
		}
		return cell!;

	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
		super.init(style: style, reuseIdentifier: reuseIdentifier);

		self.backgroundColor = UIColor.clearColor();
		self.accessoryType = .None;
		self.addSubview(lbRank);
		self.addSubview(lvImageView)
		self.addSubview(txtName);
		self.addSubview(imgHeadView);
		self.lbRank.snp_makeConstraints { (make) in
			make.centerY.equalTo(0);
			make.left.equalTo(self.snp_left).offset(30);
		}
		self.txtName.snp_makeConstraints { (make) in
			make.centerY.equalTo(0);
			make.left.equalTo(self.width / 2 - 20);
		}

		self.lvImageView.snp_makeConstraints { (make) in
			make.centerY.equalTo(0);
			make.right.equalTo(self.snp_right).offset(-30);
		}
		imgHeadView.snp_makeConstraints { (make) in
			make.right.equalTo(self.txtName.snp_left).offset(-10);
			make.width.height.equalTo(40);
		}
	}

	lazy var lbRank = UILabel.lableSimple("", corlor: UIColor.purpleColor(), size: 14);

	lazy var txtName: UILabel = self.createLB("天下第一天下第一", corlor: UIColor.blackColor());

	lazy var lvImageView = UIImageView();
	var imgHeadView = UIImageView();

	func createLB(title: String, corlor: UIColor) -> UILabel {
		let lb = UILabel();
		lb.textColor = corlor;
		lb.text = title;
		lb.font = UIFont.boldSystemFontOfSize(14);
		lb.textAlignment = NSTextAlignment.Left;
		lb.adjustsFontSizeToFitWidth = false;
		return lb;
	}

	var dataModel: rankInfoModel? {
		didSet {
			lbRank.text = dataModel?.rankId <= 9 ? "0\(dataModel!.rankId)" : "\(dataModel!.rankId )";
			if (dataModel?.rankId > 3)
			{
				lbRank.textColor = UIColor.grayColor();
			}
			else {
				lbRank.textColor = UIColor.purpleColor();
			}
			txtName.text = dataModel?.username;
			let imageUrl = NSString(format: HTTP_SMALL_IMAGE, dataModel!.headimg!) as String;
			self.imgHeadView.sd_setImageWithURL(NSURL(string: imageUrl), placeholderImage: UIImage(named: "v2_placeholder_full_size"));
			self.imgHeadView.layer.cornerRadius = 20;
			self.imgHeadView.layer.masksToBounds = true;
			if (dataModel!.isHost)
			{
				lvImageView.image = UIImage(named: lvIcoNameGet((dataModel?.lv_exp?.intValue)!, type: .HostIcoLV))
				lvImageView.scale(2, ySclae: 2)
			}
			else {
				txtName.textColor = UIColor.blackColor();
				lvImageView.image = UIImage(named: lvIcoNameGet((dataModel?.lv_rich!.intValue)!, type: .UserIcoLv))
				lvImageView.scale(1.5, ySclae: 1.5)
			}

		}
	}

}

