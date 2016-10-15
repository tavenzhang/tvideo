//
//  BaseTabViewController.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/6/25.
//  Copyright © 2016年 张新华. All rights reserved.
//

import UIKit

class BaseUIViewController: UIViewController {

	let loadProgressAnimationView: LoadProgressAnimationView = LoadProgressAnimationView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 3))

	override func viewDidLoad() {
		super.viewDidLoad();
		// buildNavigationItem();
		self.view.addSubview(loadProgressAnimationView);
	}


	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}

	// MARK: - Build UI
//	private func buildNavigationItem() {
//
//		navigationItem.leftBarButtonItem = UIBarButtonItem.barButton("扫一扫", titleColor: UIColor.blackColor(),
//			image: UIImage(named: "icon_black_scancode")!, hightLightImage: nil,
//			target: self, action: #selector(BaseUIViewController.leftItemClick), type: ItemButtonType.Left)
//
//		navigationItem.rightBarButtonItem = UIBarButtonItem.barButton("搜 索", titleColor: UIColor.blackColor(),
//			image: UIImage(named: "icon_search")!, hightLightImage: nil,
//			target: self, action: #selector(BaseUIViewController.rightItemClick), type: ItemButtonType.Right) // navigationItem.title="hello!"
//	}

	// MARK:- Action
	// MARK: 扫一扫和搜索Action
	func leftItemClick() {
		// let qrCode = QRCodeViewController()
		// navigationController?.pushViewController(qrCode, animated: true)
	}

	func rightItemClick() {
		// let searchVC = SearchProductViewController()
		// navigationController!.pushViewController(searchVC, animated: false)
	}

	func titleViewClick() {
		// weak var tmpSelf = self;

//        let adressVC = MyAdressViewController { (adress) -> () in
//            let titleView = AdressTitleView(frame: CGRectMake(0, 0, 0, 30))
//            titleView.setTitle(adress.address!)
//            titleView.frame = CGRectMake(0, 0, titleView.adressWidth, 30)
//            tmpSelf?.navigationItem.titleView = titleView
//            UserInfo.sharedUserInfo.setDefaultAdress(adress)
//
//            let tap = UITapGestureRecognizer(target: self, action: #selector(SelectedAdressViewController.titleViewClick))
//            tmpSelf?.navigationItem.titleView?.addGestureRecognizer(tap)
//        }
//        adressVC.isSelectVC = true
//        navigationController?.pushViewController(adressVC, animated: true)
	}

}
