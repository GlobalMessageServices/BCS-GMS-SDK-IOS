//
//  hybersdk.swift
//  hybersdk
//
//  Created by Kirill Kotov on 08/05/2019.
//  Copyright © 2019 ard. All rights reserved.
//

//import UIKit
import Foundation
import UIKit
import CryptoSwift
import SwiftyBeaver
//
//import CoreData
//import FirebaseCore
//import FirebaseMessaging
//import FirebaseInstanceID

//coredata
//https://medium.com/@ankurvekariya/core-data-crud-with-swift-4-2-for-beginners-40efe4e7d1cc


public extension Notification.Name {
    static let didReceiveData = Notification.Name("didReceiveData")
    static let didCompleteTask = Notification.Name("didCompleteTask")
    static let completedLengthyDownload = Notification.Name("completedLengthyDownload")
}

public class HyberSDK {
    
    private let log = SwiftyBeaver.self
    
    public init(
        platform_branch: PushSdkParametersPublic.BranchStructObj = PushSdkParametersPublic.branchMasterValue,
        log_level: SwiftyBeaver.Level = .error
        )
    {
        Constants.registrationstatus = UserDefaults.standard.bool(forKey: "registrationstatus")
        Constants.hyber_registration_token = UserDefaults.standard.string(forKey: "hyber_registration_token")
        Constants.deviceId = UserDefaults.standard.string(forKey: "deviceId")
        Constants.firebase_registration_token = UserDefaults.standard.string(forKey: "firebase_registration_token")
        Constants.hyber_user_msisdn = UserDefaults.standard.string(forKey: "hyber_user_msisdn")
        Constants.hyber_user_password = UserDefaults.standard.string(forKey: "hyber_user_password")
        
        Constants.platform_branch_active = platform_branch
        //Constants.log_level_active = log_level
        let console = ConsoleDestination()
        console.format = "$Dyyyy-MM-dd HH:mm:ss.SSS$d PushSDK $T $N.$F:$l $L: $M"
        console.minLevel = log_level
        let file = FileDestination()
        Constants.logger.addDestination(console)
        Constants.logger.addDestination(file)
    }
    
    private let processor = Processing.init()
    
    
    
    //answer codes
    //200 - Ok
    
    //answers from remote server
    //401 HTTP code – (Client error) authentication error, probably errors
    //400 HTTP code – (Client error) request validation error, probably errors
    //500 HTTP code – (Server error)
    
    //sdk errors
    //700 - internal SDK error
    //701 - already exists
    //704 - not registered
    //705 - remote server error
    //707 - incorrect input
    //710 - unknown error
    
    
    //{
    //    "result":"Ok",
    //    "description":"",
    //    "code":200,
    //    "body":{
    //}
    //}
    
    
    
    
    let answer_b = AnswerBuider.init()
    
    
    //Procedure 1. new device registration
    //x_hyber_sesion_id - firebase FCM token
    //x_hyber_ios_bundle_id - ios application bundle id
    //X_Hyber_Client_API_Key - provide by hub administrator
    //user_phone - subscribers msisdn
    //subscribers password (optional, for future use)
    public func hyber_register_new(user_phone: String, user_password: String, x_hyber_sesion_id: String, x_hyber_ios_bundle_id: String, X_Hyber_Client_API_Key: String)->HyberFunAnswerRegister {
        
        Constants.logger.debug("Start function registrar main")
        
        
        if (Constants.registrationstatus==false){
            if (user_phone != "" && x_hyber_sesion_id != "" && X_Hyber_Client_API_Key != "" ) {
                UserDefaults.standard.set(x_hyber_sesion_id, forKey: "firebase_registration_token")
                Constants.firebase_registration_token = x_hyber_sesion_id
                let hyber_rest_server = HyberAPI.init()
                let hyber_register_new_answer = hyber_rest_server.hyber_device_register(X_Hyber_Client_API_Key: X_Hyber_Client_API_Key, X_Hyber_Session_Id: x_hyber_sesion_id, X_Hyber_IOS_Bundle_Id: x_hyber_ios_bundle_id,  device_Name:UIDevice.modelName, device_Type: Constants.localizedModel, os_Type: "ios", sdk_Version: Constants.sdkVersion, user_Pass: user_password, user_Phone: user_phone)
                return hyber_register_new_answer
            }
            else {
                return HyberFunAnswerRegister.init(code: 701, result: "error", description: "Incorrect input parameters", deviceId: Constants.deviceId ?? "unknown", token: Constants.hyber_registration_token ?? "firebase_empty", userId: "", userPhone: Constants.hyber_user_msisdn ?? "", createdAt: "")
            }
        }
        else {
            return HyberFunAnswerRegister.init(code: 707, result: "error", description: "Registration exists", deviceId: Constants.deviceId ?? "unknown", token: Constants.hyber_registration_token ?? "token_empty", userId: "", userPhone: Constants.hyber_user_msisdn ?? "", createdAt: "")
        }
    }
    
    //Procedure 2. Delete registration
    public func hyber_clear_current_device()->HyberGeneralAnswerStruct {
            if (Constants.registrationstatus==true){
                let X_Hyber_Session_Id: String = Constants.firebase_registration_token ?? "firebase_empty"
                let hyber_rest_server = HyberAPI.init()
                let answer = hyber_rest_server.hyber_device_revoke(dev_list: [Constants.deviceId ?? "unknown"], X_Hyber_Session_Id: X_Hyber_Session_Id, X_Hyber_Auth_Token: Constants.hyber_registration_token ?? "firebase_empty")
                return answer
            } else {
                return answer_b.general_answer_struct(resp_code: "704", body_json: "error", description: "Not registered")
            }
    }
    
    
    public func hyber_get_device_all_from_hyber() -> HyberFunAnswerGetDeviceList {
            if (Constants.registrationstatus==true){
                let X_Hyber_Session_Id: String = Constants.firebase_registration_token ?? "firebase_empty"
                let hyber_rest_server = HyberAPI.init()
                let ansss = hyber_rest_server.hyber_device_get_all(X_Hyber_Session_Id: X_Hyber_Session_Id, X_Hyber_Auth_Token: Constants.hyber_registration_token ?? "token_empty")
                Constants.logger.debug(ansss)
                return ansss}
            else {
                return HyberFunAnswerGetDeviceList.init(code: 704, result: "error", description: "Not registered", body: nil)
            }
    }
    
    public func hyber_send_message_callback(message_id: String, message_text: String) -> HyberGeneralAnswerStruct {
            if (Constants.registrationstatus==true){
                let X_Hyber_Session_Id: String = Constants.firebase_registration_token ?? "firebase_empty"
                let hyber_rest_server = HyberAPI.init()
                let anss = hyber_rest_server.hyber_message_callback(message_Id: message_id, answer: message_text, X_Hyber_Session_Id: X_Hyber_Session_Id, X_Hyber_Auth_Token: Constants.hyber_registration_token ?? "token_empty")
                
                return anss}
            else {
                return answer_b.general_answer_struct(resp_code: "704", body_json: "error", description: "Not registered")
            }
    }
    
    public func hyber_message_delivery_report(message_id: String) -> HyberGeneralAnswerStruct {
            if (Constants.registrationstatus==true) {
                let X_Hyber_Session_Id: String = Constants.firebase_registration_token ?? "firebase_empty"
                let hyber_rest_server = HyberAPI.init()
                Constants.logger.debug(X_Hyber_Session_Id)
                Constants.logger.debug(message_id)
                Constants.logger.debug(String(Constants.hyber_registration_token ?? ""))
                
                let asaa = hyber_rest_server.hyber_message_dr(message_Id: message_id, received_At: "123123122341", X_Hyber_Session_Id: X_Hyber_Session_Id, X_Hyber_Auth_Token: Constants.hyber_registration_token ?? "token_empty")
                
                return asaa}
            else {
                return answer_b.general_answer_struct(resp_code: "704", body_json: "error", description: "Not registered")
            }
    }
    
    public func hyber_update_registration() -> HyberGeneralAnswerStruct {
            if (Constants.registrationstatus==true) {
                let X_Hyber_Session_Id: String = Constants.firebase_registration_token ?? "firebase_empty"
                let hyber_rest_server = HyberAPI.init()
                
                let ansss = hyber_rest_server.hyber_device_update(fcm_Token: Constants.firebase_registration_token ?? "firebase_empty", os_Type: "ios", os_Version: Constants.dev_os_Version, device_Type: Constants.localizedModel, device_Name: UIDevice.modelName, sdk_Version: Constants.sdkVersion, X_Hyber_Session_Id: X_Hyber_Session_Id, X_Hyber_Auth_Token:Constants.hyber_registration_token ?? "token_empty")
                return ansss }
            else {
                return answer_b.general_answer_struct(resp_code: "704", body_json: "error", description: "Not registered")
            }
    }
    
    enum MyError: Error {
        case FoundNil(String)
    }
    
    public func hyber_get_message_history(period_in_seconds: Int) -> HyberFunAnswerGetMessageHistory {
            if (Constants.registrationstatus==true) {
                let X_Hyber_Session_Id: String = Constants.firebase_registration_token ?? "firebase_empty"
                let hyber_rest_server = HyberAPI.init()
                
                let ansss = hyber_rest_server.hyber_message_get_history( utc_time: period_in_seconds, X_Hyber_Session_Id: X_Hyber_Session_Id, X_Hyber_Auth_Token: Constants.hyber_registration_token ?? "token_empty" )
                return ansss }
            else {
                return HyberFunAnswerGetMessageHistory.init(code: 704, result: "error", description: "Not registered", body: nil)
            }
    }
    
    
    public func hyber_clear_all_device()->HyberGeneralAnswerStruct {

            if (Constants.registrationstatus==true) {
                let getdev = hyber_get_device_all_from_hyber()
                
                var listdev: [String] = []
                
                let dev_list_all = getdev.body
                
                /*
                 let jsonData2 = try? JSONSerialization.data(withJSONObject: string1, options: [])
                 let jsonString2 = String(data: jsonData2!, encoding: .utf8)!
                 let string2 = String(jsonString2).replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
                 print(string2)
                 */
                
                for jj in dev_list_all?.devices ?? []
                {
                    listdev.append(String(jj.id))
                }
                
                Constants.logger.debug(listdev)
                
                let X_Hyber_Session_Id: String = Constants.firebase_registration_token ?? "firebase_empty"
                Constants.logger.debug(String(Constants.deviceId ?? "unknown"))
                Constants.logger.debug(X_Hyber_Session_Id)
                Constants.logger.debug(String(Constants.hyber_registration_token ?? "token_empty"))
                
                let hyber_rest_server = HyberAPI.init()
                let ggg = hyber_rest_server.hyber_device_revoke(dev_list: listdev, X_Hyber_Session_Id: X_Hyber_Session_Id, X_Hyber_Auth_Token: Constants.hyber_registration_token ?? "empty_token")
                
                return ggg
                
            }
            else {
                return answer_b.general_answer_struct(resp_code: "704", body_json: "error", description: "Not registered")
            }
    }
    
    public func rewrite_msisdn(newmsisdn: String) -> HyberGeneralAnswerStruct {
        UserDefaults.standard.set(newmsisdn, forKey: "hyber_user_msisdn")
        Constants.firebase_registration_token = newmsisdn
        return HyberGeneralAnswerStruct.init(code: 200, result: "Ok", description: "Success", body: "newmsisdn: \(newmsisdn)")
    }
    
    public func rewrite_password(newpassword: String) -> HyberGeneralAnswerStruct{
        UserDefaults.standard.set(newpassword, forKey: "hyber_user_password")
        Constants.firebase_registration_token = newpassword
        return HyberGeneralAnswerStruct.init(code: 200, result: "Ok", description: "Success", body: "newpassword: \(newpassword)")
    }
    
    
    public func hyber_check_queue() -> HyberFunAnswerGeneral {
            if (Constants.registrationstatus==true) {
                let X_Hyber_Session_Id: String = Constants.firebase_registration_token ?? "firebase_empty"
                let hyber_rest_server = HyberAPI.init()
                let ansss = hyber_rest_server.hyber_check_queue(X_Hyber_Session_Id: X_Hyber_Session_Id, X_Hyber_Auth_Token: Constants.hyber_registration_token ?? "token_empty" )
                return ansss
            }
            else {
                return answer_b.general_answer2(resp_code: 704, body_json: "error", description: "Not registered")
            }
    }
}



extension String {
    
    func sha256() -> String{
        if let stringData = self.data(using: String.Encoding.utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return ""
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        return hexString
    }
    
}


