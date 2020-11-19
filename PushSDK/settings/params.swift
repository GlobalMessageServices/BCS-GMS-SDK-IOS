//
//
//  Created by Kirill Kotov on 28/04/2019.
//  Copyright © 2019 ard. All rights reserved.
//

import Foundation
import CoreData
import UIKit

import SwiftyBeaver


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
    var deviceId: String?=nil
    var token: String?=nil
    var userId: Int?=0
    var userPhone: String?=nil
    var createdAt: String?=nil
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
    public var url: String?=nil
    
    public func toString() -> String {
        return "ImageResponse(url: \(self.url ?? ""))"
    }
}

public struct ButtonResponse {
    public var text: String?=nil
    public var url: String?=nil
    
    public func toString() -> String {
        return "ButtonResponse(text: \(self.text ?? ""), url: \(self.url ?? ""))"
    }
}

public struct MessagesResponseStr {
    public var phone: String?=nil
    public var messageId: String?=nil
    public var title: String?=nil
    public var body: String?=nil
    public var image: ImageResponse?=nil
    public var button: ButtonResponse?=nil
    public var time: String?=nil
    public var partner: String?=nil
    
    public func toString() -> String {
        return "MessagesResponseStr(phone: \(self.phone ?? ""), messageId: \(self.messageId ?? ""), title: \(self.title ?? ""), body: \(self.body ?? ""), image: \(self.image?.toString() ?? ""), button: \(self.button?.toString() ?? ""), time: \(self.time ?? ""), partner: \(self.partner ?? ""))"
    }
}

public struct MessagesListResponse {
    public var limitDays: Int?=nil
    public var limitMessages: Int?=nil
    public var lastTime: Int?=nil
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
    public var code: Int?=nil
    public var result: String?=nil
    public var description: String?=nil
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


public struct PushSdkParametersPublic {
    
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
    
    //urls for push rest server Master Server
    public static var branchMasterValue: BranchStructObj = BranchStructObj(
        url_Http_Update: "device/update",
        url_Http_Registration: "device/registration",
        url_Http_Revoke: "device/revoke",
        url_Http_Device_getall: "device/all",
        url_Http_Mess_callback: "message/callback",
        url_Http_Mess_dr: "message/dr",
        push_url_mess_queue: "message/queue",
        url_Http_Mess_history: "message/history?startDate="
    )
    

    static let TAG_LOGGING = "PushSDK"
    static let push_log_level_error = "error"
    static let push_log_level_debug = "debug"
}


public struct PushKConstants {
    
    public static var registrationstatus = UserDefaults.standard.bool(forKey: "registrationstatus")
    public static var push_registration_token = UserDefaults.standard.string(forKey: "push_registration_token")
    public static var deviceId = UserDefaults.standard.string(forKey: "deviceId")
    public static var userId = UserDefaults.standard.string(forKey: "userId")
    public static var created_at = UserDefaults.standard.string(forKey: "created_at")
    
    public static var push_user_msisdn = UserDefaults.standard.string(forKey: "push_user_msisdn")
    public static var push_user_password = UserDefaults.standard.string(forKey: "push_user_password")
    public static var firebase_registration_token = UserDefaults.standard.string(forKey: "firebase_registration_token")
    public static var platform_branch_active: PushSdkParametersPublic.BranchStructObj = PushSdkParametersPublic.branchMasterValue
    public static var log_level_active: String = "error"
    
    public static let logger = SwiftyBeaver.self
    
    //static let push_registration_token = UserDefaults.standard.bool(forKey: "push_registration_token")
    
    
    
    let kOSType = "ios"
    static let serverSdkVersion = "2.3"
    static let sdkVersion = "1.0.0.20"
    static let dev_os_Version = UIDevice.current.systemVersion
    static let kDeviceType = "\(UIDevice.current.model)"
    static let kDeviceType2 = "\(UIDevice.current.batteryLevel)"
    static let identifierForVendor = "\(String(describing: UIDevice.current.identifierForVendor))"
    static let localizedModel = "\(UIDevice.current.localizedModel)"
    //let kDeviceName = "\(UIDevice.current.modelName)"
    static let kBundleID = Bundle.main.infoDictionary?[kCFBundleIdentifierKey as String] as? String
    
    static let kPushClientAPIKey = UserDefaults.standard.string(forKey:"clientApiKey")
    static let kFCM = UserDefaults.standard.string(forKey: "fcmToken")
    
    static let branch = "master"
    
    static let debug_log_path = "/Users/imperituroard/Desktop/application_debug.log" as String
    static let loglevel = ".debug" as String
    static let application_name = "test_app" as String
    
    public static var message_buffer = "" as String
    
    public static var basePushURLactive = "" as String
    static var pusher_counter = 1
}


public extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPhone12,8":                              return "iPhone SE (2nd generation)"
            case "iPhone13,1":                              return "iPhone 12 mini"
            case "iPhone13,2":                              return "iPhone 12"
            case "iPhone13,3":                              return "iPhone 12 Pro"
            case "iPhone13,4":                              return "iPhone 12 Pro Max"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,3", "iPad11,4":                    return "iPad Air (3rd generation)"
            case "iPad13,1", "iPad13,2":                    return "iPad Air (4th generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad Mini 5"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch) (1st generation)"
            case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch) (1st generation)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
}
