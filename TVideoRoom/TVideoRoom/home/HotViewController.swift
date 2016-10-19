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

class HotViewController: BaseUIViewController {

	var flag: Int = -1
	var collectionView: LFBCollectionView!
	var lastContentOffsetY: CGFloat = 0;

	// 热播列表
	var hotList: [Activity]?;
	var adList: [Activity]?;
	var loadFunHandl: loadDataFun?;

	override func viewDidLoad() {
		super.viewDidLoad();
		buildCollectionView();
		buildTableData();
	}

	deinit {
		NotificationCenter.default.removeObserver(self);
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

	func getMoreFresh() {
		headRefresh() ;
	}
	/**
     下拉获取
     */
	func buildTableData() -> Void {
		var testData = [Activity]();
		let data1 = Activity();
		data1.img = "http://p.lgfxc.net/43cadf050bb5ec86043a99343b2608ee";
		let data2 = Activity()
		data2.img = "http://p.lgfxc.net/43cadf050bb5ec86043a99343b2608ee";
		let data3 = Activity();
		data3.img = "http://p.lgfxc.net/43cadf050bb5ec86043a99343b2608ee";
		testData.append(data1);
		testData.append(data2);
		testData.append(data3);
		adList = testData;
		// headRefresh();
	}

	/**
     获取数据
     */
	func headRefresh() {
		loadProgressAnimationView.startLoadProgressAnimation();
		if (loadFunHandl != nil)
		{
			loadFunHandl?(false);
		}
	}

	// 数据加载完成刷新
	func loadDataFinished(_ dataList: [Activity]) -> Void {
		self.collectionView.mj_header.endRefreshing();
		self.collectionView.mj_footer.endRefreshing();
		self.collectionView.isHidden = false;
		self.loadProgressAnimationView.endLoadProgressAnimation();
		hotList = dataList;
		self.collectionView.reloadData();
	}

	// 建立集合
	func buildCollectionView() -> Void {
		let layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 5
		layout.minimumLineSpacing = 8
		layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		layout.headerReferenceSize = CGSize(width: 0, height: 22);
		collectionView = LFBCollectionView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - 64), collectionViewLayout: layout)
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.backgroundColor = LFBGlobalBackgroundColor
		collectionView.register(UINib(nibName: "HotLiveCell", bundle: nil), forCellWithReuseIdentifier: "Cell");
		collectionView.register(AdBannerView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "adHeaderView")
		view.addSubview(collectionView)
		let refreshHeadView = LFBRefreshHeader(refreshingTarget: self, refreshingAction: #selector(VideoListViewController.headRefresh));
		collectionView.mj_header = refreshHeadView;
		let refreshFootView = LFBRefreshFooter(refreshingTarget: self, refreshingAction: #selector(VideoListViewController.headRefresh));
		collectionView.mj_footer = refreshFootView;
		self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0);
		collectionView.isHidden = true;
	}

}
// MARK:- HomeHeadViewDelegate TableHeadViewAction
extension HotViewController: HomeTableHeadViewDelegate {
	func tableHeadView(_ headView: AdBannerView, focusImageViewClick index: Int) {
		if adList?.count > 0 {
			// let path = NSBundle.mainBundle().pathForResource("FocusURL", ofType: "plist")
			// let array = NSArray(contentsOfFile: path!)
			// let webVC = WebViewController(navigationTitle: headData!.data!.focus![index].username!, urlStr: array![index] as! String)
			// navigationController?.pushViewController(webVC, animated: true)
		}
	}

	func tableHeadView(_ headView: AdBannerView, iconClick index: Int) {
		// if adList?.icons?.count > 0 {
		// let webVC = WebViewController(navigationTitle: headData!.data!.icons![index].username!, urlStr: headData!.data!.icons![index].customURL!)
		// navigationController?.pushViewController(webVC, animated: true)
		// }
	}
}

extension HotViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if (hotList != nil)
		{
			return (hotList?.count)! ;
		}
		return 0;
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HotLiveCell
		cell.hotData = hotList?[(indexPath as NSIndexPath).row];
		return cell
	}

	func numberOfSections(in collectionView: UICollectionView) -> Int {

		return 1
	}
	// 设置item 宽
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let w = ScreenWidth;
		let h = isPlusDevice ? (320 / ScreenWidth) * 450: (320 / ScreenWidth) * 400;
		let itemSize = CGSize(width: w, height: h);

		return itemSize
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		if section == 0 {
			return CGSize(width: AdBannerView.bannerFrame.width, height: AdBannerView.bannerFrame.height);
		}
		return CGSize.zero
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {

		return CGSize.zero
	}

	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		var headView: AdBannerView?;
		if kind == UICollectionElementKindSectionHeader {
			if ((indexPath as NSIndexPath).section == 0)
			{
				headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "adHeaderView", for: indexPath) as? AdBannerView
				headView!.data = adList;
				headView!.delegate = self;
				return headView!;
			}
		}

		return headView!;
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		var itemAcive: Activity;
		itemAcive = (hotList?[(indexPath as NSIndexPath).row])!;
		let roomId = itemAcive.uid as! Int;
		DataCenterModel.enterVideoRoom(rid: roomId, vc: self.navigationController!)
//		let roomview = VideoRoomUIViewVC();
//		roomview.roomId = roomId;
//		self.navigationController?.pushViewController(roomview, animated: true);
//		Flurry.logEvent("enter videoRoom", withParameters: ["roomId": roomId], timed: false);
	}
}
