//
//  LFBRefreshHeader.swift
//  TVideoRoom
//
//  Created by  on 16/6/26.
//  Copyright © 2016年 . All rights reserved.
//
import UIKit
import MJRefresh

class LFBRefreshHeader: MJRefreshGifHeader {

	override func prepare() {
		super.prepare()
		stateLabel?.isHidden = false
		lastUpdatedTimeLabel?.isHidden = true

		setImages([UIImage(named: "v2_pullRefresh1")!], for: MJRefreshState.idle)
		setImages([UIImage(named: "v2_pullRefresh2")!], for: MJRefreshState.pulling)
		setImages([UIImage(named: "v2_pullRefresh1")!, UIImage(named: "v2_pullRefresh2")!], for: MJRefreshState.refreshing)

		setTitle("下拉刷新", for: .idle)
		setTitle("松手开始刷新", for: .pulling)
		setTitle("正在刷新", for: .refreshing)
	}
}
class LFBRefreshFooterNew: MJRefreshFooter {

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

class LFBRefreshFooter: MJRefreshAutoGifFooter {

	override func prepare() {
		super.prepare()
		stateLabel?.isHidden = false
		setImages([UIImage(named: "v2_pullRefresh1")!], for: MJRefreshState.idle)
		setImages([UIImage(named: "v2_pullRefresh2")!], for: MJRefreshState.pulling)
		setImages([UIImage(named: "v2_pullRefresh1")!, UIImage(named: "v2_pullRefresh2")!], for: MJRefreshState.refreshing);
		setTitle("", for: .idle)
		setTitle("松手开始获取", for: .pulling)
		setTitle("数据获取中...", for: .refreshing)
	}
}
