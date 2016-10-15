//
//  GiftEffectVC.swift

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class GiftEffectVC: UIView {

	var giftSendBarOne: GiftSendBar?;
	var giftSendBarTwo: GiftSendBar?;
	var giftSendBarThree: GiftSendBar?;

	var gifsendBarOneUid: UInt32 = 0;
	var gifsendBarTWoUid: UInt32 = 0;
	var gifsendBarThreeUid: UInt32 = 0;

	var gifsendBarOneUid_giftid: UInt32 = 0;
	var gifsendBarTWoUid_giftid: UInt32 = 0;
	var gifsendBarThreeUid_giftid: UInt32 = 0;

	var giftStructureArray = [GiftInfoModel]();
	var giftSendTimer: Timer?;
	// 送礼累计个数
	static var giftCount: UInt32 = 0;

	override init(frame: CGRect) {
		super.init(frame: frame);
		NotificationCenter.default.addObserver(self, selector: #selector(self.removesendGiftbar), name: NSNotification.Name(rawValue: "removegistSendbar"), object: nil);
		self.isMultipleTouchEnabled = false;
		self.isUserInteractionEnabled = false;
	}
	deinit
	{
		NotificationCenter.default.removeObserver(self)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// 添加礼物
	func addEffectGift(_ gift: GiftInfoModel) {
		gift.selfIconStr = GiftEffectVC.giftCount % 2 == 0 ? "giftHead1" : "giftHead2";
		GiftEffectVC.giftCount = GiftEffectVC.giftCount + 1;
		gift.send_user_id = GiftEffectVC.giftCount;
		giftStructureArray.append(gift);
		if giftSendTimer == nil && giftStructureArray.count > 0 {
			self.giftTimerStart()
		}
	}

	func giftTimerStart() {
		giftSendTimer = Timer.scheduledTimer(timeInterval: 1.25, target: self, selector: #selector(self.giftAnimationSHow), userInfo: nil, repeats: true)
		// 1.65s //2.65
		giftSendTimer!.fire()
	}

	func isAlreadyIsExit() -> Bool {
		var isExit = false
		let giftShowInfoStructure = giftStructureArray[0];
		if (giftShowInfoStructure.send_user_id == gifsendBarOneUid) && (self.giftSendBarOne != nil) && giftSendBarOne!.timer.isValid && (gifsendBarOneUid_giftid == giftShowInfoStructure.gift_uid) {
			self.giftSendBarOne?.gifBig = (giftSendBarOne?.gifBig)! + Int64(giftShowInfoStructure.giftCounts);
			if giftSendBarOne?.gifBig >= 11 && (giftSendBarOne?.gifBig)! - 10 > giftSendBarOne!.countAdd {
				self.giftSendBarOne?.countAdd = (giftSendBarOne?.gifBig)! - 10
			}
			isExit = true
		}
		else if (giftShowInfoStructure.send_user_id == gifsendBarTWoUid) && (giftSendBarTwo != nil) && (giftSendBarTwo?.timer.isValid)! && (gifsendBarTWoUid_giftid == giftShowInfoStructure.gift_uid)
		{
			self.giftSendBarTwo?.gifBig = (giftSendBarTwo?.gifBig)! + Int64(giftShowInfoStructure.giftCounts)
			if giftSendBarTwo?.gifBig >= 11 && (giftSendBarTwo?.gifBig)! - 10 > giftSendBarTwo!.countAdd {
				self.giftSendBarTwo!.countAdd = giftSendBarTwo!.gifBig - 10
			}
			isExit = true
		}
		else if (giftShowInfoStructure.send_user_id == gifsendBarThreeUid) && (giftSendBarThree != nil) && (giftSendBarThree?.timer.isValid)! && gifsendBarThreeUid_giftid == giftShowInfoStructure.gift_uid {
			self.giftSendBarThree!.gifBig = giftSendBarThree!.gifBig + Int64(giftShowInfoStructure.giftCounts);
			if giftSendBarThree!.gifBig >= 11 && giftSendBarThree!.gifBig - 10 > giftSendBarThree!.countAdd {
				self.giftSendBarThree!.countAdd = giftSendBarThree!.gifBig - 10
			}
			isExit = true
		}
//		if isExit {
//			giftStructureArray.removeAtIndex(0)
//		}
		return isExit
	}

	func initGiftSendbarwithtag(_ tag: Int) {
		// 初始化礼物赠送条
		let giftShowInfoStructure = giftStructureArray[0];
		giftStructureArray.remove(at: 0);
		var yPos: CGFloat = 0
		yPos = ScreenHeight - 200 - 75 - 10
		let giftsendbar = GiftSendBar(frame: CGRect(x: 10 - ScreenWidth, y: yPos, width: ScreenWidth - 20, height: 75))
		if tag == 0 {
			self.giftSendBarOne = giftsendbar
			self.gifsendBarOneUid = giftShowInfoStructure.send_user_id
			self.gifsendBarOneUid_giftid = giftShowInfoStructure.gift_uid
			self.addSubview(giftSendBarOne!);
		}
		else if tag == 1 {
			self.giftSendBarTwo = giftsendbar
			self.gifsendBarTWoUid = giftShowInfoStructure.send_user_id
			self.gifsendBarTWoUid_giftid = giftShowInfoStructure.gift_uid
			self.addSubview(giftSendBarTwo!);
		}
		else if tag == 2 {
			self.giftSendBarThree = giftsendbar
			self.gifsendBarThreeUid = giftShowInfoStructure.send_user_id
			self.gifsendBarThreeUid_giftid = giftShowInfoStructure.gift_uid
			self.addSubview(giftSendBarThree!);
		}
		giftsendbar.setSendGiftBarUsername(giftShowInfoStructure.senderNickString, giftnumString: "\(giftShowInfoStructure.giftCounts)", withgiftname: giftShowInfoStructure.giftNameString, withgiftpath: giftShowInfoStructure.giftThumbnailPath)
		giftsendbar.setImageViewimagefromStr(giftShowInfoStructure.selfIconStr);
	}

	func giftAnimationSHow() {
		if giftStructureArray.count > 0 {
			if !self.isAlreadyIsExit() {
				if giftSendBarOne == nil {
					self.initGiftSendbarwithtag(0)
					self.giftSendBarAppear(giftSendBarOne!)
				}
				else if giftSendBarTwo == nil {
					self.initGiftSendbarwithtag(1)
					self.giftSendBarAppear(giftSendBarTwo!)
				}
				else if giftSendBarThree == nil {
					self.initGiftSendbarwithtag(2)
					self.giftSendBarAppear(giftSendBarThree!)
				}
				LogHttp("giftStructureArray.count---\(giftStructureArray.count)");
			}
		}
		else if giftStructureArray.count == 0 {
			self.giftTimerStop()
		}
	}

	func giftTimerStop() {
		if giftSendTimer != nil {
			if giftSendTimer!.isValid {
				giftSendTimer!.invalidate()
			}
			giftSendTimer = nil
		}
	}

	func giftSendbarAnimation(_ giftsendbar: GiftSendBar) {
		// UIView.animationsEnabled = true
		UIView.animate(withDuration: 0.7, animations: { () -> Void in
			if self.giftStructureArray.count > 1 {
				self.adjustGiftSendBar(giftsendbar)
			}
			}, completion: { _ in })
	}

	func adjustGiftSendBar(_ giftsendbar: GiftSendBar) {
		// 向上滚动坐标调整
		let yPos: CGFloat = ScreenHeight - 200 - 75 - 10
		if giftsendbar == giftSendBarTwo {
			if (giftSendBarOne != nil) && giftSendBarOne?.frame.origin.y <= yPos && giftSendBarOne?.frame.origin.y > (yPos - 75 - 10) {
				self.giftSendBarOne!.frame = CGRect(x: 10, y: yPos - 75 - 10, width: ScreenWidth - 20, height: 75)
				if (giftSendBarThree != nil) && giftSendBarThree!.frame.origin.y <= (yPos - 75 - 10) && giftSendBarThree!.frame.origin.y > (yPos - 75 - 10 - 75 - 10) {
					self.giftSendBarThree!.frame = CGRect(x: 10, y: (yPos - 75 - 10) - 75 - 10, width: ScreenWidth - 20, height: 75)
				}
			}
			else if (giftSendBarThree != nil) && giftSendBarThree!.frame.origin.y <= yPos && giftSendBarThree!.frame.origin.y > (yPos - 75 - 10) {
				if yPos - 75 - 10 == giftSendBarTwo!.frame.origin.y {
					return
				}
				self.giftSendBarThree!.frame = CGRect(x: 10, y: yPos - 75 - 10, width: ScreenWidth - 20, height: 75)
			}
		}
		else if (giftsendbar == giftSendBarThree) {
			if (giftSendBarTwo != nil) && yPos <= giftSendBarTwo!.frame.origin.y && giftSendBarTwo!.frame.origin.y > (yPos - 75 - 10) {
				self.giftSendBarTwo!.frame = CGRect(x: 10, y: yPos - 75 - 10, width: ScreenWidth - 20, height: 75)
				if (giftSendBarOne != nil) && (yPos - 75 - 10) >= giftSendBarOne!.frame.origin.y && giftSendBarOne!.frame.origin.y > (yPos - 75 - 10 - 75 - 10) {
					self.giftSendBarOne!.frame = CGRect(x: 10, y: yPos - 75 - 10 - 75 - 10, width: ScreenWidth - 20, height: 75)
				}
			}
			else if (giftSendBarOne != nil) && yPos >= giftSendBarOne!.frame.origin.y && giftSendBarOne!.frame.origin.y > (yPos - 75 - 10) {
				if yPos - 75 - 10 == giftSendBarThree!.frame.origin.y {
					return
				}
				self.giftSendBarOne!.frame = CGRect(x: 10, y: yPos - 75 - 10, width: ScreenWidth - 20, height: 75)
			}
		}
		else if giftsendbar == giftSendBarOne {
			if (giftSendBarThree != nil) && giftSendBarThree!.frame.origin.y <= yPos && giftSendBarThree!.frame.origin.y > (yPos - 75 - 10) {
				self.giftSendBarThree!.frame = CGRect(x: 10, y: yPos - 75 - 10, width: ScreenWidth - 20, height: 75)
				if (giftSendBarTwo != nil) && (yPos - 75 - 10) >= giftSendBarThree!.frame.origin.y && giftSendBarThree!.frame.origin.y > (yPos - 75 - 10 - 75 - 10) {
					self.giftSendBarTwo!.frame = CGRect(x: 10, y: (yPos - 75 - 10) - 75 - 10, width: ScreenWidth - 20, height: 75)
				}
			}
			else if (giftSendBarTwo != nil) && giftSendBarTwo!.frame.origin.y <= yPos && giftSendBarTwo!.frame.origin.y > (yPos - 75 - 10) {
				if yPos - 75 - 10 == giftSendBarOne!.frame.origin.y {
					return
				}
				self.giftSendBarTwo!.frame = CGRect(x: 10, y: yPos - 75 - 10, width: ScreenWidth - 20, height: 75);
			}
		}
	}

	func giftSendBarAppear(_ giftsendbar: GiftSendBar) {
		// 出场动画
		UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1.0, options: UIViewAnimationOptions(), animations: { () -> Void in
			self.adjustGiftSendBar(giftsendbar)
			let yPos: CGFloat = ScreenHeight - 200 - 75 - 10
			giftsendbar.frame = CGRect(x: 10, y: yPos, width: ScreenWidth - 20, height: 75)
			}, completion: { (finished: Bool) -> Void in
			self.perform(#selector(self.giftSendbarAnimation), with: giftsendbar, afterDelay: 1.5)
		})
	}

	func removesendGiftbar(_ notify: Notification) {
		// 通知动画播放结束，重置用户uid以及礼物id
		var dict = (notify as NSNotification).userInfo!
		let gifesendBar = (dict["gifensendbar"] as! GiftSendBar)
		if gifesendBar == giftSendBarOne {
			self.giftSendBarOne = nil
			self.gifsendBarOneUid = 0
			self.gifsendBarOneUid_giftid = 0
		}
		else if gifesendBar == giftSendBarTwo {
			self.giftSendBarTwo = nil
			self.gifsendBarTWoUid = 0
			self.gifsendBarTWoUid_giftid = 0
		}
		else if gifesendBar == giftSendBarThree {
			self.giftSendBarThree = nil
			self.gifsendBarThreeUid = 0
			self.gifsendBarTWoUid_giftid = 0
		}
		self.giftAnimationSHow();
	}
}
