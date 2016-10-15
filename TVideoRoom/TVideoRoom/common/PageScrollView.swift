//
//  PageScrollView.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/6/26.
//  Copyright © 2016年 张新华. All rights reserved.
//
import UIKit
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

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
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




class PageScrollView: UIView {
    
    fileprivate let imageViewMaxCount = 3
    fileprivate var imageScrollView: UIScrollView!
    fileprivate var pageControl: UIPageControl!
    fileprivate var timer: Timer?
    fileprivate var placeholderImage: UIImage?
    fileprivate var imageClick:((_ index: Int) -> ())?
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
    
    convenience init(frame: CGRect, placeholder: UIImage, focusImageViewClick:@escaping ((_ index: Int) -> Void)) {
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
        imageScrollView.contentSize = CGSize(width: CGFloat(imageViewMaxCount) * width, height: 0)
        for i in 0...imageViewMaxCount - 1 {
            let imageView = imageScrollView.subviews[i] as! UIImageView
            imageView.isUserInteractionEnabled = true
            imageView.frame = CGRect(x: CGFloat(i) * imageScrollView.width, y: 0, width: imageScrollView.width, height: imageScrollView.height)
        }
        
        let pageW: CGFloat = 80
        let pageH: CGFloat = 20
        let pageX: CGFloat = imageScrollView.width - pageW
        let pageY: CGFloat = imageScrollView.height - pageH-5;
        pageControl.frame = CGRect(x: pageX, y: pageY, width: pageW, height: pageH)
        
        updatePageScrollView()
    }
    
    // MARK: BuildUI
    fileprivate func buildImageScrollView() {
        imageScrollView = UIScrollView()
        imageScrollView.bounces = false
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.showsVerticalScrollIndicator = false
        imageScrollView.isPagingEnabled = true
        imageScrollView.delegate = self
        addSubview(imageScrollView)
        
        for _ in 0..<3 {
            let imageView = UIImageView()
            let tap = UITapGestureRecognizer(target: self, action: #selector(PageScrollView.imageViewClick(_:)))
            imageView.addGestureRecognizer(tap)
            imageScrollView.addSubview(imageView)
        }
    }
    
    fileprivate func buildPageControl() {
        pageControl = UIPageControl()
        pageControl.hidesForSinglePage = true
        //修改默认图片
        pageControl.pageIndicatorTintColor = UIColor(patternImage: UIImage(named: "v2_home_cycle_dot_normal")!)
        pageControl.currentPageIndicatorTintColor = UIColor(patternImage: UIImage(named: "v2_home_cycle_dot_selected")!)
        addSubview(pageControl)
        
    }
    
    //MARK: 更新内容
    fileprivate func updatePageScrollView() {
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
                imageView.sd_setImage(with: URL(string: data![index].img!), placeholderImage: placeholderImage)
            }
        }
        
        imageScrollView.contentOffset = CGPoint(x: imageScrollView.width, y: 0)
    }
    
    
    // MARK: Timer
    fileprivate func startTimer() {
        timer = Timer(timeInterval: 3.0, target: self, selector: #selector(getter: PageScrollView.next), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    fileprivate func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func next() {
        imageScrollView.setContentOffset(CGPoint(x: 2.0 * imageScrollView.frame.size.width, y: 0), animated: true)
    }
    
    // MARK: ACTION
    func imageViewClick(_ tap: UITapGestureRecognizer) {
        if imageClick != nil {
            imageClick!(tap.view!.tag)
        }
    }
}

// MARK:- UIScrollViewDelegate
extension PageScrollView: UIScrollViewDelegate {
    //滚动过程ing 由于这里是三个imageview循环，所以不能简单点用   Int(scrollView.contentOffset.x / ScreenWidth + 0.5) 来算出pageIndex
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
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
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        stopTimer()
    }
    //结束拖动，但是有可能还有惯性是否还有惯性
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("-----scrollViewDidEndDragging------decelerate=\(decelerate)");
        startTimer()
    }
    //结束惯性...
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("-----------scrollViewDidEndDecelerating")
        updatePageScrollView()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // print("scrollViewDidEndScrollingAnimation")
        updatePageScrollView()
    }
}
