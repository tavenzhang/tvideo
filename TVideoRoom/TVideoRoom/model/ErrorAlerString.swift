//
//  ErrorAlerString.swift
//  TVideoRoom
//
//  Created by  on 16/10/13.
//  Copyright © 2016年 . All rights reserved.
//

import Foundation

class ErrAlertManger {

	static let instance: ErrAlertManger = ErrAlertManger();
	var errorArray = [Int: String]()
	fileprivate init() {
		errorArray[1801] = "被踢的玩家不存在";
		errorArray[1802] = "不能踢管理员";
		errorArray[1803] = "该用户已不在当前房间，操作失败!";
		errorArray[1804] = "贵族不能踢高等级用户";
		errorArray[1805] = "贵族最大踢人次数";
		errorArray[1806] = "被踢用户具有防踢人权限，踢人失败！";
		errorArray[1807] = "普通用户没有禁言权限,请充值贵族并提升您的贵族等级!";
		errorArray[1808] = "禁言次数超过最大次数";
		errorArray[1809] = "贵族不能禁言高等级用户";
		errorArray[1810] = "被禁言用户具有防禁言权限，禁言失败！";
		errorArray[1811] = "普通用户不能踢人！";
		errorArray[1812] = "被禁言人还在禁言当中！";
		errorArray[1813] = "不能禁言管理员！";
		errorArray[1814] = "没有权限,请充值升级你的贵族等级！";
		//
		errorArray[2007] = "您的余额不足，请充值！";
		errorArray[2014] = "直播暂未开始，不能抢座！";
		errorArray[2012] = "您的余额不足，不能抢座！";
		errorArray[2015] = "不能在自己房间内抢座位！";
		errorArray[2102] = "不能超过40个管理员！";
		errorArray[2103] = "直播暂未开始，不能飞屏！";
		errorArray[2116] = "直播暂未开始，不能广播！";
		errorArray[1514] = "只有主播和管理员才能踢人！";
		errorArray[1516] = "不是房主不能踢人！";
		// 抽奖活动
		errorArray[2118] = "抽奖人数不能大于房间用户数";
		errorArray[2117] = "非主播不能发起抽奖";
		errorArray[3] = "参数错误";
		errorArray[1003] = "参数您的当前帐户余额不足,请您充值哦!"; // 送礼物余额不足

		errorArray[1008] = "您已经被主播(或管理员)禁言了．"; // 禁止聊天
		errorArray[1543] = "您被主播(或管理员)踢出该房间，30分钟内不能进入．";
		errorArray[2001] = "进入失败!\n房间密码输入不正确，请重新输入."; // 房间密码错误
		errorArray[2002] = "进入失败!\n您当前余额不足，请您充值后再观看．";
		errorArray[2003] = "进入失败!\n房间已经满员了！";
		errorArray[2004] = "房间免费时间已到！";
		errorArray[2005] = "进入失败！\n该房间限制游客进入！";
		errorArray[2006] = "进入失败！\n该房间为VIP专属区,请开通包月VIP会员再进入，谢谢！";
		errorArray[4001] = "当前身份不能增送贵族礼物,先成为贵族吧!"
	}

	func getDescByError(_ error: Int) -> String {
		var result = errorArray[error] ;

		if (result == nil) || (result == "")
		{
			result = "未知错误！"
		}
		return result!;
	}
}
