// Created by 张新华 on 16/6/2.
//  Copyright © 2016年 张新华. All rights reserved.
//

import UIKit
import TAmf3Socket
import TRtmpPlay
import SwiftyJSON
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
	switch (lhs, rhs) {
	case let (l?, r?):
		return l < r
	case (nil, _?):
		return true
	default:
		return false
	}
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
	switch (lhs, rhs) {
	case let (l?, r?):
		return l > r
	default:
		return rhs < lhs
	}
}

class VideoListViewController: BaseUIViewController {

	fileprivate var flag: Int = -1
	fileprivate var collectionView: LFBCollectionView!
	fileprivate var lastContentOffsetY: CGFloat = 0
	fileprivate var isAnimation: Bool = false
	fileprivate var videoList: [Activity]? = [];

	var loadFunHandl: loadDataFun?;
	// var titleHash: [Int: String] = [Int: String]();
	override func viewDidLoad() {
		super.viewDidLoad()
		buildCollectionView()
		buildTableData();
	}

	deinit {

	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated);
		headRefresh();
	}

	override func viewDidAppear(_ animated: Bool) {
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
		layout.headerReferenceSize = CGSize(width: 0, height: 22);
		collectionView = LFBCollectionView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - 64), collectionViewLayout: layout)
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.backgroundColor = LFBGlobalBackgroundColor
		collectionView.register(HomeCell.self, forCellWithReuseIdentifier: "Cell")
		collectionView.register(HomeCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView");
		view.addSubview(collectionView)
		let refreshHeadView = LFBRefreshHeader(refreshingTarget: self, refreshingAction: #selector(VideoListViewController.headRefresh));
		collectionView.mj_header = refreshHeadView;
		let refreshFootView = LFBRefreshFooter(refreshingTarget: self, refreshingAction: #selector(VideoListViewController.headRefresh));
		collectionView.mj_footer = refreshFootView;
		self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0);
		self.collectionView.isHidden = true;
	}

	/**
     获取数据
     */
	func headRefresh() {
		loadProgressAnimationView.startLoadProgressAnimation();
		if (loadFunHandl != nil)
		{
			loadFunHandl?();
		}
	}

	// 数据加载完成刷新
	func loadDataFinished(_ dataList: [Activity]) -> Void {
		self.collectionView.mj_header.endRefreshing();
		self.collectionView.isHidden = false;
		self.collectionView.mj_footer.endRefreshing();
		self.loadProgressAnimationView.endLoadProgressAnimation();
		videoList = dataList;
		self.collectionView.reloadData();
	}

	/**
     下拉获取
     */
	func buildTableData() -> Void {
		// var titleHash: [Int: String] = [Int: String]();
//		titleHash[1] = "小编推荐";
//		titleHash[3] = "大秀场";
//		titleHash[2] = "才艺主播";
	}

}

extension VideoListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//		if section == 0 {
//			return homeData?.hotList?.count ?? 0
//		} else if section == 1 {
//			return homeData?.homeList?.count ?? 0
//		}
		return (videoList?.count)!;
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HomeCell
		cell.activities = videoList?[(indexPath as NSIndexPath).row];
		return cell;
	}

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	// 设置item 宽
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		var itemSize = CGSize.zero
//        if indexPath.section == 0 {
//            itemSize = CGSizeMake(ScreenWidth - HomeCollectionViewCellMargin * 2, 140)
//        } else if indexPath.section == 1 {
//            itemSize = CGSizeMake((ScreenWidth - HomeCollectionViewCellMargin * 2) * 0.5 - 4, 250)
//        }
		itemSize = CGSize(width: (ScreenWidth - HomeCollectionViewCellMargin * 2) * 0.5 - 4, height: 130)
		return itemSize
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//		if section == 0 {
//			return CGSizeMake(ScreenWidth, HomeCollectionViewCellMargin * 2);
//		} else if section == 1 {
//			return CGSizeMake(ScreenWidth, HomeCollectionViewCellMargin * 2);
//		}

		return CGSize.zero
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		if section == 0 {
			return CGSize(width: ScreenWidth, height: HomeCollectionViewCellMargin)
		} else if section == 1 {
			// return CGSizeMake(ScreenWidth, HomeCollectionViewCellMargin*2)
		}

		return CGSize.zero
	}

	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

		if (indexPath as NSIndexPath).section == 0 && ((indexPath as NSIndexPath).row == 0 || (indexPath as NSIndexPath).row == 1) {
			return
		}

		if isAnimation {
			startAnimation(cell, offsetY: 80, duration: 0.5)
		}
	}

	fileprivate func startAnimation(_ view: UIView, offsetY: CGFloat, duration: TimeInterval) {

		view.transform = CGAffineTransform(translationX: 0, y: offsetY);
		UIView.animate(withDuration: duration, animations: { () -> Void in
			view.transform = CGAffineTransform.identity
		})
	}

	func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
		// if indexPath.section == 1 && headData != nil && freshHot != nil && isAnimation {
		if videoList?.count > 0 && isAnimation {
			startAnimation(view, offsetY: 60, duration: 0.2)
		}
	}

	// MARK: - ScrollViewDelegate
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView.contentOffset.y <= scrollView.contentSize.height {
			isAnimation = lastContentOffsetY < scrollView.contentOffset.y
			lastContentOffsetY = scrollView.contentOffset.y;
		}
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		var itemAcive: Activity;
		itemAcive = (videoList?[(indexPath as NSIndexPath).row])!;
		let roomId = itemAcive.uid as! Int;
		if (roomId > 0)
		{
			DataCenterModel.enterVideoRoom(rid: roomId, vc: self.navigationController!)
		}
		else {
			showSimplpAlertView(self, tl: "房间不存在", msg: "该房间id错误！");
		}

	}
}

