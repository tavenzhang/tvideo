//
//  InfoView.swift

import UIKit
import SnapKit

class LoginView: UIView {

	var txtName: UILabel?;
	var txtId: UILabel?;
	var txtSex: UILabel?;
	var txtArea: UILabel?;
	var txtMail: UILabel?;
	var txtTitle: UILabel?;
	var moneyTitle: UILabel?;

	var txtLv: UILabel?;
	var imgViewLv: UIImageView?;
	var imgHeadView: UIImageView?;
	var defaultInfo: PersonInfoModel = PersonInfoModel();

	weak var parentViewVC: MyDetailViewController?;
	var reyBtn: UIButton?;
	var logBtn: UIButton?;

	var isLoginSucess: Bool {
		didSet {
			reyBtn?.isHidden = isLoginSucess;
			logBtn?.isHidden = isLoginSucess;
			moneyTitle?.isHidden = !isLoginSucess;
			if (!isLoginSucess)
			{
				resetData();
			}
		}
	}
	override init(frame: CGRect) {
		isLoginSucess = false;
		super.init(frame: frame);
		resetData();
		setup();
	}

	func resetData() {
		defaultInfo.nickname = "你是游客,请先登录~";
		defaultInfo.safemail = "???";
		defaultInfo.sex = NSNumber(value: -1);
		defaultInfo.lv_exp = NSNumber(value: 000000);
		defaultInfo.lv_rich = NSNumber(value: 0);
		defaultInfo.uid = NSNumber(value: 000);
		defaultInfo.points = NSNumber(value: 0);
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setup() -> Void {
		let img = UIImageView(image: UIImage(named: "userBg"));
		img.sizeToFit();
		imgHeadView = UIImageView(image: UIImage(named: "headHolder"));
		img.addSubview(imgHeadView!);
		self.addSubview(img);
		reyBtn = UIButton.BunImgSimple(UIImage(named: "regbtn")!, hightLightImage: nil, target: self, action: #selector(self.clickReg));
		logBtn = UIButton.BunImgSimple(UIImage(named: "loginBtn")!, hightLightImage: nil, target: self, action: #selector(self.clickLogin));
		self.addSubview(reyBtn!);
		self.addSubview(logBtn!)
		let scaleNum: CGFloat = 1.5;
		imgHeadView?.layer.cornerRadius = 20;
		imgHeadView?.layer.masksToBounds = true;
		imgHeadView!.scale(scaleNum, ySclae: scaleNum);
		reyBtn!.scale(scaleNum, ySclae: scaleNum);
		logBtn!.scale(scaleNum, ySclae: scaleNum);

		img.snp.makeConstraints { (make) in
			make.width.equalTo(self.width);
			let h = (self.width / 720) * 267;
			make.height.equalTo(h);
			make.left.equalTo(self.snp.left);
			make.top.equalTo(self.snp.top);
		}
		self.layoutIfNeeded();
		imgHeadView!.snp.makeConstraints { (make) in
			make.centerX.equalTo(img.snp.centerX);
			make.centerY.equalTo(img.snp.centerY).offset(-20);
			make.width.height.equalTo(40);
		}
		reyBtn!.snp.makeConstraints { (make) in
			make.right.equalTo(imgHeadView!.snp.left).offset(2);
			make.top.equalTo(imgHeadView!.snp.bottom).offset(37);
		}
		logBtn!.snp.makeConstraints { (make) in
			make.left.equalTo(imgHeadView!.snp.right).offset(-2);
			make.top.equalTo(imgHeadView!.snp.bottom).offset(37);
		}
		txtName = UILabel.labelSimpleToView(self, 16, UIColor.white);
		img.addSubview(txtName!);
		txtName?.snp.makeConstraints { (make) in
			make.centerX.equalTo(img.centenX);
			make.centerY.equalTo(img.snp.centerY).offset(22);
		}
		moneyTitle = UILabel.labelSimpleToView(self, 12, UIColor.green);
		img.addSubview(moneyTitle!);
		moneyTitle?.snp.makeConstraints({ (make) in
			make.top.equalTo((txtName?.snp.bottom)!).offset(5);
			make.centerX.equalTo(img.centenX);
		})
		moneyTitle?.isHidden = true;
		// 表格信息

		txtId = UILabel.labelSimpleToView(self, 13, UIColor.gray);
		txtSex = UILabel.labelSimpleToView(self, 13, UIColor.gray);

		txtArea = UILabel.labelSimpleToView(self, 13, UIColor.gray);
		txtMail = UILabel.labelSimpleToView(self, 13, UIColor.gray);
		txtTitle = UILabel.labelSimpleToView(self, 13, UIColor.gray);
		txtLv = UILabel.labelSimpleToView(self, 13, UIColor.gray);

		txtId?.snp.makeConstraints { (make) in
			make.top.equalTo (img.snp.bottom).offset(10);
			make.left.equalTo(img.snp.left).offset(10); }
		txtMail?.snp.makeConstraints { (make) in
			make.top.equalTo ((txtId?.snp.bottom)!).offset(10);
			make.left.equalTo((txtId?.snp.left)!);
		}
		txtTitle?.snp.makeConstraints { (make) in
			make.top.equalTo ((txtMail?.snp.bottom)!).offset(10);
			make.left.equalTo((txtMail?.snp.left)!);
		}

		txtSex?.snp.makeConstraints { (make) in
			make.top.equalTo ((txtId?.snp.top)!);
			make.left.equalTo((txtId?.snp.right)!).offset(20);
		}

		txtArea?.snp.makeConstraints { (make) in
			make.top.equalTo ((txtSex?.snp.top)!);
			make.left.equalTo((txtSex?.snp.right)!).offset(20);
		}

		txtLv?.snp.makeConstraints { (make) in
			make.top.equalTo ((txtTitle?.snp.top)!);
			make.left.equalTo((txtId?.snp.left)!);
		}
		imgViewLv = UIImageView();
		self.addSubview(imgViewLv!);
		imgViewLv?.snp.makeConstraints({ (make) in
			make.centerY.equalTo((txtLv?.snp.centerY)!);
			make.left.equalTo((txtLv?.snp.right)!).offset(20);
		})
		updateMyInfo(defaultInfo);
	}

	func crateUILable(_ container: UIView?, _ size: Int = 12, _ color: UIColor = UIColor.colorWithCustom(100, g: 100, b: 100)) -> UILabel {
		let lb: UILabel = UILabel();
		lb.font = UIFont(name: "Arial", size: 12);
		lb.adjustsFontSizeToFitWidth = true;
		lb.textAlignment = NSTextAlignment.left;
		let color = UIColor.colorWithCustom(100, g: 100, b: 100);
		lb.textColor = color;
		if (container != nil)
		{
			container?.addSubview(lb);
		}
		return lb;
	}

	func updateMyInfo(_ info: PersonInfoModel) {
		txtName?.text = info.nickname!;
		txtId?.text = "ID:\(info.uid!)";
		txtArea?.text = "地区:秘密基地"
		txtMail?.text = "邮箱:\(info.safemail!)";
		// txtTitle?.text = "头衔:\(info.titleName!)";
		txtLv?.text = "财富等级: \(info.lv_rich!)     头衔:";
		txtSex?.text = "性别:\(info.sexName)";
		if (info.roled?.intValue == 3)
		{
			imgViewLv!.image = UIImage(named: lvIcoNameGet((info.lv_exp!.int32Value), type: .hostIcoLV));
			imgViewLv!.scale(2, ySclae: 2)
		}
		else {
			imgViewLv!.image = UIImage(named: lvIcoNameGet((info.lv_rich!.int32Value), type: .userIcoLv));
			imgViewLv!.scale(2, ySclae: 2)
		}
		moneyTitle?.text = "余额:\(info.points!.intValue) 钻";
	}

	func clickReg() {
		LogHttp("clickReg");
	}

	func clickLogin() {
		LogHttp("clickLogin");
		var myName = UserDefaults.standard.string(forKey: "login_name");
		var mypwd = UserDefaults.standard.string(forKey: "login_pwd");
		myName = myName == nil ? "" : myName;
		mypwd = mypwd == nil ? "" : mypwd;
		showLoginlert(parentViewVC, txtName: myName!, pwd: mypwd!)
		{ (name, pwd) in
			self.validLogin(name, pwd: pwd);
		}
	}

	func validLogin(_ name: String, pwd: String) -> Void {
		let passStr = encodeStr(pwd);
		let paraList = ["uname": name, "password": passStr, "sCode": "", "v_remember": 0] as [String: Any];
		var _ = HttpTavenService.requestJson(getWWWHttp(HTTP_LOGIN), isGet: false, para: paraList as [String: AnyObject]) { (httpResult) in
			if (httpResult.isSuccess)
			{
				if (httpResult.dataJson?["status"].int! == 1)
				{
					let key = httpResult.dataJson!["msg"].string!;
					DataCenterModel.sharedInstance.roomData.key = key;
					HttpTavenService.requestJson(getWWWHttp(HTTP_GETUSR_INFO), completionHadble: { [weak self](httpResult) in
						let result = deserilObjectWithDictonary(httpResult.dataJson?.dictionaryObject
							as! NSDictionary, cls: LoginModel.classForCoder()) as! LoginModel;
						self?.defaultInfo = result.info!;
						self?.updateMyInfo((self?.defaultInfo)!);
						let imageUrl = NSString(format: HTTP_SMALL_IMAGE as NSString, (self?.defaultInfo.headimg!)!) as String;
						self?.imgHeadView?.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "v2_placeholder_full_size"));
						self?.isLoginSucess = true;
						self?.parentViewVC?.focusModel?.msgNum = (result.myfav?.count)!;
						self?.parentViewVC?.focusModel?.targeData = result.myfav as AnyObject?;
						self?.parentViewVC?.flushTable();
						UserDefaults.standard.set(name, forKey: "login_name");
						UserDefaults.standard.set(pwd, forKey: "login_pwd");
						UserDefaults.standard.synchronize();
						// self?.parentViewVC?.privateMail?.msgNum = result
					})
					// showAlertHandle(self.myVC!, tl: "", cont: "登陆成功", okHint: "ok", cancelHint: "cancel")
				}
				else {
					showSimplpAlertView(self.parentViewVC!, tl: "登陆失败", msg: "用户名密码错误", btnHiht: "重试", okHandle: {
						[weak self] in
						showLoginlert(self!.parentViewVC!, txtName: "", pwd: "", loginHandle: { (name, pwd) in
							self?.validLogin(name, pwd: pwd);
						})
					})
				}

			}
		}
	}

	func dec2hex(_ num: Int) -> String {
		return String(format: " % 0X", num)
	}

	func encodeStr(_ str: String) -> String {
		var es = [String]();
		var s = str.characters.map { String($0) }
		let lenth = s.count;
		for i in 0 ..< lenth
		{
			let c = s[i];
			var ec = c.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed);
			if (c == ec)
			{
				let ucodeNum = (c as NSString).character(at: 0)
				let st = "00" + dec2hex(Int(ucodeNum));
				ec = st.substring(st.characters.count, -2);
			}
			es.append(ec!);
		}
		let resutStr = es.joined(separator: "");
		let regular = try! NSRegularExpression(pattern: " / % / g", options: .caseInsensitive)
		let nsNew = NSMutableString(string: resutStr);
		regular.replaceMatches(in: nsNew, options: .reportProgress, range: NSMakeRange(0, resutStr.characters.count), withTemplate: "");
		return nsNew as String;

	}
}
