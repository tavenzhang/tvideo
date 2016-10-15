//
//  NSMudatableDataExtension.swift
//  TVideo
//
//  Created by 张新华 on 16/5/31.
//  Copyright © 2016年 张新华. All rights reserved.

import Foundation

//对于需要在网络传输中传输负数的情况需要先把负数的Int转换为无符号的整数UInt.在计算机中,负数的表示方法是采用补码的形式.在swift中,可以使用UInt32(bitPattern:Int32)以及Int32(bitPattern:UInt32)方法来相互的转换.比如,-5转换为无符号的补码形式为:fffffffb
public extension NSMutableData {
	public var isNativeBigEndian: Bool { return NSHostByteOrder() == NS_BigEndian }

	// 整型
	public func appendShort(_ value: Int, isBigEndian: Bool = true) {
		let networkOrderVal = UInt16(value);
		var data = isBigEndian ? networkOrderVal.bigEndian : networkOrderVal.littleEndian;
		self.append(&data, length: MemoryLayout<UInt16>.size);
	}

	public func appendInt(_ value: Int, isBigEndian: Bool = true) {
		let networkOrderVal = UInt32(value)
		var data = isBigEndian ? networkOrderVal.bigEndian : networkOrderVal.littleEndian;
		self.append(&data, length: MemoryLayout<UInt32>.size);
	}

	public func appendUInt64(_ value: Int, isBigEndian: Bool = true) {
		let networkOrderVal = UInt64(value)
		var data = isBigEndian ? networkOrderVal.bigEndian : networkOrderVal.littleEndian;
		self.append(&data, length: MemoryLayout<UInt64>.size);
	}

	public func getShort(_ isBigEndian: Bool = true) -> Int {
		let range: NSRange = NSRange(location: 0, length: MemoryLayout<UInt16>.size)
		var val: UInt16 = 0
		self.getBytes(&val, range: range);
		self.replaceBytes(in: range, withBytes: nil, length: 0)
		return isBigEndian ? Int(val.bigEndian) : Int(val.littleEndian);
	}

	public func getInt32(_ isBigEndian: Bool = true) -> Int {
		var val: Int32 = 0
		let range = NSRange(location: 0, length: MemoryLayout<Int32>.size);
		self.getBytes(&val, range: range)
		self.replaceBytes(in: range, withBytes: nil, length: 0)
		return isBigEndian ? Int(val.bigEndian) : Int(val.littleEndian);
	}

	public func getUInt32(_ isBigEndian: Bool = true) -> Int {
		var val: UInt32 = 0
		let range = NSRange(location: 0, length: MemoryLayout<UInt32>.size);
		self.getBytes(&val, range: range)
		self.replaceBytes(in: range, withBytes: nil, length: 0)
		return isBigEndian ? Int(val.bigEndian) : Int(val.littleEndian);
	}

	public func getUInt64(_ isBigEndian: Bool = true) -> UInt64 {
		let range: NSRange = NSRange(location: 0, length: MemoryLayout<UInt64>.size)
		var val: UInt64 = 0
		self.getBytes(&val, range: range)
		self.replaceBytes(in: range, withBytes: nil, length: 0)
		return isBigEndian ? val.bigEndian : val.littleEndian
	}

	// 浮点型 fload 4 字节
	public func appendFloat(_ value: Float, isBigEndian: Bool = true) {

		if ((isBigEndian && (!isNativeBigEndian)) || (!isBigEndian && isNativeBigEndian))
		{
			var networkOrderVal = CFConvertFloat32HostToSwapped(Float32(value))
			self.append(&networkOrderVal, length: MemoryLayout<Float32>.size);
		}
		else {
			var data = value;
			self.append(&data, length: MemoryLayout<Float32>.size)
		}

	}
	// 浮点型 double 8 字节
	public func appendDouble(_ value: Double, isBigEndian: Bool = true) {
		if ((isBigEndian && (!isNativeBigEndian)) || (!isBigEndian && isNativeBigEndian))
		{
			var networkOrderVal = CFConvertFloat64HostToSwapped(Float64(value))
			self.append(&networkOrderVal, length: MemoryLayout<Float64>.size);
		}
		else {
			var data = value;
			self.append(&data, length: MemoryLayout<Float64>.size)
		}
	}

	public func getFloat() -> Float {
		let range: NSRange = NSRange(location: 0, length: MemoryLayout<Float32>.size)
		var val: CFSwappedFloat32 = CFSwappedFloat32(v: 0)
		self.getBytes(&val, range: range)
		let result = CFConvertFloat32SwappedToHost(val)
		self.replaceBytes(in: range, withBytes: nil, length: 0)
		return result;
	}

	public func getDouble() -> Double {
		let range: NSRange = NSRange(location: 0, length: MemoryLayout<Float64>.size)
		var val: CFSwappedFloat64 = CFSwappedFloat64(v: 0)
		self.getBytes(&val, range: range)
		let result = CFConvertFloat64SwappedToHost(val)
		self.replaceBytes(in: range, withBytes: nil, length: 0)
		return result
	}

	// MARK: Bool
	public func appendBool(_ val: Bool) {
		var data = val;
		self.append(&data, length: MemoryLayout<Bool>.size)
	}

	public func getBool() -> Bool {
		let range: NSRange = NSRange(location: 0, length: MemoryLayout<Bool>.size)
		var val: Bool = false
		self.getBytes(&val, range: range)
		self.replaceBytes(in: range, withBytes: nil, length: 0)
		return val
	}

	// MARK: String
	public func appendString(_ val: String, isBigEndian: Bool = true, encoding: String.Encoding = String.Encoding.utf8) {
		// 获取到字节的长度,使用某一种编码
		let pLength: Int = val.lengthOfBytes(using: encoding)

		// 放入字符串的长度
		self.appendInt(pLength, isBigEndian: isBigEndian)

		// 把字符串按照某种编码转化为字节数组
		let data = val.data(using: encoding)

		// 放入NSData中
		self.append(data!);
	}

	enum AppException: Error {
		case empty
		case formatCastStringException
	}

	public func getString(_ isBigEndian: Bool = true, encoding: String.Encoding = String.Encoding.utf8) throws -> String {

		// 先获取到长度
		let len = self.getInt32(isBigEndian);

		let range = NSRange(location: 0, length: len)
		// 找到子字节数组
		let subData = self.subdata(with: range);

		// 直接使用String的构造函数,采用某种编码格式获取字符串
		let resutString = String(data: subData, encoding: encoding)

		// 如果凑不起字符串,就表示数据不正确,那么就抛出异常
		guard resutString != nil else {
			throw AppException.formatCastStringException;
		}
		self.replaceBytes(in: range, withBytes: nil, length: 0)
		// 返回结果
		return resutString!;
	}

	// 截取字节数组
	public func getBytesByLength(_ len: Int, location: Int = 0) -> NSMutableData
	{

		let nsRange = NSRange(location: location, length: len);
		let subData = self.subdata(with: nsRange);
		self.replaceBytes(in: nsRange, withBytes: nil, length: 0);
		let nsMuData = NSMutableData(data: subData);
		return nsMuData;
	}
}

extension String {

	var parseJSONString: AnyObject? {

		let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)

		if let jsonData = data {
			// Will return an object or nil if JSON decoding fails
			return try! JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject?
		} else {
			// Lossless conversion of the string was not possible
			return nil
		}
	}
}
