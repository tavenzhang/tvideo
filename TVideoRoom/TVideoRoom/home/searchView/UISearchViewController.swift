//
//  UISearchViewController.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/10/5.
//  Copyright © 2016年 张新华. All rights reserved.
//

import UIKit

class UISearchViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {

	var dataActives: [Activity] = [];
	weak var parentNVC: UINavigationController?;
	fileprivate var flag: Int = -1
	fileprivate var collectionView: LFBCollectionView!;
	fileprivate var lastContentOffsetY: CGFloat = 0
	fileprivate var isAnimation: Bool = false;
	var resultSrarchController = UISearchController(searchResultsController: nil);

	override func viewDidLoad() {
		super.viewDidLoad()
		resultSrarchController.delegate = self;
		resultSrarchController.searchBar.delegate = self;
		resultSrarchController.searchResultsUpdater = self;
		resultSrarchController.searchBar.sizeToFit();
		resultSrarchController.hidesNavigationBarDuringPresentation = false;
		resultSrarchController.dimsBackgroundDuringPresentation = false;

		resultSrarchController.searchBar.searchBarStyle = .default;
		resultSrarchController.searchBar.placeholder = "请输入主播名字"
		self.view.backgroundColor = UIColor.white;
		self.definesPresentationContext = true;
		buildCollectionView();
		// Do any additional setup after loading the view.
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated);
		resultSrarchController.searchBar.text = "";
		dataActives.removeAll();
		collectionView.reloadData();
		resultSrarchController.searchBar.becomeFirstResponder();
		self.view.addSubview(resultSrarchController.searchBar);

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	/**
     设置状态栏风格
     */
	override var preferredStatusBarStyle : UIStatusBarStyle {
		return UIStatusBarStyle.lightContent;
	}

	// 建立集合
	func buildCollectionView() -> Void {
		let layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 5
		layout.minimumLineSpacing = 8
		layout.sectionInset = UIEdgeInsets(top: 0, left: HomeCollectionViewCellMargin, bottom: 0, right: HomeCollectionViewCellMargin)
		layout.headerReferenceSize = CGSize(width: 0, height: 22);
		collectionView = LFBCollectionView(frame: CGRect(x: 0, y: resultSrarchController.searchBar.height, width: ScreenWidth, height: ScreenHeight - resultSrarchController.searchBar.height), collectionViewLayout: layout)
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.backgroundColor = LFBGlobalBackgroundColor
		collectionView.register(HomeCell.self, forCellWithReuseIdentifier: "Cell");
		view.addSubview(collectionView)
		self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
	}

	func updateSearchResults(for searchController: UISearchController) {

		dataActives.removeAll();
		let homeData = DataCenterModel.sharedInstance.homeData;
		let keyText = resultSrarchController.searchBar.text;
		LogHttp("resultSrarchController---\(keyText)");
		if (homeData.totalList != nil)
		{
			for item in homeData.totalList!
			{
				if item.username!.contains(keyText!) {
					dataActives.append(item);
				}
			}
		}
		collectionView.reloadData();
	}

	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) // called when
	{
		self.view.removeFromSuperview();
	}

	func willDismissSearchController(_ searchController: UISearchController)
	{
		self.view.removeFromSuperview();
	}

}

extension UISearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

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
	// TODO MARK: 查看更多商品被点击
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
		let roomview: VideoRoomUIViewVC = VideoRoomUIViewVC();
		roomview.roomId = roomId;
		self.view.removeFromSuperview();
		resultSrarchController.searchBar.resignFirstResponder();
		resultSrarchController.searchBar.removeFromSuperview();
		parentNVC?.pushViewController(roomview, animated: true);
		Flurry.logEvent("enter videoRoom", withParameters: ["roomId": roomId], timed: false);

	}
}

