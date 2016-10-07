//
//  HomeCell.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/6/26.
//  Copyright © 2016年 张新华. All rights reserved.
//

import UIKit

enum HomeCellTyep: Int {
	case Horizontal = 0
	case Vertical = 1
}

class HomeCell: UICollectionViewCell {
	// MARK: - 初始化子空间
	private lazy var backImageView: UIImageView = {
		let backImageView = UIImageView()
		return backImageView
	}()

//    private lazy var goodsImageView: UIImageView = {
//        let goodsImageView = UIImageView()
//        goodsImageView.contentMode = UIViewContentMode.ScaleAspectFit
//        return goodsImageView
//    }()

	private lazy var nameLabel: UILabel = {
		let nameLabel = UILabel()
		nameLabel.textAlignment = NSTextAlignment.Left
		nameLabel.font = HomeCollectionTextFont
		nameLabel.textColor = UIColor.purpleColor()
		return nameLabel
	}()

	private lazy var giveImageView: UIImageView = {
		let giveImageView = UIImageView()
		giveImageView.image = UIImage(named: r_home_live_img);
		giveImageView.backgroundColor = UIColor.colorWithCustom(212, g: 84, b: 91);
		return giveImageView
	}()

	private lazy var specificsLabel: UILabel = {
		let specificsLabel = UILabel()
		specificsLabel.textColor = UIColor.colorWithCustom(212, g: 84, b: 91);
		specificsLabel.font = UIFont.systemFontOfSize(12)
		specificsLabel.textAlignment = .Left
		return specificsLabel
	}()

	private var type: HomeCellTyep? {
		didSet {
			backImageView.hidden = !(type == HomeCellTyep.Horizontal)
		}
	}

	var addButtonClick: ((imageView: UIImageView) -> ())?

	// MARK: - 便利构造方法
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = UIColor.whiteColor()
		addSubview(backImageView)
		addSubview(giveImageView)
		// addSubview(specificsLabel)
		addSubview(nameLabel)

	}

	// MARK: - 模型set方法
	var activities: Activity? {
		didSet {
			self.type = .Horizontal
			let imageUrl = NSString(format: HTTP_IMAGE, activities!.headimg!) as String;
			backImageView.sd_setImageWithURL(NSURL(string: imageUrl), placeholderImage: UIImage(named: r_home_videoImgPlaceholder))
			nameLabel.text = activities!.username;
			nameLabel.hidden = false;
			giveImageView.hidden = activities!.live_status == 0;
		}
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - 布局
	override func layoutSubviews() {
		super.layoutSubviews()
		backImageView.frame = bounds
		// goodsImageView.frame = CGRectMake(0, 0, width, width)
		nameLabel.frame = CGRectMake(5, height - nameLabel.height - 20, 100, 20);
		// giveImageView.frame = CGRectMake(width-30,6, 44, 32);
		giveImageView.frame = CGRectMake(width - 32, 6, 25, 16);
	}

}
