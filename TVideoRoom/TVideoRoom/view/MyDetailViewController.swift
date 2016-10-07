//
//  MyDetailView.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/6/26.
//  Copyright © 2016年 张新华. All rights reserved.
//

import UIKit
import SnapKit

class MyDetailViewController: BaseUIViewController {

	lazy var infoView: InfoView = {
		var info = InfoView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight));
		info.myVC = self;
		return info;
	}();


	override func viewDidLoad() {
		super.viewDidLoad();
		self.view.backgroundColor = UIColor.whiteColor();
		self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor();
		navigationItem.title = "个人信息";
		self.view.addSubview(infoView);
	
	}

	override func viewDidAppear(animated: Bool) {
		self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor();
	}

}