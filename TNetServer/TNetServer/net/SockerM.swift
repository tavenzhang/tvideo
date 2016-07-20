//  Created by 张新华 on 16/5/30.
//  Copyright © 2016年 张新华. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

public typealias SockeLogBlock = (log:String) -> Void

var scokeLogBlock:SockeLogBlock?=nil;


func TLog(cont:String,args: CVarArgType...) -> Void {
    if((scokeLogBlock) != nil)
    {
        var  log = NSString(format: cont, arguments: getVaList(args));
        scokeLogBlock!(log: log as String);
    }
}


class Tsocker:AsyncSocket{
    
    static var socket:AsyncSocket?=nil;
    
    static func shareSocket()->AsyncSocket
    {
        if socket==nil
        {
            socket = AsyncSocket();
        }
        return socket!;
    }
}


public class  TSocketMangager{
    //心跳间隔
    var heartTimeDim:Double = 10;
    //消息头长度
    var headLenth = 2;
    var  buffMutableData:NSMutableData;
    
    var hearTime:NSTimer?=nil
    var socket:Tsocker?=nil;
    var isReadingMsgLen:Bool = false;
    var curAmfMsgLen = 0;
    var _host:String="";
    var _port:Int = 0;
    var _timeOut:NSTimeInterval = NSTimeInterval(0);
    
    public init()
    {
        
        buffMutableData = NSMutableData();
        socket = Tsocker(delegate:self);
        self.socket?.setRunLoopModes([NSRunLoopCommonModes]);
    }
    
    deinit{
        hearTime?.invalidate();
    }
    
    public func regLog(block:SockeLogBlock){
        scokeLogBlock = block;
        
    }
    public func setHeartAndHead(heartTime:Double,msgLen:Int)
    {
        heartTimeDim = heartTime;
        headLenth = msgLen;
    }
    
    public   func startConnectSocket(host:String,port:Int,timeOut:NSTimeInterval=0)->Void
    {
        
        _host = host;
        _port = port;
        _timeOut = timeOut;
        if socket!.isConnected() == false
        {
            do{
                if timeOut > 0 {
                    try socket!.connectToHost(host, onPort: UInt16(port), withTimeout: timeOut)
                    
                }
                else{
                    try socket!.connectToHost(host, onPort: UInt16(port));
                }
                
            } catch {
                TLog("startConnectSocket connect went wrong!")
            }
        }
        else{
            closeSocket();
            startConnectSocket(host,port: port,timeOut: _timeOut);
        }
        TLog("startConnectSocket =%@", args: NSThread.currentThread().name!);
    }
    
    
    @objc public func closeSocket()
    {
        TLog("closeSocket")
        if socket!.isConnected()
        {
            socket!.disconnect();
        }
    }
    //重新连接
    public func reConnect() -> Void {
        startConnectSocket(_host,port: _port,timeOut: _timeOut);
    }
    
    //send message
    //  public func sendMessage(message:String){
    //        let data = message.dataUsingEncoding(NSUTF8StringEncoding)
    //        self.socket?.writeData(data, withTimeout: 1, tag: 1)
    //    }
    
    public func getHeartTime() -> Double {
        return heartTimeDim;
    }
    
    public func getHeadLength() -> Int {
        return headLenth;
    }
    
    // 心跳包监测连接
    @objc public func heartMessageSend() {
        // 向服务器发送固定可是的消息，来检测长连接
        TLog("heartMessageSend");
        let longConnect = "connect is here";
        let data  = longConnect.dataUsingEncoding(NSUTF8StringEncoding);
        self.socket?.writeData(data, withTimeout: 1, tag: 1)
    }
}

extension TSocketMangager:AsyncSocketDelegate{
    
    @objc public func onSocket(sock: AsyncSocket!, didConnectToHost host: String!, port: UInt16)
    {
        TLog("host=%@-port=%d  connect Successful!",args: host,port);
        if self.hearTime == nil {
            hearTime = NSTimer.init(timeInterval: self.getHeartTime(), target: self, selector:#selector(TSocketMangager.heartMessageSend), userInfo: nil, repeats: true);
            NSRunLoop.currentRunLoop().addTimer(self.hearTime!, forMode: NSRunLoopCommonModes)
            hearTime?.fire();
        }
        NSNotificationCenter.defaultCenter().postNotificationName(NOTICE_SOCKET_CONNECT_SUCCESS, object: nil);
        self.socket?.readDataWithTimeout(NSTimeInterval(-1), buffer: buffMutableData, bufferOffset:UInt (buffMutableData.length), tag: 9);
    }
    //可以通过sock.userData 来区分是由于什么原因断线
    @objc  public func onSocketDidDisconnect(sock: AsyncSocket!) {
        NSNotificationCenter.defaultCenter().postNotificationName(NOTICE_SOCKET_DISCONNECT, object: nil);
        //            if (sock.userData ==  SocketOfflineByServer) {
        //                // 服务器掉线，重连
        //                self.startConnectSocket();
        //            }
        //            else if (sock.userData == SocketOfflineByUser) {
        //
        //                // 如果由用户断开，不进行重连
        //                return;
        //            }else if (sock.userData == SocketOfflineByWifiCut) {
        //
        //                // wifi断开，不进行重连
        //                return;
        //            }
    }
    //socket 即将断开
    @objc public func onSocket(sock: AsyncSocket!, willDisconnectWithError err: NSError!){
        //wifi 断开 即将断开时触发
        if(sock.unreadData().length>0)
        {
            self.onSocket(sock, didReadData: sock.unreadData(), withTag: 0);
        }
        else{
            let errOp:NSError? = err;
            if(errOp != nil && errOp!.code == 57){
                //   socket?.setUserData(<#T##userData: Int##Int#>)
                //socket!.unreadData;
            }
        }
        TLog("willDisconnectWithError event error  beafor ----onSocketDidDisconnect!");
    }
    
    
    //socket 发送数据成功后
    @objc public func onSocket(sock: AsyncSocket!, didWriteDataWithTag tag: Int){
        TLog("发送成功b uffData.length--%d",args:buffMutableData.length);
        
        
    }
    
    //socket  接受到数据后 这里是处理数据的关键
    @objc public func onSocket(sock: AsyncSocket!, didReadData data: NSData!, withTag tag: Int){
        //        self.socket?.readDataWithTimeout(NSTimeInterval(1), buffer: buffData, bufferOffset: UInt(buffData.length), maxLength: UInt(data.length), tag: 6);
        
        //            print("messagId==\(messagId)-- msg2===\(messagId2)--buffMutableData.length==\(buffMutableData.length)")
    }
    
    
}
