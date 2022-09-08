//
//  PushSDK.swift
//  GMSPushSDKIOS
//
//  Created by o.korniienko on 22.08.22.
//

import Foundation
import CryptoSwift
import SwiftyBeaver


public extension Notification.Name {
    static let receivePushKData = Notification.Name("pushKSdkReceiveData")

}


public class PushSDKVar {
    public static let LOGLEVEL_DEBUG = SwiftyBeaver.Level.debug
    public static let LOGLEVEL_ERROR = SwiftyBeaver.Level.error
    
    public static var branchMasterValue: BranchStructObj = BranchStructObj(
        urlHttpUpdate: "device/update",
        urlHttpRegistration: "device/registration",
        urlHttpRevoke: "device/revoke",
        urlHttpDeviceGetAll: "device/all",
        urlHttpMesscallback: "message/callback",
        urlHttpMessDr: "message/dr",
        pusUrlMessQueue: "message/queue",
        urlHttpMessHistory: "message/history?startDate="
    )
}

public class PushSDK {
    
    private let log = SwiftyBeaver.self
    private let parserClassAdapter = PusherKParser.init()
    private let pushRestServer = PushAPI.init()
    //private let funNotificator = PushNotification.init()
    let answerBuilder = AnswerBuilder.init()
    
    
    public init(
        platformBranch: BranchStructObj = PushSDKVar.branchMasterValue,
        logLevel: SwiftyBeaver.Level = PushSDKVar.LOGLEVEL_ERROR,
        pushStyle: Int = 0,
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
        PushKConstants.pushRegistratioToken = UserDefaults.standard.string(forKey: "push_registration_token")
        PushKConstants.deviceId = UserDefaults.standard.string(forKey: "deviceId")
        PushKConstants.firebaseRegistrationToken = UserDefaults.standard.string(forKey: "firebase_registration_token")
        PushKConstants.pushUserMsisdn = UserDefaults.standard.string(forKey: "push_user_msisdn")
        PushKConstants.pushUserPassword = UserDefaults.standard.string(forKey: "push_user_password")
        parserClassAdapter.urlsInitialization(branchUrl: basePushURL, methodPaths: platformBranch)
        PushKConstants.basePushURLactive = basePushURL

        let console = ConsoleDestination()
        console.format = "$Dyyyy-MM-dd HH:mm:ss.SSS$d PushSDK $T $N.$F:$l $L: $M"
        console.minLevel = logLevel
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
    //xPushSessionId - firebase FCM token
    //xPushIOSBundleId - ios application bundle id
    //xPushClientAPIKey - provide by hub administrator
    //userPhone - subscribers msisdn
    //userPassword - subscribers password (optional, for future use)
    public func pushRegisterNew(userPhone: String, userPassword: String, xPushSessionId: String, xPushIOSBundleId: String, xPushClientAPIKey: String) -> PushKFunAnswerRegister {
        
        PushKConstants.logger.debug("Start function registrar pushRegisterNew")
        PushKConstants.logger.debug("Input func pushRegisterNew: userPhone: \(userPhone),  userPassword: \(userPassword), xPushSessionId: \(xPushSessionId), xPushIOSBundleId: \(xPushIOSBundleId), xPushClientAPIKey: \(xPushClientAPIKey)")
        
        PushKConstants.logger.debug("Used constants: registrationstatus: \(PushKConstants.registrationstatus)")
        
        if (!PushKConstants.registrationstatus){
            if (userPhone != "" && xPushSessionId != "" && xPushClientAPIKey != "" ) {
                UserDefaults.standard.set(xPushSessionId, forKey: "firebase_registration_token")
                PushKConstants.firebaseRegistrationToken = xPushSessionId
                let pusRegisterNewAnswer = pushRestServer.registerPushDevice(xPushClientAPIKey: xPushClientAPIKey, xPushSessionId: xPushSessionId, xPushIOSBundleId: xPushIOSBundleId, userPass: userPassword, userPhone: userPhone)
                return pusRegisterNewAnswer
            }
            else {
                return PushKFunAnswerRegister.init(code: 701, result: "error", description: "Incorrect input parameters", deviceId: PushKConstants.deviceId ?? "unknown", token: PushKConstants.pushRegistratioToken ?? "firebase_empty", userId: "", userPhone: PushKConstants.pushUserMsisdn ?? "", createdAt: "")
            }
        }
        else {
            return PushKFunAnswerRegister.init(code: 707, result: "error", description: "Registration exists", deviceId: PushKConstants.deviceId ?? "unknown", token: PushKConstants.pushRegistratioToken ?? "token_empty", userId: "", userPhone: PushKConstants.pushUserMsisdn ?? "", createdAt: "")
        }
    }
    
    public func pushRegisterNew(userPhone: String, userPassword: String, xPushIOSBundleId: String, xPushClientAPIKey: String)->PushKFunAnswerRegister {
        PushKConstants.logger.debug("Start function registrar pushRegisterNew2")
        PushKConstants.logger.debug("Input func pushRegisterNew2: userPhone: \(userPhone),  userPassword: \(userPassword), xPushIOSBundleId: \(xPushIOSBundleId), xPushClientAPIKey: \(xPushClientAPIKey)")
        
        PushKConstants.logger.debug("Used constants: registrationstatus: \(PushKConstants.registrationstatus)")
        
        let xPushSessionId = PushSdkFirHelpers.firebaseUpdateToken()
        
        PushKConstants.logger.debug("Token updated for registration: xPushSessionId: \(xPushSessionId)")
        
        if (!PushKConstants.registrationstatus==false){
            if (userPhone != "" && xPushSessionId != "" && xPushClientAPIKey != "" ) {
                let pusRegisterNewAnswer = pushRestServer.registerPushDevice(xPushClientAPIKey: xPushClientAPIKey, xPushSessionId: xPushSessionId, xPushIOSBundleId: xPushIOSBundleId, userPass: userPassword, userPhone: userPhone)
                return pusRegisterNewAnswer
            }
            else {
                
                PushKConstants.logger.debug("Error pushRegisterNew2. Incorrect input parameters: userPhone: \(userPhone), xPushSessionId: \(xPushSessionId), xPushClientAPIKey: \(xPushClientAPIKey)")
                
                return PushKFunAnswerRegister.init(code: 701, result: "error", description: "Incorrect input parameters", deviceId: PushKConstants.deviceId ?? "unknown", token: PushKConstants.pushRegistratioToken ?? "firebase_empty", userId: "", userPhone: PushKConstants.pushUserMsisdn ?? "", createdAt: "")
            }
        }
        else {
            return PushKFunAnswerRegister.init(code: 707, result: "error", description: "Registration exists", deviceId: PushKConstants.deviceId ?? "unknown", token: PushKConstants.pushRegistratioToken ?? "token_empty", userId: "", userPhone: PushKConstants.pushUserMsisdn ?? "", createdAt: "")
        }
    }
    
    public func pushUpdateRegistration() -> PushKGeneralAnswerStruct {
            if (PushKConstants.registrationstatus) {
                
                let xPushSessionId: String = PushSdkFirHelpers.firebaseUpdateToken()
                
                let answer = pushRestServer.pushUpdateRegistration(fcmToken: PushKConstants.firebaseRegistrationToken ?? "firebase_empty", xPushSessionId: xPushSessionId, xPushAuthToken:PushKConstants.pushRegistratioToken ?? "token_empty")
                return answer }
            else {
                return answerBuilder.generalAnswerStruct(respCode: 704, bodyJson: "error", description: "Not registered")
            }
    }
    
    
    //Delete registration
    public func pushClearCurrentDevice()->PushKGeneralAnswerStruct {
            if (PushKConstants.registrationstatus){
                let xPushSessionId: String = PushKConstants.firebaseRegistrationToken ?? "firebase_empty"
                
                let answer = pushRestServer.pushDeviceRevoke(devList: [PushKConstants.deviceId ?? "unknown"], xPushSessionId: xPushSessionId, xPushAuthToken: PushKConstants.pushRegistratioToken ?? "firebase_empty")
                return answer
            } else {
                return answerBuilder.generalAnswerStruct(respCode: 704, bodyJson: "error", description: "Not registered")
            }
    }
    
    //Get all devices related to number
    public func pushGetDeviceAllFromServer() -> PushKFunAnswerGetDeviceList {
            if (PushKConstants.registrationstatus){
                let xPushSessionId: String = PushKConstants.firebaseRegistrationToken ?? "firebase_empty"
                let answer = pushRestServer.pushDevicesGetAll(xPushSessionId: xPushSessionId, xPushAuthToken: PushKConstants.pushRegistratioToken ?? "token_empty")
                PushKConstants.logger.debug(answer)
                return answer}
            else {
                return PushKFunAnswerGetDeviceList.init(code: 704, result: "error", description: "Not registered", body: nil)
            }
    }
    
    
    //Delete registration of all devices related to number
    public func pushClearAllDevice()->PushKGeneralAnswerStruct {

            if (PushKConstants.registrationstatus) {
                let getdevResponse = pushGetDeviceAllFromServer()

                var listDevId: [String] = []

                let devListAll = getdevResponse.body

                for device in devListAll?.devices ?? []
                {
                    listDevId.append(String(device.id))
                }

                PushKConstants.logger.debug(listDevId)

                let xPushSessionId: String = PushKConstants.firebaseRegistrationToken ?? "firebase_empty"
                PushKConstants.logger.debug(String(PushKConstants.deviceId ?? "unknown"))
                PushKConstants.logger.debug(xPushSessionId)
                PushKConstants.logger.debug(String(PushKConstants.pushRegistratioToken ?? "token_empty"))

                let answer = pushRestServer.pushDeviceRevoke(devList: listDevId, xPushSessionId: xPushSessionId, xPushAuthToken: PushKConstants.pushRegistratioToken ?? "empty_token")

                return answer

            }
            else {
                return answerBuilder.generalAnswerStruct(respCode: 704, bodyJson: "error", description: "Not registered")
            }
    }
    
    //Get message history related to current device
    public func pushGetMessageHistory(periodInSeconds: Int) -> PushKFunAnswerGetMessageHistory {
            if (PushKConstants.registrationstatus) {
                let xPushSessionId: String = PushKConstants.firebaseRegistrationToken ?? "firebase_empty"
                
                let answer = pushRestServer.pushGetMessageHistory(utcTime: periodInSeconds, xPushSessionId: xPushSessionId, xPushAuthToken: PushKConstants.pushRegistratioToken ?? "token_empty" )
                return answer
                
            }
            else {
                return PushKFunAnswerGetMessageHistory.init(code: 704, result: "error", description: "Not registered", body: nil)
            }
    }
    
    
    public func pushCheckQueue() -> PushKFunAnswerGeneral {
            if (PushKConstants.registrationstatus) {
                let xPushSessionId: String = PushKConstants.firebaseRegistrationToken ?? "firebase_empty"
                let answer = pushRestServer.checkQueue(xPushSessionId: xPushSessionId, xPushAuthToken: PushKConstants.pushRegistratioToken ?? "token_empty" )
                return answer
            }
            else {
                return answerBuilder.generalAnswer(respCode: 704, bodyJson: "error", description: "Not registered")
            }
    }
    
    
    //send message DR
    public func pushMessageDeliveryReport(messageId: String) -> PushKGeneralAnswerStruct {
            if (PushKConstants.registrationstatus) {
                let xPushSessionId: String = PushKConstants.firebaseRegistrationToken ?? "firebase_empty"
                PushKConstants.logger.debug(xPushSessionId)
                PushKConstants.logger.debug(messageId)
                PushKConstants.logger.debug(String(PushKConstants.pushRegistratioToken ?? "firebase_empty"))
                
                let answer = pushRestServer.sendMessageDR(messageId: messageId, xPushSessionId: xPushSessionId, xPushAuthToken: PushKConstants.pushRegistratioToken ?? "token_empty")
                
                return answer}
            else {
                return answerBuilder.generalAnswerStruct(respCode: 704, bodyJson: "error", description: "Not registered")
            }
    }
    
    
    
    public func pushSendMessageCallback(messageId: String, callbackText: String) -> PushKGeneralAnswerStruct {
            if (PushKConstants.registrationstatus){
                let xPushSessionId: String = PushKConstants.firebaseRegistrationToken ?? "firebase_empty"
                let answer = pushRestServer.sendMessageCallBack(messageId: messageId, answer: callbackText, xPushSessionId: xPushSessionId, xPushAuthToken: PushKConstants.pushRegistratioToken ?? "token_empty")
                
                return answer}
            else {
                return answerBuilder.generalAnswerStruct(respCode: 704, bodyJson: "error", description: "Not registered")
            }
    }
    
    
    //function for parsing incoming message from firebase
    public static func parseIncomingPush(message: Notification) -> PushKMess {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: message.userInfo ?? "", options: []) else { return  PushKMess(code: 500, result: "Error in process message", messageFir: FullFirebaseMessageStr(aps: MessApsDataStr(contentAvailable: 0), message: MessagesResponseStr(), googleCSenderId: "", gcmMessageId: ""))}
        let jsonString = String(data: jsonData, encoding: .utf8)
        let newString = String(jsonString ?? "").replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
        let parsedMessage = PushServerAnswParser.messageIncomingJson(strResp: newString)
        return PushKMess(code: 200, result: "Success", messageFir: parsedMessage)
    }
    
    //userInfo parse
    public static func parseIncomingPush(message:  [AnyHashable : Any]) -> PushKMess {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: message , options: []) else { return  PushKMess(code: 500, result: "Error in process message", messageFir: FullFirebaseMessageStr(aps: MessApsDataStr(contentAvailable: 0), message: MessagesResponseStr(), googleCSenderId: "", gcmMessageId: ""))}
        
        let jsonString = String(data: jsonData, encoding: .utf8)
        let newString = String(jsonString ?? "").replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
        let parsedMessage = PushServerAnswParser.messageIncomingJson(strResp: newString)
        return PushKMess(code: 200, result: "Success", messageFir: parsedMessage)
    }
    
    
}
