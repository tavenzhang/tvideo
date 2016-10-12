//
//  ChatModel.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/10/11.
//  Copyright © 2016年 张新华. All rights reserved.
//

import Foundation

enum MessageType: Int {
	case Text
	case Audio
	case Picture
	case Video
}

class ChatMessage: NSObject {
	var content = "";
	var messageType: MessageType = .Text;
	var isSender = false
	var sendName = ""
}

class FaceData: NSObject {
	var faceName = "";
	var faceIco = "";

	static var faceDataList: [FaceData] = {
		var dataList = [FaceData]();
		for i in 1..<44 {
			var sname: String
			var ico: String
			if i < 10 {
				sname = "{/0\(i)}"
				ico = "0\(i)"
			}
			else if i < 44 {
				ico = "\(i)"
				sname = "{/\(i)}"
			}
			else {
				ico = "0\(i)"
				sname = "{/\(i)}"
			}
			var vo = FaceData(faceName: sname, faceIco: ico)
			dataList.append(vo);
		}
		return dataList;
	}()

	init(faceName: String, faceIco: String) {
		super.init()
		self.faceName = faceName;
		self.faceIco = faceIco;
	}

	class func voWithFaceName(faceName: String, faceIco: String) -> FaceData {
		return FaceData(faceName: faceName, faceIco: faceIco);
	}

}

