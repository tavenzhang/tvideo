//
//  As3MsgFactory.swift
//  TVideo
//
//  Created by 张新华 on 16/5/31.
//  Copyright © 2016年 张新华. All rights reserved.
//

import Foundation
import SwiftyJSON
import TAmf3Socket
import NSLogger
import TRtmpPlay
import TChat
var streamThread: NSThread?;
class AMF3MsgControl:NSObject {

    let dataCenterM: DataCenterModel;

    internal static let sharedInstance = AMF3MsgControl()

    private override init() {
        dataCenterM = DataCenterModel.sharedInstance;
    }
    
//    @objc func chooseRtmp(notification:NSNotification){
//           let path = notification.object as! String;
//        if(streamThread != nil) {
//            LogSocket("streamThread=%@", args: (streamThread?.name)!);
//          //  streamThread?.performSelector(Selector("sendRrtmp"), withObject: path);
//        }
//    }
//    
//    @objc func sendRrtmp(path:String){
//        let msg2001 = s_msg_20001(cmd: MSG_20001,rtmpStr: path);
//        let socketManger = SocketManager.sharedInstance.amf3SocketManger;
//        socketManger.sendMessage(msg2001);
//    }

    /**
     socket 消息处理中心
     
     - author: taven
     - date: 16-06-28 13:06:49
     
     - parameter message: <#message description#>
     */
//    func handleMessage(message: NSObject) -> Void {
//        let socketManger = SocketManager.sharedInstance.amf3SocketManger!;
//        let json = JSON(message);
//        let cmd = json["cmd"].int!;
//        if((streamThread == nil))
//        {
//            streamThread = NSThread.currentThread();
//            //NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(AMF3MsgControl.chooseRtmp), name: E_SOCKERT_2001, object: nil)
//        }
//       // NSLog("reve:<--cmd=%d---%s", cmd,json);
//        LogSocket("reve:<--cmd=%d---%@",args: cmd,json.description);
//       // print("reve:<--cmd=\(cmd)---\(json)")
//        switch cmd {
//        case MSG_10000://登陆验证
//            dataCenterM.roomData!.aeskey = json["limit"].string!;
//            socketManger.setStartHeart(true);
//            let r_msg = r_msg_10000(_data: (dataCenterM.roomData!.key + String(dataCenterM.roomData!.roomId) + "jugg123"), _aesKey: dataCenterM.roomData!.aeskey);
//            let s_msge = s_msg_10001(cmd: MSG_10001, _roomId: dataCenterM.roomData!.roomId, _pass: dataCenterM.roomData!.pass, _roomLimit: r_msg.getAesk(), _isPublish: dataCenterM.roomData!.isPublish, _publishUrl: dataCenterM.roomData!.publishUrl, _sid: dataCenterM.roomData!.sid, _key: dataCenterM.roomData!.key);
//            socketManger.sendMessage(s_msge);
//        case MSG_10002://进入房间
//            let s_8002 = s_msg_noBody(_cmd: MSG_80002);
//            socketManger.sendMessage(s_8002);
//            break
//        case MSG_80002://获取到播放列表
//            let rtmpListStr = json["userrtmp"].string;
//            if (rtmpListStr != "") {
//                let rtmpList = rtmpListStr?.componentsSeparatedByString(",");
//                var resultIpList = [String]();
//                for item in rtmpList! {
//                    let str = item.componentsSeparatedByString("@@")[0];
//
//                    if (str as NSString).containsString("rtmp") {
//                        resultIpList.append(str);
//                    }
//                }
//                let queue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
//                var index=0;
//                if (resultIpList.count > 0) {
//                    for item2 in resultIpList {
//                         index+=1;
//                        dispatch_async(queue) {
//                            let ret = KxMovieViewController.testRtmpConnect(item2);
//                                 print("test connection----ret=\(ret)====item=\(item2)")
//                            if (ret > 0) {
//                                self.dataCenterM.roomData?.rtmpList.append(item2);
//                
//                                if(self.dataCenterM.roomData?.rtmpList.count==1){
//                                    
//                                dispatch_async(dispatch_get_main_queue()){
//                                   let msg2001 = s_msg_20001(cmd: MSG_20001,rtmpStr: item2);
//                                    socketManger.sendMessage(msg2001);
//    
//                                }
//                              }
//                            }
//                        }
//                    }
//                }
//            }
//            break;
//        case MSG_20001:
//            var itemInfo = json["items"][0];
//            if(itemInfo != nil)
//            {
//                dataCenterM.roomData?.lastRtmp = itemInfo["rtmp"].string!;
//                dataCenterM.roomData?.sid = itemInfo["sid"].string!;
//                let rtmpPath =  (dataCenterM.roomData?.lastRtmp)!+"/"+(dataCenterM.roomData?.sid)!;
//                NSNotificationCenter.defaultCenter().postNotificationName(RTMP_START_PLAY, object: rtmpPath);
//            }
//            else{
//                  NSNotificationCenter.defaultCenter().postNotificationName(RTMP_START_PLAY, object: "");
//            }
//            break;
//        case MSG_500: //break
//          //  var info = json["msg"].string
//            break;
//        case MSG_11002:
//            if(json["richLv"].int>=2)
//            {
//                var msgVo:ChatMessage?;
//                msgVo=ChatMessage();
//                msgVo?.sendName = "欢迎 ["+json["name"].string!+"] 进入直播间!";
//                msgVo?.content = "";
//                msgVo?.isSender = false;
//                msgVo?.messageType = MessageTypeText;
//                NSNotificationCenter.defaultCenter().postNotificationName(E_SOCKERT_Chat_30001, object: msgVo!);
//            }
//            break
//            
//        case MSG_30001:
//            let type=json["type"].int;
//            var msgVo:ChatMessage?;
//            var semdName = json["sendName"].string!+":";
//            switch type! {
//            case 8:
//                break;
//            case 3:
//                semdName = "[系统消息]"
//                fallthrough
//            case 6:
//                semdName = "[系统消息]"
//                fallthrough
//            default:
//                msgVo=ChatMessage();
//                msgVo?.sendName = semdName;
//                msgVo?.content = json["content"].string;
//                msgVo?.isSender = false;
//                msgVo?.messageType = MessageTypeText;
//            }
//            if((msgVo) != nil)
//            {
//                 NSNotificationCenter.defaultCenter().postNotificationName(E_SOCKERT_Chat_30001, object: msgVo!);
//            }
//            
//        default:
//            break
//                //print("222");
//        }
//
//    }


}