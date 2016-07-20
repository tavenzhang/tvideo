//
//  Amf3Socket.swift
//  TVideo
//
//  Created by 张新华 on 16/5/31.
//  Copyright © 2016年 张新华. All rights reserved.
//

import Foundation
import CocoaAsyncSocket
import BBSZLib

public class Amf3SocketManager: TSocketMangager {
    
    //消息处理函数
    public var messageHandle:((mesage:NSObject)->Void)?;
    var isStartHeat:Bool = false;
    // Using NSLock
    let critLock = NSLock()
    public override init()
    {
        super.init()
    }
    
    
    public func regMessageHandle(handle:(mesage:NSObject)->Void){
        self.messageHandle = handle;
    }
    
    let hertMessage = S_msg_heart_9999(_cmd: 9999);
    
    
    @objc   public  func sendMessage(message:S_msg_base){
        //critLock.lock()
        do{
            let amf3=AMF3Archiver()
            let dic = message.toDictionary()
            TLog("send:--->%@",args: dic);
            amf3.encodeObject(dic);
            let amfData = try amf3.archiverData().bbs_dataByDeflating() as! NSMutableData;
            amfData.appendString("\r\n");
            self.socket?.writeData(amfData, withTimeout: 1, tag: 1);
        }
        catch{
            TLog("message send error!");
        }
        //critLock.unlock();
    }
    
    public func setStartHeart(tag:Bool)
    {
        isStartHeat = tag;
    }
    
    // 心跳包监测连接
    public   override func heartMessageSend() {
        // 向服p务器发送固定可是的消息，来检测长连接
        if(isStartHeat)
        {
            sendMessage(hertMessage);
        }
    }
    
    
    //socket  接收到数据后放到缓存集中处理 这里是处理数据的关键
    override public func onSocket(sock: AsyncSocket!, didReadData data: NSData!, withTag tag: Int){
        TLog("收到数据buffMutableData.length=%d curAmfMsgLen==%d",args:buffMutableData.length,curAmfMsgLen);
        //  critLock.lock();
        while (buffMutableData.length >= self.headLenth)
        {
            
            if curAmfMsgLen <= 0 {
                curAmfMsgLen = buffMutableData.getShort();
                isReadingMsgLen = true
            }
            if(buffMutableData.length<curAmfMsgLen)
            {
                break;
            }
            
            var objNSData:NSData?
            do{
                objNSData = try buffMutableData.getBytesByLength(curAmfMsgLen).bbs_dataByInflating();
                curAmfMsgLen = 0;
            } catch{
                print("bbs_dataByInflating error");
                curAmfMsgLen = 0;
            }
            curAmfMsgLen = 0
            
            var amf3Unarchiver:AMFUnarchiver?;
            if(objNSData!.length>0)
            {
                do{
                    amf3Unarchiver = try AMFUnarchiver(forReadingWithData: objNSData, encoding: kAMF3Encoding);
                }
                catch{
                    print("AMFUnarchiver error");
                }
                var obj:NSObject?;
                if(amf3Unarchiver != nil)
                {
                    obj =  amf3Unarchiver!.decodeObject();
                }
                
                if self.messageHandle != nil &&  obj != nil
                {
                    //这里可以 考虑另外取线程数据 以免阻赛该数据接收线程
                    //  dispatch_async(dispatch_get_main_queue())
                    // {
                    self.messageHandle!(mesage: obj!);
                    // };
                }
            }
        }
        // critLock.unlock();
        
        
        TLog("处理后buffMutableData.length=%d curAmfMsgLen==%d",args:buffMutableData.length,curAmfMsgLen);
        self.socket?.readDataWithTimeout(NSTimeInterval(-1), buffer: buffMutableData, bufferOffset:UInt (buffMutableData.length), tag: 9);
        // self.socket?.readDataWithTimeout(NSTimeInterval(-1), buffer: buffMutableData, bufferOffset:UInt (buffMutableData.length), tag: 9);
    }
    
    
    
}