//
//  HotLiveCell.swift
//  TVideoRoom
//
//  Created by  on 16/10/4.
//  Copyright © 2016年 . All rights reserved.
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

	var hotData: Activity?
	{
		didSet {

			self.txtperson.text = "\(hotData!.total!)人观看";
			self.txtname.text = hotData?.username;
			let imageUrl = NSString(format: HTTP_IMAGE as NSString, hotData!.headimg!) as String;
			self.imgHeadView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "v2_placeholder_full_size"));
			self.imgHeadView.layer.cornerRadius = 20;
			self.imgHeadView.layer.masksToBounds = true;
			self.imgHeadView.layer.borderColor = UIColor.purple.cgColor;
			self.imgHeadView.layer.borderWidth = 1;
			self.imgBigView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "v2_placeholder_full_size"));
			imglive.isHidden = (hotData?.live_status == 0);
			btnLocation.setTitle("来自神秘花园", for: UIControlState());
			// let ico = "hlvr\(hotData!.lv_exp!.intValue)";
			imgLv.image = UIImage(named: lvIcoNameGet(hotData!.lv_exp!.int32Value, type: .hostIcoLV));

		}
	}
}
