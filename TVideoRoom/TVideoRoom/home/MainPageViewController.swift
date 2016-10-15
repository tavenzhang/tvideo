//
//  MainPageViewController.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/10/4.
//  Copyright © 2016年 张新华. All rights reserved.
//

import UIKit
typealias loadDataFun = () -> Void;

class MainPageViewController: UIViewController, UIScrollViewDelegate {

	var menuBar: MenuBarView?;
	var scrollView: UIScrollView?;
	var hotliveVC: HotViewController?;
	var homeVC: VideoListViewController?;
	var careVC: VideoListViewController?;
	var isRequestIng: Bool = false;
	lazy var serachViewVC: UISearchViewController = {
		LogHttp("create serachViewVC");
		var svc = UISearchViewController() ;
		svc.view.frame = UIScreen.main.bounds;
		return svc;
	}();

	func createView() {
		let view = UIScrollView(frame: UIScreen.main.bounds)
		view.contentSize = CGSize(width: ScreenWidth * 3, height: 0);
		view.backgroundColor = UIColor.white
		// 去掉滚动条
		view.showsVerticalScrollIndicator = false
		view.showsHorizontalScrollIndicator = false
		// 设置分页
		view.isPagingEnabled = true
		// 设置代理
		view.delegate = self
		// 去掉弹簧效果
		view.bounces = false
		let height: CGFloat = ScreenHeight - 49;
		// 添加子视图
		hotliveVC = HotViewController();
		hotliveVC?.loadFunHandl = loadDataEvent;
		hotliveVC!.view.frame = UIScreen.main.bounds
		hotliveVC!.view.height = height;
		self.addChildViewController(hotliveVC!);
		view.addSubview(hotliveVC!.view)

		homeVC = VideoListViewController();
		homeVC?.loadFunHandl = loadDataEvent;
		homeVC!.view.frame = UIScreen.main.bounds
		homeVC!.view.x = ScreenWidth;
		homeVC!.view.height = height
		self.addChildViewController(homeVC!)
		view.addSubview(homeVC!.view);

		careVC = VideoListViewController()
		careVC!.view.frame = UIScreen.main.bounds;
		careVC!.view.x = ScreenWidth * 2;
		careVC?.loadFunHandl = loadDataEvent;
		self.addChildViewController(careVC!);
		view.addSubview(careVC!.view);
		self.scrollView = view;
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		createView();
		self.view.addSubview(self.scrollView!);
		setup();
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated);
		if (self.menuBar == nil)
		{
			setupTopMenu();
		}
	}

	func setup() {
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: r_home_btnSrarch)!, style: .done, target: self, action: #selector(self.searchHostVideo));
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: r_home_btnRank)!, style: .done, target: self, action: #selector(self.rankCrown));
		self.setupTopMenu();
	}

	func rankCrown() {
		let web = WebViewController(navigationTitle: "排行", urlStr: "http://www.baidu.com");
		self.menuBar!.removeFromSuperview()
		self.menuBar = nil
		self.navigationController!.pushViewController(web, animated: true)
	}

	func searchHostVideo() {
		serachViewVC.parentNVC = self.navigationController;
		self.view.addSubview(serachViewVC.view);
	}

	func loadDataEvent() -> Void {
		if (isRequestIng)
		{
			return;
		}
		isRequestIng = true;
		let queue = DispatchQueue.global(qos: .default);
		queue.async {
			LogHttp("open---getData");
			HttpTavenService.requestJson(getWWWHttp(HTTP_HOME_LIST)) {
				(dataResutl: HttpResult) in
				let homeData = DataCenterModel.sharedInstance.homeData;
				if (dataResutl.dataJson == nil || !dataResutl.isSuccess)
				{
					homeData.totalList = [Activity]();
					homeData.homeList = [Activity]();
					homeData.hotList = [Activity]();
					homeData.oneByOneList = [Activity]();
				}
				else {
					var data = dataResutl.dataJson!;
					let genData = data["rooms"].arrayObject ;

					if ((genData) != nil)
					{
						homeData.totalList = deserilObjectsWithArray(genData! as NSArray, cls: Activity.classForCoder()) as? [Activity];
						homeData.totalList = homeData.totalList?.sorted(by: { Int($0.total!) > Int($1.total!) });
						homeData.homeList = homeData.totalList?.sorted(by: { Int($0.live_status!) > Int($1.live_status!) });
						// 大厅在线主播
						homeData.hotList = homeData.homeList?.filter({ (item: Activity) -> Bool in
							return item.live_status != 0;
						})

						homeData.oneByOneList = homeData.homeList?.filter({ (item: Activity) -> Bool in
							return (item.lv_type == 3) && (item.live_status != 0);
						})
					}
				}

				DispatchQueue.main.async {
					let homeData = DataCenterModel.sharedInstance.homeData;
					self.hotliveVC?.loadDataFinished(homeData.hotList!);
					self.careVC?.loadDataFinished(homeData.oneByOneList!);
					self.homeVC?.loadDataFinished(homeData.homeList!);
					self.isRequestIng = false;
				}
			}
		}
	}

	func setupTopMenu() {
		// 设置顶部选择视图
		self.menuBar = MenuBarView(frame: self.navigationController!.navigationBar.bounds);
		menuBar!.x = 45
		menuBar!.width = ScreenWidth - 45 * 2;

		menuBar!.selectedBlock = { (type: Int) -> Void in
			self.scrollView!.setContentOffset(CGPoint(x: CGFloat(type) * ScreenWidth, y: 0), animated: true)
		}
		self.navigationController!.navigationBar.addSubview(self.menuBar!)
	}

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let page: CGFloat = scrollView.contentOffset.x / ScreenWidth
		if ((self.menuBar) != nil)
		{
			let offsetX: CGFloat = scrollView.contentOffset.x / ScreenWidth * (self.menuBar!.width * 0.5 - Home_Seleted_Item_W * 0.5 - 15)
			self.menuBar!.underLine.x = 15 + offsetX
			if page == 1 {
				self.menuBar!.underLine.x = offsetX + 10
			}
			else if page > 1 {
				self.menuBar!.underLine.x = offsetX + 5
			}
			self.menuBar!.setSelectedType(Int(page + 0.5)) ;
		}

	}
}
