
import Foundation

class Utility {

	class func emotionStr(with text: String, faceDataList: [FaceData], y: CGFloat) -> NSMutableAttributedString {

		// 1、创建一个可变的属性字符串
		let attributeString = NSMutableAttributedString(string: text)
		// 2、通过正则表达式来匹配字符串
		// let regex_emoji = "\\{\\/[a-zA-Z0-9\\/\\u{4e00}-\\u{9fa5}]+\\}";
		let regex_emoji = "\\{\\/[0-9]{2}\\}";
		// 匹配表情
		var re: NSRegularExpression?;
		do {
			re = try NSRegularExpression(pattern: regex_emoji, options: .caseInsensitive);
		} catch {
			LogHttp("NSRegularExpression eer=");
		}

		let resultArray = re?.matches(in: text, options: [], range: NSMakeRange(0, text.characters.count));
		// 3、获取所有的表情以及位置
		// 用来存放字典，字典中存储的是图片和图片对应的位置
		var imageArray = [AnyObject]()
		// 根据匹配范围来用图片进行相应的替换
		for match: NSTextCheckingResult in resultArray! {
			// 获取数组元素中得到range
			let range = match.range
			// 获取原字符串中对应的值
			let subStr = text.substring(range.location, range.location + range.length);
			for i in 0..<faceDataList.count {
				if (faceDataList[i].faceName == subStr) {
					// face[i][@"png"]就是我们要加载的图片
					let textAttachment = NSTextAttachment()
					// 给附件添加图片
					let name = faceDataList[i].faceIco;
					textAttachment.image = UIImage.bundleImageName(name);
					// 调整一下图片的位置,如果你的图片偏上或者偏下，调整一下bounds的y值即可
					textAttachment.bounds = CGRect(x: 0, y: y, width: textAttachment.image!.size.width, height: textAttachment.image!.size.height)
					// 把附件转换成可变字符串，用于替换掉源字符串中的表情文字
					let imageStr = NSAttributedString(attachment: textAttachment)
					// 把图片和图片对应的位置存入字典中
					var imageDic = [String: AnyObject](minimumCapacity: 2)
					imageDic["image"] = imageStr
					imageDic["range"] = range as AnyObject?
					// 把字典存入数组中
					imageArray.append(imageDic as AnyObject);
				}
			}
		}
		var i = imageArray.count - 1;
		while i >= 0 {
			// 进行替换
			attributeString.replaceCharacters(in: imageArray[i]["range"] as! NSRange, with: imageArray[i]["image"] as! NSAttributedString);
			i -= 1
		}
		return attributeString;
	}

	class func exchangeString(_ pattenStr: String, withText text: String, imageName: String) -> NSMutableAttributedString {
		// 1、创建一个可变的属性字符串
		let attributeString = NSMutableAttributedString(string: text)
		// 2、匹配字符串
		let re = try! NSRegularExpression(pattern: pattenStr, options: .caseInsensitive);
		// The output below is limited by 1 KB.
		let resultArray = re.matches(in: text, options: [], range: NSMakeRange(0, text.characters.count));
		// 3、获取所有的图片以及位置
		// 用来存放字典，字典中存储的是图片和图片对应的位置
		var imageArray = [AnyObject]() /* capacity: resultArray.count */
		// 根据匹配范围来用图片进行相应的替换
		for match: NSTextCheckingResult in resultArray {
			// 获取数组元素中得到range
			let range = match.range
			// 新建文字附件来存放我们的图片(iOS7才新加的对象)
			let textAttachment = NSTextAttachment()
			// 给附件添加图片
			textAttachment.image! = UIImage.bundleImageName(imageName);
			// 修改一下图片的位置,y为负值，表示向下移动
			textAttachment.bounds = CGRect(x: 0, y: -2, width: textAttachment.image!.size.width, height: textAttachment.image!.size.height)
			// 把附件转换成可变字符串，用于替换掉源字符串中的表情文字
			let imageStr = NSAttributedString(attachment: textAttachment)
			// 把图片和图片对应的位置存入字典中
			var imageDic = [String: AnyObject](minimumCapacity: 2);
			imageDic["image"] = imageStr
			imageDic["range"] = range as AnyObject?;
			// 把字典存入数组中
			imageArray.append(imageDic as AnyObject);
		}
		// 4、从后往前替换，否则会引起位置问题
		var i = imageArray.count - 1;
		while i >= 0 {
			// 进行替换
			attributeString.replaceCharacters(in: imageArray[i]["range"] as! NSRange, with: imageArray[i]["image"] as! NSAttributedString);
			i -= 1
		}
		return attributeString;
	}

}
