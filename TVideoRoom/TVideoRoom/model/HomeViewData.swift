//
//  HomeViewData.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/6/27.
//  Copyright © 2016年 张新华. All rights reserved.
//

import Foundation
import UIKit

/// 房间内具体信息
class RoomData: NSObject {
    var socketList:[String]?=["117.27.250.50:9015","117.27.250.83:9015","222.161.187.171:9015","14.29.50.69:9015","183.131.213.175:9015","116.31.99.233:9015"];
    var socketIp:String="116.31.99.233";
    var port:Int = 9007;
    var sid:String = "";
    var lastRtmp="";
    var roomId:Int = 1593972
    var pass:String="";
    var isPublish = false;
    var publishUrl="";
    var key = "2lhppu074j7atof7kd4562u5p0";
    var aeskey = "";
    var rtmpList=[String!]();
    
    var rtmpPath:String{
        get{
            return lastRtmp+"/"+sid;
        }
    }

}


class HomeData: NSObject {
    var AdList: [Activity]?
    var icons: [Activity]?
    var hotList: [Activity]?
    var tuijianList: [Activity]?

}

class Activity:BaseDeSerialsModel {
    var headimg:String?;
    var live_time:String?;
    var username:String? ;
    var uid:NSNumber?;
    var live_status:NSNumber?;
    var img:String?{
        get{
            return headimg;
        }
        set{
            headimg = newValue;
        }
    }
    
    var hostImg:String?{
        //var str= /video_gs/video/img/get_cover?uid=1842653&v=1466860291999
        if ((headimg! as NSString).containsString("&v=")){
            var tempArr = self.headimg?.componentsSeparatedByString("&v=");
            let newStr = String(format: "http://p1.1room1.co/public/images/anchorimg/%@.jpg", (String(uid!) + "_"+String(tempArr![1])));
            return newStr;
        }
        else{
            return self.headimg!
        }
    }
}