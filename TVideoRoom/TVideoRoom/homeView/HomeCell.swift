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
    //MARK: - 初始化子空间
    private lazy var backImageView: UIImageView = {
        let backImageView = UIImageView()
        return backImageView
    }()
    
    private lazy var goodsImageView: UIImageView = {
        let goodsImageView = UIImageView()
        goodsImageView.contentMode = UIViewContentMode.ScaleAspectFit
        return goodsImageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = NSTextAlignment.Left
        nameLabel.font = HomeCollectionTextFont
        nameLabel.textColor = UIColor.purpleColor()
        return nameLabel
    }()
    
    private lazy var fineImageView: UIImageView = {
        let fineImageView = UIImageView()
        fineImageView.image = UIImage(named: "jingxuan.png")
        return fineImageView
    }()
    
    private lazy var giveImageView: UIImageView = {
        let giveImageView = UIImageView()
        giveImageView.image = UIImage(named: "buyOne.png")
        return giveImageView
    }()
    
    private lazy var specificsLabel: UILabel = {
        let specificsLabel = UILabel()
        specificsLabel.textColor = UIColor.colorWithCustom(100, g: 100, b: 100)
        specificsLabel.font = UIFont.systemFontOfSize(12)
        specificsLabel.textAlignment = .Left
        return specificsLabel
    }()
    

    
    
    private var type: HomeCellTyep? {
        didSet {
            backImageView.hidden = !(type == HomeCellTyep.Horizontal)
            goodsImageView.hidden = (type == HomeCellTyep.Horizontal)
            //nameLabel.hidden = (type == HomeCellTyep.Horizontal)
            fineImageView.hidden = (type == HomeCellTyep.Horizontal)
            giveImageView.hidden = (type == HomeCellTyep.Horizontal)
            specificsLabel.hidden = (type == HomeCellTyep.Horizontal)
        }
    }
    
    var addButtonClick:((imageView: UIImageView) -> ())?
    
    // MARK: - 便利构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        addSubview(backImageView)
        addSubview(goodsImageView)
        addSubview(fineImageView)
        addSubview(giveImageView)
        addSubview(specificsLabel)
        addSubview(nameLabel)
        
        weak var tmpSelf = self
  
    }
    
    // MARK: - 模型set方法
    var activities: Activity? {
        didSet {
            self.type = .Horizontal
            backImageView.sd_setImageWithURL(NSURL(string: activities!.hostImg!), placeholderImage: UIImage(named: "v2_placeholder_full_size"))
            nameLabel.text=activities!.username;
            nameLabel.hidden = false;
        }
    }
    
    var goods: Goods? {
        didSet {
            self.type = .Vertical
//            goodsImageView.sd_setImageWithURL(NSURL(string: goods!.img!), placeholderImage: UIImage(named: "v2_placeholder_square"))
//            nameLabel.text = goods?.name
//            if goods!.pm_desc == "买一赠一" {
//                giveImageView.hidden = false
//            } else {
//                
//                giveImageView.hidden = true
//            }
//            
//            specificsLabel.text = goods?.specifics

        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backImageView.frame = bounds
        goodsImageView.frame = CGRectMake(0, 0, width, width)
        nameLabel.frame = CGRectMake(5, height-nameLabel.height-20, 100, 20)
        fineImageView.frame = CGRectMake(5, CGRectGetMaxY(nameLabel.frame), 30, 15)
        giveImageView.frame = CGRectMake(CGRectGetMaxX(fineImageView.frame) + 3, fineImageView.y, 35, 15)
        specificsLabel.frame = CGRectMake(nameLabel.x, CGRectGetMaxY(fineImageView.frame), width, 20)
    }
    
}
