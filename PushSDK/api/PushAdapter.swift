//
//  PushAdapter.swift
//  GMSPushSDKIOS
//
//  Created by o.korniienko on 22.08.22.
//

import Foundation
import CryptoSwift
import Alamofire




internal class PushAPI {
    
    private let jsonparser = PushServerAnswParser.init()
    private let pushDatabaseAdapter = PushKDatabase.init()
    private let answerBuider = AnswerBuilder.init()
    private let serverDataResponses = DataResponses()
    
    
    
    //function for device registration
    func registerPushDevice(xPushClientAPIKey: String, xPushSessionId: String, xPushIOSBundleId: String, userPass:String, userPhone:String) -> PushKFunAnswerRegister {
        
        PushKConstants.logger.debug("Start function registerPushDevice")
        let semaphore = DispatchSemaphore(value: 0)
         
        
        var genAnsw: PushKFunAnswerRegister = PushKFunAnswerRegister(code: 0, result: "", description: "", deviceId: "", token: "", userId: "", userPhone: "", createdAt: "")
         
        let osVersion = PushKConstants.devOSVersion
        
        let requestURL = PushKConstants.platformBrancActive.urlHttpRegistration
        PushKConstants.logger.debug("registerPushDevice url string is \(requestURL)")
         
        let params: Parameters = [
            "deviceName": UIDevice.modelName,
            "deviceType": PushKConstants.localizedModel,
            "osType": "ios",
            "osVersion": osVersion,
            "sdkVersion": PushKConstants.sdkVersion,
            "userPass": userPass,
            "userPhone": userPhone
        ]
                 
        let headersRequest: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Hyber-Session-Id": xPushSessionId,
            "X-Hyber-Client-API-Key": xPushClientAPIKey,
            "X-Hyber-IOS-Bundle-Id": xPushIOSBundleId
        ]
        
        PushKConstants.logger.debug(params)
        PushKConstants.logger.debug(headersRequest)
        
        
        Task{
            serverDataResponses.registerResponse = await makePostRequest(headersRequest: headersRequest, params: params, url: requestURL)
            semaphore.signal()
        }
        semaphore.wait()
        
        let response = serverDataResponses.registerResponse
        PushKConstants.logger.debug("registerPushDevice response is \(String(describing: response))")
        genAnsw.code = response?.response?.statusCode ?? 500
        
        if response != nil && response?.error == nil{
            PushKConstants.logger.debug("registerPushDevice response debugDescription is \(String(describing: response?.debugDescription))")

        
            switch response?.response?.statusCode {
                case 200:
                    PushKConstants.logger.debug("registerPushDevice response data is \(String(describing: response?.data))")
                    let responseNSString = NSString (data: (response?.data)! , encoding:      String.Encoding.utf8.rawValue)
        
                    PushKConstants.logger.debug(String(responseNSString ?? ""))
                    let respStr = String(responseNSString ?? "")
                    PushKConstants.logger.debug(respStr)
                    let parsedRegisterResp = self.jsonparser.registerJParse(strResp: respStr)
        
                    genAnsw.result = "Success"
                    genAnsw.description = "Procedure completed"
                    genAnsw.createdAt = parsedRegisterResp.createdAt ??  "empty"
                    genAnsw.deviceId = parsedRegisterResp.deviceId ?? "unknown"
                    genAnsw.token = parsedRegisterResp.token ?? "empty_token"
                    genAnsw.userId = String(parsedRegisterResp.userId ?? 0)
        
                    self.pushDatabaseAdapter.saveDataAfterRegisterOk(
                        userPhone: userPhone,
                        token: parsedRegisterResp.token ?? "empty_token",
                        deviceId: parsedRegisterResp.deviceId ?? "unknown",
                        userPassword: userPass,
                        createdAt: parsedRegisterResp.createdAt ??  "empty",
                        userId: String(parsedRegisterResp.userId ?? 0)
                    )
        
                    PushKConstants.logger.debug(parsedRegisterResp.token ?? "")
                    PushKConstants.logger.debug("registerPushDevice response code is \(String(describing: response?.response!.statusCode))")
        
                default:
                    PushKConstants.logger.debug("registerPushDevice response code is \(String(describing: response?.response!.statusCode))")
        
        
            }
            
        }
                    
        
        return genAnsw
        
    }
    
    //update device registration on push server
    func pushUpdateRegistration(fcmToken: String, xPushSessionId: String, xPushAuthToken:String) -> PushKGeneralAnswerStruct {
        PushKConstants.logger.debug("Start function pushUpdateRegistration")
        let semaphore = DispatchSemaphore(value: 0)
        var genAnsw: PushKGeneralAnswerStruct = PushKGeneralAnswerStruct.init(code: 0, result: "unknown", description: "unknown", body: "unknown")
        let requestURL = PushKConstants.platformBrancActive.urlHttpUpdate
        PushKConstants.logger.debug("pushUpdateRegistration url string is \(requestURL)")
        
        let timeInterval =  NSDate().timeIntervalSince1970
        let timet = Int(round(timeInterval) as Double)
        PushKConstants.logger.debug("pushUpdateRegistration request X-Hyber-Timestamp is \(String(timet))")
        
        let authToken = xPushAuthToken + ":" + String(timet)
        let sha256AuthToken = authToken.sha256()
        PushKConstants.logger.debug(sha256AuthToken)
        
        let params =  [
            "fcmToken": fcmToken,
            "osType": "ios",
            "osVersion": PushKConstants.devOSVersion,
            "deviceType": PushKConstants.localizedModel,
            "deviceName": UIDevice.modelName,
            "sdkVersion": PushKConstants.sdkVersion
            ] as Dictionary<String, AnyObject>
        
        let headersRequest: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "X-Hyber-Session-Id": xPushSessionId,
            "X-Hyber-Timestamp": String(timet),
            "X-Hyber-Auth-Token": sha256AuthToken
        ]
        
        PushKConstants.logger.debug(params)
        PushKConstants.logger.debug(headersRequest)
        
        Task{
            serverDataResponses.updateResponse = await makePostRequest(headersRequest: headersRequest, params: params, url: requestURL)
            semaphore.signal()
        }
        semaphore.wait()
        
        let response = serverDataResponses.updateResponse
        PushKConstants.logger.debug("pushUpdateRegistration response is \(String(describing: response))")
        genAnsw.code = response?.response?.statusCode ?? 500
        
        if response != nil && response?.error == nil{
            
            PushKConstants.logger.debug("pushUpdateRegistration response debugDescription is \(String(describing: response?.debugDescription))")
            PushKConstants.logger.debug("pushUpdateRegistration response data is \(String(describing: response?.data))")
            let bodyJson: String = String(decoding: (response?.data)!, as: UTF8.self)
            PushKConstants.logger.debug("pushUpdateRegistration bodyJsonF from push server: \(bodyJson)")
    
            let devisParsed = self.jsonparser.updateregistrationJParse(strResp: bodyJson)
            
            var description = "Success"
            
            switch response?.response?.statusCode {
                case 401:
                    description = "Failed"
                    UserDefaults.standard.set(false, forKey: "registrationstatus")
                    PushKConstants.registrationstatus = false
                    UserDefaults.standard.synchronize()
                    PushKConstants.logger.debug("pushUpdateRegistration response code is \(String(describing: response?.response!.statusCode))")
                default:
                    description = "Failed"
                    PushKConstants.logger.debug("pushUpdateRegistration response code is \(String(describing: response?.response!.statusCode))")
            }
            
            genAnsw = self.answerBuider.generalAnswerStruct(respCode: response?.response!.statusCode ?? 0, bodyJson: "deviceId: \(devisParsed.deviceId)", description: description)
            
        }
        
        return genAnsw
    }
    
    //remove devices from push server
    func pushDeviceRevoke(devList: [String], xPushSessionId: String, xPushAuthToken:String)->PushKGeneralAnswerStruct {
        PushKConstants.logger.debug("Start function pushDeviceRevoke")
        let semaphore = DispatchSemaphore(value: 0)
         
        
        
        var genAnsw: PushKGeneralAnswerStruct = PushKGeneralAnswerStruct.init(code: 0, result: "unknown", description: "unknown", body: "unknown")
        
        let requestURL = PushKConstants.platformBrancActive.urlHttpRevoke
        PushKConstants.logger.debug("pushDeviceRevoke url string is \(requestURL)")
        
        
        let timeInterval =  NSDate().timeIntervalSince1970
        let timet = Int(round(timeInterval) as Double)
        PushKConstants.logger.debug("pushDeviceRevoke request X-Hyber-Timestamp is \(String(timet))")
        
        let authToken = xPushAuthToken + ":" + String(timet)
        let sha256AuthToken = authToken.sha256()
        PushKConstants.logger.debug(sha256AuthToken)
        
        let params = ["devices": devList] as Dictionary<String, AnyObject>
        
        let headersRequest: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Hyber-Session-Id": xPushSessionId,
            "X-Hyber-Timestamp": String(timet),
            "X-Hyber-Auth-Token": sha256AuthToken
        ]
        PushKConstants.logger.debug(params)
        PushKConstants.logger.debug(headersRequest)
        
        Task{
            serverDataResponses.revokeDeviceResponse = await makePostRequest(headersRequest: headersRequest, params: params, url: requestURL)
            semaphore.signal()
        }
        semaphore.wait()
        
        let response = serverDataResponses.revokeDeviceResponse
        PushKConstants.logger.debug("pushDeviceRevoke response is \(String(describing: response))")
        genAnsw.code = response?.response?.statusCode ?? 500
        
        if response != nil && response?.error == nil{
            PushKConstants.logger.debug("pushDeviceRevoke response data is \(String(describing:response?.data))")
        
            let bodyJson: String = String(decoding: (response?.data)!, as: UTF8.self)
    
            PushKConstants.logger.debug("pushDeviceRevoke bodyJson from push server: \(bodyJson)")
    
            var description = "Success"
    
            PushKConstants.logger.debug("pushDeviceRevoke response debugDescription is \(response.debugDescription)")
        
            switch response?.response?.statusCode {
                case 200, 401:
        
                    UserDefaults.standard.set(false, forKey: "registrationstatus")
                    PushKConstants.registrationstatus = false
                    UserDefaults.standard.synchronize()
                    PushKConstants.logger.debug("pushDeviceRevoke response code is \(String(describing: response?.response!.statusCode))")
                default:
                    description = "Failed"
                    PushKConstants.logger.debug("pushDeviceRevoke response code is \(String(describing: response?.response!.statusCode))")
        
        
            }
            genAnsw = self.answerBuider.generalAnswerStruct(respCode: response?.response!.statusCode ?? 0, bodyJson: bodyJson, description: description)
            
        }
                    
        return genAnsw
    }
    
    
    //get devices info from push server
    func pushDevicesGetAll(xPushSessionId: String, xPushAuthToken:String) -> PushKFunAnswerGetDeviceList{
        PushKConstants.logger.debug("Start function pushDevicesGetAll")
        let semaphore = DispatchSemaphore(value: 0)
         
        
        var genAnsw: PushKFunAnswerGetDeviceList = PushKFunAnswerGetDeviceList(code: 0, result: "", description: "", body: nil)
        
        let requestURL = PushKConstants.platformBrancActive.urlHttpDeviceGetAll
        PushKConstants.logger.debug("pushDevicesGetAll url string is \(requestURL)")
        
        
        let timeInterval =  NSDate().timeIntervalSince1970
        let timet = Int(round(timeInterval) as Double)
        PushKConstants.logger.debug("pushDevicesGetAll request X-Hyber-Timestamp is \(String(timet))")
        
        let authToken = xPushAuthToken + ":" + String(timet)
        let sha256AuthToken = authToken.sha256()
        PushKConstants.logger.debug(sha256AuthToken)
        
        let headersRequest: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "X-Hyber-Session-Id": xPushSessionId,
            "X-Hyber-Timestamp": String(timet),
            "X-Hyber-Auth-Token": sha256AuthToken
        ]
        PushKConstants.logger.debug(headersRequest)
        
        
        Task{
            serverDataResponses.getAllDevicesResponse = await makeGetRequest(headersRequest: headersRequest, url: requestURL)
            semaphore.signal()
        }
        semaphore.wait()
        
        let response = serverDataResponses.getAllDevicesResponse
        PushKConstants.logger.debug("pushDevicesGetAll response is \(String(describing: response))")
        genAnsw.code = response?.response?.statusCode ?? 500
        
        if response != nil && response?.error == nil{
            PushKConstants.logger.debug("pushDevicesGetAll response jsonData is \(String(describing:     response?.debugDescription))")
            PushKConstants.logger.debug("pusGetMessageHistory response data is \(String(describing: response?.data))")
        
            switch response?.response?.statusCode {
                case 200:
        
                    let bodyJson: String = String(decoding: (response?.data)!, as: UTF8.self)
                    PushKConstants.logger.debug("pushDevicesGetAll bodyJson from push server: \(bodyJson)")
        
        
                    genAnsw.description = "Success"
                    genAnsw.result = "Ok"
                    genAnsw.body = self.jsonparser.getDeviceListJson(strResp: bodyJson)
                    PushKConstants.logger.debug("pushDevicesGetAll response code is \(String(describing: response?.response!.statusCode))")
        
                case 401:
                    PushKConstants.registrationstatus = false
                    UserDefaults.standard.set(false, forKey: "registrationstatus")
                    UserDefaults.standard.synchronize()
                    PushKConstants.logger.debug("pushDevicesGetAll response code is \(String(describing: response?.response!.statusCode))")
        
                default:
                    PushKConstants.logger.debug("pushDevicesGetAll response code is \(String(describing: response?.response!.statusCode))")
        
        
            }
            
        }
                    
        
        return genAnsw
        
    }
    
    
    //get message history for device from push server
    func pushGetMessageHistory(utcTime: Int, xPushSessionId: String, xPushAuthToken:String)->PushKFunAnswerGetMessageHistory {
        
        PushKConstants.logger.debug("Start function pushGetMessageHistory")
        let semaphore = DispatchSemaphore(value: 0)
         
        var genAnsw: PushKFunAnswerGetMessageHistory = PushKFunAnswerGetMessageHistory.init(code: 0, result: "unknown", description: "unknown", body: nil)
        
        let timeInterval =  NSDate().timeIntervalSince1970
        let timet = Int(round(timeInterval) as Double)
        PushKConstants.logger.debug("pushGetMessageHistory request X-Hyber-Timestamp is \(String(timet))")
        
        let timestampForServerUrl = timet - utcTime
        
        let requestURL = String(format: "\(PushKConstants.platformBrancActive.urlHttpMessHistory)\(String(timestampForServerUrl))")
        PushKConstants.logger.debug("pushGetMessageHistory url string is \(requestURL)")
        
        let authToken = xPushAuthToken + ":" + String(timet)
        let sha256AuthToken = authToken.sha256()
        PushKConstants.logger.debug(sha256AuthToken)
        
        let headersRequest: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "X-Hyber-Session-Id": xPushSessionId,
            "X-Hyber-Timestamp": String(timet),
            "X-Hyber-Auth-Token": sha256AuthToken
        ]
        PushKConstants.logger.debug(headersRequest)
        
        Task{
            serverDataResponses.historyResponse = await makeGetRequest(headersRequest: headersRequest, url: requestURL)
            semaphore.signal()
        }
        semaphore.wait()
        
        let response = serverDataResponses.historyResponse
        PushKConstants.logger.debug("pushGetMessageHistory response is \(String(describing: response))")
        genAnsw.code = response?.response?.statusCode ?? 500
    
        if response != nil && response?.error == nil{
            
            PushKConstants.logger.debug("pushGetMessageHistory response data is \(String(describing: response?.data))")
            
            PushKConstants.logger.debug("pushGetMessageHistory response debugDescription is \(String(describing: response?.debugDescription))")
            
            switch response?.response?.statusCode {
                case 200:
                    
                    let bodyJson: String = String(decoding: (response?.data)!, as: UTF8.self)
                    PushKConstants.logger.debug("pusGetMessageHistory bodyJson from push server: \(bodyJson)")
                    genAnsw.description = "Success"
                    genAnsw.result = "Ok"
                    genAnsw.body = self.jsonparser.getMessageHistoryJson(strResp: bodyJson)
                    
                    PushKConstants.logger.debug("pushGetMessageHistory response code is \(String(describing: response?.response!.statusCode))")
                
                case 401:
                    PushKConstants.registrationstatus = false
                    UserDefaults.standard.set(false, forKey: "registrationstatus")
                    UserDefaults.standard.synchronize()
                    
                    PushKConstants.logger.debug("pushGetMessageHistory response code is \(String(describing: response?.response!.statusCode))")
                default:
                    PushKConstants.logger.debug("pushGetMessageHistory response code is \(String(describing: response?.response!.statusCode))")
            }
        }
        
        
        return genAnsw
        
    }
    
    
    //check queue
    func checkQueue(xPushSessionId: String, xPushAuthToken:String)->PushKFunAnswerGeneral {
        
        var genAnsw: PushKFunAnswerGeneral = PushKFunAnswerGeneral(code: 0, result: "unknown", description: "unknown", body: "{}")
        
        
        let requestURL = PushKConstants.platformBrancActive.pusUrlMessQueue
        PushKConstants.logger.debug("checkQueue url string is \(requestURL)")
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let timeInterval =  NSDate().timeIntervalSince1970
        let timet = Int(round(timeInterval) as Double)
        PushKConstants.logger.debug("checkQueue request X-Hyber-Timestamp is \(String(timet))")
        
        let authToken = xPushAuthToken + ":" + String(timet)
        let sha256AuthToken = authToken.sha256()
        PushKConstants.logger.debug(sha256AuthToken)
        
        let params =  [:] as Dictionary<String, AnyObject>
        let headersRequest: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "X-Hyber-Session-Id": xPushSessionId,
            "X-Hyber-Timestamp": String(timet),
            "X-Hyber-Auth-Token": sha256AuthToken
        ]
        PushKConstants.logger.debug(params)
        PushKConstants.logger.debug(headersRequest)

        Task{
            serverDataResponses.queueResponse = await makePostRequest(headersRequest: headersRequest, params: params, url: requestURL)
            semaphore.signal()
        }
        semaphore.wait()
        
        let response = serverDataResponses.queueResponse
        PushKConstants.logger.debug("checkQueue response is \(String(describing: response))")
        genAnsw.code = response?.response?.statusCode ?? 500
        
        if response != nil && response?.error == nil{
            PushKConstants.logger.debug("checkQueue response data is \(String(describing: response?.data))")
            
            PushKConstants.logger.debug("checkQueue response debugDescription is \(String(describing: response?.debugDescription))")
            let bodyJson: String = String(decoding: (response?.data)!, as: UTF8.self)
            PushKConstants.logger.debug("checkQueue bodyJson from push server: \(bodyJson)")
        
            var description = "Success"
            
            switch response?.response?.statusCode {
                case 401:
                    description = "Failed"
                    PushKConstants.registrationstatus = false
                    UserDefaults.standard.set(false, forKey: "registrationstatus")
                    UserDefaults.standard.synchronize()
                    
                    PushKConstants.logger.debug("checkQueue response code is \(String(describing: response?.response!.statusCode))")
                default:
                    description = "Failed"
                    PushKConstants.logger.debug("checkQueue response code is \(String(describing: response?.response!.statusCode))")
            }
            genAnsw  = self.answerBuider.generalAnswer(respCode: response?.response!.statusCode ?? 0, bodyJson: bodyJson, description: description)
        }
        
        return genAnsw
    }
    
    //send delivery report to push server
    func sendMessageDR(messageId: String, xPushSessionId: String, xPushAuthToken:String)->PushKGeneralAnswerStruct {
        if (messageId != "" && messageId != "[]" ) {
            var genAnsw: PushKGeneralAnswerStruct = PushKGeneralAnswerStruct.init(code: 0, result:"unknown", description: "unknown", body: "unknown")
            
            let requestURL = PushKConstants.platformBrancActive.urlHttpMessDr
            PushKConstants.logger.debug("sendMessageDR url string is \(requestURL)")
            
            let semaphore = DispatchSemaphore(value: 0)
            
            let timeInterval =  NSDate().timeIntervalSince1970
            let timet = Int(round(timeInterval) as Double)
            PushKConstants.logger.debug("sendMessageDR request X-Hyber-Timestamp is \(String(timet))")
            
            let authToken = xPushAuthToken + ":" + String(timet)
            let sha256AuthToken = authToken.sha256()
            PushKConstants.logger.debug(sha256AuthToken)
            
            let params = ["messageId":messageId] as Dictionary<String, AnyObject>
            
            let headersRequest: HTTPHeaders = [
                "Content-Type": "application/json",
                "Accept": "application/json",
                "X-Hyber-Session-Id": xPushSessionId,
                "X-Hyber-Timestamp": String(timet),
                "X-Hyber-Auth-Token": sha256AuthToken
            ]
            PushKConstants.logger.debug(params)
            PushKConstants.logger.debug(headersRequest)
            Task{
                serverDataResponses.drResponse = await makePostRequest(headersRequest:headersRequest, params: params, url: requestURL)
                semaphore.signal()
            }
            semaphore.wait()
            
            let response = serverDataResponses.drResponse
            PushKConstants.logger.debug("sendMessageDR response is \(String(describing: response))")
            genAnsw.code = response?.response?.statusCode ?? 500
            
            if response != nil && response?.error == nil{
                PushKConstants.logger.debug("sendMessageDR response data is \(String(describing:response?.data))")
                
                PushKConstants.logger.debug("sendMessageDR response debugDescription is\(String(describing: response?.debugDescription))")
                let bodyJson: String = String(decoding: (response?.data)!, as: UTF8.self)
                PushKConstants.logger.debug("sendMessageDR bodyJson from push server:\(bodyJson)")
            
                var description = "Success"
                
                switch response?.response?.statusCode {
                    case 401:
                        description = "Failed"
                        PushKConstants.registrationstatus = false
                        UserDefaults.standard.set(false, forKey: "registrationstatus")
                        UserDefaults.standard.synchronize()
                        PushKConstants.logger.debug("sendMessageDR response code is \(String(describing:response?.response!.statusCode))")
                    default:
                        description = "Failed"
                        PushKConstants.logger.debug("sendMessageDR response code is \(String(describing:response?.response!.statusCode))")
                }
                genAnsw = self.answerBuider.generalAnswerStruct(respCode:response?.response!.statusCode ?? 0, bodyJson: bodyJson, description:description)
            }
            
            return genAnsw
        }else{
            PushKConstants.logger.debug("sendMessageDR messageId is \(messageId)")
            return self.answerBuider.generalAnswerStruct(respCode: 700, bodyJson:"{\"error\":\"Incorrect input\"}", description: "Failed")
        }
    }
    
    
    //send message callback to push server
    func sendMessageCallBack(messageId: String, answer: String, xPushSessionId: String,xPushAuthToken:String)->PushKGeneralAnswerStruct {
        
        let semaphore = DispatchSemaphore(value: 0)
        var genAnsw: PushKGeneralAnswerStruct = PushKGeneralAnswerStruct.init(code: 0, result:"unknown", description: "unknown", body: "unknown")
        
        let requestURL = PushKConstants.platformBrancActive.urlHttpMesscallback
        PushKConstants.logger.debug("sendMessaeCallBack url string is \(requestURL)")
        
        let timeInterval =  NSDate().timeIntervalSince1970
        let timet = Int(round(timeInterval) as Double)
        PushKConstants.logger.debug("sendMessaeCallBack request X-Hyber-Timestamp is \(String(timet))")
        
        let authToken = xPushAuthToken + ":" + String(timet)
        let sha256AuthToken = authToken.sha256()
        PushKConstants.logger.debug(sha256AuthToken)
        
        let params =  [
            "messageId": messageId,
            "answer": answer
        ] as Dictionary<String, AnyObject>
        
        let headersRequest: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "X-Hyber-Session-Id": xPushSessionId,
            "X-Hyber-Timestamp": String(timet),
            "X-Hyber-Auth-Token": sha256AuthToken
        ]
        PushKConstants.logger.debug(params)
        PushKConstants.logger.debug(headersRequest)
        Task{
            serverDataResponses.callBackResponse = await makePostRequest(headersRequest:headersRequest, params: params, url: requestURL)
            semaphore.signal()
        }
        semaphore.wait()
        
        let response = serverDataResponses.callBackResponse
        PushKConstants.logger.debug("sendMessaeCallBack response is \(String(describing: response))")
        genAnsw.code = response?.response?.statusCode ?? 500
        
        if response != nil && response?.error == nil{
            PushKConstants.logger.debug("sendMessaeCallBack response data is \(String(describing:response?.data))")
            
            PushKConstants.logger.debug("sendMessaeCallBack response debugDescription is\(String(describing: response?.debugDescription))")
            let bodyJson: String = String(decoding: (response?.data)!, as: UTF8.self)
            PushKConstants.logger.debug("sendMessaeCallBack bodyJson from push server:\(bodyJson)")
        
            var description = "Success"
            
            switch response?.response?.statusCode {
                case 401:
                    description = "Failed"
                    PushKConstants.registrationstatus = false
                    UserDefaults.standard.set(false, forKey: "registrationstatus")
                    UserDefaults.standard.synchronize()
                    
                    PushKConstants.logger.debug("sendMessaeCallBack response code is\(String(describing: response?.response!.statusCode))")
                default:
                    description = "Failed"
                    PushKConstants.logger.debug("sendMessaeCallBack response code is\(String(describing: response?.response!.statusCode))")
            }
            genAnsw  = self.answerBuider.generalAnswerStruct(respCode:response?.response!.statusCode ?? 0, bodyJson: bodyJson, description:description)
        }
        
        
        return genAnsw
    }
    
    
    
    func makePostRequest(headersRequest: HTTPHeaders, params: Parameters, url: String) async -> DataResponse<String, AFError>{
        let task = AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headersRequest){$0.timeoutInterval = 15}.serializingString()
        let response = await task.response
        //{$0.timeoutInterval = 30}
        return response
        
    }
    
    func makeGetRequest(headersRequest: HTTPHeaders, url: String) async -> DataResponse<String, AFError>{
        let task = AF.request(url, method: .get, encoding:JSONEncoding.default, headers: headersRequest){$0.timeoutInterval = 15}.serializingString()
        let response = await task.response
            
        return response
    }
    
    
}


internal class DataResponses{
    
    var registerResponse : DataResponse<String, AFError>!
    var getAllDevicesResponse : DataResponse<String, AFError>!
    var revokeDeviceResponse : DataResponse<String, AFError>!
    var updateResponse : DataResponse<String, AFError>!
    var historyResponse: DataResponse<String, AFError>!
    var callBackResponse: DataResponse<String, AFError>!
    var drResponse: DataResponse<String, AFError>!
    var queueResponse: DataResponse<String, AFError>!
    
}
