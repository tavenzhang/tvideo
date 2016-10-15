//
//  TSegmentedControl.swift
//  TVideoRoom
//

class TSegmentedControl: UISegmentedControl {

	var segmentedClick: ((_ index: Int) -> Void)?

	override init(items: [Any]?) {
		super.init(items: items)
		tintColor = LFBNavigationYellowColor
		setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.black], for: UIControlState.selected)
		setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.colorWithCustom(100, g: 100, b: 100)], for: UIControlState())
		addTarget(self, action: #selector(self.segmentedControlDidValuechange), for: UIControlEvents.valueChanged)
		selectedSegmentIndex = 0
	}

	convenience init(items: [AnyObject]?, didSelectedIndex: @escaping (_ index: Int) -> ()) {
		self.init(items: items)

		segmentedClick = didSelectedIndex
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	func segmentedControlDidValuechange(_ sender: UISegmentedControl) {
		if segmentedClick != nil {
			segmentedClick!(sender.selectedSegmentIndex)
		}
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
