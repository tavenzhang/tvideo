//
//  GiftMenuBar.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/10/10.
//  Copyright © 2016年 张新华. All rights reserved.
//

import UIKit

class GiftMenuBar: UIView {

	// MARK: - 初始化子空间
	var menuBar: TabBarMenu?;

	var changeBtnClick: tabClickBlock?;

	var menuTabClick: tabClickBlock?;

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup();
	}

	deinit {
		changeBtnClick = nil;
		menuTabClick = nil;
		menuBar = nil;
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func regMenuTabClick(_ clickHandle: @escaping tabClickBlock)
	{
		menuTabClick = clickHandle;
	}

	func setup() {

		menuBar = TabBarMenu();
		let changeLineBtn = self.createBtn("换线", tag: 3, size: 17, color: UIColor.purple);
		self.addSubview(changeLineBtn);
		self.addSubview(menuBar!);
		menuBar?.snp.makeConstraints { (make) in
			make.width.equalTo(self.width * 3 / 4);
			make.height.equalTo(self);
			make.top.equalTo(self);
			make.left.equalTo(self);
		}
		// 强制更新一次
		self.layoutIfNeeded();
		menuBar?.creatBtnByList(["聊天", "礼物", "贡献榜"], txtSize: 16, color: UIColor.brown);
		menuBar!.regClickHandle(tabBtnClikc);
		changeLineBtn.snp.makeConstraints { (make) in
			make.centerY.equalTo(self);
			make.right.equalTo(self.snp.right).offset(-20);
		};
	}

	func tabBtnClikc(_ tag: Int)
	{
		if (menuTabClick != nil)
		{
			menuTabClick!(tag);
		}
	}

	func createBtn(_ title: String, tag: Int, size: CGFloat = 14, color: UIColor? = UIColor.brown) -> UIButton {
		let btn = UIButton()

		btn.titleLabel!.font = UIFont.systemFont(ofSize: size);
		btn.setTitle(title, for: UIControlState())
		btn.setTitleColor(color?.withAlphaComponent(0.6), for: .highlighted);
		btn.setTitleColor(color, for: UIControlState())
		btn.tag = tag;
		btn.addTarget(self, action: #selector(self.click), for: .touchUpInside)
		return btn
	}

	// 点击事件
	func click(_ btn: UIButton) {
		if (changeBtnClick != nil)
		{
			changeBtnClick!(btn.tag);
		}
	}

	// 通过move 移动按钮横线
	func movebtnByTag(_ selectedType: Int) {
		menuBar?.movebtnByTag(selectedType);
	}

}
