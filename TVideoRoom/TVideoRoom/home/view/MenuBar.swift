//
//  MenuBar.swift
//  TVideoRoom
//
//  Created by  on 16/10/4.
//  Copyright © 2016年 . All rights reserved.
//

import UIKit
import SnapKit


class MenuBarView: UIView {

	// MARK: - 初始化子空间
	var selectedBtn: UIButton?;
	var selectedBlock: tabClickBlock?;
	var hotBtn: UIButton?;
	var _selectedType: Int = 0;
	// 延迟初始化
	lazy var underLine: UIView = {
        let underLineView = UIView(frame: CGRect(x: 15.0, y: self.height - 4, width: Home_Seleted_Item_W + DefaultMargin, height: 2.0));
		underLineView.backgroundColor = UIColor.white;
		self.addSubview(underLineView)
		return underLineView
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup();

	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setup() {
		let hotBtn = self.createBtn("热播", tag: 0)
		let newBtn = self.createBtn("大厅", tag: 1)
		let careBtn = self.createBtn("一对一", tag: 2)
		self.addSubview(hotBtn)
		self.addSubview(newBtn)
		self.addSubview(careBtn)
		self.hotBtn = hotBtn
		newBtn.snp_makeConstraints { (make) in
			make.center.equalTo(self);
			make.width.equalTo(Home_Seleted_Item_W);
		}
		hotBtn.snp_makeConstraints { (make) in
			make.left.equalTo((DefaultMargin * 2))
			make.centerY.equalTo(self)
			make.width.equalTo(Home_Seleted_Item_W)
		}
		careBtn.snp_makeConstraints { (make) in
			make.right.equalTo(-DefaultMargin * 2)
			make.centerY.equalTo(self)
			make.width.equalTo(Home_Seleted_Item_W)
		}
		// 强制更新一次
		self.layoutIfNeeded();
		// 默认选中最热
		self.click(hotBtn);
	}

	override class var layerClass : AnyClass {
		return super.layerClass
	}

	func createBtn(_ title: String, tag: Int) -> UIButton {
		let btn = UIButton()
		btn.titleLabel!.font = UIFont.systemFont(ofSize: 17)
		btn.setTitle(title, for: UIControlState())
		btn.setTitleColor(UIColor.white.withAlphaComponent(0.6), for: UIControlState())
		btn.setTitleColor(UIColor.white, for: .selected)
		btn.tag = tag;
		btn.addTarget(self, action: #selector(self.click), for: .touchUpInside)
		return btn
	}

	// 点击事件
	func click(_ btn: UIButton) {
		self.selectedBtn?.isSelected = false
		btn.isSelected = true
		self.selectedBtn = btn
        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            () -> Void in
            self.underLine.x = CGFloat(btn.x - DefaultMargin * 0.5);
            }, completion: nil)
        
//		UIView.animateWithDuration(0.5, animations: { () -> Void in
//			self.underLine.x = CGFloat(btn.x - DefaultMargin * 0.5);
//		})

		if (self.selectedBlock != nil) {
			self.selectedBlock!(btn.tag)
		}
	}

	func setSelectedType(_ selectedType: Int) {
		_selectedType = selectedType
		self.selectedBtn?.isSelected = false
		for view: UIView in self.subviews {
			if (view is UIButton) && view.tag == selectedType {
				self.selectedBtn = (view as! UIButton)
				(view as! UIButton).isSelected = true
			}
		}
	}

}
