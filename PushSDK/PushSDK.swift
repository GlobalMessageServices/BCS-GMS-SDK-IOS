//
//  PushSDK.swift
//  GMSPushSDKIOS
//
//  Created by o.korniienko on 22.08.22.
//

import Foundation
import UIKit
import CryptoSwift
import SwiftyBeaver


public extension Notification.Name {
    static let receivePushKData = Notification.Name("pushKSdkReceiveData")

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
    private let push_rest_server = PushAPI.init()
    //private let funNotificator = PushNotification.init()
    let answer_b = AnswerBuilder.init()
    
    
    public init(
        platform_branch: BranchStructObj = PushSDKVar.branchMasterValue,
        log_level: SwiftyBeaver.Level = PushSDKVar.LOGLEVEL_ERROR,
        push_style: Int = 0,
        basePushURL: String,
        
        //display notification auto
        enableNotification: Bool = true,
        
        //enable delivery report auto
        enableDeliveryReportAuto: Bool = true,
        
        // Working if enableNotification is true and enableDeliveryReportAuto is true
        // 1 - if notification permitted in application settings then send delivery report. Else not send report
        // 2 - always send delivery report if receive
        deliveryReportLogic: Int = 1
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

        let console = ConsoleDestination()
        console.format = "$Dyyyy-MM-dd HH:mm:ss.SSS$d PushSDK $T $N.$F:$l $L: $M"
        console.minLevel = log_level
        let file = FileDestination()
        PushKConstants.logger.addDestination(console)
        PushKConstants.logger.addDestination(file)
        
        PushKConstants.enableNotificationFlag = enableNotification
        PushKConstants.deliveryReportLogicFlag = deliveryReportLogic
        PushKConstants.enableDeliveryReportAutoFlag = enableDeliveryReportAuto
    }
    
    
    
    
    //answer codes
    //200 - Ok
    
    //answers from remote server
    //401 HTTP code – (Client error) authentication error, probably errors
    //400 HTTP code – (Client error) request validation error, probably errors
    //500 HTTP code – (Server error)
    
    //sdk errors
    //700 - internal SDK error
    //701 - incorrect input
    //704 - not registered
    //707 - already exists
    
    
    
    
    //device registration
    //x_push_sesion_id - firebase FCM token
    //x_push_ios_bundle_id - ios application bundle id
    //X_Push_Client_API_Key - provide by hub administrator
    //user_phone - subscribers msisdn
    //subscribers password (optional, for future use)
    public func pushRegisterNew(user_phone: String, user_password: String, x_push_sesion_id: String, x_push_ios_bundle_id: String, X_Push_Client_API_Key: String) -> PushKFunAnswerRegister {
        
        PushKConstants.logger.debug("Start function registrar push_register_new")
        PushKConstants.logger.debug("Input func push_register_new: user_phone: \(user_phone),  user_password: \(user_password), x_push_sesion_id: \(x_push_sesion_id), x_push_ios_bundle_id: \(x_push_ios_bundle_id), X_Push_Client_API_Key: \(X_Push_Client_API_Key)")
        
        PushKConstants.logger.debug("Used constants: registrationstatus: \(PushKConstants.registrationstatus)")
        
        if (PushKConstants.registrationstatus==false){
            if (user_phone != "" && x_push_sesion_id != "" && X_Push_Client_API_Key != "" ) {
                UserDefaults.standard.set(x_push_sesion_id, forKey: "firebase_registration_token")
                PushKConstants.firebase_registration_token = x_push_sesion_id
                //let push_rest_server = PushAPI.init()
                let push_register_new_answer = push_rest_server.registerPushDevice(X_Push_Client_API_Key: X_Push_Client_API_Key, X_Push_Session_Id: x_push_sesion_id, X_Push_IOS_Bundle_Id: x_push_ios_bundle_id,  device_Name:UIDevice.modelName, device_Type: PushKConstants.localizedModel, os_Type: "ios", sdk_Version: PushKConstants.sdkVersion, user_Pass: user_password, user_Phone: user_phone)
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
        PushKConstants.logger.debug("Start function registrar push_register_new2")
        PushKConstants.logger.debug("Input func push_register_new2: user_phone: \(user_phone),  user_password: \(user_password), x_push_ios_bundle_id: \(x_push_ios_bundle_id), X_Push_Client_API_Key: \(X_Push_Client_API_Key)")
        
        PushKConstants.logger.debug("Used constants: registrationstatus: \(PushKConstants.registrationstatus)")
        
        let x_push_sesion_id = PushSdkFirHelpers.firebaseUpdateToken()
        
        PushKConstants.logger.debug("Token updated for registration: x_push_sesion_id: \(x_push_sesion_id)")
        
        if (PushKConstants.registrationstatus==false){
            if (user_phone != "" && x_push_sesion_id != "" && X_Push_Client_API_Key != "" ) {
                //let push_rest_server = PushAPI.init()
                let push_register_new_answer = push_rest_server.registerPushDevice(X_Push_Client_API_Key: X_Push_Client_API_Key, X_Push_Session_Id: x_push_sesion_id, X_Push_IOS_Bundle_Id: x_push_ios_bundle_id,  device_Name:UIDevice.modelName, device_Type: PushKConstants.localizedModel, os_Type: "ios", sdk_Version: PushKConstants.sdkVersion, user_Pass: user_password, user_Phone: user_phone)
                return push_register_new_answer
            }
            else {
                
                PushKConstants.logger.debug("Error pushRegisterNew. Incorrect input parameters: user_phone: \(user_phone), x_push_sesion_id: \(x_push_sesion_id), X_Push_Client_API_Key: \(X_Push_Client_API_Key)")
                
                return PushKFunAnswerRegister.init(code: 701, result: "error", description: "Incorrect input parameters", deviceId: PushKConstants.deviceId ?? "unknown", token: PushKConstants.push_registration_token ?? "firebase_empty", userId: "", userPhone: PushKConstants.push_user_msisdn ?? "", createdAt: "")
            }
        }
        else {
            return PushKFunAnswerRegister.init(code: 707, result: "error", description: "Registration exists", deviceId: PushKConstants.deviceId ?? "unknown", token: PushKConstants.push_registration_token ?? "token_empty", userId: "", userPhone: PushKConstants.push_user_msisdn ?? "", createdAt: "")
        }
    }
    
    public func pushUpdateRegistration() -> PushKGeneralAnswerStruct {
            if (PushKConstants.registrationstatus==true) {
                
                let X_Push_Session_Id: String = PushSdkFirHelpers.firebaseUpdateToken()
                //let push_rest_server = PushAPI.init()
                
                let ansss = push_rest_server.pushUpdateRegistration(fcm_Token: PushKConstants.firebase_registration_token ?? "firebase_empty", os_Type: "ios", os_Version: PushKConstants.dev_os_Version, device_Type: PushKConstants.localizedModel, device_Name: UIDevice.modelName, sdk_Version: PushKConstants.sdkVersion, X_Push_Session_Id: X_Push_Session_Id, X_Push_Auth_Token:PushKConstants.push_registration_token ?? "token_empty")
                return ansss }
            else {
                return answer_b.generalAnswerStruct(resp_code: 704, body_json: "error", description: "Not registered")
            }
    }
    
    
    //Delete registration
    public func pushClearCurrentDevice()->PushKGeneralAnswerStruct {
            if (PushKConstants.registrationstatus==true){
                let X_Push_Session_Id: String = PushKConstants.firebase_registration_token ?? "firebase_empty"
                //let push_rest_server = PushAPI.init()
                let answer = push_rest_server.pushDeviceRevoke(dev_list: [PushKConstants.deviceId ?? "unknown"], X_Push_Session_Id: X_Push_Session_Id, X_Push_Auth_Token: PushKConstants.push_registration_token ?? "firebase_empty")
                return answer
            } else {
                return answer_b.generalAnswerStruct(resp_code: 704, body_json: "error", description: "Not registered")
            }
    }
    
    //Get all devices related to number
    public func pushGetDeviceAllFromServer() -> PushKFunAnswerGetDeviceList {
            if (PushKConstants.registrationstatus==true){
                let X_Push_Session_Id: String = PushKConstants.firebase_registration_token ?? "firebase_empty"
                //let push_rest_server = PushAPI.init()
                let ansss = push_rest_server.pushDevicesGetAll(X_Push_Session_Id: X_Push_Session_Id, X_Push_Auth_Token: PushKConstants.push_registration_token ?? "token_empty")
                PushKConstants.logger.debug(ansss)
                return ansss}
            else {
                return PushKFunAnswerGetDeviceList.init(code: 704, result: "error", description: "Not registered", body: nil)
            }
    }
    
    
}
