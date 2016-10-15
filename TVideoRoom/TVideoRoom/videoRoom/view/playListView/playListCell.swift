

class playListCell: UITableViewCell {

	class func cellFormTablView(_ tableView: UITableView, _ indexPath: IndexPath) -> playListCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? playListCell ;
		if (cell == nil)
		{
			tableView.register(playListCell.self, forCellReuseIdentifier: "cell");
			cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? playListCell ;
		}
		return cell!;

	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
		super.init(style: style, reuseIdentifier: reuseIdentifier);
		self.backgroundColor = UIColor.clear;
		self.accessoryType = .none;
		self.addSubview(vipImageView);
		self.addSubview(lvImageView)
		self.lvImageView.snp.makeConstraints { (make) in
			make.centerY.equalTo(self);
			make.left.equalTo(self.snp.left).offset(30);
		}
		self.txtName.snp.makeConstraints { (make) in
			make.centerX.equalTo(self);
			make.centerY.equalTo(self);
			// make.left.equalTo(self.width / 2 - 50);
		}

		self.vipImageView.snp_makeConstraints { (make) in
			make.centerY.equalTo(self);
			make.right.equalTo(self.snp.right).offset(-30);
		}
	}

	lazy var vipImageView = UIImageView();
	lazy var txtName: UILabel = {
		var lb: UILabel = self.createLB("天下第一天下第一", corlor: UIColor.black);
		self.contentView.addSubview(lb);
		return lb;
	}()
	lazy var lvImageView = UIImageView();

	func createLB(_ title: String, corlor: UIColor) -> UILabel {
		let lb = UILabel();
		lb.textColor = corlor;
		lb.text = title;
		lb.font = UIFont.boldSystemFont(ofSize: 14);
		lb.textAlignment = NSTextAlignment.left;
		lb.adjustsFontSizeToFitWidth = false;
		return lb;
	}

	var dataModel: playInfoModel? {
		didSet {
			vipImageView.image = UIImage(named: lvIcoNameGet((dataModel?.icon?.int32Value)!, type: .vipIcoLv))

			// lvImageView.image = UIImage(named: lvIcoNameGet((dataModel?.icon?.intValue)!, type: .VipIcoLv))
			if (dataModel?.ruled?.int32Value == 3)
			{
				txtName.text = "\(dataModel!.name!) (主播)";
				txtName.textColor = UIColor.purple;
				lvImageView.image = UIImage(named: lvIcoNameGet((dataModel?.lv?.int32Value)!, type: .hostIcoLV))
				lvImageView.scale(1.5, ySclae: 1.5)
			}
			else {
				txtName.text = dataModel?.name;
				txtName.textColor = UIColor.black;
				lvImageView.image = UIImage(named: lvIcoNameGet((dataModel?.richLv.int32Value)!, type: .userIcoLv))
				lvImageView.scale(1.5, ySclae: 1.5)
			}

		}
	}

}
