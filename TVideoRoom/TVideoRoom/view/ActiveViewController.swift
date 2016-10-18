//
//  UIFindViewConntroller.swift
//  TVideoRoom
//
import UIKit

class ActiveViewController: WebViewController {

	override func viewDidLoad() {
		super.viewDidLoad();

	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated);
		self.refreshClick();
	}
}
