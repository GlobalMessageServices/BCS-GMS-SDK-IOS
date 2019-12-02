//
//  params.swift
//  test222
//
//  Created by ard on 28/04/2019.
//  Copyright © 2019 ard. All rights reserved.
//

import Foundation
import CoreData
import UIKit


public struct HyberFunAnswerRegister {
    var code: Int
    var result: String
    var description: String
    var deviceId: String
    var token: String
    var userId: String
    var userPhone: String
    var createdAt: String
}

public struct HyberFunAnswerGeneral {
    var code: Int
    var result: String
    var description: String
    var body: String
}



public struct Constants {
    
    static var registrationstatus = UserDefaults.standard.bool(forKey: "registrationstatus")
    static var hyber_registration_token = UserDefaults.standard.string(forKey: "hyber_registration_token")
    static var deviceId = UserDefaults.standard.string(forKey: "deviceId")
    public static var hyber_user_msisdn = "375291234567"
    public static var hyber_user_password = ""
    public static var firebase_registration_token = UserDefaults.standard.string(forKey: "firebase_registration_token")
    
    
    //static let hyber_registration_token = UserDefaults.standard.bool(forKey: "hyber_registration_token")
    
    
    
    
    let kOSType = "ios"
    static let sdkVersion = "0.0.12"
    static let dev_os_Version = UIDevice.current.systemVersion
    static let kDeviceType = "\(UIDevice.current.model)"
    static let kDeviceType2 = "\(UIDevice.current.batteryLevel)"
    static let identifierForVendor = "\(UIDevice.current.identifierForVendor)"
    static let localizedModel = "\(UIDevice.current.localizedModel)"
    //let kDeviceName = "\(UIDevice.current.modelName)"
    static let kBundleID = Bundle.main.infoDictionary?[kCFBundleIdentifierKey as String] as? String
    
    static let kHyberClientAPIKey = UserDefaults.standard.string(forKey:"clientApiKey")
    static let kFCM = UserDefaults.standard.string(forKey: "fcmToken")
    
    static let branch = "master"
    
    static func url_Http_Registration_fun(branch: String) -> String {
        if (branch=="master")
        {
            return "https://push.hyber.im/api/2.3/device/registration"
        }else {
            return "https://test-push.hyber.im/api/2.3/device/registration"
        }
    }
    
    static func url_Http_Revoke_fun(branch: String) -> String {
        if (branch=="master")
        {
            return "https://push.hyber.im/api/2.3/device/revoke"
        }else {
            return "https://test-push.hyber.im/api/2.3/device/revoke"
        }
    }
    
    static func url_Http_Update_fun(branch: String) -> String {
        if (branch=="master")
        {
            return "https://push.hyber.im/api/2.3/device/update"
        }else {
            return "https://test-push.hyber.im/api/2.3/device/update"
        }
    }
    
    static func url_Http_Mess_history_fun(branch: String) -> String {
        if (branch=="master")
        {
            return "https://push.hyber.im/api/2.3/message/history?startDate="
        }else {
            return "https://test-push.hyber.im/api/2.3/message/history?startDate="
        }
    }
    
    
    static func url_Http_Mess_dr_fun(branch: String) -> String {
        if (branch=="master")
        {
            return "https://push.hyber.im/api/2.3/message/dr"
        }else {
            return "https://test-push.hyber.im/api/2.3/message/dr"
        }
    }
    
    static func url_Http_Mess_callback_fun(branch: String) -> String {
        if (branch=="master")
        {
            return "https://push.hyber.im/api/2.3/message/callback"
        }else {
            return "https://test-push.hyber.im/api/2.3/message/callback"
        }
    }
    
    static func url_Http_Device_getall_fun(branch: String) -> String {
        if (branch=="master")
        {
            return "https://push.hyber.im/api/2.3/device/all"
        }else {
            return "https://test-push.hyber.im/api/2.3/device/all"
        }
    }
    
    static func fun_hyber_url_mess_queue(branch: String) -> String {
        if (branch == "master") {
            return "https://push.hyber.im/api/2.3/message/queue"
        } else {
            return "https://test-push.hyber.im/api/2.3/message/queue"
        }
    }
    

    
    //urls for hyber rest server
    static let url_Http_Registration = url_Http_Registration_fun(branch: branch) as NSString
    static let url_Http_Revoke = url_Http_Revoke_fun(branch: branch) as NSString
    static let url_Http_Update = url_Http_Update_fun(branch: branch) as NSString
    static let url_Http_Mess_history = url_Http_Mess_history_fun(branch: branch) as String
    static let url_Http_Mess_dr = url_Http_Mess_dr_fun(branch: branch) as NSString
    static let url_Http_Mess_callback = url_Http_Mess_callback_fun(branch: branch) as NSString
    static let url_Http_Device_getall = url_Http_Device_getall_fun(branch: branch) as NSString
    static let hyber_url_mess_queue = fun_hyber_url_mess_queue(branch: branch) as NSString
    
    
    static let debug_log_path = "/Users/imperituroard/Desktop/application_debug.log" as String
    static let loglevel = ".debug" as String
    static let application_name = "test_app" as String
    
    static var message_buffer = "" as String
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
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad Mini 5"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
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
