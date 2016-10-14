//
//  RoomMenuBar.swift
//  TVideoRoom
//
import UIKit
import SnapKit

class RoomMenuBar: UIView {
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

	func regMenuTabClick(clickHandle: tabClickBlock)
	{
		menuTabClick = clickHandle;
	}

	func setup() {

		menuBar = TabBarMenu();
		let changeLineBtn = self.createBtn("换线", tag: 3, size: 17, color: UIColor.purpleColor());
		self.addSubview(changeLineBtn);
		self.addSubview(menuBar!);
		menuBar?.snp_makeConstraints(closure: { (make) in
			make.width.equalTo(self.width * 3 / 4);
			make.height.equalTo(self);
			make.top.equalTo(self);
			make.left.equalTo(self);
		})
		// 强制更新一次
		self.layoutIfNeeded();
		menuBar?.creatBtnByList(["聊天", "贡献榜", "在线"], txtSize: 16, color: UIColor.brownColor());
		menuBar!.regClickHandle(tabBtnClikc);
		changeLineBtn.snp_makeConstraints { (make) in
			make.centerY.equalTo(self);
			make.right.equalTo(self.snp_right).offset(-20);
		};
	}

	func tabBtnClikc(tag: Int)
	{
		if (menuTabClick != nil)
		{
			menuTabClick!(tag: tag);
		}
	}

	func createBtn(title: String, tag: Int, size: CGFloat = 14, color: UIColor? = UIColor.brownColor()) -> UIButton {
		let btn = UIButton()

		btn.titleLabel!.font = UIFont.systemFontOfSize(size);
		btn.setTitle(title, forState: .Normal)
		btn.setTitleColor(color?.colorWithAlphaComponent(0.6), forState: .Highlighted);
		btn.setTitleColor(color, forState: .Normal)
		btn.tag = tag;
		btn.addTarget(self, action: #selector(self.click), forControlEvents: .TouchUpInside)
		return btn
	}

	// 点击事件
	func click(btn: UIButton) {
		if (changeBtnClick != nil)
		{
			changeBtnClick!(tag: btn.tag);
		}
	}

	// 切换按钮
	func movebtnByTag(selectedType: Int) {
		menuBar?.movebtnByTag(selectedType);
	}

}
