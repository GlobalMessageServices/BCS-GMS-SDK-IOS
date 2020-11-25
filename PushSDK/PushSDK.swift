//
//  pushsdk.swift
//  pushsdk
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
import FirebaseInstanceID

//coredata
//https://medium.com/@ankurvekariya/core-data-crud-with-swift-4-2-for-beginners-40efe4e7d1cc


public extension Notification.Name {
    static let receivePushKData = Notification.Name("pushKSdkReceiveData")
    //static let didCompleteTask = Notification.Name("didCompleteTask")
    //static let completedLengthyDownload = Notification.Name("completedLengthyDownload")
}


public class PushSDKVar {
    public static let LOGLEVEL_DEBUG = SwiftyBeaver.Level.debug
    public static let LOGLEVEL_ERROR = SwiftyBeaver.Level.error
    
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
}

public class PushSDK {
    
    private let log = SwiftyBeaver.self
    private let parserClassAdapter = PusherKParser.init()
    private let parserJson = PushKAnswParser.init()
    //private let fb_init_adapter = PushKFirebaseSdk.init()
    
    public init(
        platform_branch: BranchStructObj = PushSDKVar.branchMasterValue,
        log_level: SwiftyBeaver.Level = PushSDKVar.LOGLEVEL_ERROR,
        push_style: Int = 0,
        basePushURL: String
        )
    {
        PushKConstants.registrationstatus = UserDefaults.standard.bool(forKey: "registrationstatus")
        PushKConstants.push_registration_token = UserDefaults.standard.string(forKey: "push_registration_token")
        PushKConstants.deviceId = UserDefaults.standard.string(forKey: "deviceId")
        PushKConstants.firebase_registration_token = UserDefaults.standard.string(forKey: "firebase_registration_token")
        PushKConstants.push_user_msisdn = UserDefaults.standard.string(forKey: "push_user_msisdn")
        PushKConstants.push_user_password = UserDefaults.standard.string(forKey: "push_user_password")
        parserClassAdapter.urlsInitialization(branchUrl: basePushURL, method_paths: platform_branch)
        PushKConstants.basePushURLactive = basePushURL
        //Constants.log_level_active = log_level
        let console = ConsoleDestination()
        console.format = "$Dyyyy-MM-dd HH:mm:ss.SSS$d PushSDK $T $N.$F:$l $L: $M"
        console.minLevel = log_level
        let file = FileDestination()
        PushKConstants.logger.addDestination(console)
        PushKConstants.logger.addDestination(file)
    }
    
    private let processor = PushKProcessing.init()
    
    
    
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
    //x_push_sesion_id - firebase FCM token
    //x_push_ios_bundle_id - ios application bundle id
    //X_Push_Client_API_Key - provide by hub administrator
    //user_phone - subscribers msisdn
    //subscribers password (optional, for future use)
    public func pushRegisterNew(user_phone: String, user_password: String, x_push_sesion_id: String, x_push_ios_bundle_id: String, X_Push_Client_API_Key: String)->PushKFunAnswerRegister {
        
        PushKConstants.logger.debug("Start function registrar main")
        PushKConstants.logger.debug("Input func push_register_new: user_phone: \(user_phone),  user_password: \(user_password), x_push_sesion_id: \(x_push_sesion_id), x_push_ios_bundle_id: \(x_push_ios_bundle_id), X_Push_Client_API_Key: \(X_Push_Client_API_Key)")
        
        PushKConstants.logger.debug("Used constants: registrationstatus: \(PushKConstants.registrationstatus)")
        
        if (PushKConstants.registrationstatus==false){
            if (user_phone != "" && x_push_sesion_id != "" && X_Push_Client_API_Key != "" ) {
                UserDefaults.standard.set(x_push_sesion_id, forKey: "firebase_registration_token")
                PushKConstants.firebase_registration_token = x_push_sesion_id
                let push_rest_server = PushKAPI.init()
                let push_register_new_answer = push_rest_server.push_device_register(X_Push_Client_API_Key: X_Push_Client_API_Key, X_Push_Session_Id: x_push_sesion_id, X_Push_IOS_Bundle_Id: x_push_ios_bundle_id,  device_Name:UIDevice.modelName, device_Type: PushKConstants.localizedModel, os_Type: "ios", sdk_Version: PushKConstants.sdkVersion, user_Pass: user_password, user_Phone: user_phone)
                return push_register_new_answer
            }
            else {
                return PushKFunAnswerRegister.init(code: 701, result: "error", description: "Incorrect input parameters", deviceId: PushKConstants.deviceId ?? "unknown", token: PushKConstants.push_registration_token ?? "firebase_empty", userId: "", userPhone: PushKConstants.push_user_msisdn ?? "", createdAt: "")
            }
        }
        else {
            return PushKFunAnswerRegister.init(code: 707, result: "error", description: "Registration exists", deviceId: PushKConstants.deviceId ?? "unknown", token: PushKConstants.push_registration_token ?? "token_empty", userId: "", userPhone: PushKConstants.push_user_msisdn ?? "", createdAt: "")
        }
    }
    
    public func pushRegisterNew(user_phone: String, user_password: String, x_push_ios_bundle_id: String, X_Push_Client_API_Key: String)->PushKFunAnswerRegister {
        
        PushKConstants.logger.debug("Start function registrar main")
        PushKConstants.logger.debug("Input func push_register_new2: user_phone: \(user_phone),  user_password: \(user_password), x_push_ios_bundle_id: \(x_push_ios_bundle_id), X_Push_Client_API_Key: \(X_Push_Client_API_Key)")
        
        PushKConstants.logger.debug("Used constants: registrationstatus: \(PushKConstants.registrationstatus)")
        
        let x_push_sesion_id = self.firebaseUpdateToken()
        
        if (PushKConstants.registrationstatus==false){
            if (user_phone != "" && x_push_sesion_id != "" && X_Push_Client_API_Key != "" ) {
                UserDefaults.standard.set(x_push_sesion_id, forKey: "firebase_registration_token")
                let push_rest_server = PushKAPI.init()
                let push_register_new_answer = push_rest_server.push_device_register(X_Push_Client_API_Key: X_Push_Client_API_Key, X_Push_Session_Id: x_push_sesion_id, X_Push_IOS_Bundle_Id: x_push_ios_bundle_id,  device_Name:UIDevice.modelName, device_Type: PushKConstants.localizedModel, os_Type: "ios", sdk_Version: PushKConstants.sdkVersion, user_Pass: user_password, user_Phone: user_phone)
                return push_register_new_answer
            }
            else {
                return PushKFunAnswerRegister.init(code: 701, result: "error", description: "Incorrect input parameters", deviceId: PushKConstants.deviceId ?? "unknown", token: PushKConstants.push_registration_token ?? "firebase_empty", userId: "", userPhone: PushKConstants.push_user_msisdn ?? "", createdAt: "")
            }
        }
        else {
            return PushKFunAnswerRegister.init(code: 707, result: "error", description: "Registration exists", deviceId: PushKConstants.deviceId ?? "unknown", token: PushKConstants.push_registration_token ?? "token_empty", userId: "", userPhone: PushKConstants.push_user_msisdn ?? "", createdAt: "")
        }
    }
    
    //Procedure 2. Delete registration
    public func pushClearCurrentDevice()->PushKGeneralAnswerStruct {
            if (PushKConstants.registrationstatus==true){
                let X_Push_Session_Id: String = PushKConstants.firebase_registration_token ?? "firebase_empty"
                let push_rest_server = PushKAPI.init()
                let answer = push_rest_server.push_device_revoke(dev_list: [PushKConstants.deviceId ?? "unknown"], X_Push_Session_Id: X_Push_Session_Id, X_Push_Auth_Token: PushKConstants.push_registration_token ?? "firebase_empty")
                return answer
            } else {
                return answer_b.general_answer_struct(resp_code: "704", body_json: "error", description: "Not registered")
            }
    }
    
    
    public func pushGetDeviceAllFromServer() -> PushKFunAnswerGetDeviceList {
            if (PushKConstants.registrationstatus==true){
                let X_Push_Session_Id: String = PushKConstants.firebase_registration_token ?? "firebase_empty"
                let push_rest_server = PushKAPI.init()
                let ansss = push_rest_server.push_device_get_all(X_Push_Session_Id: X_Push_Session_Id, X_Push_Auth_Token: PushKConstants.push_registration_token ?? "token_empty")
                PushKConstants.logger.debug(ansss)
                return ansss}
            else {
                return PushKFunAnswerGetDeviceList.init(code: 704, result: "error", description: "Not registered", body: nil)
            }
    }
    
    public func pushSendMessageCallback(message_id: String, message_text: String) -> PushKGeneralAnswerStruct {
            if (PushKConstants.registrationstatus==true){
                let X_Push_Session_Id: String = PushKConstants.firebase_registration_token ?? "firebase_empty"
                let push_rest_server = PushKAPI.init()
                let anss = push_rest_server.push_message_callback(message_Id: message_id, answer: message_text, X_Push_Session_Id: X_Push_Session_Id, X_Push_Auth_Token: PushKConstants.push_registration_token ?? "token_empty")
                
                return anss}
            else {
                return answer_b.general_answer_struct(resp_code: "704", body_json: "error", description: "Not registered")
            }
    }
    
    public func pushMessageDeliveryReport(message_id: String) -> PushKGeneralAnswerStruct {
            if (PushKConstants.registrationstatus==true) {
                let X_Push_Session_Id: String = PushKConstants.firebase_registration_token ?? "firebase_empty"
                let push_rest_server = PushKAPI.init()
                PushKConstants.logger.debug(X_Push_Session_Id)
                PushKConstants.logger.debug(message_id)
                PushKConstants.logger.debug(String(PushKConstants.push_registration_token ?? "firebase_empty"))
                
                let asaa = push_rest_server.push_message_dr(message_Id: message_id, received_At: "0", X_Push_Session_Id: X_Push_Session_Id, X_Push_Auth_Token: PushKConstants.push_registration_token ?? "token_empty")
                
                return asaa}
            else {
                return answer_b.general_answer_struct(resp_code: "704", body_json: "error", description: "Not registered")
            }
    }
    
    public func pushUpdateRegistration() -> PushKGeneralAnswerStruct {
            if (PushKConstants.registrationstatus==true) {
                let X_Push_Session_Id: String = PushKConstants.firebase_registration_token ?? "firebase_empty"
                let push_rest_server = PushKAPI.init()
                
                let ansss = push_rest_server.push_device_update(fcm_Token: PushKConstants.firebase_registration_token ?? "firebase_empty", os_Type: "ios", os_Version: PushKConstants.dev_os_Version, device_Type: PushKConstants.localizedModel, device_Name: UIDevice.modelName, sdk_Version: PushKConstants.sdkVersion, X_Push_Session_Id: X_Push_Session_Id, X_Push_Auth_Token:PushKConstants.push_registration_token ?? "token_empty")
                return ansss }
            else {
                return answer_b.general_answer_struct(resp_code: "704", body_json: "error", description: "Not registered")
            }
    }
    
    enum MyError: Error {
        case FoundNil(String)
    }
    
    public func pushGetMessageHistory(period_in_seconds: Int) -> PushKFunAnswerGetMessageHistory {
            if (PushKConstants.registrationstatus==true) {
                let X_Push_Session_Id: String = PushKConstants.firebase_registration_token ?? "firebase_empty"
                let push_rest_server = PushKAPI.init()
                
                let ansss = push_rest_server.push_message_get_history( utc_time: period_in_seconds, X_Push_Session_Id: X_Push_Session_Id, X_Push_Auth_Token: PushKConstants.push_registration_token ?? "token_empty" )
                return ansss }
            else {
                return PushKFunAnswerGetMessageHistory.init(code: 704, result: "error", description: "Not registered", body: nil)
            }
    }
    
    
    public func pushClearAllDevice()->PushKGeneralAnswerStruct {

            if (PushKConstants.registrationstatus==true) {
                let getdev = pushGetDeviceAllFromServer()
                
                var listdev: [String] = []
                
                let dev_list_all = getdev.body
                
                for jj in dev_list_all?.devices ?? []
                {
                    listdev.append(String(jj.id))
                }
                
                PushKConstants.logger.debug(listdev)
                
                let X_Push_Session_Id: String = PushKConstants.firebase_registration_token ?? "firebase_empty"
                PushKConstants.logger.debug(String(PushKConstants.deviceId ?? "unknown"))
                PushKConstants.logger.debug(X_Push_Session_Id)
                PushKConstants.logger.debug(String(PushKConstants.push_registration_token ?? "token_empty"))
                
                let push_rest_server = PushKAPI.init()
                let ggg = push_rest_server.push_device_revoke(dev_list: listdev, X_Push_Session_Id: X_Push_Session_Id, X_Push_Auth_Token: PushKConstants.push_registration_token ?? "empty_token")
                
                return ggg
                
            }
            else {
                return answer_b.general_answer_struct(resp_code: "704", body_json: "error", description: "Not registered")
            }
    }
    
    public func rewrite_msisdn(newmsisdn: String) -> PushKGeneralAnswerStruct {
        UserDefaults.standard.set(newmsisdn, forKey: "push_user_msisdn")
        PushKConstants.firebase_registration_token = newmsisdn
        return PushKGeneralAnswerStruct.init(code: 200, result: "Ok", description: "Success", body: "newmsisdn: \(newmsisdn)")
    }
    
    public func rewrite_password(newpassword: String) -> PushKGeneralAnswerStruct{
        UserDefaults.standard.set(newpassword, forKey: "push_user_password")
        PushKConstants.firebase_registration_token = newpassword
        return PushKGeneralAnswerStruct.init(code: 200, result: "Ok", description: "Success", body: "newpassword: \(newpassword)")
    }
    
    
    public func pushCheckQueue() -> PushKFunAnswerGeneral {
            if (PushKConstants.registrationstatus==true) {
                let X_Push_Session_Id: String = PushKConstants.firebase_registration_token ?? "firebase_empty"
                let push_rest_server = PushKAPI.init()
                let ansss = push_rest_server.push_check_queue(X_Push_Session_Id: X_Push_Session_Id, X_Push_Auth_Token: PushKConstants.push_registration_token ?? "token_empty" )
                return ansss
            }
            else {
                return answer_b.general_answer2(resp_code: 704, body_json: "error", description: "Not registered")
            }
    }
    
    
    internal func firebaseUpdateToken() -> String {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                UserDefaults.standard.set(result.token, forKey: "firebase_registration_token")
                PushKConstants.firebase_registration_token = result.token
                UserDefaults.standard.synchronize()
                print("Remote instance ID token: \(result.token)")
            }
        }
        
        return PushKConstants.firebase_registration_token ?? ""
    }
    
    

    
    //function for parsing incoming message from firebase
    public static func parseIncomingPush(message: Notification) -> PushKMess {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: message.userInfo ?? "", options: []) else { return  PushKMess(code: 500, result: "Error in process message", messageFir: FullFirebaseMessageStr(aps: MessApsDataStr(contentAvailable: ""), message: MessagesResponseStr(), googleCSenderId: "", gcmMessageId: ""))}
        let jsonString = String(data: jsonData, encoding: .utf8)
        let newString = String(jsonString ?? "").replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
        let parsed_message = PushKAnswParser.messageIncomingJson(str_resp: newString)
        return PushKMess(code: 200, result: "Success", messageFir: parsed_message)
    }
    
    
}





