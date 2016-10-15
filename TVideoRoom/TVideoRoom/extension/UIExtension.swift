//
//  UIExtension.swift
//  TVideoRoom

import UIKit
/// 对UIView的扩展
extension Int
{
	func toCGFloat() -> CGFloat {
		return CGFloat(self);
	}
}
extension CGFloat
{
	func toInt() -> Int {
		return Int(self);
	}
}
extension UIImage {

	class func resizableImageWithName(_ imageName: String) -> UIImage {
		// 加载原有图片
		let norImage = UIImage(named: imageName);
		// 获取原有图片的宽高的一半
		let w: CGFloat = norImage!.size.width * 0.5
		let top: CGFloat = norImage!.size.height * 0.5
		let bottom: CGFloat = norImage!.size.height - top
		// 生成可以拉伸指定位置的图片
		let newImage = norImage!.resizableImage(withCapInsets: UIEdgeInsetsMake(top, w, bottom, w), resizingMode: .stretch)
		return newImage
	}

	class func bundleImageName(_ imageName: String) -> UIImage {
//		let bundlePath = NSURL(fileURLWithPath: NSBundle.mainBundle().resourcePath!).URLByAppendingPathComponent("Chat.bundle").absoluteString
//		let nsBund = NSBundle(path: bundlePath)
		// let img = UIImage(named: imageName, inBundle: nsBund, compatibleWithTraitCollection: nil)!
		let img = UIImage(named: imageName);
		return img!
	}

}

extension Data {

	func toUtf8String() -> String {
		return String(data: self, encoding: String.Encoding.utf8)!;
	}
}

extension UILabel {
	class func lableSimple(_ title: String, corlor: UIColor, size: CGFloat, align: NSTextAlignment = .left) -> UILabel {
		let lb = UILabel();
		lb.textColor = corlor;
		lb.text = title;
		lb.font = UIFont.boldSystemFont(ofSize: size);
		lb.textAlignment = align;
		lb.adjustsFontSizeToFitWidth = true;
		return lb;
	}

}
extension UIColor {

	class func colorWithCustom(_ r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
		return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
	}

	class func colorWithCustom(_ r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
		return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
	}

	class func randomColor() -> UIColor {
		let r = CGFloat(arc4random_uniform(256))
		let g = CGFloat(arc4random_uniform(256))
		let b = CGFloat(arc4random_uniform(256))
		return UIColor.colorWithCustom(r, g: g, b: b)
	}
}

enum ItemButtonType: Int {
	case left = 0
	case right = 1
	case `default` = 2
}

extension UIButton {

	class func BtnSimple(_ title: String, titleColor: UIColor, image: UIImage?, hightLightImage: UIImage?, target: AnyObject?, action: Selector, type: ItemButtonType = .default) -> UIButton {
		var btn: UIButton?;
		if type == ItemButtonType.left {
			btn = ItemLeftButton(type: .custom)
		} else if type == ItemButtonType.right {
			btn = ItemRightButton(type: .custom)
		}
		else {
			btn = UIButton()
		}
		if (image != nil)
		{
			btn!.setImage(image!, for: UIControlState())
		}
		btn?.setTitle(title, for: UIControlState());
		btn!.setTitleColor(titleColor, for: UIControlState())
		btn!.setTitleColor(titleColor.withAlphaComponent(0.6), for: .highlighted);
		if (hightLightImage != nil)
		{
			btn!.setImage(hightLightImage, for: .highlighted);
		}
		btn!.addTarget(target, action: action, for: .touchUpInside)
		btn!.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
		btn!.titleLabel?.font = UIFont.systemFont(ofSize: 10);
		return btn!;
	}

	class func BunImgSimple(_ image: UIImage, hightLightImage: UIImage?, target: AnyObject?, action: Selector, type: ItemButtonType = .default) -> UIButton
	{
		var btn: UIButton?;
		if type == ItemButtonType.left {
			btn = ItemLeftButton(type: .custom)
		} else if type == ItemButtonType.right {
			btn = ItemRightButton(type: .custom)
		}
		else {
			btn = UIButton()
		}
		btn!.setImage(image, for: UIControlState())
		if (hightLightImage != nil)
		{
			btn!.setImage(hightLightImage, for: .highlighted)
		}
		btn!.imageView?.contentMode = UIViewContentMode.center
		btn!.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
		btn!.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
		return btn!;

	}

}

extension String {

	/**
     Encode a String to Base64
     
     :returns:
     */
	func toBase64() -> String {

		let data = self.data(using: String.Encoding.utf8)
		return data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))

	}

}

extension UIBarButtonItem {

	class func barButton(_ title: String, titleColor: UIColor, image: UIImage, hightLightImage: UIImage?, target: AnyObject?, action: Selector, type: ItemButtonType) -> UIBarButtonItem {
		var btn: UIButton = UIButton()
		if type == ItemButtonType.left {
			btn = ItemLeftButton(type: .custom)
		} else {
			btn = ItemRightButton(type: .custom)
		}
		btn.setTitle(title, for: UIControlState())
		btn.setImage(image, for: UIControlState())
		btn.setTitleColor(titleColor, for: UIControlState())
		btn.setImage(hightLightImage, for: .highlighted)
		btn.addTarget(target, action: action, for: .touchUpInside)
		btn.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
		btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)

		return UIBarButtonItem(customView: btn)
	}

	class func barButton(_ image: UIImage, target: AnyObject?, action: Selector) -> UIBarButtonItem {
		let btn = ItemLeftImageButton(type: .custom)
		btn.setImage(image, for: UIControlState())
		btn.imageView?.contentMode = UIViewContentMode.center
		btn.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
		btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
		return UIBarButtonItem(customView: btn)
	}

	class func barButton(_ title: String, titleColor: UIColor, target: AnyObject?, action: Selector) -> UIBarButtonItem {
		let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 44))
		btn.setTitle(title, for: UIControlState())
		btn.setTitleColor(titleColor, for: UIControlState())
		btn.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
		btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
		if title.characters.count == 2 {
			btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -25)
		}
		return UIBarButtonItem(customView: btn)
	}

}
