

import UIKit
import SnapKit



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
	func regClickHandle(_ blcok: @escaping tabClickBlock)
	{
		selectedBlock = blcok;
	}

	func creatBtnByList(_ btnNameList: [String], txtSize: CGFloat, color: UIColor, underLinColor: UIColor = UIColor.purple) {
		// self.backgroundColor = UIColor.redColor();
		btnList.removeAll();
		let count: CGFloat = CGFloat(btnNameList.count);
		itemSize = self.width / count;
		for (index, title) in btnNameList.enumerated()
		{
			let btn = createBtn(title, tag: index, size: txtSize, color: color);
			btn.frame = CGRect(x: CGFloat(index) * itemSize, y: 0, width: itemSize, height: self.height);
			// btn.centenY = 0;
			btnList.append(btn);
			self.addSubview(btn);

		}
		underLine = UIView(frame: CGRect(x: 15.0, y: self.height - 4, width: itemSize / 2, height: 2.0));
		underLine!.backgroundColor = UIColor.purple;
		self.addSubview(underLine!);
		if (btnList.count > 0)
		{
			click(btnList[0]);
		}
		self.layoutIfNeeded();
	}

	func createBtn(_ title: String, tag: Int, size: CGFloat = 14, color: UIColor? = UIColor.brown) -> UIButton {
		let btn = UIButton()
		// let fsize:CGFloat = size as! CGFloat
		btn.titleLabel!.font = UIFont.systemFont(ofSize: size);
		btn.setTitle(title, for: UIControlState())
		btn.setTitleColor(color?.withAlphaComponent(0.6), for: .selected)
		btn.setTitleColor(color, for: UIControlState())
		btn.tag = tag;
		btn.addTarget(self, action: #selector(self.click), for: .touchUpInside)
		return btn
	}

// 点击事件
	func click(_ btn: UIButton) {
		self.selectedBtn?.isSelected = false
		btn.isSelected = true
		self.selectedBtn = btn
		isBtnClickAnimation = true;
		moveBtn(btn);
		if (self.selectedBlock != nil) {
			self.selectedBlock!(btn.tag);
		}
	}

	func moveBtn(_ btn: UIButton) {
		UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
			() -> Void in
			self.underLine!.x = CGFloat(btn.tag) * (self.itemSize) + self.itemSize / 4;
			}, completion: {
			(bool) -> Void in
			self.isBtnClickAnimation = false;
			}
		);
	}

	func setSelectedType(_ selectedType: Int) {
		_selectedType = selectedType
		self.selectedBtn?.isSelected = false
		for view: UIView in self.subviews {
			if (view is UIButton) && view.tag == selectedType {
				self.selectedBtn = (view as! UIButton)
				(view as! UIButton).isSelected = true;
			}
		}
	}

	func movebtnByTag(_ selectedType: Int) {
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
