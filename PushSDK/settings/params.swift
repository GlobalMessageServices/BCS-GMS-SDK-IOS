//
//
//  Created by Kirill Kotov on 28/04/2019.
//  Copyright © 2019 ard. All rights reserved.
//

import Foundation
import CoreData
import UIKit

import SwiftyBeaver












public struct PushSdkParametersPublic {
    

    
    //urls for push rest server Master Server
    
    

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
    public static var platform_branch_active: BranchStructObj = PushSDKVar.branchMasterValue
    public static var log_level_active: String = "error"
    
    public static let logger = SwiftyBeaver.self
    
    //static let push_registration_token = UserDefaults.standard.bool(forKey: "push_registration_token")
    
    
    
    let kOSType = "ios"
    static let serverSdkVersion = "2.3"
    static let sdkVersion = "1.0.0.28"
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
    public static var pusher_counter = 1
}


