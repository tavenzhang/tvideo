//
//  GiftEffectVC.swift

import UIKit

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
	var giftSendTimer: NSTimer?;
	// 送礼累计个数
	static var giftCount: UInt32 = 0;

	override init(frame: CGRect) {
		super.init(frame: frame);
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.removesendGiftbar), name: "removegistSendbar", object: nil);
		self.multipleTouchEnabled = false;
		self.userInteractionEnabled = false;
	}
	deinit
	{
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// 添加礼物
	func addEffectGift(gift: GiftInfoModel) {
		gift.selfIconStr = GiftEffectVC.giftCount % 2 == 0 ? "giftHead1" : "giftHead2";
		GiftEffectVC.giftCount = GiftEffectVC.giftCount + 1;
		gift.send_user_id = GiftEffectVC.giftCount;
		giftStructureArray.append(gift);
		if giftSendTimer == nil && giftStructureArray.count > 0 {
			self.giftTimerStart()
		}
	}

	func giftTimerStart() {
		giftSendTimer = NSTimer.scheduledTimerWithTimeInterval(1.25, target: self, selector: #selector(self.giftAnimationSHow), userInfo: nil, repeats: true)
		// 1.65s //2.65
		giftSendTimer!.fire()
	}

	func isAlreadyIsExit() -> Bool {
		var isExit = false
		let giftShowInfoStructure = giftStructureArray[0];
		if (giftShowInfoStructure.send_user_id == gifsendBarOneUid) && (self.giftSendBarOne != nil) && giftSendBarOne!.timer.valid && (gifsendBarOneUid_giftid == giftShowInfoStructure.gift_uid) {
			self.giftSendBarOne?.gifBig = (giftSendBarOne?.gifBig)! + Int64(giftShowInfoStructure.giftCounts);
			if giftSendBarOne?.gifBig >= 11 && (giftSendBarOne?.gifBig)! - 10 > giftSendBarOne!.countAdd {
				self.giftSendBarOne?.countAdd = (giftSendBarOne?.gifBig)! - 10
			}
			isExit = true
		}
		else if (giftShowInfoStructure.send_user_id == gifsendBarTWoUid) && (giftSendBarTwo != nil) && (giftSendBarTwo?.timer.valid)! && (gifsendBarTWoUid_giftid == giftShowInfoStructure.gift_uid)
		{
			self.giftSendBarTwo?.gifBig = (giftSendBarTwo?.gifBig)! + Int64(giftShowInfoStructure.giftCounts)
			if giftSendBarTwo?.gifBig >= 11 && (giftSendBarTwo?.gifBig)! - 10 > giftSendBarTwo!.countAdd {
				self.giftSendBarTwo!.countAdd = giftSendBarTwo!.gifBig - 10
			}
			isExit = true
		}
		else if (giftShowInfoStructure.send_user_id == gifsendBarThreeUid) && (giftSendBarThree != nil) && (giftSendBarThree?.timer.valid)! && gifsendBarThreeUid_giftid == giftShowInfoStructure.gift_uid {
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

	func initGiftSendbarwithtag(tag: Int) {
		// 初始化礼物赠送条
		let giftShowInfoStructure = giftStructureArray[0];
		giftStructureArray.removeAtIndex(0);

		var yPos: CGFloat = 0
		yPos = ScreenHeight - 200 - 75 - 10
		let giftsendbar = GiftSendBar(frame: CGRectMake(10 - ScreenWidth, yPos, ScreenWidth - 20, 75))
		if tag == 0 {
			self.giftSendBarOne = giftsendbar
			self.gifsendBarOneUid = giftShowInfoStructure.send_user_id
			self.gifsendBarOneUid_giftid = giftShowInfoStructure.gift_uid
			self.addSubview(giftSendBarOne!)
		}
		else if tag == 1 {
			self.giftSendBarTwo = giftsendbar
			self.gifsendBarTWoUid = giftShowInfoStructure.send_user_id
			self.gifsendBarTWoUid_giftid = giftShowInfoStructure.gift_uid
			self.addSubview(giftSendBarTwo!)
		}
		else if tag == 2 {
			self.giftSendBarThree = giftsendbar
			self.gifsendBarThreeUid = giftShowInfoStructure.send_user_id
			self.gifsendBarThreeUid_giftid = giftShowInfoStructure.gift_uid
			self.addSubview(giftSendBarThree!)
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
			if giftSendTimer!.valid {
				giftSendTimer!.invalidate()
			}
			giftSendTimer = nil
		}
	}

	func giftSendbarAnimation(giftsendbar: GiftSendBar) {
		// UIView.animationsEnabled = true
		UIView.animateWithDuration(0.7, animations: { () -> Void in
			if self.giftStructureArray.count > 1 {
				self.adjustGiftSendBar(giftsendbar)
			}
			}, completion: { _ in })
	}

	func adjustGiftSendBar(giftsendbar: GiftSendBar) {
		// 向上滚动坐标调整
		let yPos: CGFloat = ScreenHeight - 200 - 75 - 10
		if giftsendbar == giftSendBarTwo {
			if (giftSendBarOne != nil) && giftSendBarOne?.frame.origin.y <= yPos && giftSendBarOne?.frame.origin.y > (yPos - 75 - 10) {
				self.giftSendBarOne!.frame = CGRectMake(10, yPos - 75 - 10, ScreenWidth - 20, 75)
				if (giftSendBarThree != nil) && giftSendBarThree!.frame.origin.y <= (yPos - 75 - 10) && giftSendBarThree!.frame.origin.y > (yPos - 75 - 10 - 75 - 10) {
					self.giftSendBarThree!.frame = CGRectMake(10, (yPos - 75 - 10) - 75 - 10, ScreenWidth - 20, 75)
				}
			}
			else if (giftSendBarThree != nil) && giftSendBarThree!.frame.origin.y <= yPos && giftSendBarThree!.frame.origin.y > (yPos - 75 - 10) {
				if yPos - 75 - 10 == giftSendBarTwo!.frame.origin.y {
					return
				}
				self.giftSendBarThree!.frame = CGRectMake(10, yPos - 75 - 10, ScreenWidth - 20, 75)
			}
		}
		else if (giftsendbar == giftSendBarThree) {
			if (giftSendBarTwo != nil) && yPos <= giftSendBarTwo!.frame.origin.y && giftSendBarTwo!.frame.origin.y > (yPos - 75 - 10) {
				self.giftSendBarTwo!.frame = CGRectMake(10, yPos - 75 - 10, ScreenWidth - 20, 75)
				if (giftSendBarOne != nil) && (yPos - 75 - 10) >= giftSendBarOne!.frame.origin.y && giftSendBarOne!.frame.origin.y > (yPos - 75 - 10 - 75 - 10) {
					self.giftSendBarOne!.frame = CGRectMake(10, yPos - 75 - 10 - 75 - 10, ScreenWidth - 20, 75)
				}
			}
			else if (giftSendBarOne != nil) && yPos >= giftSendBarOne!.frame.origin.y && giftSendBarOne!.frame.origin.y > (yPos - 75 - 10) {
				if yPos - 75 - 10 == giftSendBarThree!.frame.origin.y {
					return
				}
				self.giftSendBarOne!.frame = CGRectMake(10, yPos - 75 - 10, ScreenWidth - 20, 75)
			}
		}
		else if giftsendbar == giftSendBarOne {
			if (giftSendBarThree != nil) && giftSendBarThree!.frame.origin.y <= yPos && giftSendBarThree!.frame.origin.y > (yPos - 75 - 10) {
				self.giftSendBarThree!.frame = CGRectMake(10, yPos - 75 - 10, ScreenWidth - 20, 75)
				if (giftSendBarTwo != nil) && (yPos - 75 - 10) >= giftSendBarThree!.frame.origin.y && giftSendBarThree!.frame.origin.y > (yPos - 75 - 10 - 75 - 10) {
					self.giftSendBarTwo!.frame = CGRectMake(10, (yPos - 75 - 10) - 75 - 10, ScreenWidth - 20, 75)
				}
			}
			else if (giftSendBarTwo != nil) && giftSendBarTwo!.frame.origin.y <= yPos && giftSendBarTwo!.frame.origin.y > (yPos - 75 - 10) {
				if yPos - 75 - 10 == giftSendBarOne!.frame.origin.y {
					return
				}
				self.giftSendBarTwo!.frame = CGRectMake(10, yPos - 75 - 10, ScreenWidth - 20, 75);
			}
		}
	}

	func giftSendBarAppear(giftsendbar: GiftSendBar) {
		// 出场动画
		UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1.0, options: .CurveEaseInOut, animations: { () -> Void in
			self.adjustGiftSendBar(giftsendbar)
			let yPos: CGFloat = ScreenHeight - 200 - 75 - 10
			giftsendbar.frame = CGRectMake(10, yPos, ScreenWidth - 20, 75)
			}, completion: { (finished: Bool) -> Void in
			self.performSelector(#selector(self.giftSendbarAnimation), withObject: giftsendbar, afterDelay: 1.5)
		})
	}

	func removesendGiftbar(notify: NSNotification) {
		// 通知动画播放结束，重置用户uid以及礼物id
		var dict = notify.userInfo!
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