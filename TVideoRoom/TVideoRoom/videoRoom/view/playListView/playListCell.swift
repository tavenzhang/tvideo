

class playListCell: UITableViewCell {

	class func cellFormTablView(tableView: UITableView, _ indexPath: NSIndexPath) -> playListCell {
		var cell = tableView.dequeueReusableCellWithIdentifier("cell") as? playListCell ;
		if (cell == nil)
		{
			tableView.registerClass(playListCell.self, forCellReuseIdentifier: "cell");
			cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? playListCell ;
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
		self.addSubview(vipImageView);
		self.addSubview(lvImageView)
		self.lvImageView.snp_makeConstraints { (make) in
			make.centerY.equalTo(0);
			make.left.equalTo(self.snp_left).offset(30);
		}
		self.txtName.snp_makeConstraints { (make) in
			make.centerX.equalTo(0);
			make.centerY.equalTo(0);
			// make.left.equalTo(self.width / 2 - 50);
		}

		self.vipImageView.snp_makeConstraints { (make) in
			make.centerY.equalTo(0);
			make.right.equalTo(self.snp_right).offset(-30);
		}
	}

	lazy var vipImageView = UIImageView();
	lazy var txtName: UILabel = {
		var lb: UILabel = self.createLB("天下第一天下第一", corlor: UIColor.blackColor());
		self.contentView.addSubview(lb);
		return lb;
	}()
	lazy var lvImageView = UIImageView();

	func createLB(title: String, corlor: UIColor) -> UILabel {
		let lb = UILabel();
		lb.textColor = corlor;
		lb.text = title;
		lb.font = UIFont.boldSystemFontOfSize(14);
		lb.textAlignment = NSTextAlignment.Left;
		lb.adjustsFontSizeToFitWidth = false;
		return lb;
	}

	var dataModel: playInfoModel? {
		didSet {
			vipImageView.image = UIImage(named: lvIcoNameGet((dataModel?.icon?.intValue)!, type: .VipIcoLv))

			// lvImageView.image = UIImage(named: lvIcoNameGet((dataModel?.icon?.intValue)!, type: .VipIcoLv))
			if (dataModel?.ruled?.intValue == 3)
			{
				txtName.text = "\(dataModel!.name!) (主播)";
				txtName.textColor = UIColor.purpleColor();
				lvImageView.image = UIImage(named: lvIcoNameGet((dataModel?.lv?.intValue)!, type: .HostIcoLV))
				lvImageView.scale(1.5, ySclae: 1.5)
			}
			else {
				txtName.text = dataModel?.name;
				txtName.textColor = UIColor.blackColor();
				lvImageView.image = UIImage(named: lvIcoNameGet((dataModel?.richLv.intValue)!, type: .UserIcoLv))
				lvImageView.scale(1.5, ySclae: 1.5)
			}

		}
	}

}
