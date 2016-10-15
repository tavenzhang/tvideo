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
		var info = InfoView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight));
		info.myVC = self;
		return info;
	}();


	override func viewDidLoad() {
		super.viewDidLoad();
		self.view.backgroundColor = UIColor.white;
		self.navigationController?.navigationBar.barTintColor = UIColor.white;
		navigationItem.title = "个人信息";
		self.view.addSubview(infoView);
	
	}

	override func viewDidAppear(_ animated: Bool) {
		self.navigationController?.navigationBar.barTintColor = UIColor.white;
	}

}
