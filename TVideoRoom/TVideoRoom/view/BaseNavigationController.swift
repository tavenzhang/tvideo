//
//  BaseNavigationController.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/6/25.
//  Copyright © 2016年 张新华. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    var isAnimation = true
 
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer!.delegate = nil
        navigationBar.translucent = false;
        let bar=UINavigationBar.appearance();
        bar.titleTextAttributes =  [NSForegroundColorAttributeName:UIColor.whiteColor()];
        bar.setBackgroundImage(UIImage(named: r_nav_barbg_414x70), forBarMetrics: UIBarMetrics.Default);
       
    }
    
    lazy var backBtn: UIButton = {
        //设置返回按钮属性
        let backBtn = UIButton(type: UIButtonType.Custom)
        backBtn.setImage(UIImage(named: r_nav_btnBack_9x16), forState: .Normal);
        backBtn.titleLabel?.hidden = true
        backBtn.addTarget(self, action: #selector(BaseNavigationController.backBtnClick), forControlEvents: .TouchUpInside)
        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
        let btnW: CGFloat = ScreenWidth > 375.0 ? 50 : 44
        backBtn.frame = CGRectMake(0, 0, btnW, 40)
        
        return backBtn
    }()
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.hidesBackButton = true
        if childViewControllers.count > 0 {
            
            UINavigationBar.appearance().backItem?.hidesBackButton = false
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn);
            
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    
    func backBtnClick() {
        // 判断两种情况: push 和 present
        if (((self.presentedViewController != nil) || (self.presentingViewController != nil)) && (self.childViewControllers.count == 1))
        {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else{
                  popViewControllerAnimated(self.isAnimation)
        }
  
    }
    
}