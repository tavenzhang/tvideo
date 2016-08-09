//
//  NSLoggerSupport.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/6/22.
//  Copyright © 2016年 张新华. All rights reserved.
//

import NSLogger
var  soketQuque = dispatch_queue_create("socket",DISPATCH_QUEUE_CONCURRENT);

func LogSocket(format: String!, args: CVarArgType...) {
    LogMessage_va("socket", 3, format, getVaList(args))
}

func LogHttp(format: String!, args: CVarArgType...) {
    LogMessage_va("Http", 3, format, getVaList(args))
}
func LogMessageT(domain: String!, level: Int32, format: String!, args: CVarArgType...) {
    LogMessage_va(domain, level, format, getVaList(args))
}

func LogMessageF(filename: UnsafePointer<Int8>, lineNumber: Int32, functionName: UnsafePointer<Int8>, domain: String!, level: Int32, format: String!, args: CVarArgType...) {
    LogMessageF_va(filename, lineNumber, functionName, domain, level, format, getVaList(args))
}

func LogMessageTo(logger:COpaquePointer ,domain: String!, level: Int32, format: String!, args: CVarArgType...) {
    LogMessageTo_va(logger, domain, level, format, getVaList(args))
}


func LogMessageToF(logger: COpaquePointer, filename: UnsafePointer<Int8>, lineNumber: Int32, functionName: UnsafePointer<Int8>, domain: String!, level: Int32, format: String!, args: CVarArgType...) {
    LogMessageToF_va(logger, filename, lineNumber, functionName, domain, level, format, getVaList(args))
}

extension String {
    func substring(s: Int, _ e: Int? = nil) -> String {
        let start = s >= 0 ? self.startIndex : self.endIndex
        let startIndex = start.advancedBy(s)
        
        var end: String.Index
        var endIndex: String.Index
        if(e == nil){
            end = self.endIndex
            endIndex = self.endIndex
        } else {
            end = e >= 0 ? self.startIndex : self.endIndex
            endIndex = end.advancedBy(e!)
        }
        
        let range = Range<String.Index>(startIndex..<endIndex)
        return self.substringWithRange(range)
        
    }
}
