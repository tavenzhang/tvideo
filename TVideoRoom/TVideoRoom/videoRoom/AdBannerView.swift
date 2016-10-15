//
//  TVideoRoom
//
import UIKit

class AdBannerView: UICollectionReusableView {
	fileprivate var pageScrollView: PageScrollView?
	// private var hotView: HotView?
	weak var delegate: HomeTableHeadViewDelegate?

	override init(frame: CGRect) {
		super.init(frame: frame)
		buildPageScrollView();
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: 模型的set方法
	var data: [Activity]? {
		didSet {
			pageScrollView?.data = data;
		}
	}
	// MARK: 初始化子控件
	func buildPageScrollView() {
		weak var tmpSelf = self
		pageScrollView = PageScrollView(frame: CGRect.zero, placeholder: UIImage(named: r_home_videoImgPlaceholder)!, focusImageViewClick: { (index) -> Void in
			tmpSelf?.delegate?.tableHeadView?(tmpSelf!, focusImageViewClick: index);
		})
		addSubview(pageScrollView!)
	}

	// MARK: 布局子控件
	override func layoutSubviews() {
		super.layoutSubviews()
		pageScrollView?.frame = AdBannerView.bannerFrame;
	}

	internal static var bannerFrame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenWidth * 0.25);
}
// - MARK: Delegate
@objc protocol HomeTableHeadViewDelegate: NSObjectProtocol {
	@objc optional func tableHeadView(_ headView: AdBannerView, focusImageViewClick index: Int)
	@objc optional func tableHeadView(_ headView: AdBannerView, iconClick index: Int)
}

class HomeCollectionFooterView: UICollectionReusableView {

	fileprivate let titleLabel: UILabel = UILabel()

	override init(frame: CGRect) {
		super.init(frame: frame)
		titleLabel.text = "点击产看更多主播 >"
		titleLabel.textAlignment = NSTextAlignment.center;
		titleLabel.font = UIFont.systemFont(ofSize: 16)
		titleLabel.textColor = UIColor.colorWithCustom(150, g: 150, b: 150)
		titleLabel.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 50)
		addSubview(titleLabel)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func hideLabel() {
		self.titleLabel.isHidden = true
	}

	func showLabel() {
		self.titleLabel.isHidden = false
	}

	func setFooterTitle(_ text: String, textColor: UIColor) {
		titleLabel.text = text
		titleLabel.textColor = textColor
	}
}


class HomeCollectionHeaderView: UICollectionReusableView {
	let titleLabel: UILabel = UILabel()

	convenience init(frame: CGRect, title: String) {
		self.init(frame: frame);
		titleLabel.text = "title";
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		titleLabel.text = "才艺主播"
		titleLabel.textAlignment = NSTextAlignment.left
		titleLabel.font = UIFont.systemFont(ofSize: 14)
		titleLabel.frame = CGRect(x: 10, y: 0, width: 200, height: 20)
		titleLabel.textColor = UIColor.colorWithCustom(150, g: 150, b: 150)
		addSubview(titleLabel)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
