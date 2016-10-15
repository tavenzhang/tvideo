//
//  NSLoggerSupport.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/6/22.
//  Copyright © 2016年 张新华. All rights reserved.
//

import NSLogger
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
	switch (lhs, rhs) {
	case let (l?, r?):
		return l < r
	case (nil, _?):
		return true
	default:
		return false
	}
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
	switch (lhs, rhs) {
	case let (l?, r?):
		return l >= r
	default:
		return !(lhs < rhs)
	}
}

var soketQuque = DispatchQueue(label: "socket", attributes: DispatchQueue.Attributes.concurrent);

func LogSocket(_ format: String!, args: CVarArg...) {
	LogMessage_va("socket", 3, format, getVaList(args))
}

func LogHttp(_ format: String!, args: CVarArg...) {
	LogMessage_va("Http", 3, format, getVaList(args))
}
func LogMessageT(_ domain: String!, level: Int32, format: String!, args: CVarArg...) {
	LogMessage_va(domain, level, format, getVaList(args))
}

func LogMessageF(_ filename: UnsafePointer<Int8>, lineNumber: Int32, functionName: UnsafePointer<Int8>, domain: String!, level: Int32, format: String!, args: CVarArg...) {
	LogMessageF_va(filename, lineNumber, functionName, domain, level, format, getVaList(args))
}

func LogMessageTo(_ logger: OpaquePointer, domain: String!, level: Int32, format: String!, args: CVarArg...) {
	LogMessageTo_va(logger, domain, level, format, getVaList(args))
}

func LogMessageToF(_ logger: OpaquePointer, filename: UnsafePointer<Int8>, lineNumber: Int32, functionName: UnsafePointer<Int8>, domain: String!, level: Int32, format: String!, args: CVarArg...) {
	LogMessageToF_va(logger, filename, lineNumber, functionName, domain, level, format, getVaList(args))
}

extension String {

	subscript (_ r: Range<Int>) -> String {

		get {
			let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound);
			let endIndex = self.index(self.startIndex, offsetBy: r.upperBound);
			return self[Range(uncheckedBounds: (lower: startIndex, upper: endIndex))]
		}
	}

	func substring(_ s: Int, _ e: Int? = nil) -> String {
		let start = s >= 0 ? self.startIndex : self.endIndex
		let startIndex = self.index(start, offsetBy: s);// start.advancedBy(s)
		var end: String.Index
		var endIndex: String.Index
		if (e == nil) {
			end = self.endIndex
			endIndex = self.endIndex
		} else {
			end = e >= 0 ? self.startIndex : self.endIndex
			endIndex = self.index(end, offsetBy: e!);
		}
        let range = Range(uncheckedBounds: (lower: startIndex, upper: endIndex))
	//	let range = Range<String.Index>(startIndex..<endIndex)
		return self.substring(with: range);

	}
}
