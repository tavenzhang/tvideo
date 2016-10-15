//
//  DictModelProtocol.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/6/26.
//  Copyright © 2016年 张新华. All rights reserved.
//

import Foundation

@objc public protocol DictModelProtocol {
	static func customClassMapping() -> [String: String]?
}

///  字典转模型管理器
open class DictModelManager {

	fileprivate static let instance = DictModelManager()
	/// 全局统一访问入口
	open class var sharedManager: DictModelManager {
		return instance
	}

	/// 模型缓冲，[类名: 模型信息字典]
	fileprivate var modelCache = [String: [String: String]]()

	/// 字典转模型
	/// - parameter dict: 数据字典
	/// - parameter cls:  模型类
	///
	/// - returns: 模型对象
	open func objectWithDictionary(_ dict: NSDictionary, _ cls: AnyClass) -> AnyObject? {
		// 动态获取命名空间
		let ns = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
		// 模型信息
		let infoDict = fullModelInfo(cls)

		let obj: AnyObject = (cls as! NSObject.Type).init();

		autoreleasepool {
			// 3. 遍历模型字典
			for (k, v) in infoDict {
				if k == "desc" {
					let newValue = dict["description"] as? String
					obj.setValue(newValue, forKey: "desc")
				}

				if let value: AnyObject = (dict.value(forKey: k) as AnyObject?) {
					// print("value.classForCoder===\(value.classForCoder)-key=\(k) ---value=\(value)---00-\(value === NSNull())------v.isEmpty==\(v.isEmpty)---")
					if v.isEmpty {
						if !(value === NSNull()) {
							// 320:1x  375:2x   414:3x
							if k == "number" && ScreenWidth < 375 {
								if let vav: String = value as? String {
									obj.setValue(Int(vav)!, forKey: k)
								}
							} else {
								obj.setValue(value, forKey: k);
							}
						}

					} else {
						let type = "\(value.classForCoder)"

						if type == "NSDictionary" {

							if let subObj: AnyObject = objectWithDictionary(value as! NSDictionary, NSClassFromString(ns + "." + v)!) {
								obj.setValue(subObj, forKey: k)
							}

						} else if type == "NSArray" {

							if let subObj: AnyObject = objectsWithArray(value as! NSArray, NSClassFromString(ns + "." + v)!) {
								obj.setValue(subObj, forKey: k)
							}
						}
					}
				}
			}
		}

		return obj
	}

	/// 创建自定义对象数组
	///
	/// - parameter NSArray: 字典数组
	/// - parameter cls:     模型类
	///
	/// - returns: 模型数组
	open func objectsWithArray(_ array: NSArray, _ cls: AnyClass) -> NSArray? {

		var list = [AnyObject]()

		autoreleasepool { () -> () in
			for value in array {
				let type = "\((value as AnyObject).classForCoder!)"

				if type == "NSDictionary" {
					if let subObj: AnyObject = objectWithDictionary(value as! NSDictionary, cls) {
						list.append(subObj)
					}
				} else if type == "NSArray" {
					if let subObj: AnyObject = objectsWithArray(value as! NSArray, cls) {
						list.append(subObj)
					}
				}
			}
		}

		if list.count > 0 {
			return list as NSArray?
		} else {
			return nil
		}
	}

	/// 模型转字典
	///
	/// - parameter obj: 模型对象
	///
	/// - returns: 字典信息
	open func objectDictionary(_ obj: AnyObject) -> [String: AnyObject]? {
		// 1. 取出对象模型字典
		let infoDict = fullModelInfo(obj.classForCoder)

		var result = [String: AnyObject]()
		// 2. 遍历字典
		for (k, v) in infoDict {
			var value = obj.value!(forKey: k) as AnyObject?
			if value == nil {
				value = NSNull()
			}

			if v.isEmpty || value === NSNull() {
				result[k] = value
			} else {
				let type = "\(value!.classForCoder)"

				var subValue: AnyObject?
				if type == "NSArray" {
					subValue = objectArray(value! as! [AnyObject]) as AnyObject?
				} else {
					subValue = objectDictionary(value!) as AnyObject?
				}
				if subValue == nil {
					subValue = NSNull()
				}
				result[k] = subValue
			}
		}

		if result.count > 0 {
			return result
		} else {
			return nil
		}
	}

	/// 模型数组转字典数组
	///
	/// - parameter array: 模型数组
	///
	/// - returns: 字典数组
	open func objectArray(_ array: [AnyObject]) -> [AnyObject]? {

		var result = [AnyObject]()

		for value in array {
			let type = "\(value.classForCoder)"

			var subValue: AnyObject?
			if type == "NSArray" {
				subValue = objectArray(value as! [AnyObject]) as AnyObject?
			} else {
				subValue = objectDictionary(value) as AnyObject?
			}
			if subValue != nil {
				result.append(subValue!)
			}
		}

		if result.count > 0 {
			return result
		} else {
			return nil
		}
	}

	// MARK: - 私有函数
	/// 加载完整类信息
	///
	/// - parameter cls: 模型类
	///
	/// - returns: 模型类完整信息
	func fullModelInfo(_ cls: AnyClass) -> [String: String] {

		// print("-------------------\(cls)");
		// print("------------currentCls.superclass()-------\(cls.superclass())");
		// print("000---\(SupermarketResouce.self)")
		// 检测缓冲池
		if let cache = modelCache["\(cls)"] {
			return cache
		}

		var currentCls: AnyClass = cls

		var infoDict = [String: String]()
		while let parent: AnyClass = currentCls.superclass() {
			infoDict.merge(modelInfo(currentCls))
			currentCls = parent
		}

		// 写入缓冲池
		modelCache["\(cls)"] = infoDict

		return infoDict
	}

	/// 加载类信息
	///
	/// - parameter cls: 模型类
	///
	/// - returns: 模型类信息
	func modelInfo(_ cls: AnyClass) -> [String: String] {
		// 检测缓冲池
		if let cache = modelCache["\(cls)"] {
			return cache
		}

		// 拷贝属性列表
		var count: UInt32 = 0
		let properties = class_copyPropertyList(cls, &count)

		// 检查类是否实现了协议
		var mappingDict: [String: String]?;
		if cls.responds(to: Selector("customClassMapping")) {
			mappingDict = cls.customClassMapping()
		}

		var infoDict = [String: String]()
		for i in 0..<count {
			let property = properties?[Int(i)]
			// 属性名称
			let cname = property_getName(property)
			let name = String(cString: cname!)
			// 空合运算
			let type = mappingDict?[name] ?? ""
			// print("name=\(name)----type=\(type)")
			infoDict[name] = type
		}

		free(properties)

		// 写入缓冲池
		modelCache["\(cls)"] = infoDict

		return infoDict
	}

}

extension Dictionary {
	/// 将字典合并到当前字典
	mutating func merge<K, V>(_ dict: [K: V]) {
		for (k, v) in dict {
			self.updateValue(v as! Value, forKey: k as! Key)
		}
	}
}
