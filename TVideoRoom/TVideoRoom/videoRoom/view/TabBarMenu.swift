//
//  RoolMenu.swift
//  TVideoRoom

import UIKit
import SnapKit

typealias tabClickBlock = (tag: Int) -> Void;

class TabBarMenu: UIView {

	// MARK: - 初始化子空间
	var selectedBtn: UIButton?;
	var selectedBlock: tabClickBlock?;
	var _selectedType: Int = 0;
	var btnList: [UIButton] = [];
	// 延迟初始化
	var underLine: UIView?;
	var itemSize: CGFloat = 0;

	var isBtnClickAnimation: Bool = false;

	override func layoutSubviews() {
		super.layoutSubviews();
	}

	override init(frame: CGRect) {
		super.init(frame: frame);

	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	deinit
	{
		selectedBlock = nil;

	}

	/// 注册点击回调
	func regClickHandle(blcok: tabClickBlock)
	{
		selectedBlock = blcok;
	}

	func creatBtnByList(btnNameList: [String], txtSize: CGFloat, color: UIColor, underLinColor: UIColor = UIColor.purpleColor()) {
		// self.backgroundColor = UIColor.redColor();
		btnList.removeAll();
		let count: CGFloat = CGFloat(btnNameList.count);
		itemSize = self.width / count;
		for (index, title) in btnNameList.enumerate()
		{
			let btn = createBtn(title, tag: index, size: txtSize, color: color);
			btn.frame = CGRectMake(CGFloat(index) * itemSize, 0, itemSize, self.height);
			//btn.centenY = 0;
			btnList.append(btn);
			self.addSubview(btn);

		}
		underLine = UIView(frame: CGRect(x: 15.0, y: self.height - 4, width: itemSize / 2, height: 2.0));
		underLine!.backgroundColor = UIColor.purpleColor();
		self.addSubview(underLine!);
		click(btnList[0]);
		self.layoutIfNeeded();
	}

	func createBtn(title: String, tag: Int, size: CGFloat = 14, color: UIColor? = UIColor.brownColor()) -> UIButton {
		let btn = UIButton()
		// let fsize:CGFloat = size as! CGFloat
		btn.titleLabel!.font = UIFont.systemFontOfSize(size);
		btn.setTitle(title, forState: .Normal)
		btn.setTitleColor(color?.colorWithAlphaComponent(0.6), forState: .Selected)
		btn.setTitleColor(color, forState: .Normal)
		btn.tag = tag;
		btn.addTarget(self, action: #selector(self.click), forControlEvents: .TouchUpInside)
		return btn
	}

// 点击事件
	func click(btn: UIButton) {
		self.selectedBtn?.selected = false
		btn.selected = true
		self.selectedBtn = btn
		isBtnClickAnimation = true;
		moveBtn(btn);
		if (self.selectedBlock != nil) {
			self.selectedBlock!(tag: btn.tag);
		}
	}

	func moveBtn(btn: UIButton) {
		UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
			() -> Void in
			self.underLine!.x = CGFloat(btn.tag) * (self.itemSize) + self.itemSize / 4;
			}, completion: {
			(bool) -> Void in
			self.isBtnClickAnimation = false;
			}
		);
	}

	func setSelectedType(selectedType: Int) {
		_selectedType = selectedType
		self.selectedBtn?.selected = false
		for view: UIView in self.subviews {
			if (view is UIButton) && view.tag == selectedType {
				self.selectedBtn = (view as! UIButton)
				(view as! UIButton).selected = true;
			}
		}
	}

	func movebtnByTag(selectedType: Int) {
		for btn in btnList
		{
			if (btn.tag == selectedType)
			{
				if (!isBtnClickAnimation)
				{
					setSelectedType(selectedType);
					moveBtn(selectedBtn!);
				}
				return;
			}
		}
	}

}
