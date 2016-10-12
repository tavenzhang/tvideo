//
//  FaceManageView.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/10/12.
//  Copyright © 2016年 张新华. All rights reserved.
//

import Foundation
let kWidth = ScreenWidth;
typealias SelectBlock = (faceName: String) -> Void
class YYFaceView: UIView {
	// var faceitemsList = [[FaceData]]();
	var magnifierView: UIImageView!

	var selectedFaceName = ""
	var pageNumber = 0
	var block: SelectBlock?;

	let item_width: CGFloat = 30
	let item_height: CGFloat = 30
	let item_h_dim: CGFloat = 20
	let item_v_dim: CGFloat = 5

	var maxCellCount: Int = 0
	var maxRow: Int = 0
	var startPostionX: CGFloat = 0.0
	var startPostionY: CGFloat = 0.0

	let PAGE_SIZE = 21;

	let faceDataList = FaceData.faceDataList;

	override init(frame: CGRect) {
		super.init(frame: frame)

		self.initData()
		self.backgroundColor = UIColor.clearColor()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	// The output below is limited by 1 KB.
	// Please Sign Up (Free!) to remove this limitation.

	/**
     * 行 row:3
     * 列 colum:7
     * 表情尺寸 30*30 pixels
     */
	func initData() {
		maxRow = 3
		maxCellCount = Int(ScreenWidth / (item_width + item_h_dim));
		startPostionX = (ScreenWidth - maxCellCount.toCGFloat() * (item_width + item_h_dim) + item_h_dim) / 2
		startPostionY = 10
		// faceitemsList = [[FaceData]]();
		// faceList = [AnyObject]()
		self.pageNumber = faceDataList.count / PAGE_SIZE + 1;
		// 设置尺寸
		self.frame = CGRectMake(0, 0, CGFloat(self.pageNumber) * ScreenWidth, 3 * item_height + 20)
		// self.width = items.count *[UIScreen mainScreen].bounds.size.width;
		// self.height = 3 * item_height+20;
		// 放大镜
		magnifierView = UIImageView(frame: CGRectMake(0, 0, 64, 92))
		magnifierView.image = UIImage.bundleImageName("emoticon_keyboard_magnifier")
		magnifierView.hidden = true
		magnifierView.backgroundColor = UIColor.clearColor()
		self.addSubview(magnifierView)
		let faceItem = UIImageView(frame: CGRectMake((64 - 30) / 2, 15, item_width, item_width))
		faceItem.tag = 2013
		faceItem.backgroundColor = UIColor.clearColor()
		magnifierView.addSubview(faceItem)
	}
	/*
	 *
	 items = [
	 ["表情1",“表情2”,“表情3”,......“表情28”],
	 ["表情1",“表情2”,“表情3”,......“表情28”],
	 ["表情1",“表情2”,“表情3”,......“表情28”]
	 ];
	 */
	override func drawRect(rect: CGRect) {
		let faceDataList = FaceData.faceDataList;
		// 定义列和行
		var row: Int = 0
		var colum: Int = 0
		for i in 0..<self.pageNumber {
			var pum = 0;
			if (i < (self.pageNumber - 1))
			{
				pum = self.PAGE_SIZE;
			}
			else {
				pum = faceDataList.count - i * PAGE_SIZE;
			}
			// = i < self.pageNumber
			for j in 0..<pum {
				let item = faceDataList[i * self.PAGE_SIZE + j] ;
				let imageName = item.faceIco;
				let image = UIImage.bundleImageName(imageName)
				var frame = CGRectMake(colum.toCGFloat() * (self.item_width + self.item_h_dim), row.toCGFloat() * (self.item_height + self.item_v_dim), self.item_width, self.item_height)
				// 考虑页数，需要加上前几页的宽度
				let x: CGFloat = (CGFloat(i) * ScreenWidth) + frame.origin.x
				frame.origin.x = x + self.startPostionX
				frame.origin.y += self.startPostionY
				image.drawInRect(frame)
				// 更新列与行
				colum += 1
				if colum % self.maxCellCount == 0 {
					row += 1
					colum = 0
				}
				if row == self.maxRow {
					row = 0
				}
			}
		}
	}

	func touchFace(point: CGPoint) {
		// 页数
		let page: Int = Int(point.x / kWidth);
		let x: CGFloat = point.x - (page.toCGFloat() * kWidth) - startPostionX;
		let y: CGFloat = point.y - startPostionY
		// 计算列与行
		var colum = Int(x / (item_width + item_h_dim));
		var row = Int(y / (item_height + item_v_dim))
		if colum > maxCellCount {
			colum = maxCellCount
		}
		if colum < 0 {
			colum = 0
		}
		// 索引从0开始
		if row > (maxRow - 1) {
			row = (maxRow - 1)
		}
		if row < 0 {
			row = 0
		}
		// 计算选中表情的索引
		let index = colum + (row * maxCellCount) + page * PAGE_SIZE

		if (faceDataList.count > index)
		{
			let item = faceDataList[index];
			let faceName = item.faceName;
			// self.selectedFaceName = faceName
			if (self.selectedFaceName != faceName) {
				// 给放大镜添加上表情
				let imageName = item.faceIco
				let image = UIImage.bundleImageName(imageName)
				let faceItem = (magnifierView.viewWithTag(2013)! as! UIImageView)
				faceItem.image = image
				magnifierView.left = (page.toCGFloat() * kWidth) + CGFloat(colum * Int(item_width + item_h_dim));
				magnifierView.bottom = CGFloat(row) * item_height + 30;
				self.selectedFaceName = faceName
			}
		}
		else {
			self.selectedFaceName = "";
		}

	}

// MARK: - touch事件
// touch 触摸开始
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		magnifierView.hidden = false
		let touch = touches.first!
		let point = touch.locationInView(self)
		self.touchFace(point)
		if (self.superview! is UIScrollView) {
			let scrollView = (self.superview! as! UIScrollView)
			scrollView.scrollEnabled = false
		}
	}
// touch 触摸移动

	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		let touch = touches.first!
		let point = touch.locationInView(self)
		self.touchFace(point)
	}

// touch 触摸结束
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		magnifierView.hidden = true
		if (self.superview! is UIScrollView) {
			let scrollView = (self.superview! as! UIScrollView)
			scrollView.scrollEnabled = true
		}
		if self.block != nil {
			self.block!(faceName: selectedFaceName)
		}
	}

	override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
		magnifierView.hidden = true
		if (self.superview! is UIScrollView) {
			let scrollView = (self.superview! as! UIScrollView)
			scrollView.scrollEnabled = true
		}
	}
}

typealias SendBtnClickBlock = () -> Void

class YYFaceScrollView: UIView, UIScrollViewDelegate {
	var scrollView: UIScrollView!
	var faceView: YYFaceView!
	var pageControl: UIPageControl!
	var bottomView: UIView!

	var sendBlock: SendBtnClickBlock?;

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.initViews()

	}

	convenience init(selectBlock block: SelectBlock) {
		self.init(frame: CGRectZero)
		faceView.block = block

	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func initViews() {
		// 顶部的分隔线
		let topLineView = UIView(frame: CGRectMake(0, 0, kWidth, 0.5))
		topLineView.backgroundColor = UIColor.grayColor()
		topLineView.alpha = 0.3
		self.addSubview(topLineView)
		faceView = YYFaceView(frame: CGRectZero)
		scrollView = UIScrollView(frame: CGRectMake(0, 0, kWidth, faceView.height))
		scrollView.backgroundColor = UIColor.clearColor()
		scrollView.contentSize = CGSizeMake(faceView.width, faceView.height)
		scrollView.pagingEnabled = true
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.clipsToBounds = false
		scrollView.delegate = self
		scrollView.addSubview(faceView)
		self.addSubview(scrollView)
		pageControl = UIPageControl(frame: CGRectMake(0, scrollView.frame.origin.y + scrollView.frame.size.height, 40, 20))
		pageControl.backgroundColor = UIColor.clearColor()
		pageControl.numberOfPages = faceView.pageNumber
		pageControl.currentPage = 0
		self.addSubview(pageControl)
		self.addbottomView()
		self.height = scrollView.height + pageControl.height + 20 + bottomView.height
		self.width = scrollView.width
	}

	func addbottomView() {
		// bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, pageControl.bottom+10, 320, 35)];
		bottomView = UIView(frame: CGRectMake(0, scrollView.frame.origin.y + scrollView.frame.size.height + 20, kWidth, 35))
		bottomView.backgroundColor = UIColor.clearColor()
		self.addSubview(bottomView)
		let topLine = UIView(frame: CGRectMake(0, 6, bottomView.width, 0.5))
		topLine.backgroundColor = UIColor.grayColor()
		bottomView.addSubview(topLine)
//		let smallemoBtn = UIButton(frame: CGRectMake(0, 0, bottomView.height, bottomView.height))
//		smallemoBtn.backgroundColor = UIColor.clearColor()
//		smallemoBtn.setImage(UIImage.bundleImageName("emotion"), forState: .Normal)
//		smallemoBtn.addTarget(self, action: #selector(self.changeForEmotion), forControlEvents: .TouchUpInside)
//		bottomView.addSubview(smallemoBtn)
//		let lineView = UIView(frame: CGRectMake(smallemoBtn.right + 2, 10, 1, smallemoBtn.height - 6));
//		bottomView.addSubview(lineView)
		let sendBtn = UIButton(frame: CGRectMake(kWidth - 70, 10, 60, bottomView.height))
		sendBtn.backgroundColor = UIColor.colorWithCustom(122, g: 122, b: 255, a: 1) ;
		sendBtn.setTitle("发送", forState: .Normal);
		sendBtn.cornRadius(10);
		sendBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		sendBtn.addTarget(self, action: #selector(self.sendBtnClick), forControlEvents: .TouchUpInside)
		bottomView.addSubview(sendBtn)
	}

	func scrollViewDidScroll(scrollView: UIScrollView) {
		let pageNumber = scrollView.contentOffset.x / kWidth
		pageControl.currentPage = pageNumber.toInt();
	}

	func changeForEmotion() {
		LogHttp("changeForEmotion");
	}

	func sendBtnClick() {

		if (sendBlock != nil) {
			sendBlock!()
		}
	}

}
