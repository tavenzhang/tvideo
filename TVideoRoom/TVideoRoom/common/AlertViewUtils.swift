//
//  AlertViewUtils.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/7/7.
//  Copyright © 2016年 张新华. All rights reserved.
//

import Foundation

typealias alertHanld = ()->Void;
typealias loginAlertHandle = (_ name:String,_ pwd:String)->Void;
/**
 弹出一个按钮的 简单弹出框
 
 - author: taven
 - date: 16-07-07 16:07:55
 */
func showSimplpAlertView(_ uiCtrol:UIViewController?, tl:String,msg:String,btnHiht:String = "确定",okHandle:alertHanld?=nil) -> Void {
    
    let alertCtr = UIAlertController(title: tl, message: msg, preferredStyle: UIAlertControllerStyle.alert)
    let  okAction = UIAlertAction(title: btnHiht, style: UIAlertActionStyle.destructive){
        (action) in
        if((okHandle) != nil)
        {
            okHandle!();
        }
        uiCtrol?.dismiss(animated: false, completion: nil);
    };
    alertCtr.addAction(okAction);
    uiCtrol?.present(alertCtr, animated: true, completion: nil);
}
/**
 待回调弹出方式
 
 - author: taven
 - date: 16-07-07 16:07:26
 */
func showAlertHandle(_ uiCtrol:UIViewController?,tl:String,cont:String,okHint:String?,cancelHint:String?,okHandle:alertHanld?=nil,canlHandle:alertHanld?=nil) -> Void {
    let alertCtr = UIAlertController(title: tl, message: cont, preferredStyle: UIAlertControllerStyle.alert);
    let  okAction = UIAlertAction(title: okHint, style: UIAlertActionStyle.destructive){
        (action) in
        if((okHandle) != nil)
        {
             okHandle!();
        }
        uiCtrol?.dismiss(animated: false, completion: nil);
    };
    let  canelAction = UIAlertAction(title: cancelHint, style: UIAlertActionStyle.destructive){
        (action) in
        if((canlHandle) != nil)
        {
            canlHandle!();
        }
        uiCtrol?.dismiss(animated: false, completion: nil);
    };
    alertCtr.addAction(okAction);
    alertCtr.addAction(canelAction);
       uiCtrol?.present(alertCtr, animated: true, completion: nil);
}


func showLoginlert(_ uiCtrol:UIViewController?,loginHandle:loginAlertHandle?=nil) -> UIAlertController {
        let alertCtr = UIAlertController(title:"login" , message: "", preferredStyle: UIAlertControllerStyle.alert);
        alertCtr.addTextField(){
            (textF:UITextField) in
            textF.placeholder = "用户名";
            textF.text="258333601@163.com"
        }
    
     alertCtr.addTextField(){
        (textF:UITextField) in
        textF.placeholder = "密码";
        textF.isSecureTextEntry=true;
        textF.text="111111"
    }
    
    let  canelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.destructive){
        (action) in
        uiCtrol?.dismiss(animated: false, completion: nil);
      
    };
    let  okAction = UIAlertAction(title: "登陆", style: UIAlertActionStyle.cancel){
        (action) in
        let name=(alertCtr.textFields![0] as UITextField).text!;
        let pwd=(alertCtr.textFields![1] as UITextField).text!;
         loginHandle?(name,pwd);
        uiCtrol?.dismiss(animated: false, completion: nil);
    };
    alertCtr.addAction(okAction);
    alertCtr.addAction(canelAction);
    uiCtrol?.present(alertCtr, animated: true, completion: nil);

    return alertCtr;
}
