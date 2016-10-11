//
//  GiftShopCell.swift
//  TVideoRoom
//
import SnapKit

class GiftShopCell: UICollectionViewCell {
	// MARK: - 初始化子空间
	private lazy var backImageView: UIImageView = {
		let backImageView = UIImageView()
		return backImageView
	}()

	var nameLabel = UILabel.lableSimple("", corlor: UIColor.blackColor(), size: 10, align: NSTextAlignment.Center);

	var priceLabel: UILabel = UILabel.lableSimple("", corlor: UIColor.grayColor(), size: 8, align: NSTextAlignment.Center);

	var newLabel: UILabel = UILabel.lableSimple("new!", corlor: UIColor.redColor(), size: 9, align: NSTextAlignment.Center);

	var addButtonClick: ((imageView: UIImageView) -> ())?

	// MARK: - 便利构造方法
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = UIColor.whiteColor()
		addSubview(backImageView);
		addSubview(nameLabel);
		addSubview(priceLabel);
		addSubview(newLabel);
		backImageView.snp_makeConstraints { (make) in
			make.centerX.equalTo(0);
			make.top.equalTo(5);
			make.width.height.equalTo(40);
		}
		nameLabel.snp_makeConstraints { (make) in
			make.top.equalTo(backImageView.snp_bottom).offset(-1);
			make.centerX.equalTo(0);

		}
		priceLabel.snp_makeConstraints { (make) in
			make.top.equalTo(nameLabel.snp_bottom).offset(1);
			make.centerX.equalTo(0);

		}
		newLabel.snp_makeConstraints { (make) in
			make.top.equalTo(self.snp_top).offset(1);
			make.right.equalTo(self.snp_right).offset(-2)
		}
		self.layer.borderWidth = 1;
		self.layer.borderColor = UIColor.grayColor().CGColor;

	}
	override var selected: Bool {
		didSet {
			super.selected = selected;
			self.backgroundColor = selected ? UIColor.redColor().colorWithAlphaComponent(0.5) : UIColor.whiteColor();
		}
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	// MARK: - 模型set方法
	var shopGiftModel: GiftDetailModel? {
		didSet {
			let gidId = shopGiftModel!.gid!.intValue;
			let imageUrl = getGiftImagUrl(gidId.description);
			backImageView.sd_setImageWithURL(NSURL(string: imageUrl), placeholderImage: UIImage(named: r_home_videoImgPlaceholder));
			nameLabel.text = shopGiftModel?.name;
			priceLabel.text = (shopGiftModel?.price?.description)! + "钻石";
			nameLabel.hidden = false;
			newLabel.hidden = shopGiftModel!.isNew == "0" ;

		}
	}

	// var selected: Bool
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

// MARK: - 布局
	override func layoutSubviews() {
		super.layoutSubviews();
	}

}
