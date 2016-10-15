//
//  RMessages.swift
//  TVideo
//
//  Created by 张新华 on 16/6/1.
//  Copyright © 2016年 张新华. All rights reserved.
//

import Foundation
import CryptoSwift
import TAmf3Socket
class r_msg_noBody: R_msg_base {

}
func decodeAES(_ data: String, aesKey: String = "hg%43*&^56ig$g38") -> String {
	let IV: String = "0102030405060708";
	let resut = try! data.decryptBase64ToString(cipher: AES(key: aesKey, iv: IV));
	return resut;
}

class r_msg_10000: r_msg_noBody {
	var data: String;
	var aesKey: String;

	init(_data: String, _aesKey: String)
	{
		data = _data;
		aesKey = _aesKey;
		// aesKey="1464762374145000";
	}

	func getAesk() -> String {
		let IV: String = "0102030405060708";
		let myData = data.data(using: .utf8);
		let base64String: String = try! (myData?.encrypt(cipher: AES(key: aesKey, iv: IV)).base64EncodedString())!;
		return base64String;
	}

}
