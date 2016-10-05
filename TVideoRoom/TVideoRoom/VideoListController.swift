// Created by 张新华 on 16/6/2.
//  Copyright © 2016年 张新华. All rights reserved.
//

import UIKit
import TAmf3Socket
import TRtmpPlay
import SwiftyJSON
import TChat

class VideoListViewController: BaseUIViewController {

	private var flag: Int = -1
	private var collectionView: LFBCollectionView!
	private var lastContentOffsetY: CGFloat = 0
	private var isAnimation: Bool = false
	private var videoList: [Activity]? = [];

	var loadFunHandl: loadDataFun?;
	// var titleHash: [Int: String] = [Int: String]();
	override func viewDidLoad() {
		super.viewDidLoad()
		buildCollectionView()
		buildTableData()
		// ProgressHUDManager.setBackgroundColor(UIColor.colorWithCustom(240, g: 240, b: 240))
		// ProgressHUDManager.setFont(UIFont.systemFontOfSize(16));
	}

	deinit {

	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated);
		headRefresh();
	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated);
		Flurry.logEvent("enter home");

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
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
		collectionView.registerClass(HomeCell.self, forCellWithReuseIdentifier: "Cell")
		collectionView.registerClass(HomeCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView")
		// collectionView.registerClass(HomeCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footerView")
		view.addSubview(collectionView)
		let refreshHeadView = LFBRefreshHeader(refreshingTarget: self, refreshingAction: #selector(VideoListViewController.headRefresh));
		collectionView.mj_header = refreshHeadView;
		let refreshFootView = LFBRefreshFooter(refreshingTarget: self, refreshingAction: #selector(VideoListViewController.headRefresh));
		collectionView.mj_footer = refreshFootView;
		self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0);
		self.collectionView.hidden = true;
	}

	/**
     获取数据
     - author: taven
     - date: 16-06-28 09:06:33
     */
	func headRefresh() {
		loadProgressAnimationView.startLoadProgressAnimation();
		if (loadFunHandl != nil)
		{
			loadFunHandl?();
		}
	}

	// 数据加载完成刷新
	func loadDataFinished(dataList: [Activity]) -> Void {
		self.collectionView.mj_header.endRefreshing();
		self.collectionView.hidden = false;
		self.loadProgressAnimationView.endLoadProgressAnimation();
		videoList = dataList;
		self.collectionView.reloadData();
	}


	/**
     下拉获取
     - author: taven
     - date: 16-06-28 10:06:20
     */
	func buildTableData() -> Void {
		// var titleHash: [Int: String] = [Int: String]();
//		titleHash[1] = "小编推荐";
//		titleHash[3] = "大秀场";
//		titleHash[2] = "才艺主播";
	}

}

extension VideoListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//		if section == 0 {
//			return homeData?.hotList?.count ?? 0
//		} else if section == 1 {
//			return homeData?.homeList?.count ?? 0
//		}
		return (videoList?.count)!;
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! HomeCell
		cell.activities = videoList?[indexPath.row];
		return cell;
	}

	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	// 设置item 宽
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		var itemSize = CGSizeZero
//        if indexPath.section == 0 {
//            itemSize = CGSizeMake(ScreenWidth - HomeCollectionViewCellMargin * 2, 140)
//        } else if indexPath.section == 1 {
//            itemSize = CGSizeMake((ScreenWidth - HomeCollectionViewCellMargin * 2) * 0.5 - 4, 250)
//        }
		itemSize = CGSizeMake((ScreenWidth - HomeCollectionViewCellMargin * 2) * 0.5 - 4, 130)
		return itemSize
	}

	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//		if section == 0 {
//			return CGSizeMake(ScreenWidth, HomeCollectionViewCellMargin * 2);
//		} else if section == 1 {
//			return CGSizeMake(ScreenWidth, HomeCollectionViewCellMargin * 2);
//		}

		return CGSizeZero
	}

	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		if section == 0 {
			return CGSizeMake(ScreenWidth, HomeCollectionViewCellMargin)
		} else if section == 1 {
			// return CGSizeMake(ScreenWidth, HomeCollectionViewCellMargin*2)
		}

		return CGSizeZero
	}

	func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {

		if indexPath.section == 0 && (indexPath.row == 0 || indexPath.row == 1) {
			return
		}

		if isAnimation {
			startAnimation(cell, offsetY: 80, duration: 0.5)
		}
	}

	private func startAnimation(view: UIView, offsetY: CGFloat, duration: NSTimeInterval) {

		view.transform = CGAffineTransformMakeTranslation(0, offsetY);
		UIView.animateWithDuration(duration, animations: { () -> Void in
			view.transform = CGAffineTransformIdentity
		})
	}

	func collectionView(collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, atIndexPath indexPath: NSIndexPath) {
		// if indexPath.section == 1 && headData != nil && freshHot != nil && isAnimation {
		if videoList?.count>0 && isAnimation {
			startAnimation(view, offsetY: 60, duration: 0.2)
		}
	}

//	func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//		if kind == UICollectionElementKindSectionHeader {
//
//			let headView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView", forIndexPath: indexPath) as! HomeCollectionHeaderView;
//			headView.titleLabel.text = titleHash[indexPath.section + 1];
//			return headView;
//		}
//
//		let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "footerView", forIndexPath: indexPath) as! HomeCollectionFooterView
//
//		if indexPath.section == 1 && kind == UICollectionElementKindSectionFooter {
//			footerView.showLabel()
//			footerView.tag = 100
//		} else {
//			footerView.hideLabel()
//			footerView.tag = 1
//		}
//
//		return footerView
//	}

	// MARK: - ScrollViewDelegate
	func scrollViewDidScroll(scrollView: UIScrollView) {
		if scrollView.contentOffset.y <= scrollView.contentSize.height {
			isAnimation = lastContentOffsetY < scrollView.contentOffset.y
			lastContentOffsetY = scrollView.contentOffset.y;
		}
	}

	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		var itemAcive: Activity;
		itemAcive = (videoList?[indexPath.row])!;
		let roomId = itemAcive.uid as! Int;
		if (roomId > 0)
		{
			let roomview: VideoRoomUIView = VideoRoomUIView();
			roomview.roomId = roomId;
			Flurry.logEvent("enter videoRoom", withParameters: ["roomId": roomId], timed: false);
		}
		else {
			showSimplpAlertView(self, tl: "房间不存在", msg: "该房间id错误！");
		}

	}
}

