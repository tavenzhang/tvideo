
import UIKit
let kContentFontSize: CGFloat = 14.0 // 内容字体大小
let kPadding: CGFloat = 5.0// 控件间隙
let kEdgeInsetsWidth: CGFloat = 20.0 // 内容内边距宽度

class ChatCell: UITableViewCell {

	/** 头像视图 */
	var faceImageView: UIImageView?;
	/** 背景图 */
	var bgButton: UIButton?;
	/** 文字内容视图 */
	var contentLabel: UILabel?;

	var nameLable: UILabel?;

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.initSubViews()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func initSubViews() {
		// 初始化头像视图
//		self.faceImageView = UIImageView(frame: CGRectZero)
//		self.faceImageView!.layer.cornerRadius = 5
//		self.faceImageView!.layer.masksToBounds = true
//		self.faceImageView!.backgroundColor = UIColor.clearColor()
		// [self.contentView addSubview:_faceImageView];
		// 发送名初始化
		self.nameLable = UILabel()
		self.nameLable!.frame = CGRect(x: kPadding, y: kPadding, width: ScreenWidth, height: 20)
		self.nameLable!.font = UIFont.systemFont(ofSize: kContentFontSize)
		self.nameLable!.textColor = UIColor.purple
		self.contentView.addSubview(nameLable!);
		// nameLable ＝ [UILabel alloc]int;
		// 初始化正文视图
		self.bgButton = UIButton(frame: CGRect.zero)
		self.contentView.addSubview(bgButton!)
		// 初始化正文视图
		self.contentLabel = UILabel(frame: CGRect.zero)
		self.contentLabel!.font = UIFont.systemFont(ofSize: kContentFontSize)
		self.contentLabel!.numberOfLines = 0
		bgButton!.addSubview(contentLabel!);
	}

	class func cellWithTableView(_ tableView: UITableView) -> ChatCell {
		let identifier = "chatCell"
		var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ChatCell;
		if cell == nil {
			tableView.register(RankGiftCell.self, forCellReuseIdentifier: identifier);
			cell = ChatCell(style: .default, reuseIdentifier: identifier);
			cell?.backgroundColor = UIColor.clear
			cell?.contentView.backgroundColor = UIColor.clear
		}
		return cell!;
	}

	/** 计算cell 的高度 */
	class func heightOfCellWithMessage(_ message: ChatMessage) -> CGFloat {
		var height: CGFloat = 0
		let textMaxWidth: CGFloat = ScreenWidth - 40 - kPadding * 2
		// 60是消息框体距离右侧或者左侧的距离
		// NSMutableAttributedString *attrStr = [Utility emotionStrWithString:message.content];
		let attrStr = Utility.emotionStr(with: message.content, faceDataList: FaceData.faceDataList, y: -8);
		attrStr.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: kContentFontSize), range: NSMakeRange(0, attrStr.length));

		let textSize = attrStr.boundingRect(with: CGSize(width: textMaxWidth, height: CGFloat(NSIntegerMax)), options: [.usesLineFragmentOrigin], context: nil).size
		height += (textSize.height + kEdgeInsetsWidth + 4);
		return height;
	}

	/** 设置头像的frame和内容 */

	func setFaceFrame() {
//		let width: CGFloat = 40
//		let height: CGFloat = 40
//		if message!.isSender {
//			// 如果是自己发送
//			self.faceImageView!.frame = CGRectMake(ScreenWidth - width - kPadding, 10, width, height);
//		}
//		else {
//			self.faceImageView!.frame = CGRectMake(kPadding, 10, width, height);
//		}
//		if message!.isSender {
//			// self.faceImageView!.image! = UIImage.bundleImageName("header_QQ");
//		}
//		else {
//			// self.faceImageView!.image! = UIImage.bundleImageName("header_wechat");
//		}
	}

	var message: ChatMessage? {
		didSet {
			// 设置头像
			// self.setFaceFrame()
			// 设置内容
			self.setMessageFrame();
		}
	}

	/** 设置文字类型message的cellframe */

	func setMessageFrame() {
		// 1、计算文字的宽高
		let textMaxWidth: CGFloat = self.width - 40 - kPadding * 2
		// 60是消息框体距离右侧或者左侧的距离
		// NSMutableAttributedString *attrStr = [Utility emotionStrWithString:_message.content];
		let attrStr = Utility.emotionStr(with: message!.content, faceDataList: FaceData.faceDataList, y: -3);
		attrStr.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: kContentFontSize), range: NSMakeRange(0, attrStr.length))
		let textSize = attrStr.boundingRect(with: CGSize(width: textMaxWidth, height: 9999999), options: .usesLineFragmentOrigin, context: nil).size
		self.contentLabel!.attributedText = attrStr
		self.contentLabel!.frame = CGRect(x: 0, y: 0, width: textSize.width, height: textSize.height);
		self.contentLabel!.top = self.nameLable!.bottom ;
		self.contentLabel!.left = self.nameLable!.left + 5;
		if ((message?.sendName) != nil) {
			self.nameLable!.text = message!.sendName
		}
		else {
			self.nameLable!.text = ""
		}

	}

}
