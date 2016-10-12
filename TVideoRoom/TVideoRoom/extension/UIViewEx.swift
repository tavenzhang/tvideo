import UIKit

extension UIView {
	static func loadInstanceFromNib<T: UIView>() -> T? {
		var className = T.description()
		className = className.characters.split {
			$0 == "."
		}.map { String($0) }[1]
		let nib = UINib(nibName: className, bundle: nil)
		let topLevelObjects = nib.instantiateWithOwner(self, options: nil)

		return topLevelObjects.filter {
			$0 is T
		}.first as? T
	}

	static func loadInstanceFromNibNamed<T: UIView>(nibNamed: String) -> T? {
		let nib = UINib(nibName: nibNamed, bundle: nil)
		let topLevelObjects = nib.instantiateWithOwner(self, options: nil)

		return topLevelObjects.filter {
			$0 is T
		}.first as? T
	}

	// to containner
	static func loadInstanceFromNibNamedToContainner<T: UIView>(nibNamed: String, container: UIView)
		-> T? {
			let instance: T? = self.loadInstanceFromNibNamed(nibNamed)
			container.addSubview(instance!)
			instance?.frame = container.bounds
			return instance
	}

	static func loadInstanceFromNibNamedToContainner<T: UIView>(container: UIView)
		-> T? {
			let instance: T? = self.loadInstanceFromNib()
			let frame = container.bounds
			instance?.frame = frame
			container.addSubview(instance!)
			return instance
	}

	static func loadInstanceFromNibNamedToSrollContainner<T: UIView>(scrollView: UIScrollView)
		-> T? {
			let instance: T? = self.loadInstanceFromNib()
			scrollView.addSubview(instance!)
			let width = scrollView.bounds.width
			var frame = instance!.frame
			let ratio = CGFloat(frame.width) / CGFloat(frame.height)
			let screenWidth = UIScreen.mainScreen().bounds.size.width
			frame.size = CGSizeMake(width, width / ratio)
			instance!.frame = frame
			instance!.setNeedsUpdateConstraints()
			instance!.setNeedsLayout()
			instance!.layoutIfNeeded()
			instance!.updateConstraintsIfNeeded()
			scrollView.contentSize = frame.size;
			return instance
	}

	func reloadViewSizeWithContainer(container: UIView) {
		self.bounds = container.bounds
		self.frame = container.frame
	}

	var x: CGFloat {
		get {
			return self.center.x
		}

		set(x) {
			var frame = self.frame
			frame.origin.x = x
			self.frame = frame
		}
	}

	var y: CGFloat {
		get {
			return self.center.y
		}

		set(y) {
			var frame = self.frame
			frame.origin.y = y
			self.frame = frame
		}
	}

	func scale(xSclae: CGFloat, ySclae: CGFloat) {
		self.transform = CGAffineTransformScale(CGAffineTransformIdentity, xSclae, ySclae);
	}

	var width: CGFloat {
		get {
			return self.frame.size.width
		}

		set(width) {
			var frame = self.frame
			frame.size.width = width
			self.frame = frame
		}
	}

	var height: CGFloat {
		get {
			return self.frame.size.height
		}

		set(height) {
			var frame = self.frame
			frame.size.height = height
			self.frame = frame
		}
	}
	var top: CGFloat {
		get {
			return self.frame.origin.y;
		}

		set(top) {
			var newframe = self.frame
			newframe.origin.y = top
			self.frame = newframe
		}
	}

	var left: CGFloat {
		get {
			return self.frame.origin.x;
		}
		set(left) {
			var newframe = self.frame
			newframe.origin.x = left;
			self.frame = newframe;
		}
	}

	var bottom: CGFloat {
		get {
			return self.frame.origin.y + self.frame.size.height;
		}
		set(newbottom) {
			var newframe = self.frame
			newframe.origin.y = newbottom - self.frame.size.height
			self.frame = newframe
		}
	}
	var right: CGFloat {
		get {
			return self.frame.origin.y + self.frame.size.height;
		}
		set(newright) {
			let delta: CGFloat = newright - (self.frame.origin.x + self.frame.size.width)
			var newframe = self.frame
			newframe.origin.x += delta
			self.frame = newframe
		}
	}

	var centenX: CGFloat {

		get {
			return self.center.x;
		}

		set(centenX) {
			var center = self.center;
			center.x = centenX;
			self.center = center;

		}
	}

	var centenY: CGFloat {

		get {
			return self.center.y;
		}

		set(centenY) {
			var center = self.center;
			center.y = centenY;
			self.center = center;
		}
	}

	func removeAllSubviews() {
		for view in (self.subviews) {
			view.removeFromSuperview()
		}
	}

	class func rasterizeView(view: UIView) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(view.frame.size, true, UIScreen.mainScreen().scale)
		view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
		let viewImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return viewImage
	}

	func isSubviewOf(view: UIView) -> Bool {
		for v in view.subviews {
			if v === self {
				return true
			}
		}
		return false
	}

	class func animateWithDuration(duration: NSTimeInterval, options: UIViewAnimationOptions, animations: () -> ()) {
		self.animateWithDuration(duration, delay: 0, options: options, animations: animations, completion: nil)
	}

	class func roundView(view: UIView, onCorner rectCorner: UIRectCorner, radius: CGFloat) {
		let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: rectCorner, cornerRadii: CGSizeMake(radius, radius))
		let maskLayer = CAShapeLayer()
		maskLayer.frame = view.bounds
		maskLayer.path = maskPath.CGPath
		view.layer.mask = maskLayer
	}

	func hideWithAnimation(hide: Bool) {

		UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseOut, animations: {
			[unowned self] in
			if hide {
				self.alpha = 0
				self.hidden = false
				self.alpha = 1
			} else {
				self.alpha = 0
			}
		}) {
			complete in
			if !hide {
				self.hidden = true
			}
		}
	}

	// MARK: add frame
	func addFrame() {
		layer.borderWidth = 1;
		self.layer.borderColor = UIColor.lightGrayColor().CGColor
	}

	// MARK: add bottom Line
	func addBottomLine(color: UIColor) {
		var frameLine = frame
		frameLine.size.height = 0.5
		frameLine.origin.y = frame.size.height - 0.5
		frameLine.origin.x = 12
		frameLine.size.width -= 24
		let line = UIView(frame: frameLine)
		line.backgroundColor = color
		addSubview(line)
		bringSubviewToFront(line)
	}

	func addBottomLine(margin: CGFloat, color: UIColor) {
		var frameLine = frame
		frameLine.size.height = 0.5
		frameLine.origin.y = frame.size.height - 0.5
		frameLine.origin.x = margin
		frameLine.size.width -= margin * 2
		let line = UIView(frame: frameLine)
		line.backgroundColor = color
		addSubview(line)
	}

	func addBottomLine(marginLeft: CGFloat, marginRight: CGFloat, marginBottom: CGFloat, color: UIColor) {
		var frameLine = frame
		frameLine.size.height = 0.5
		frameLine.origin.y = frame.size.height - 0.5 - marginBottom
		frameLine.origin.x = marginLeft
		frameLine.size.width -= (marginLeft + marginRight)
		let line = UIView(frame: frameLine)
		line.backgroundColor = color
		addSubview(line)
	}

	func cornRadius(radiuns: CGFloat, bordWidth: CGFloat = 1, boderColodr: UIColor = UIColor.grayColor()) {
		self.layer.cornerRadius = radiuns;
		self.layer.borderWidth = 1;
		self.layer.borderColor = boderColodr.CGColor;
		self.layer.masksToBounds = true;
	}

}