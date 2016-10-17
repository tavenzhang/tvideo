//
//  Amf3Socket.swift
//  TVideo

import BBSZLib

open class Amf3SocketManager: TSocketGCDServer {

	/**
	 解析消息头
	 */
	override open func readMsgHead(_ data: NSMutableData) -> Int {
		let len = data.getShort(_isByteBigEndian)
		return len ;
	}

	// 解析消息体
	override open func readMsgBody(_ data: NSMutableData) -> Bool {
		var objNSData: Data?
		do {
			objNSData = try data.getBytesByLength(curMsgBodyLength).bbs_dataByInflating();
		} catch {
			TLog("bbs_dataByInflating error");
			return false;
		}
		var amf3Unarchiver: AMFUnarchiver?;
		if (objNSData!.count > 0)
		{

			amf3Unarchiver = AMFUnarchiver(forReadingWith: objNSData, encoding: kAMF3Encoding);
			var obj: NSObject?;
			if (amf3Unarchiver != nil)
			{
				obj = amf3Unarchiver!.decodeObject();
			}

			if self.onMsgResultHandle != nil && obj != nil
			{
				self.onMsgResultHandle!(obj!);
			}
		}
		return true;
	}

	/**
	 发送消息
	 */
	override open func sendMessage(_ msgData: AnyObject?) -> Void {

		let message = msgData as! S_msg_base;
		do {
			let amf3 = AMF3Archiver()
			let dic = message.toDictionary()
			TLog("send:--->%@", args: dic);
			amf3.encode(dic);
			let amfData = try amf3.archiverData().bbs_dataByDeflating();
			let mdata = NSMutableData(data: amfData);
			mdata.appendString("\r\n");
			self.socket?.write(mdata as Data, withTimeout: 1, tag: 1);
		}
		catch {
			TLog("message send error!");
		}
	}

	/**
	 心跳包消息
	 - author: taven
	 - date: 16-07-13 13:07:32
	 */
	override open func sendHeartMsg() -> Void {

		super.sendHeartMsg();

	}

}
