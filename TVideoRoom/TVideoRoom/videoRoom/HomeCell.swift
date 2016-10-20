//
//  HomeCell.swift
//  TVideoRoom
//
//  Created by  on 16/6/26.
//  Copyright © 2016年 . All rights reserved.
//

import UIKit

enum HomeCellTyep: Int {
	case horizontal = 0
	case vertical = 1
}

class HomeCell: UICollectionViewCell {
	// MARK: - 初始化子空间
	fileprivate lazy var backImageView: UIImageView = {
		let backImageView = UIImageView()
		return backImageView
	}()

//    private lazy var goodsImageView: UIImageView = {
//        let goodsImageView = UIImageView()
//        goodsImageView.contentMode = UIViewContentMode.ScaleAspectFit
//        return goodsImageView
//    }()

	fileprivate lazy var nameLabel: UILabel = {
		let nameLabel = UILabel()
		nameLabel.textAlignment = NSTextAlignment.left
		nameLabel.font = HomeCollectionTextFont
		nameLabel.textColor = UIColor.purple
		return nameLabel
	}()

	fileprivate lazy var giveImageView: UIImageView = {
		let giveImageView = UIImageView()
		giveImageView.image = UIImage(named: r_home_live_img);
		giveImageView.backgroundColor = UIColor.colorWithCustom(212, g: 84, b: 91);
		return giveImageView
	}()

	fileprivate lazy var specificsLabel: UILabel = {
		let specificsLabel = UILabel()
		specificsLabel.textColor = UIColor.colorWithCustom(212, g: 84, b: 91);
		specificsLabel.font = UIFont.systemFont(ofSize: 12)
		specificsLabel.textAlignment = .left
		return specificsLabel
	}()

	fileprivate var type: HomeCellTyep? {
		didSet {
			backImageView.isHidden = !(type == HomeCellTyep.horizontal)
		}
	}

	var addButtonClick: ((_ imageView: UIImageView) -> ())?

	// MARK: - 便利构造方法
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = UIColor.white
		addSubview(backImageView)
		addSubview(giveImageView)
		// addSubview(specificsLabel)
		addSubview(nameLabel)

	}

	// MARK: - 模型set方法
	var activities: Activity? {
		didSet {
			self.type = .horizontal
			let imageUrl = NSString(format: HTTP_IMAGE as NSString, activities!.headimg!) as String;
			backImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: r_home_videoImgPlaceholder))
			nameLabel.text = activities!.username;
			nameLabel.isHidden = false;
			giveImageView.isHidden = activities!.live_status == 0;
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
		nameLabel.frame = CGRect(x: 5, y: height - nameLabel.height - 20, width: 100, height: 20);
		// giveImageView.frame = CGRectMake(width-30,6, 44, 32);
		giveImageView.frame = CGRect(x: width - 32, y: 6, width: 25, height: 16);
	}

}
