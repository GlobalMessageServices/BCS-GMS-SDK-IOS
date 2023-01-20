//
//  DataStructures.swift
//  GMSPushSDKIOS
//
//  Created by o.korniienko on 22.08.22.
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
        var answResult = ""
        for h in devices {
            let currentStr = h.toString()
            if answResult == "" {
                answResult = "[" + answResult + currentStr
            }
            else {
                answResult = answResult + ", " + currentStr
            }
        }
        answResult = answResult + "]"
        return answResult
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
    public var contentAvailable: Int
    
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
        var answResult = "MessagesListResponse(limitDays: \(limitDays ?? 0), limitMessages: \(limitMessages ?? 0), lastTime: \(lastTime ?? 0), messages: "
        var ansMess = ""
        if (messages.count != 0) {
        for h in messages {
            let currenStr = h.toString()
            if ansMess == "" {
                ansMess = "[" + ansMess + currenStr
            }
            else {
                ansMess = ansMess + ", " + currenStr
            }
        }
            ansMess = ansMess + "]"
            answResult = answResult + ansMess + ")"
            }
            
        else {
            answResult = answResult + "[])"
        }
        
        return answResult
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
     var urlHttpUpdate: String
     var urlHttpRegistration: String
     var urlHttpRevoke: String
     var urlHttpDeviceGetAll: String
     var urlHttpMesscallback: String
     var urlHttpMessDr: String
     var pusUrlMessQueue: String
     var urlHttpMessHistory: String
}


public struct PushkUserData {
    var deviceOS: String
    var osVersion: String
    var deviceModel: String
    var languageAndRegion: LanguageAndRegion
    var timeZoneAbreviation: String
    var timeZoneIdentifier: String
    
    public func toString() -> String {
        return "PushkUserData(deviceOS: \(self.deviceOS),\n osVersion: \(self.osVersion),\n deviceModel: \(self.deviceModel),\n languageAndRegion: \(self.languageAndRegion.toString()),\n timeZoneAbreviation: \(self.timeZoneAbreviation),\n timeZoneIdentifier: \(self.timeZoneIdentifier))"
    }
}

public struct LanguageAndRegion{
    var deviceLanguage: String
    var deviceLanguageEn: String
    var isoLanguageCode: String
    var isoRegion: String
    var region: String
    var regionEn: String
    
    public func toString() -> String {
        return "LanguageAndRegion(deviceLanguage: \(self.deviceLanguage),\n deviceLanguageEn: \(self.deviceLanguageEn),\n isoLanguageCode: \(self.isoLanguageCode),\n isoRegion: \(self.isoRegion),\n region: \(self.region),\n regionEn: \(self.regionEn))"
    }
}
