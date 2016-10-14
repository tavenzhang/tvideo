//
//  InfoView.swift

import UIKit
import SnapKit

class InfoView: UIView {

	var myVC: UIViewController?;
	var defaultInfo: MyInfo = MyInfo();
	var txtName: UILabel?;
	var txtId: UILabel?;
	var txtSex: UILabel?;
	var txtArea: UILabel?;
	var txtMail: UILabel?;
	var txtTitle: UILabel?;
	var txtLv: UILabel?;

	override init(frame: CGRect) {
		super.init(frame: frame);
		defaultInfo.niceName = "你是游客,请登录~";
		defaultInfo.email = "???";
		defaultInfo.sex = "?";
		defaultInfo.titleName = "???";
		defaultInfo.nextExp = "?????";
		defaultInfo.area = "???";
		defaultInfo.userId = "???";
		setup()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setup() -> Void {
		let img = UIImageView(image: UIImage(named: "userBg"));
		img.sizeToFit();
		let imgHead = UIImageView(image: UIImage(named: "headHolder"));
		img.addSubview(imgHead);
		self.addSubview(img);
		let reyBtn = UIButton.BunImgSimple(UIImage(named: "regbtn")!, hightLightImage: nil, target: self, action: #selector(self.clickReg));
		let logBtn = UIButton.BunImgSimple(UIImage(named: "loginBtn")!, hightLightImage: nil, target: self, action: #selector(self.clickLogin));
		self.addSubview(reyBtn);
		self.addSubview(logBtn)
		let scaleNum: CGFloat = 1.5;
		imgHead.scale(scaleNum, ySclae: scaleNum);
		reyBtn.scale(scaleNum, ySclae: scaleNum);
		logBtn.scale(scaleNum, ySclae: scaleNum);
		img.snp_makeConstraints { (make) in
			make.width.equalTo(self.width);
			let h = (self.width / 720) * 267;
			make.height.equalTo(h);
		}
		imgHead.snp_makeConstraints { (make) in
			make.center.equalTo(img).offset(CGPoint(x: 0, y: -20));
		}
		reyBtn.snp_makeConstraints { (make) in
			make.right.equalTo(imgHead.snp_left).offset(2);
			make.top.equalTo(imgHead.snp_bottom).offset(23);
		}
		logBtn.snp_makeConstraints { (make) in
			make.left.equalTo(imgHead.snp_right).offset(-2);
			make.top.equalTo(imgHead.snp_bottom).offset(23);
		}

		txtName = UILabel();
		txtName?.textAlignment = NSTextAlignment.Left;
		self.addSubview(txtName!);

		txtId = crateUILable(self);

		txtSex = crateUILable(self);

		txtArea = crateUILable(self);
		txtMail = crateUILable(self);
		txtTitle = crateUILable(self);
		txtLv = crateUILable(self);

		txtName?.snp_makeConstraints { (make) in
			make.top.equalTo(img.snp_bottom).offset(10);
			make.left.equalTo(img.snp_left).offset(10);
		}
		txtId?.snp_makeConstraints { (make) in
			make.top.equalTo ((txtName?.snp_bottom)!).offset(10);
			make.left.equalTo((txtName?.snp_left)!);
		}
		txtMail?.snp_makeConstraints { (make) in
			make.top.equalTo ((txtId?.snp_bottom)!).offset(10);
			make.left.equalTo((txtId?.snp_left)!);
		}
		txtTitle?.snp_makeConstraints { (make) in
			make.top.equalTo ((txtMail?.snp_bottom)!).offset(10);
			make.left.equalTo((txtMail?.snp_left)!);
		}

		txtSex?.snp_makeConstraints { (make) in
			make.top.equalTo ((txtId?.snp_top)!);
			make.left.equalTo((txtId?.snp_right)!).offset(20);
		}

		txtArea?.snp_makeConstraints { (make) in
			make.top.equalTo ((txtSex?.snp_top)!);
			make.left.equalTo((txtSex?.snp_right)!).offset(20);
		}

		txtLv?.snp_makeConstraints { (make) in
			make.top.equalTo ((txtTitle?.snp_top)!);
			make.left.equalTo((txtTitle?.snp_right)!).offset(20);
		}
		updateMyInfo(defaultInfo);
	}

	func crateUILable(container: UIView?) -> UILabel {
		let lb: UILabel = UILabel();
		lb.font = UIFont(name: "Arial", size: 12);
		lb.adjustsFontSizeToFitWidth = true;
		lb.textAlignment = NSTextAlignment.Left;
		let color = UIColor.colorWithCustom(100, g: 100, b: 100);
		lb.textColor = color;
		if (container != nil)
		{
			container?.addSubview(lb);
		}
		return lb;
	}

	func updateMyInfo(info: MyInfo) {
		txtName?.text = info.niceName!;
		txtId?.text = "ID:\(info.userId!)";
		txtArea?.text = "地区:\(info.area!)"
		txtMail?.text = "邮箱:\(info.email!)";
		txtTitle?.text = "头衔:\(info.titleName!)";
		txtLv?.text = "下一级:\(info.nextExp!)";
		txtSex?.text = "性别:\(info.sex!)";
	}

	func clickReg() {
		LogHttp("clickReg");
	}

	func clickLogin() {

		LogHttp("clickLogin");
		showLoginlert(myVC) { (name, pwd) in
			self.validLogin(name, pwd: pwd);
		}
	}

	func validLogin(name: String, pwd: String) -> Void {
		let passStr = encodeStr(pwd);
		let paraList = ["uname": name, "password": passStr, "sCode": "", "v_remember": 0];
		HttpTavenService.requestJson(getWWWHttp(HTTP_LOGIN), isGet: false, para: paraList as? [String: AnyObject]) { (httpResult) in
			if (httpResult.isSuccess)
			{
				if (httpResult.dataJson?["status"].int! == 1)
				{
					let key = httpResult.dataJson!["msg"].string!;
					DataCenterModel.sharedInstance.roomData.key = key;
					showSimplpAlertView(self.myVC!, tl: "登陆成功", msg: "", btnHiht: "确定", okHandle: {
						[weak self] in
						self?.myVC!.tabBarController?.selectedIndex = 0;
					});
//					HttpTavenService.requestJson(getWWWHttp(HTTP_GETUSR_INFO), completionHadble: { (httpResult) in
//						LogHttp("get info");
//					})
				}
				else {
					showSimplpAlertView(self.myVC!, tl: "登陆失败", msg: "用户名密码错误", btnHiht: "重试", okHandle: {
						[weak self] in
						showLoginlert(self!.myVC!) { (name, pwd) in
							self?.validLogin(name, pwd: pwd);
						}
					})
				}

			}
		}
	}

	func dec2hex(num: Int) -> String {
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
			if (c == ec)
			{
				let ucodeNum = (c as NSString).characterAtIndex(0)
				let st = "00" + dec2hex(Int(ucodeNum));
				ec = st.substring(-2, st.characters.count);
			}
			es.append(ec!);
		}
		let resutStr = es.joinWithSeparator("");
		let regular = try! NSRegularExpression(pattern: "/%/g", options: .CaseInsensitive)
		let nsNew = NSMutableString(string: resutStr);
		regular.replaceMatchesInString(nsNew, options: .ReportProgress, range: NSMakeRange(0, resutStr.characters.count), withTemplate: "");
		return nsNew as String;

	}
}
