//
//  PushConstants.swift
//  GMSPushSDKIOS
//
//  Created by o.korniienko on 22.08.22.
//

import Foundation
import CoreData
import UIKit

import SwiftyBeaver


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

    public static let logger = SwiftyBeaver.self
    
    let kOSType = "ios"
    static let serverSdkVersion = "2.3"
    static let sdkVersion = "0.0.01"
    static let dev_os_Version = UIDevice.current.systemVersion
    static let deviceType = "\(UIDevice.current.model)"
    static let deviceType2 = "\(UIDevice.current.batteryLevel)"
    static let identifierForVendor = "\(String(describing: UIDevice.current.identifierForVendor))"
    static let localizedModel = "\(UIDevice.current.localizedModel)"
    static let kBundleID = Bundle.main.infoDictionary?[kCFBundleIdentifierKey as String] as? String
    
    static let kPushClientAPIKey = UserDefaults.standard.string(forKey:"clientApiKey")
    static let FCMToken = UserDefaults.standard.string(forKey: "fcmToken")
    
    static let branch = "master"
    
    public static var message_buffer = "" as String
    public static var basePushURLactive = "" as String
    public static var pusher_counter = 1
    
    public static var enableNotificationFlag = true as Bool
    public static var deliveryReportLogicFlag = 1 as Int
    public static var enableDeliveryReportAutoFlag = true as Bool
    public static var notificationPermission = false
}