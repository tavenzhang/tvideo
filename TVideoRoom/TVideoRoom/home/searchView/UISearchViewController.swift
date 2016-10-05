//
//  UISearchViewController.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/10/5.
//  Copyright © 2016年 张新华. All rights reserved.
//

import UIKit

class UISearchViewController: UIViewController, UISearchResultsUpdating,UISearchBarDelegate,UISearchControllerDelegate {

    
	var dataActives: [Activity] = [];
	weak var parentNVC: UINavigationController?;
	private var flag: Int = -1
	private var collectionView: LFBCollectionView!;
	private var lastContentOffsetY: CGFloat = 0
	private var isAnimation: Bool = false;
    var resultSrarchController = UISearchController(searchResultsController: nil);

	override func viewDidLoad() {
		super.viewDidLoad()
        resultSrarchController.delegate = self;
        resultSrarchController.searchBar.delegate = self;
        resultSrarchController.searchResultsUpdater = self;
       resultSrarchController.searchBar.sizeToFit();
        resultSrarchController.hidesNavigationBarDuringPresentation = false;
        resultSrarchController.dimsBackgroundDuringPresentation = false;
       
        resultSrarchController.searchBar.searchBarStyle = .Default;
        resultSrarchController.searchBar.placeholder="请输入主播名字"
        self.view.backgroundColor = UIColor.whiteColor();
        self.definesPresentationContext = true;
		buildCollectionView();
		// Do any additional setup after loading the view.
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated);
        resultSrarchController.searchBar.text="";
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
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent;
	}

	// 建立集合
	func buildCollectionView() -> Void {
		let layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 5
		layout.minimumLineSpacing = 8
		layout.sectionInset = UIEdgeInsets(top: 0, left: HomeCollectionViewCellMargin, bottom: 0, right: HomeCollectionViewCellMargin)
		layout.headerReferenceSize = CGSizeMake(0, 22);
		collectionView = LFBCollectionView(frame: CGRectMake(0, resultSrarchController.searchBar.height, ScreenWidth, ScreenHeight - resultSrarchController.searchBar.height), collectionViewLayout: layout)
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.backgroundColor = LFBGlobalBackgroundColor
		collectionView.registerClass(HomeCell.self, forCellWithReuseIdentifier: "Cell");
		view.addSubview(collectionView)
		self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
	}
    

	func updateSearchResultsForSearchController(searchController: UISearchController) {

		dataActives.removeAll();
		let homeData = DataCenterModel.sharedInstance.homeData;
		let keyText = resultSrarchController.searchBar.text;
		LogHttp("resultSrarchController---\(keyText)");
		if (homeData.totalList != nil)
		{
			for item in homeData.totalList!
			{
				if item.username!.containsString(keyText!) {
					dataActives.append(item);
				}
			}
		}
		collectionView.reloadData();
	}
    
     func searchBarCancelButtonClicked(searchBar: UISearchBar) // called when
     {
        self.view.removeFromSuperview();
     }
    
    
   func willDismissSearchController(searchController: UISearchController)
    {
         self.view.removeFromSuperview();
    }
    
}

extension UISearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return (dataActives.count);
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! HomeCell
		cell.activities = dataActives[indexPath.row];
		return cell
	}

	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}


	// 设置item 宽
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		var itemSize = CGSizeZero;
		itemSize = CGSizeMake((ScreenWidth - HomeCollectionViewCellMargin * 2) * 0.5 - 4, 130)
		return itemSize
	}

	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

		return CGSizeZero
	}

	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
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
		if dataActives.count > 0 && isAnimation {
			startAnimation(view, offsetY: 60, duration: 0.2)
		}
	}
	// TODO MARK: 查看更多商品被点击
	// MARK: - ScrollViewDelegate
	func scrollViewDidScroll(scrollView: UIScrollView) {
		if scrollView.contentOffset.y <= scrollView.contentSize.height {
			isAnimation = lastContentOffsetY < scrollView.contentOffset.y
			lastContentOffsetY = scrollView.contentOffset.y;
		}
	}

	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		var itemAcive: Activity;
		itemAcive = dataActives[indexPath.row];
		let roomId = itemAcive.uid as! Int;
		let roomview: VideoRoomUIView = VideoRoomUIView();
		roomview.roomId = roomId;
        self.view.removeFromSuperview();
        resultSrarchController.searchBar.resignFirstResponder();
        resultSrarchController.searchBar.removeFromSuperview();
		parentNVC?.pushViewController(roomview, animated: true);
		Flurry.logEvent("enter videoRoom", withParameters: ["roomId": roomId], timed: false);
     
	}
}

