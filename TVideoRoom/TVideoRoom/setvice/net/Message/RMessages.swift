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
		// var aes3=RNCryptor.EncryptorV3
		let IV: String = "0102030405060708";
		// let encrypted = try! input.encrypt(AES(key: aesKey, iv:IV))
		// let input: [UInt8] = [0,1,2,3,4,5,6,7,8,9]
		// input.encrypt(AES(key: "secret0key000000", iv:"0123456789012345", blockMode: .CBC));
		let base64String: String = try! data.encrypt(cipher: AES(key: aesKey, iv: IV)).toBase64();
		return base64String;
	}

}
