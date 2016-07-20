//
//  LFBRefreshHeader.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/6/26.
//  Copyright © 2016年 张新华. All rights reserved.
//
import UIKit
import MJRefresh

class LFBRefreshHeader: MJRefreshGifHeader {
    
    override func prepare() {
        super.prepare()
        stateLabel?.hidden = false
        lastUpdatedTimeLabel?.hidden = true
        
        setImages([UIImage(named: "v2_pullRefresh1")!], forState: MJRefreshState.Idle)
        setImages([UIImage(named: "v2_pullRefresh2")!], forState: MJRefreshState.Pulling)
        setImages([UIImage(named: "v2_pullRefresh1")!, UIImage(named: "v2_pullRefresh2")!], forState: MJRefreshState.Refreshing)
        
        setTitle("下拉刷新", forState: .Idle)
        setTitle("松手开始刷新", forState: .Pulling)
        setTitle("正在刷新", forState: .Refreshing)
    }
}
class LFBRefreshFooterNew:MJRefreshFooter {
    
    override func prepare() {
        super.prepare()
//        stateLabel?.hidden = false
//        setImages([UIImage(named: "v2_pullRefresh1")!], forState: MJRefreshState.Idle)
//        setImages([UIImage(named: "v2_pullRefresh2")!], forState: MJRefreshState.Pulling)
//        setImages([UIImage(named: "v2_pullRefresh1")!, UIImage(named: "v2_pullRefresh2")!], forState: MJRefreshState.Refreshing)
//        
//        setTitle("上拉拉取", forState: .Idle)
//        setTitle("松手开始获取", forState: .Pulling)
//        setTitle("数据获取中...", forState: .Refreshing)
    }
}


class LFBRefreshFooter:MJRefreshAutoGifFooter {
    
    override func prepare() {
        super.prepare()
        stateLabel?.hidden = false
        setImages([UIImage(named: "v2_pullRefresh1")!], forState: MJRefreshState.Idle)
        setImages([UIImage(named: "v2_pullRefresh2")!], forState: MJRefreshState.Pulling)
        setImages([UIImage(named: "v2_pullRefresh1")!, UIImage(named: "v2_pullRefresh2")!], forState: MJRefreshState.Refreshing);
        setTitle("上拉拉取", forState: .Idle)
        setTitle("松手开始获取", forState: .Pulling)
        setTitle("数据获取中...", forState: .Refreshing)
    }
}
