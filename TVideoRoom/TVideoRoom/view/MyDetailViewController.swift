//
//  MyDetailView.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/6/26.
//  Copyright © 2016年 张新华. All rights reserved.
//

import UIKit

class MyDetailViewController: BaseUIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
    }
    
    override func viewDidAppear(animated: Bool) {
        showLoginlert(self) { (name, pwd) in
            self.validLogin(name,pwd:pwd);
        }
    }
    
    func validLogin(name:String,pwd:String)->Void {
        let passStr = encodeStr(pwd);
        let paraList = ["uname":name,"password":passStr, "sCode": "", "v_remember": 0];
        
        HttpTavenService.requestJson(HTTP_LOGIN, isGet: false, para: paraList as? [String : AnyObject]) { (httpResult) in
            if(httpResult.isSuccess)
            {
                if( httpResult.dataJson?["status"].int! == 1)
                {
                    let key = httpResult.dataJson!["msg"].string!;
                    DataCenterModel.sharedInstance.roomData.key=key;
                    showSimplpAlertView(self, tl: "登陆成功", msg: "", btnHiht: "确定", okHandle: {
                        [weak self] in
                        self!.tabBarController?.selectedIndex = 0;
                    })
                }
                else{
                    showSimplpAlertView(self, tl: "登陆失败", msg: "用户名密码错误", btnHiht: "重试", okHandle: {
                        [weak self] in
                        showLoginlert(self) { (name, pwd) in
                            self!.validLogin(name,pwd:pwd);
                        }
                    })
                }
          
                
            }
        }
    }
    
    
    func dec2hex(num:Int) -> String {
        return String(format: "%0X", num)
    }
    
    func encodeStr(str: String) -> String {
        var es = [String]();
        var s = str.characters.map { String($0) }
        let lenth = s.count;
        for i in 0 ..< lenth
        {
            let c = s[i];
            var ec = c.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet());
            if(c == ec)
            {
                let ucodeNum = (c as NSString).characterAtIndex(0)
                let st="00"+dec2hex(Int(ucodeNum));
                ec = st.substring(-2, st.characters.count);
            }
            es.append(ec!);
        }
        let resutStr = es.joinWithSeparator("");
        let regular = try! NSRegularExpression(pattern:  "/%/g", options: .CaseInsensitive)
        let nsNew = NSMutableString(string: resutStr);
        regular.replaceMatchesInString(nsNew, options: .ReportProgress, range: NSMakeRange(0, resutStr.characters.count), withTemplate: "");
        return nsNew as String;
        
}


}