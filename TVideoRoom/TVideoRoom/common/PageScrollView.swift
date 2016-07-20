//
//  PageScrollView.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/6/26.
//  Copyright © 2016年 张新华. All rights reserved.
//
import UIKit



class PageScrollView: UIView {
    
    private let imageViewMaxCount = 3
    private var imageScrollView: UIScrollView!
    private var pageControl: UIPageControl!
    private var timer: NSTimer?
    private var placeholderImage: UIImage?
    private var imageClick:((index: Int) -> ())?
    var data:[Activity]?{
        didSet{
            if timer != nil {
                timer!.invalidate()
                timer = nil
            }
            if data?.count >= 0 {
                pageControl.numberOfPages = (data?.count)!
                pageControl.currentPage = 0
                updatePageScrollView();
                startTimer()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildImageScrollView()
        
        buildPageControl()
        
    }
    
    convenience init(frame: CGRect, placeholder: UIImage, focusImageViewClick:((index: Int) -> Void)) {
        self.init(frame: frame)
        placeholderImage = placeholder
        imageClick = focusImageViewClick
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageScrollView.frame = bounds
        imageScrollView.contentSize = CGSizeMake(CGFloat(imageViewMaxCount) * width, 0)
        for i in 0...imageViewMaxCount - 1 {
            let imageView = imageScrollView.subviews[i] as! UIImageView
            imageView.userInteractionEnabled = true
            imageView.frame = CGRectMake(CGFloat(i) * imageScrollView.width, 0, imageScrollView.width, imageScrollView.height)
        }
        
        let pageW: CGFloat = 80
        let pageH: CGFloat = 20
        let pageX: CGFloat = imageScrollView.width - pageW
        let pageY: CGFloat = imageScrollView.height - pageH-5;
        pageControl.frame = CGRectMake(pageX, pageY, pageW, pageH)
        
        updatePageScrollView()
    }
    
    // MARK: BuildUI
    private func buildImageScrollView() {
        imageScrollView = UIScrollView()
        imageScrollView.bounces = false
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.showsVerticalScrollIndicator = false
        imageScrollView.pagingEnabled = true
        imageScrollView.delegate = self
        addSubview(imageScrollView)
        
        for _ in 0..<3 {
            let imageView = UIImageView()
            let tap = UITapGestureRecognizer(target: self, action: #selector(PageScrollView.imageViewClick(_:)))
            imageView.addGestureRecognizer(tap)
            imageScrollView.addSubview(imageView)
        }
    }
    
    private func buildPageControl() {
        pageControl = UIPageControl()
        pageControl.hidesForSinglePage = true
        //修改默认图片
        pageControl.pageIndicatorTintColor = UIColor(patternImage: UIImage(named: "v2_home_cycle_dot_normal")!)
        pageControl.currentPageIndicatorTintColor = UIColor(patternImage: UIImage(named: "v2_home_cycle_dot_selected")!)
        addSubview(pageControl)
        
    }
    
    //MARK: 更新内容
    private func updatePageScrollView() {
        for i in 0 ..< imageScrollView.subviews.count {
            let imageView = imageScrollView.subviews[i] as! UIImageView
            var index = pageControl.currentPage
            if i == 0 {
                index -= 1
            } else if 2 == i {
                index += 1
            }
            
            if index < 0 {
                index = self.pageControl.numberOfPages - 1
            } else if index >= pageControl.numberOfPages {
                index = 0
            }
            
            imageView.tag = index
            if data?.count > 0 {
                imageView.sd_setImageWithURL(NSURL(string: data![index].img!), placeholderImage: placeholderImage)
            }
        }
        
        imageScrollView.contentOffset = CGPointMake(imageScrollView.width, 0)
    }
    
    
    // MARK: Timer
    private func startTimer() {
        timer = NSTimer(timeInterval: 3.0, target: self, selector: #selector(PageScrollView.next), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func next() {
        imageScrollView.setContentOffset(CGPointMake(2.0 * imageScrollView.frame.size.width, 0), animated: true)
    }
    
    // MARK: ACTION
    func imageViewClick(tap: UITapGestureRecognizer) {
        if imageClick != nil {
            imageClick!(index: tap.view!.tag)
        }
    }
}

// MARK:- UIScrollViewDelegate
extension PageScrollView: UIScrollViewDelegate {
    //滚动过程ing 由于这里是三个imageview循环，所以不能简单点用   Int(scrollView.contentOffset.x / ScreenWidth + 0.5) 来算出pageIndex
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        var page: Int = 0
        var minDistance: CGFloat = CGFloat(MAXFLOAT)
        
        for i in 0..<imageScrollView.subviews.count {
            let imageView = imageScrollView.subviews[i] as! UIImageView
            //找到离contentOffset.x最近点imageView
            let distance:CGFloat = abs(imageView.x - scrollView.contentOffset.x)
            
            if distance < minDistance {
                minDistance = distance
                page = imageView.tag
            }
        }
        pageControl.currentPage = page;
    }
    //开始拖动时 停止时间
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        stopTimer()
    }
    //结束拖动，但是有可能还有惯性是否还有惯性
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("-----scrollViewDidEndDragging------decelerate=\(decelerate)");
        startTimer()
    }
    //结束惯性...
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        print("-----------scrollViewDidEndDecelerating")
        updatePageScrollView()
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        // print("scrollViewDidEndScrollingAnimation")
        updatePageScrollView()
    }
}
