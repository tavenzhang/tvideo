//  Created by 张新华 on 16/6/2.
//  Copyright © 2016年 张新华. All rights reserved.
//

import UIKit
import TAmf3Socket
import TRtmpPlay
import SwiftyJSON
import TChat

class HomeViewController: BaseTabViewController {

    private var flag: Int = -1
    private var collectionView: LFBCollectionView!
    private var lastContentOffsetY: CGFloat = 0
    private var isAnimation: Bool = false
    private var homeData: HomeData?
    override func viewDidLoad() {
        //addNotification()
        super.viewDidLoad()
    
        navigationItem.title = "大厅";
        addHomeNotification()
        buildCollectionView()
        buildTableData()
        buildProessHud()
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
    
    func addHomeNotification()->Void{
       // NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.homeTableHeadViewHeightDidChange(_:)), name: HomeTableHeadViewHeightDidChange, object: nil)
       // NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.goodsInventoryProblem(_:)), name: HomeGoodsInventoryProblem, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.shopCarBuyProductNumberDidChange), name: LFBShopCarBuyProductNumberDidChangeNotification, object: nil)
    }

    
    func goodsInventoryProblem(noti: NSNotification) {
        if let goodsName = noti.object as? String {
            ProgressHUDManager.showImage(UIImage(named: "v2_orderSuccess")!, status: goodsName + "  库存不足了\n先买这么多, 过段时间再来看看吧~")
        }
    }
    
    func shopCarBuyProductNumberDidChange() {
        collectionView.reloadData()
    }
    
    
    //建立集合
    func buildCollectionView()->Void{
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
        collectionView.registerClass(HomeTableHeadView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "firstHeaderView")
        collectionView.registerClass(HomeCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footerView")
        view.addSubview(collectionView)
        let refreshHeadView = LFBRefreshHeader(refreshingTarget: self, refreshingAction: #selector(HomeViewController.headRefresh));
        collectionView.mj_header = refreshHeadView;
        let  refreshFootView=LFBRefreshFooter(refreshingTarget: self, refreshingAction: #selector(HomeViewController.getMoreFresh));
        collectionView.mj_footer = refreshFootView;
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0);
        self.collectionView.hidden=true;
    }
    
    /**
     获取数据
     - author: taven
     - date: 16-06-28 09:06:33
     */
    func headRefresh() {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        loadProgressAnimationView.startLoadProgressAnimation();
        dispatch_async(queue){
            HttpTavenService.requestJson(HTTP_HOST_LIST){
                (dataResutl:HttpResult) in
                self.collectionView.mj_header.endRefreshing();
                self.collectionView.hidden=false;
                self.loadProgressAnimationView.endLoadProgressAnimation();
                self.collectionView.mj_footer.endRefreshing();
                if(dataResutl.dataJson == nil || !dataResutl.isSuccess)
                {
                    return;
                }
                var data = dataResutl.dataJson!;
                let genData = data["sls"].arrayObject ;
                if((genData) != nil)
                {
                     self.homeData?.tuijianList = BaseDeSerialsModel.objectsWithArray(genData!, cls: Activity.classForCoder()) as? [Activity];
                    self.homeData?.tuijianList=self.homeData?.tuijianList?.filter({ (item:Activity) -> Bool in
                        return item.live_status != 0;
                    })
                       LogHttp("self.homeData?.tuijianList cundt==%d", args: (self.homeData?.tuijianList?.count)!)
                }
                let recData = data["rec"].arrayObject ;
                if((recData) != nil)
                {
                    self.homeData?.hotList = BaseDeSerialsModel.objectsWithArray(data["rec"].arrayObject!, cls: Activity.classForCoder()) as? [Activity];
                    self.homeData?.hotList=self.homeData?.hotList?.filter({ (item:Activity) -> Bool in
                        return item.live_status != 0;
                    })
                    LogHttp("self.homeData?.tuijianList cundt==%d", args: (self.homeData?.hotList?.count)!)
                }
              
          
                dispatch_async(dispatch_get_main_queue()) {
                    [unowned self] in
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    
    func getMoreFresh(){
        headRefresh() ;
    }
    /**
     下拉获取
     - author: taven
     - date: 16-06-28 10:06:20
     */
    func buildTableData()->Void{
        //headView?.data = nil
        //headData = nil
        //freshHot = nil
        DataCenterModel.sharedInstance.homeData=HomeData();
        homeData = DataCenterModel.sharedInstance.homeData;
        var testData=[Activity]();
        let data1 = Activity();
        data1.img="http://p1.1room1.co/public/images/staticad/0039c7e66b7c9b933cc8f482286c52f9_1465799392.jpg";
        let data2 = Activity()
        data2.img="http://p1.1room1.co/public/images/staticad/e486c9cae6dfd640aaf0396ada2bf09e_1465289179.jpg";
        let data3 = Activity();
        data3.img="http://p1.1room1.co/public/images/staticad/d401dd628b19326b9f2ef7fcc3b125a8_1458632404.jpg";
        testData.append(data1);
        testData.append(data2);
        testData.append(data3);
        homeData?.hotList = [Activity]();
        homeData?.AdList = testData;
        headRefresh();
    }
    
    
   func buildProessHud()->Void{
        ProgressHUDManager.setBackgroundColor(UIColor.colorWithCustom(240, g: 240, b: 240))
        ProgressHUDManager.setFont(UIFont.systemFontOfSize(16));
    }

}
// MARK:- HomeHeadViewDelegate TableHeadViewAction
extension HomeViewController: HomeTableHeadViewDelegate {
    func tableHeadView(headView: HomeTableHeadView, focusImageViewClick index: Int) {
        if homeData?.AdList?.count > 0 {
            //let path = NSBundle.mainBundle().pathForResource("FocusURL", ofType: "plist")
      //      let array = NSArray(contentsOfFile: path!)
        //    let webVC = WebViewController(navigationTitle: headData!.data!.focus![index].username!, urlStr: array![index] as! String)
//            navigationController?.pushViewController(webVC, animated: true)
        }
    }

    func tableHeadView(headView: HomeTableHeadView, iconClick index: Int) {
        if homeData?.icons?.count > 0 {
//            let webVC = WebViewController(navigationTitle: headData!.data!.icons![index].username!, urlStr: headData!.data!.icons![index].customURL!)
//            navigationController?.pushViewController(webVC, animated: true)
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return homeData?.hotList?.count ?? 0
        } else if section == 1 {
            return homeData?.tuijianList?.count ?? 0
       }
         return  0;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! HomeCell
        if homeData?.hotList?.count <= 0 {
            return cell
        }
        if indexPath.section == 0 {
            cell.activities = homeData!.hotList![indexPath.row];
        } else if indexPath.section == 1 {
            cell.activities = homeData!.tuijianList![indexPath.row];
        }
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if homeData?.hotList?.count <= 0 {
            return 0
        }
        return 2
    }
    //设置item 宽
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
        if section == 0 {
            return CGSizeMake(ScreenWidth, HomeCollectionViewCellMargin*15);
        } else if section == 1 {
            return CGSizeMake(ScreenWidth, HomeCollectionViewCellMargin*3);
        }
        
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
        //if indexPath.section == 1 && headData != nil && freshHot != nil && isAnimation {
        if indexPath.section == 1 && homeData != nil&&isAnimation  {
            startAnimation(view, offsetY: 60, duration: 0.2)
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if  kind == UICollectionElementKindSectionHeader {
          
            if(indexPath.section == 0)
            {
                 let headView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "firstHeaderView", forIndexPath: indexPath) as! HomeTableHeadView
                headView.data = homeData?.AdList;
                headView.delegate=self;
                headView.titleLabel.text="小编推荐";
                return headView;
            }
            else{
                    let headView2 = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView", forIndexPath: indexPath) as! HomeCollectionHeaderView
                  headView2.titleLabel.text="才艺主播";
                  return headView2
            }
            
        }
        
        let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "footerView", forIndexPath: indexPath) as! HomeCollectionFooterView
        
        if indexPath.section == 1 && kind == UICollectionElementKindSectionFooter {
            footerView.showLabel()
            footerView.tag = 100
        } else {
            footerView.hideLabel()
            footerView.tag = 1
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.moreGoodsClick(_:)))
        footerView.addGestureRecognizer(tap)
        
        return footerView
    }
    
    //TODO MARK: 查看更多商品被点击
    func moreGoodsClick(tap: UITapGestureRecognizer) {
        if tap.view?.tag == 100 {
            let tabBarController = UIApplication.sharedApplication().keyWindow?.rootViewController as! MainTabBarController;
           // tabBarController.setSelectIndex(from: 0, to: 1)
        }
    }
    
    // MARK: - ScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
//        if animationLayers?.count > 0 {
//            let transitionLayer = animationLayers![0]
//            transitionLayer.hidden = true
//        }
        
        if scrollView.contentOffset.y <= scrollView.contentSize.height {
            isAnimation = lastContentOffsetY < scrollView.contentOffset.y
            lastContentOffsetY = scrollView.contentOffset.y;
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var itemAcive:Activity;
        if(indexPath.section == 0)
        {
            itemAcive = (homeData?.hotList?[indexPath.row])!;
        }
        else
        {
            itemAcive = (homeData?.tuijianList?[indexPath.row])!;
        }
        let roomId=itemAcive.uid as! Int;
        let roomview:VideoRoomUIView =  VideoRoomUIView();
        roomview.c2sGetSocket(roomId);
        self.navigationController?.pushViewController(roomview, animated: true);
        Flurry.logEvent("enter videoRoom", withParameters: ["roomId":roomId], timed: false);
    }
}


