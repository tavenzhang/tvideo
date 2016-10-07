//
//  UIExtension.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/6/25.
//  Copyright © 2016年 张新华. All rights reserved.
//

import UIKit
/// 对UIView的扩展
extension UIView {
//	/// X值
//	var x: CGFloat {
//		return self.frame.origin.x
//	}
//	/// Y值
//	var y: CGFloat {
//		return self.frame.origin.y
//	}
//	/// 宽度
//	var width: CGFloat {
//		return self.frame.size.width
//	}
//	/// 高度
//	var height: CGFloat {
//		return self.frame.size.height
//	}
//	var size: CGSize {
//		return self.frame.size
//	}
//	var point: CGPoint {
//		return self.frame.origin
//	}
	func scale(xSclae: CGFloat, ySclae: CGFloat) {
		self.transform = CGAffineTransformScale(CGAffineTransformIdentity, xSclae, ySclae);
	}
}

extension NSData {

	func toUtf8String() -> String {
		return String(data: self, encoding: NSUTF8StringEncoding)!;
	}
}

extension UIColor {

	class func colorWithCustom(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
		return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
	}

	class func colorWithCustom(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
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
	case Left = 0
	case Right = 1
	case Default = 2
}

extension UIButton {

	class func BtnSimple(title: String, titleColor: UIColor, image: UIImage?, hightLightImage: UIImage?, target: AnyObject?, action: Selector, type: ItemButtonType = .Default) -> UIButton {
		var btn: UIButton?;
		if type == ItemButtonType.Left {
			btn = ItemLeftButton(type: .Custom)
		} else if type == ItemButtonType.Right {
			btn = ItemRightButton(type: .Custom)
		}
		else {
			btn = UIButton()
		}
		btn!.setTitle(title, forState: .Normal)
        if(image != nil)
        {
            btn!.setImage(image!, forState: .Normal)
        }
		btn!.setTitleColor(titleColor, forState: .Normal)
        if(hightLightImage != nil)
        {
            btn!.setImage(hightLightImage, forState: .Highlighted);
        }
	
		btn!.addTarget(target, action: action, forControlEvents: .TouchUpInside)
		btn!.frame = CGRectMake(0, 0, 60, 44)
		btn!.titleLabel?.font = UIFont.systemFontOfSize(10);
		return btn!;
	}

	class func BunImgSimple(image: UIImage, hightLightImage: UIImage?, target: AnyObject?, action: Selector, type: ItemButtonType = .Default) -> UIButton
	{
		var btn: UIButton?;
		if type == ItemButtonType.Left {
			btn = ItemLeftButton(type: .Custom)
		} else if type == ItemButtonType.Right {
			btn = ItemRightButton(type: .Custom)
		}
		else {
			btn = UIButton()
		}
		btn!.setImage(image, forState: UIControlState.Normal)
		if (hightLightImage != nil)
		{
			btn!.setImage(hightLightImage, forState: .Highlighted)
		}
		btn!.imageView?.contentMode = UIViewContentMode.Center
		btn!.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
		btn!.frame = CGRectMake(0, 0, 44, 44)
		return btn!;

	}

}

extension UIBarButtonItem {

	class func barButton(title: String, titleColor: UIColor, image: UIImage, hightLightImage: UIImage?, target: AnyObject?, action: Selector, type: ItemButtonType) -> UIBarButtonItem {
		var btn: UIButton = UIButton()
		if type == ItemButtonType.Left {
			btn = ItemLeftButton(type: .Custom)
		} else {
			btn = ItemRightButton(type: .Custom)
		}
		btn.setTitle(title, forState: .Normal)
		btn.setImage(image, forState: .Normal)
		btn.setTitleColor(titleColor, forState: .Normal)
		btn.setImage(hightLightImage, forState: .Highlighted)
		btn.addTarget(target, action: action, forControlEvents: .TouchUpInside)
		btn.frame = CGRectMake(0, 0, 60, 44)
		btn.titleLabel?.font = UIFont.systemFontOfSize(10)

		return UIBarButtonItem(customView: btn)
	}

	class func barButton(image: UIImage, target: AnyObject?, action: Selector) -> UIBarButtonItem {
		let btn = ItemLeftImageButton(type: .Custom)
		btn.setImage(image, forState: UIControlState.Normal)
		btn.imageView?.contentMode = UIViewContentMode.Center
		btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
		btn.frame = CGRectMake(0, 0, 44, 44)
		return UIBarButtonItem(customView: btn)
	}

	class func barButton(title: String, titleColor: UIColor, target: AnyObject?, action: Selector) -> UIBarButtonItem {
		let btn = UIButton(frame: CGRectMake(0, 0, 60, 44))
		btn.setTitle(title, forState: .Normal)
		btn.setTitleColor(titleColor, forState: .Normal)
		btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
		btn.titleLabel?.font = UIFont.systemFontOfSize(15)
		if title.characters.count == 2 {
			btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -25)
		}
		return UIBarButtonItem(customView: btn)
	}

}