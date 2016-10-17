//
//  ShowVideoViewController.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/10/17.
//  Copyright © 2016年 张新华. All rights reserved.
//

import UIKit

class ShowVideoViewController: BaseUIViewController {

	weak var parentNVC: UINavigationController?;
	fileprivate var flag: Int = -1
	fileprivate var collectionView: LFBCollectionView!;
	fileprivate var lastContentOffsetY: CGFloat = 0
	fileprivate var isAnimation: Bool = false;

	var dataActives: [Activity] = [Activity]() {
		didSet {
			collectionView.reloadData();
		}
	}

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
	}

	convenience init(title: String, dataList: [Activity]) {
		self.init(nibName: nil, bundle: nil)
		dataActives = dataList;
		self.navigationItem.title = title;

	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		buildCollectionView();
	}

	deinit {
		parentNVC = nil;
		dataActives.removeAll();

	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated);
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	/**
     设置状态栏风格
     */
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return UIStatusBarStyle.lightContent;
	}

	// 建立集合
	func buildCollectionView() -> Void {
		let layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 5
		layout.minimumLineSpacing = 8
		layout.sectionInset = UIEdgeInsets(top: 0, left: HomeCollectionViewCellMargin, bottom: 0, right: HomeCollectionViewCellMargin)
		layout.headerReferenceSize = CGSize(width: 0, height: 22);
		collectionView = LFBCollectionView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), collectionViewLayout: layout);
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.backgroundColor = LFBGlobalBackgroundColor
		collectionView.register(HomeCell.self, forCellWithReuseIdentifier: "Cell");
		view.addSubview(collectionView)
		self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
	}
}

extension ShowVideoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return (dataActives.count);
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HomeCell
		cell.activities = dataActives[(indexPath as NSIndexPath).row];
		return cell
	}

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	// 设置item 宽
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		var itemSize = CGSize.zero;
		itemSize = CGSize(width: (ScreenWidth - HomeCollectionViewCellMargin * 2) * 0.5 - 4, height: 130)
		return itemSize
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

		return CGSize.zero
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
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
		if dataActives.count > 0 && isAnimation {
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
		itemAcive = dataActives[(indexPath as NSIndexPath).row];
		let roomId = itemAcive.uid as! Int;
//		let roomview: VideoRoomUIViewVC = VideoRoomUIViewVC();
//		roomview.roomId = roomId;
//		self.navigationController?.pushViewController(roomview, animated: true);
//		Flurry.logEvent("enter videoRoom", withParameters: ["roomId": roomId], timed: false);
		DataCenterModel.enterVideoRoom(rid: roomId, vc: self.navigationController!)

	}
}

