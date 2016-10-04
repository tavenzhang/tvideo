//
//  HotLiveCell.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/10/4.
//  Copyright © 2016年 张新华. All rights reserved.
//

import UIKit

class HotLiveCell: UICollectionViewCell {
	@IBOutlet weak var txtperson: UILabel!

	@IBOutlet weak var imgLv: UIImageView!;

	@IBOutlet weak var txtname: UILabel!

	@IBOutlet weak var imgBigView: UIImageView!;

	@IBOutlet weak var imglive: UIImageView!
	@IBOutlet weak var imgHeadView: UIImageView!
	@IBOutlet weak var btnLocation: UIButton!;

	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
    
//
//	override func setSelected(selected: Bool, animated: Bool) {
//		super.setSelected(selected, animated: animated)
//
//		// Configure the view for the selected state
//	}

	var hotData: Activity?
	{
		didSet {
			self.txtperson.text = "6000观看";
			self.txtname.text = hotData?.username;
			let imageUrl = NSString(format: HTTP_IMAGE, hotData!.headimg!) as String;
			self.imgHeadView.sd_setImageWithURL(NSURL(string: imageUrl), placeholderImage: UIImage(named: "v2_placeholder_full_size"));
			self.imgHeadView.layer.cornerRadius = 20;
			self.imgHeadView.layer.masksToBounds = true
			self.imgBigView.sd_setImageWithURL(NSURL(string: imageUrl), placeholderImage: UIImage(named: "v2_placeholder_full_size"));
			imglive.hidden = false;
			btnLocation.setTitle("来自神秘花园", forState: .Normal);
		}
	}
}
