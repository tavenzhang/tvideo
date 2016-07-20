//
//  Amf3Socket.swift
//  TVideo
//
//  Created by 张新华 on 16/5/31.
//  Copyright © 2016年 张新华. All rights reserved.
//

import Foundation
import TNetServer

class SocketManager {

    internal static let sharedInstance = SocketManager()
    //消息处理函数
    var amf3SocketManger:Amf3SocketManager?;
  
    private  init() {
         amf3SocketManger = Amf3SocketManager()
         amf3SocketManger!.regMessageHandle(AMF3MsgControl.sharedInstance.handleMessage);
        addNotification();
        amf3SocketManger!.regLog(self.socketlog);
    }
    
    func socketlog(log:String) -> Void {
        LogSocket("%@",args: log);
    }
    //开启socket 连接
    func startConnectSocket(host:String,mport:Int,timeOut:NSTimeInterval=0)->Void
    {
        amf3SocketManger!.startConnectSocket(host, port: mport, timeOut: timeOut);
    }
    
    //关闭socket 连接
    func closeSocket()->Void
    {
        amf3SocketManger!.closeSocket();
    }
    
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    func sendMessage(message:S_msg_base) -> Void {
        amf3SocketManger!.sendMessage(message);
    }
    
    func addNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SocketManager.onSocketConnect), name: NOTICE_SOCKET_CONNECT_SUCCESS, object: nil)
    }
    
    // 成功连接后开始 10000消息
    @objc func onSocketConnect()  {
        sendMessage(TNetServer.S_msg_base(_cmd: 10000));
    }

}