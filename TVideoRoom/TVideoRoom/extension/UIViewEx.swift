import UIKit

extension UIView {
	static func loadInstanceFromNib<T: UIView>() -> T? {
		var className = T.description()
		className = className.characters.split {
			$0 == "."
		}.map { String($0) }[1]
		let nib = UINib(nibName: className, bundle: nil)
		let topLevelObjects = nib.instantiate(withOwner: self, options: nil)

		return topLevelObjects.filter {
			$0 is T
		}.first as? T
	}

	static func loadInstanceFromNibNamed<T: UIView>(_ nibNamed: String) -> T? {
		let nib = UINib(nibName: nibNamed, bundle: nil)
		let topLevelObjects = nib.instantiate(withOwner: self, options: nil)

		return topLevelObjects.filter {
			$0 is T
		}.first as? T
	}

	// to containner
	static func loadInstanceFromNibNamedToContainner<T: UIView>(_ nibNamed: String, container: UIView)
		-> T? {
			let instance: T? = self.loadInstanceFromNibNamed(nibNamed)
			container.addSubview(instance!)
			instance?.frame = container.bounds
			return instance
	}

	static func loadInstanceFromNibNamedToContainner<T: UIView>(_ container: UIView)
		-> T? {
			let instance: T? = self.loadInstanceFromNib()
			let frame = container.bounds
			instance?.frame = frame
			container.addSubview(instance!)
			return instance
	}

	static func loadInstanceFromNibNamedToSrollContainner<T: UIView>(_ scrollView: UIScrollView)
		-> T? {
			let instance: T? = self.loadInstanceFromNib()
			scrollView.addSubview(instance!)
			let width = scrollView.bounds.width
			var frame = instance!.frame
			let ratio = CGFloat(frame.width) / CGFloat(frame.height)
			let screenWidth = UIScreen.main.bounds.size.width
			frame.size = CGSize(width: width, height: width / ratio)
			instance!.frame = frame
			instance!.setNeedsUpdateConstraints()
			instance!.setNeedsLayout()
			instance!.layoutIfNeeded()
			instance!.updateConstraintsIfNeeded()
			scrollView.contentSize = frame.size;
			return instance
	}

	func reloadViewSizeWithContainer(_ container: UIView) {
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

	func scale(_ xSclae: CGFloat, ySclae: CGFloat) {
		self.transform = CGAffineTransform.identity.scaledBy(x: xSclae, y: ySclae);
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

	class func rasterizeView(_ view: UIView) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(view.frame.size, true, UIScreen.main.scale)
		view.layer.render(in: UIGraphicsGetCurrentContext()!)
		let viewImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return viewImage!
	}

	func isSubviewOf(_ view: UIView) -> Bool {
		for v in view.subviews {
			if v === self {
				return true
			}
		}
		return false
	}

	class func animateWithDuration(_ duration: TimeInterval, options: UIViewAnimationOptions, animations: @escaping () -> ()) {
		self.animate(withDuration: duration, delay: 0, options: options, animations: animations, completion: nil)
	}

	class func roundView(_ view: UIView, onCorner rectCorner: UIRectCorner, radius: CGFloat) {
		let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: rectCorner, cornerRadii: CGSize(width: radius, height: radius))
		let maskLayer = CAShapeLayer()
		maskLayer.frame = view.bounds
		maskLayer.path = maskPath.cgPath
		view.layer.mask = maskLayer
	}

	func hideWithAnimation(_ hide: Bool) {

		UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
			[unowned self] in
			if hide {
				self.alpha = 0
				self.isHidden = false
				self.alpha = 1
			} else {
				self.alpha = 0
			}
		}) {
			complete in
			if !hide {
				self.isHidden = true
			}
		}
	}

	// MARK: add frame
	func addFrame() {
		layer.borderWidth = 1;
		self.layer.borderColor = UIColor.lightGray.cgColor
	}

	// MARK: add bottom Line
	func addBottomLine(_ color: UIColor) {
		var frameLine = frame
		frameLine.size.height = 0.5
		frameLine.origin.y = frame.size.height - 0.5
		frameLine.origin.x = 12
		frameLine.size.width -= 24
		let line = UIView(frame: frameLine)
		line.backgroundColor = color
		addSubview(line)
		bringSubview(toFront: line)
	}

	func addBottomLine(_ margin: CGFloat, color: UIColor) {
		var frameLine = frame
		frameLine.size.height = 0.5
		frameLine.origin.y = frame.size.height - 0.5
		frameLine.origin.x = margin
		frameLine.size.width -= margin * 2
		let line = UIView(frame: frameLine)
		line.backgroundColor = color
		addSubview(line)
	}

	func addBottomLine(_ marginLeft: CGFloat, marginRight: CGFloat, marginBottom: CGFloat, color: UIColor) {
		var frameLine = frame
		frameLine.size.height = 0.5
		frameLine.origin.y = frame.size.height - 0.5 - marginBottom
		frameLine.origin.x = marginLeft
		frameLine.size.width -= (marginLeft + marginRight)
		let line = UIView(frame: frameLine)
		line.backgroundColor = color
		addSubview(line)
	}

	func cornRadius(_ radiuns: CGFloat, bordWidth: CGFloat = 1, boderColodr: UIColor = UIColor.gray) {
		self.layer.cornerRadius = radiuns;
		self.layer.borderWidth = 1;
		self.layer.borderColor = boderColodr.cgColor;
		self.layer.masksToBounds = true;
	}

}
