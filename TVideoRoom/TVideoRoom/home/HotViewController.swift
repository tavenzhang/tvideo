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
	var adList: [Activity]?;
	var loadFunHandl: loadDataFun?;

	override func viewDidLoad() {
		// addNotification()
		super.viewDidLoad();
		buildCollectionView();
		buildTableData();
	}

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self);
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

	func getMoreFresh() {
		headRefresh() ;
	}
	/**
     下拉获取
     - author: taven
     - date: 16-06-28 10:06:20
     */
	func buildTableData() -> Void {
		var testData = [Activity]();
		let data1 = Activity();
		data1.img = "http://p1.1room1.co/public/images/staticad/0039c7e66b7c9b933cc8f482286c52f9_1465799392.jpg";
		let data2 = Activity()
		data2.img = "http://p1.1room1.co/public/images/staticad/e486c9cae6dfd640aaf0396ada2bf09e_1465289179.jpg";
		let data3 = Activity();
		data3.img = "http://p1.1room1.co/public/images/staticad/d401dd628b19326b9f2ef7fcc3b125a8_1458632404.jpg";
		testData.append(data1);
		testData.append(data2);
		testData.append(data3);
		adList = testData;
		// headRefresh();
	}

	/**
     获取数据
     - author: taven
     - date: 16-06-28 09:06:33
     */
	func headRefresh() {
		loadProgressAnimationView.startLoadProgressAnimation();
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
        hotList = dataList;
        self.collectionView.reloadData();
    }

	// 建立集合
	func buildCollectionView() -> Void {
		let layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 5
		layout.minimumLineSpacing = 8
		layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		layout.headerReferenceSize = CGSizeMake(0, 22);
		collectionView = LFBCollectionView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64), collectionViewLayout: layout)
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.backgroundColor = LFBGlobalBackgroundColor
		collectionView.registerNib(UINib(nibName: "HotLiveCell", bundle: nil), forCellWithReuseIdentifier: "Cell");
		collectionView.registerClass(AdBannerView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "adHeaderView")
		view.addSubview(collectionView)
		let refreshHeadView = LFBRefreshHeader(refreshingTarget: self, refreshingAction: #selector(VideoListViewController.headRefresh));
		collectionView.mj_header = refreshHeadView;
		let refreshFootView = LFBRefreshFooter(refreshingTarget: self, refreshingAction: #selector(VideoListViewController.headRefresh));
		collectionView.mj_footer = refreshFootView;
		self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0);
		collectionView.hidden = true;
	}

}
// MARK:- HomeHeadViewDelegate TableHeadViewAction
extension HotViewController: HomeTableHeadViewDelegate {
	func tableHeadView(headView: AdBannerView, focusImageViewClick index: Int) {
		if adList?.count > 0 {
			// let path = NSBundle.mainBundle().pathForResource("FocusURL", ofType: "plist")
			// let array = NSArray(contentsOfFile: path!)
			// let webVC = WebViewController(navigationTitle: headData!.data!.focus![index].username!, urlStr: array![index] as! String)
			// navigationController?.pushViewController(webVC, animated: true)
		}
	}

	func tableHeadView(headView: AdBannerView, iconClick index: Int) {
		// if adList?.icons?.count > 0 {
		// let webVC = WebViewController(navigationTitle: headData!.data!.icons![index].username!, urlStr: headData!.data!.icons![index].customURL!)
		// navigationController?.pushViewController(webVC, animated: true)
		// }
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
		let h = (320 / ScreenWidth) * 400
		let itemSize = CGSizeMake(w, h);

		return itemSize
	}

	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		if section == 0 {
			return CGSizeMake(AdBannerView.bannerFrame.width, AdBannerView.bannerFrame.height);
		}
		return CGSizeZero
	}

	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {

		return CGSizeZero
	}

	func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
		var headView: AdBannerView?;
		if kind == UICollectionElementKindSectionHeader {
			if (indexPath.section == 0)
			{
				headView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "adHeaderView", forIndexPath: indexPath) as? AdBannerView
				headView!.data = adList;
				headView!.delegate = self;
				return headView!;
			}
		}
		return headView!;
	}

	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		var itemAcive: Activity;
		itemAcive = (hotList?[indexPath.row])!;
		let roomId = itemAcive.uid as! Int;
		let roomview = VideoRoomUIViewVC();
		roomview.roomId = roomId;
		self.navigationController?.pushViewController(roomview, animated: true);
		Flurry.logEvent("enter videoRoom", withParameters: ["roomId": roomId], timed: false);
	}
}
