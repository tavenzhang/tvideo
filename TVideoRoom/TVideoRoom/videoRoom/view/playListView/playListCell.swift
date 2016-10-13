//
//  playListCell.swift
//  TVideoRoom
//

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

	override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
		super.init(style: style, reuseIdentifier: reuseIdentifier);
		self.backgroundColor = UIColor.clearColor();
		self.accessoryType = .None;
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
		var lb = self.createLB("1", corlor: UIColor.blueColor());
		self.contentView.addSubview(lb);
		return lb;
	}()
	lazy var txtName: UILabel = {
		var lb: UILabel = self.createLB("天下第一天下第一", corlor: UIColor.blackColor());
		self.contentView.addSubview(lb);
		return lb;
	}()
	lazy var txtMoeny: UILabel = {
		var lb = self.createLB("111111111", corlor: UIColor.redColor());
		self.contentView.addSubview(lb);
		return lb;
	}()

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

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
			txtRank.text = "rank1";
			txtName.text = dataModel?.name;
			txtMoeny.text = "1) ￥";
		}
	}

}
