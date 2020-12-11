//
//  DataStructures.swift
//  PushSDK
//
//  Created by Kirill Kotov on 20.11.2020.
//  Copyright © 2020 PUSHER. All rights reserved.
//


import Foundation

public struct PushKFunAnswerRegister {
    public var code: Int
    public var result: String
    public var description: String
    public var deviceId: String
    public var token: String
    public var userId: String
    public var userPhone: String
    public var createdAt: String
    
    public func toString() -> String {
        return "PushKFunAnswerRegister(code: \(self.code), result: \(self.result), description: \(self.description), deviceId: \(self.deviceId), token: \(self.token), userId: \(self.userId), userPhone: \(self.userPhone), createdAt: \(self.createdAt))"
    }
}

public struct PushKFunAnswerGeneral {
    public var code: Int
    public var result: String
    public var description: String
    public var body: String
    
    public func toString() -> String {
        return "PushKFunAnswerGeneral(code: \(self.code), result: \(self.result), description: \(self.description), body: \(self.body))"
    }
}

struct RegisterJsonParse {
    var deviceId: String?=""
    var token: String?=""
    var userId: Int?=0
    var userPhone: String?=""
    var createdAt: String?=""
}

struct UpdateRegJsonParse {
    var deviceId: String
}

struct InternalCoreConnection {
    var register: PushKFunAnswerRegister? = nil
    var general: PushKFunAnswerGeneral? = nil
}

public struct PushKGetDevice {
    public var id : Int
    public var osType: String
    public var osVersion: String
    public var deviceType: String
    public var deviceName: String
    public var sdkVersion: String
    public var createdAt: String
    public var updatedAt: String
    
    public func toString() -> String {
        return "PushKGetDevice(id: \(self.id), osType: \(self.osType), osVersion: \(self.osVersion), deviceType: \(self.deviceType), deviceName: \(self.deviceName), sdkVersion: \(self.sdkVersion), createdAt: \(self.createdAt), updatedAt: \(self.updatedAt))"
    }
}

public struct PushKGetDeviceList {
    public var devices: [PushKGetDevice]
    
    public func toString() -> String {
        var answ_result = ""
        for h in devices {
            let current_str = h.toString()
            if answ_result == "" {
                answ_result = "[" + answ_result + current_str
            }
            else {
                answ_result = answ_result + ", " + current_str
            }
        }
        answ_result = answ_result + "]"
        return answ_result
    }
}


public struct PushKFunAnswerGetDeviceList {
    public var code: Int
    public var result: String
    public var description: String
    public var body: PushKGetDeviceList? = nil
    
    public func toString() -> String {
        return "PushKFunAnswerGetDeviceList(code: \(self.code), result: \(self.result), description: \(self.description), body: \(self.body?.toString() ?? "[]"))"
    }
}

public struct ImageResponse {
    public var url: String?=""
    
    public func toString() -> String {
        return "ImageResponse(url: \(self.url ?? ""))"
    }
}

public struct ButtonResponse {
    public var text: String?=""
    public var url: String?=""
    
    public func toString() -> String {
        return "ButtonResponse(text: \(self.text ?? ""), url: \(self.url ?? ""))"
    }
}

public struct MessagesResponseStr {
    public var phone: String?=""
    public var messageId: String?=""
    public var title: String?=""
    public var body: String?=""
    public var image: ImageResponse?=nil
    public var button: ButtonResponse?=nil
    public var time: String?=""
    public var partner: String?=""
    
    public func toString() -> String {
        return "MessagesResponseStr(phone: \(self.phone ?? ""), messageId: \(self.messageId ?? ""), title: \(self.title ?? ""), body: \(self.body ?? ""), image: \(self.image?.toString() ?? ""), button: \(self.button?.toString() ?? ""), time: \(self.time ?? ""), partner: \(self.partner ?? ""))"
    }
}

public struct MessApsDataStr {
    public var contentAvailable: String
    
    public func toString() -> String{
        return "MessApsDataStr(contentAvailable: \(contentAvailable)"
    }
}

public struct FullFirebaseMessageStr {
    public var aps: MessApsDataStr
    public var message: MessagesResponseStr
    public var googleCSenderId: String
    public var gcmMessageId: String
    
    public func toString() -> String {
        return "FullFirebaseMessageStr(aps: \(aps.toString()), message: \(message.toString()), googleCSenderId: \(googleCSenderId), gcmMessageId: \(gcmMessageId)"
    }
}

public struct MessagesListResponse {
    public var limitDays: Int?=0
    public var limitMessages: Int?=0
    public var lastTime: Int?=0
    public var messages: [MessagesResponseStr]
    
    public func toString() -> String {
        var answ_result = "MessagesListResponse(limitDays: \(limitDays ?? 0), limitMessages: \(limitMessages ?? 0), lastTime: \(lastTime ?? 0), messages: "
        var ans_mess = ""
        if (messages.count != 0) {
        for h in messages {
            let current_str = h.toString()
            if ans_mess == "" {
                ans_mess = "[" + ans_mess + current_str
            }
            else {
                ans_mess = ans_mess + ", " + ans_mess
            }
        }
        ans_mess = ans_mess + "]"
        answ_result = answ_result + ans_mess + ")"
            }
            
        else {
            answ_result = answ_result + "[])"
        }
        
        return answ_result
    }
}

public struct PushKFunAnswerGetMessageHistory {
    public var code: Int?=0
    public var result: String?=""
    public var description: String?=""
    public var body: MessagesListResponse? = nil
    
    public func toString() -> String {
        return "PushKFunAnswerGetMessageHistory(code: \(self.code ?? 0), result: \(self.result ?? ""), description: \(self.description ?? ""), body: \(self.body?.toString() ?? ""))"
    }
}

public struct PushKGeneralAnswerStruct {
    public var code: Int
    public var result: String
    public var description: String
    public var body: String
    
    public func toString() -> String {
        return "PushKGeneralAnswerStruct(code: \(self.code), result: \(self.result), description: \(self.description), body: \(self.body))"
    }
}

public struct PushKMess {
    public var code: Int
    public var result: String
    public var messageFir: FullFirebaseMessageStr
    
    public func toString() -> String {
        return "PushKMess(code: \(code), result: \(result), message: \(messageFir.toString() )"
    }
}

public struct BranchStructObj {
     var url_Http_Update: String
     var url_Http_Registration: String
     var url_Http_Revoke: String
     var url_Http_Device_getall: String
     var url_Http_Mess_callback: String
     var url_Http_Mess_dr: String
     var push_url_mess_queue: String
     var url_Http_Mess_history: String
}


