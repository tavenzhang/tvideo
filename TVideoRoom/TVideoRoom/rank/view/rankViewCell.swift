//
//  rankViewCell.swift

class RankViewCell: UITableViewCell {

	class func cellFormTablView(_ tableView: UITableView, _ indexPath: IndexPath) -> RankViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? RankViewCell ;
		if (cell == nil)
		{
			tableView.register(RankViewCell.self, forCellReuseIdentifier: "cell");
			cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RankViewCell ;
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
		self.addSubview(lbRank);
		self.addSubview(lvImageView)
		self.addSubview(txtName);
		self.addSubview(imgHeadView);
		self.lbRank.snp.makeConstraints { (make) in
			make.centerY.equalTo(self);
			make.left.equalTo(self.snp.left).offset(30);
		}
		self.txtName.snp.makeConstraints { (make) in
			make.centerY.equalTo(self);
			make.left.equalTo(self.width / 2 - 20);
		}

		self.lvImageView.snp.makeConstraints { (make) in
			make.centerY.equalTo(self);
			make.right.equalTo(self.snp.right).offset(-30);
		}
		imgHeadView.snp.makeConstraints { (make) in
			make.right.equalTo(self.txtName.snp.left).offset(-10);
			make.width.height.equalTo(40);
		}
	}

	lazy var lbRank = UILabel.lableSimple("", corlor: UIColor.purple, size: 14);

	lazy var txtName: UILabel = self.createLB("天下第一天下第一", corlor: UIColor.black);

	lazy var lvImageView = UIImageView();
	var imgHeadView = UIImageView();

	func createLB(_ title: String, corlor: UIColor) -> UILabel {
		let lb = UILabel();
		lb.textColor = corlor;
		lb.text = title;
		lb.font = UIFont.boldSystemFont(ofSize: 14);
		lb.textAlignment = NSTextAlignment.left;
		lb.adjustsFontSizeToFitWidth = false;
		return lb;
	}

	var dataModel: rankInfoModel? {
		didSet {
			lbRank.text = (dataModel?.rankId)! <= 9 ? "0\(dataModel!.rankId)" : "\(dataModel!.rankId )";
			if ((dataModel?.rankId)! > 3)
			{
				lbRank.textColor = UIColor.gray;
			}
			else {
				lbRank.textColor = UIColor.purple;
			}
			txtName.text = dataModel?.username;
			let imageUrl = NSString(format: HTTP_SMALL_IMAGE as NSString, dataModel!.headimg!) as String;
			self.imgHeadView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "v2_placeholder_full_size"));
			self.imgHeadView.layer.cornerRadius = 20;
			self.imgHeadView.layer.masksToBounds = true;
			if (dataModel!.isHost)
			{
				lvImageView.image = UIImage(named: lvIcoNameGet((dataModel?.lv_exp?.int32Value)!, type: .hostIcoLV))
				lvImageView.scale(2, ySclae: 2)
			}
			else {
				txtName.textColor = UIColor.black;
				lvImageView.image = UIImage(named: lvIcoNameGet((dataModel?.lv_rich!.int32Value)!, type: .userIcoLv))
				lvImageView.scale(1.5, ySclae: 1.5)
			}

		}
	}

}

