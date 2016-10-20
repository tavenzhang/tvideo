//
//  AlertViewUtils.swift
//  TVideoRoom
//
//  Created by  on 16/7/7.
//  Copyright © 2016年 . All rights reserved.
//

import Foundation


/**
 弹出一个按钮的 简单弹出框
 
 - author: taven
 - date: 16-07-07 16:07:55
 */
func showSimplpAlertView(_ ctrol: UIViewController?, tl: String, msg: String, btnHiht: String = "确定", okHandle: alertHanld? = nil) -> Void {

	var uiCtrol = ctrol;
	if (uiCtrol == nil) {
		uiCtrol = UIApplication.shared.keyWindow?.rootViewController;
	}
	let alertCtr = UIAlertController(title: tl, message: msg, preferredStyle: UIAlertControllerStyle.alert)
	let okAction = UIAlertAction(title: btnHiht, style: UIAlertActionStyle.destructive) {
		(action) in
		uiCtrol?.dismiss(animated: false, completion: nil);
		if ((okHandle) != nil)
		{
			okHandle!();
		}
	};
	alertCtr.addAction(okAction);
	uiCtrol?.present(alertCtr, animated: true, completion: nil);
}
/**
 待回调弹出方式
 
 - author: taven
 - date: 16-07-07 16:07:26
 */
func showAlertHandle(_ ctrol: UIViewController?, tl: String, cont: String, okHint: String?, cancelHint: String?, canlHandle: alertHanld?, okHandle: alertHanld?) -> Void {
	var uiCtrol = ctrol;
	if (uiCtrol == nil) {
		uiCtrol = UIApplication.shared.keyWindow?.rootViewController;
	}
	let alertCtr = UIAlertController(title: tl, message: cont, preferredStyle: UIAlertControllerStyle.alert);
	let okAction = UIAlertAction(title: okHint, style: UIAlertActionStyle.destructive) {
		(action) in
		uiCtrol?.dismiss(animated: false, completion: nil);
		if ((okHandle) != nil)
		{
			okHandle!();
		}

	};
	let canelAction = UIAlertAction(title: cancelHint, style: UIAlertActionStyle.destructive) {
		(action) in
		uiCtrol?.dismiss(animated: false, completion: nil);
		if ((canlHandle) != nil)
		{
			canlHandle!();
		}

	};
	alertCtr.addAction(okAction);
	alertCtr.addAction(canelAction);
	uiCtrol?.present(alertCtr, animated: true, completion: nil);
}

func showSimpleInputAlert(_ ctrol: UIViewController?, title: String, placeholder: String, btnName: String, okHandle: sinputAlertHandle? = nil) {
	var uiCtrol = ctrol;
	if (uiCtrol == nil) {
		uiCtrol = UIApplication.shared.keyWindow?.rootViewController;
	}
	let alertCtr = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.alert);
	alertCtr.addTextField() {
		(textF: UITextField) in
		textF.placeholder = placeholder;
		textF.text = "";
	}
	let okAction = UIAlertAction(title: btnName, style: UIAlertActionStyle.cancel) {
		(action) in
		let domain = (alertCtr.textFields![0] as UITextField).text!;
		okHandle?(domain);
		uiCtrol?.dismiss(animated: false, completion: nil);
	};
	alertCtr.addAction(okAction);
	uiCtrol?.present(alertCtr, animated: true, completion: nil);
}

func showLoginlert(_ uiCtrol: UIViewController?, txtName: String, pwd: String, loginHandle: loginAlertHandle? = nil) -> UIAlertController {
	let alertCtr = UIAlertController(title: "login", message: "", preferredStyle: UIAlertControllerStyle.alert);
	alertCtr.addTextField() {
		(textF: UITextField) in
		textF.placeholder = "用户名";
		textF.text = txtName;
	}

	alertCtr.addTextField() {
		(textF: UITextField) in
		textF.placeholder = "密码";
		textF.isSecureTextEntry = true;
		textF.text = pwd;
	}

	let canelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.destructive) {
		(action) in
		uiCtrol?.dismiss(animated: false, completion: nil);

	};
	let okAction = UIAlertAction(title: "登陆", style: UIAlertActionStyle.cancel) {
		(action) in
		let name = (alertCtr.textFields![0] as UITextField).text!;
		let pwd = (alertCtr.textFields![1] as UITextField).text!;
		loginHandle?(name, pwd);
		uiCtrol?.dismiss(animated: false, completion: nil);
	};
	alertCtr.addAction(okAction);
	alertCtr.addAction(canelAction);
	uiCtrol?.present(alertCtr, animated: true, completion: nil);

	return alertCtr;
}
