//
//  MainTabBarConntroller.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/6/25.
//  Copyright © 2016年 张新华. All rights reserved.
//
import UIKit

class MainTabBarController: UITabBarController {

	private var fristLoadMainTabBarController: Bool = true
	private var adImageView: UIImageView?
	var adImage: UIImage? {
		didSet {
			weak var tmpSelf = self
			adImageView = UIImageView(frame: ScreenBounds)
			adImageView!.image = adImage!
			self.view.addSubview(adImageView!)

			UIImageView.animateWithDuration(3, animations: { () -> Void in
				tmpSelf!.adImageView!.transform = CGAffineTransformMakeScale(1.2, 1.2)
				tmpSelf!.adImageView!.alpha = 0
			}) { (finsch) -> Void in
				tmpSelf!.adImageView!.removeFromSuperview()
				tmpSelf!.adImageView = nil
			}
		}
	}

	// MARK:- view life circle
	override func viewDidLoad() {
		super.viewDidLoad();
		buildMainTabBarChildViewController()
		#if DEBUG
			let a = 2;
		#else
			let a = 3;
		#endif
		print("aaaaaaaaaaa===\(a)")
		self.delegate = self;
	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated);
	}

	func getView(name: String) -> UIViewController {
		return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(name);
	}

	private func buildMainTabBarChildViewController() {
		let manView = MainPageViewController();
		tabBarControllerAddChildViewController(manView, title: "大厅", imageName: r_tabBtn_home, selectedImageName: r_tabBtn_home_r, tag: 0)
		tabBarControllerAddChildViewController(RankViewController(navigationTitle: "排行", urlStr: HTTP_RANK_PAGE), title: "排行", imageName: r_tabBtn_rank, selectedImageName: r_tabBtn_rank_r, tag: 1)
		tabBarControllerAddChildViewController(ActiveViewController(navigationTitle: "活动", urlStr: HTTP_ACITVE_PAGE), title: "活动", imageName: r_tabBtn_active, selectedImageName: r_tabBtn_active_r, tag: 2)
		tabBarControllerAddChildViewController(MyDetailViewController(), title: "我", imageName: r_btn_me, selectedImageName: r_btn_me_r, tag: 3);
	}

	private func tabBarControllerAddChildViewController(childVC: UIViewController, title: String, imageName: String, selectedImageName: String, tag: Int) {
		let vcItem = UITabBarItem(title: title, image: UIImage(named: imageName), selectedImage: UIImage(named: selectedImageName))
		vcItem.tag = tag
		// vcItem.animation = RAMBounceAnimation()
		childVC.tabBarItem = vcItem

		let navigationVC = BaseNavigationController(rootViewController: childVC)
		addChildViewController(navigationVC)
	}

}
extension MainTabBarController: UITabBarControllerDelegate {
	func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {

	}

}
