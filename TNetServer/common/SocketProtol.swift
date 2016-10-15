
// Created by 张新华 on 16/5/30.
//  Copyright © 2016年 张新华. All rights reserved.

 protocol netSocketProtol {
    
    func readMsgHead(_ data: NSMutableData) -> Int;
    
    func readMsgBody(_ data: NSMutableData) -> Bool;
    
    func sendHeartMsg() -> Void;
    
    func sendMessage(_ msgData: AnyObject?) -> Void;

}

 protocol netWebSocketProtol {
    
    func onOpen(_ para: AnyObject,sucessHandle:connectSucessHandle?) -> Void;
    
    func onMessageReceive(_ data: AnyObject) -> Void;
    
    func onSendMessage(_ msgData: AnyObject?) -> Void;
}

public typealias connectSucessHandle = () -> Void

public typealias SockeLogBlock = (_ log: String) -> Void

public typealias messageDictionaryBlock = (_ msgKey:AnyObject) -> AnyObject

public typealias messageResultHandleBlock = (_ mesage: AnyObject) -> Void




