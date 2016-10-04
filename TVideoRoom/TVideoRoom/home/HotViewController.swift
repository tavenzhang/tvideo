//
//  HotViewController.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/10/3.
//  Copyright © 2016年 张新华. All rights reserved.
//

import UIKit
import TAmf3Socket
import TRtmpPlay
import SwiftyJSON
import TChat

class HotViewController: BaseUIViewController {

	private var flag: Int = -1
	private var collectionView: LFBCollectionView!
	private var lastContentOffsetY: CGFloat = 0;

	// 热播列表
	var hotList: [Activity]?;

	override func viewDidLoad() {
		// addNotification()
		super.viewDidLoad();
		buildCollectionView();
		buildTableData();
	}

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self);
	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated);
		Flurry.logEvent("enter home");

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.

	}

	func getMoreFresh() {
		headRefresh() ;
	}
	/**
     下拉获取
     - author: taven
     - date: 16-06-28 10:06:20
     */
	func buildTableData() -> Void {
		headRefresh();
	}

	/**
     获取数据
     - author: taven
     - date: 16-06-28 09:06:33
     */
	func headRefresh() {
		let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
		loadProgressAnimationView.startLoadProgressAnimation();
		dispatch_async(queue) {
			HttpTavenService.requestJson(HTTP_HOST_LIST) {
				(dataResutl: HttpResult) in
				self.collectionView.mj_header.endRefreshing();
				self.collectionView.hidden = false;
				self.loadProgressAnimationView.endLoadProgressAnimation();
				self.collectionView.mj_footer.endRefreshing();
				if (dataResutl.dataJson == nil || !dataResutl.isSuccess)
				{
					return;
				}
				var data = dataResutl.dataJson!;
				let genData = data["sls"].arrayObject ;
				if ((genData) != nil)
				{
					self.hotList = BaseDeSerialsModel.objectsWithArray(genData!, cls: Activity.classForCoder()) as? [Activity];
//					self.hotList = self.hotList!.filter({ (item: Activity) -> Bool in
//						return item.live_status != 0;
//					})
				}
				dispatch_async(dispatch_get_main_queue()) {
					[unowned self] in
					self.collectionView.reloadData()
				}
			}
		}
	}

	// 建立集合
	func buildCollectionView() -> Void {
		let layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 5
		layout.minimumLineSpacing = 8
		layout.sectionInset = UIEdgeInsets(top: 0, left: HomeCollectionViewCellMargin, bottom: 0, right: HomeCollectionViewCellMargin)
		layout.headerReferenceSize = CGSizeMake(0, 22);
		collectionView = LFBCollectionView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64), collectionViewLayout: layout)
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.backgroundColor = LFBGlobalBackgroundColor

//        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ALinHotLiveCell class]) bundle:nil] forCellReuseIdentifier:
//            reuseIdentifier];
//        [self.tableView registerClass:[ALinHomeADCell class] forCellReuseIdentifier:ADReuseIdentifier];
//
//        self.currentPage = 1;
		collectionView.registerNib(UINib(nibName: "HotLiveCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
		// collectionView.registerClass(HotViewCell.self, forCellWithReuseIdentifier: "Cell")
		view.addSubview(collectionView)
		let refreshHeadView = LFBRefreshHeader(refreshingTarget: self, refreshingAction: #selector(HomeViewController.headRefresh));
		collectionView.mj_header = refreshHeadView;
		let refreshFootView = LFBRefreshFooter(refreshingTarget: self, refreshingAction: #selector(HomeViewController.getMoreFresh));
		collectionView.mj_footer = refreshFootView;
		self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0);
	}

}

extension HotViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if (hotList != nil)
		{
			return (hotList?.count)! ;
		}
		return 0;
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! HotLiveCell
		cell.hotData = hotList?[indexPath.row];
		return cell
	}

	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {

		return 1
	}
	// 设置item 宽
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		let w = ScreenWidth;
		let h = (320/ScreenWidth) * 400
		let itemSize = CGSizeMake(w, h);

		return itemSize
	}

	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CGSizeZero
	}

	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {

		return CGSizeZero
	}

	func collectionView(collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, atIndexPath indexPath: NSIndexPath) {
		// if indexPath.section == 1 && headData != nil && freshHot != nil && isAnimation {
//		if indexPath.section == 1 && homeData != nil && isAnimation {
//			startAnimation(view, offsetY: 60, duration: 0.2)
//		}
	}

	// TODO MARK: 查看更多商品被点击
	func moreGoodsClick(tap: UITapGestureRecognizer) {
		if tap.view?.tag == 100 {
//			let tabBarController = UIApplication.sharedApplication().keyWindow?.rootViewController as! MainTabBarController;
			// tabBarController.setSelectIndex(from: 0, to: 1)
		}
	}

	// MARK: - ScrollViewDelegate
	func scrollViewDidScroll(scrollView: UIScrollView) {
		// if animationLayers?.count > 0 {
		// let transitionLayer = animationLayers![0]
		// transitionLayer.hidden = true
		// }

		if scrollView.contentOffset.y <= scrollView.contentSize.height {
			// isAnimation = lastContentOffsetY < scrollView.contentOffset.y
			lastContentOffsetY = scrollView.contentOffset.y;
		}
	}

	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		var itemAcive: Activity;
		itemAcive = (hotList?[indexPath.row])!;
		let roomId = itemAcive.uid as! Int;
		let roomview: VideoRoomUIView = VideoRoomUIView();
		roomview.c2sGetSocket(roomId);
		self.navigationController?.pushViewController(roomview, animated: true);
		Flurry.logEvent("enter videoRoom", withParameters: ["roomId": roomId], timed: false);
	}
}
